;;the information for the data paths should not require that the machine be run with start but should be
;;generated only once the machine is defined. that is, after the instructions have been assembled.

;;we could have, and should have, used tables or sets. or a table of sets. and let* would have been smart.

;; '((*assign*) (*test*) (*branch*) ...) is not the same as using lists as shown below
;;not specified in sicp that using quote makes the local state be shared between all instances of make-new-machine
;;using (list (list '*assign*) ...) prevents shared state, and objects function how we want as per chapter 3
(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
	(instructions (list (list '*assign*) (list '*test*) (list '*branch*)
			    (list '*goto*) (list '*save*) (list '*restore*) (list '*perform*)))
	(goto-registers (list '*head*))
	(stack-registers (list '(*save*) '(*restore*)))
	(register-sources (list '*head*)))
    (let ((the-ops (list (list 'initialize-stack (lambda () (stack 'initialize)))))
          (register-table (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name)
        (if (assoc name register-table)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
      (define (lookup-register name)
        (let ((val (assoc name register-table)))
          (if val
              (cadr val)
              (error "Unknown register:" name))))
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (begin
                ((instruction-execution-proc (car insts)))
                (execute)))))
      (define (dispatch message)
        (cond ((eq? message 'start)
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)
              ((eq? message 'get-register) lookup-register)
              ((eq? message 'install-operations)
               (lambda (ops) (set! the-ops (append the-ops ops))))
              ((eq? message 'stack) stack)
              ((eq? message 'operations) the-ops)
	      ((eq? message 'instructions) instructions)
	      ((eq? message 'goto-registers) goto-registers)
	      ((eq? message 'stack-registers) stack-registers)
	      ((eq? message 'register-sources) register-sources)
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))


;;i have forgotten that '(a) is not a symbol but is a pair, so we replace all memqs with exists
;;memq but uses equal? instead of eq?
(define (exists obj ls)
  (cond ((null? ls) false)
	((equal? obj (car ls)) ls)
	(else (exists? obj (cdr ls)))))

(define (make-assign inst machine labels operations pc)
  (let ((reg-name (assign-reg-name inst))
        (value-exp (assign-value-exp inst))
	(assign-entries (assoc '*assign* (machine 'instructions)))
	(register-sources (machine 'register-sources)))
    (if (not (exists inst assign-entries))
	(set-cdr! assign-entries (cons inst (cdr assign-entries))))
    (let ((value-proc
           (if (operation-exp? value-exp)
               (make-operation-exp
                value-exp machine labels operations)
               (make-primitive-exp
                (car value-exp) machine labels)))
	  (target (get-register machine reg-name))
	  (sources (assoc reg-name (cdr register-sources))))
      (if sources
	  (if (not (exists value-exp sources))
	      (set-cdr! sources (cons value-exp (cdr sources))))
	  (set-cdr! register-sources
		    (cons (list reg-name value-exp)
			  (cdr register-sources))))
      (lambda ()
        (set-contents! target (value-proc))
        (advance-pc pc)))))

(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
    (if (operation-exp? condition)
        (let ((test-entries (assoc '*test* (machine 'instructions)))
	      (condition-proc
	       (make-operation-exp
                condition machine labels operations)))
	  (if (not (exists inst test-entries))
	      (set-cdr! test-entries (cons inst (cdr test-entries))))
	  (lambda ()
	    (set-contents! flag (condition-proc))
	    (advance-pc pc)))
        (error "Bad TEST instruction -- ASSEMBLE" inst))))

(define (make-branch inst machine labels flag pc)
  (let ((dest (branch-dest inst)))
    (if (label-exp? dest)
        (let ((insts
               (lookup-label labels (label-exp-label dest)))
	      (branch-entries (assoc '*branch* (machine 'instructions))))
	  (if (not (exists inst branch-entries))
	      (set-cdr! branch-entries (cons inst (cdr branch-entries))))
          (lambda ()
            (if (get-contents flag)
                (set-contents! pc insts)
                (advance-pc pc))))
        (error "Bad BRANCH instruction -- ASSEMBLE" inst))))

(define (make-goto inst machine labels pc)
  (let ((dest (goto-dest inst))
	(goto-entries (assoc '*goto* (machine 'instructions))))
    (if (not (exists inst goto-entries))
	(set-cdr! goto-entries (cons inst (cdr goto-entries))))
    (cond ((label-exp? dest)
           (let ((insts (lookup-label labels (label-exp-label dest))))
             (lambda () (set-contents! pc insts))))
          ((register-exp? dest)
           (let ((reg-name (register-exp-reg dest)))
	     (let ((reg (get-register machine reg-name))
		   (goto-registers (machine 'goto-registers)))
	       (if (not (exists reg-name goto-registers))
		   (set-cdr! goto-registers (cons reg-name (cdr goto-registers))))
               (lambda ()
		 (set-contents! pc (get-contents reg))))))
           (else (error "Bad GOTO instruction -- ASSEMBLE" inst)))))

(define (make-save inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst))
	(save-entries (assoc '*save* (machine 'instructions)))
	(save-registers (assoc '*save* (machine 'stack-registers))))
    (let ((reg (get-register machine reg-name)))
      (if (not (exists inst save-entries))
	  (set-cdr! save-entries (cons inst (cdr save-entries))))
      (if (not (exists reg-name save-registers))
	  (set-cdr! save-registers (cons reg-name (cdr save-registers))))
      (lambda ()
	(push stack (get-contents reg))
	(advance-pc pc)))))

(define (make-restore inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst))
	(restore-entries (assoc '*restore* (machine 'instructions)))
	(restore-registers (assoc '*restore* (machine 'stack-registers))))
    (let ((reg (get-register machine reg-name)))
      (if (not (exists inst restore-entries))
	  (set-cdr! restore-entries (cons inst (cdr restore-entries))))
      (if (not (exists reg-name restore-registers))
	  (set-cdr! restore-registers (cons reg-name (cdr restore-registers))))
      (lambda ()
	(set-contents! reg (pop stack))
	(advance-pc pc)))))

(define (make-perform inst machine labels operations pc)
  (let ((action (perform-action inst)))
    (if (operation-exp? action)
        (let ((action-proc
               (make-operation-exp
                action machine labels operations))
	      (perform-entries (assoc '*perform* (machine 'instructions))))
	  (if (not (exists inst perform-entries))
	      (set-cdr! perform-entries (cons inst (cdr perform-entries))))
          (lambda ()
            (action-proc)
            (advance-pc pc)))
        (error "Bad PERFORM instruction -- ASSEMBLE" inst))))

(define fib-machine
  (make-machine
   '(continue n val)
   (list (list '< <) (list '- -) (list '+ +))
   '((assign continue (label fib-done))
     fib-loop
     (test (op <) (reg n) (const 2))
     (branch (label immediate-answer))
     (save continue)
     (assign continue (label afterfib-n-1))
     (save n)                          
     (assign n (op -) (reg n) (const 1))
     (goto (label fib-loop))           
     afterfib-n-1                      
     (restore n)
     (restore continue)
     (assign n (op -) (reg n) (const 2))
     (save continue)
     (assign continue (label afterfib-n-2))
     (save val)                       
     (goto (label fib-loop))
     afterfib-n-2                      
     (assign n (reg val))    
     (restore val)                
     (restore continue)
     (assign val (op +) (reg val) (reg n)) 
     (goto (reg continue)) 
     immediate-answer
     (assign val (reg n))
     (goto (reg continue))
     fib-done)))

;;instructions
;;(*assign* (assign val (reg n)) (assign val (op +) (reg val) (reg n)) (assign n (reg val)) (assign continue (label afterfib-n-2)) (assign n (op -) (reg n) (const 2)) (assign n (op -) (reg n) (const 1)) (assign continue (label afterfib-n-1)) (assign continue (label fib-done)))

;;(*test* (test (op <) (reg n) (const 2)))

;;(*branch* (branch (label immediate-answer)))

;;(*goto* (goto (reg continue)) (goto (label fib-loop)))

;;(*save* (save val) (save n) (save continue))

;;(*restore* (restore val) (restore continue) (restore n))

;;(*perform*)

;;goto-registers
;;(*head* continue)

;;stack-registers. obviously doesn't need the sublists but should be a list of the register names
;;((*save* val n continue) (*restore* val continue n))

;;register-sources. non-composed expressions are doubly parenthesized
;;(*head* (val ((reg n)) ((op +) (reg val) (reg n))) (n ((reg val)) ((op -) (reg n) (const 2)) ((op -) (reg n) (const 1))) (continue ((label afterfib-n-2)) ((label afterfib-n-1)) ((label fib-done))))

;;the information for the data paths should not require that the machine be run with start but should be
;;generated only once the machine is defined. that is, after the instructions have been assembled.

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
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
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

(define (make-assign inst machine labels operations pc)
  (let ((reg-name (assign-reg-name inst))
        (value-exp (assign-value-exp inst))
	(assign-entries (assoc '*assign* (machine 'instructions)))
	(register-sources (machine 'register-sources)))
    (if (not (memq inst assign-entries))
	(set-cdr! assign-entries (cons inst (cdr assign-entries)))) ;add inst to instructions
    (let ((value-proc
           (if (operation-exp? value-exp)
               (make-operation-exp
                value-exp machine labels operations)
               (make-primitive-exp
                (car value-exp) machine labels)))
	  (target (get-register machine reg-name))
	  (sources (lookup reg-name register-sources)))
      (if sources                                                  ;sources for this register exist?
	  (set-cdr! sources (cons car value-exp (cdr sources)))  ;add this source to the register's sources
	  (set-cdr! register-sources                               ;add this register and its source to machine
		    (cons (list reg-name value-exp)          ;(car value-exp) to remove extra ()
			  (cdr register-sources))))                ;since value-exp is doubly parenthesized for
      (lambda ()                                                   ;operation-exp?
        (set-contents! target (value-proc))
        (advance-pc pc)))))

(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
    (if (operation-exp? condition)
        (let ((test-entries (assoc '*test* (machine 'instructions)))
	      (condition-proc
	       (make-operation-exp
                condition machine labels operations)))
	  (if (not (memq inst test-entries))
	      (set-cdr! test-entries (cons inst (cdr test-entries)))) ;here!
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
	  (if (not (memq inst branch-entries))
	      (set-cdr! branch-entries (cons inst (cdr branch-entries)))) ;here!
          (lambda ()
            (if (get-contents flag)
                (set-contents! pc insts)
                (advance-pc pc))))
        (error "Bad BRANCH instruction -- ASSEMBLE" inst))))

(define (make-goto inst machine labels pc)
  (let ((dest (goto-dest inst))
	(goto-entries (assoc '*goto* (machine 'instructions))))
    (if (not (memq inst goto-entries))
	(set-cdr! goto-entries (cons inst (cdr goto-entries)))) ;here!
    (cond ((label-exp? dest)
           (let ((insts (lookup-label labels (label-exp-label dest))))
             (lambda () (set-contents! pc insts))))
          ((register-exp? dest)
           (let ((reg-name (register-exp-reg dest))
		 (goto-registers (machine 'goto-registers)))
	     (let ((reg (get-register machine reg-name)))
	       (if (not (lookup reg-name goto-registers))
		   (set-cdr! goto-registers (cons reg-name (cdr goto-registers))))
               (lambda ()
		 (set-contents! pc (get-contents reg))))))
           (else (error "Bad GOTO instruction -- ASSEMBLE" inst)))))

(define (make-save inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst))
	(save-entries (assoc '*save* (machine 'instructions)))
	(save-registers (assoc '*save* (machine 'stack-registers))))
    (let ((reg (get-register machine reg-name)))
      (if (not (memq inst save-entries))
	  (set-cdr! save-entries (cons inst (cdr save-entries)))) ;here!
      (if (not (memq reg-name save-registers))
	  (set-cdr! save-registers (cons reg-name (cdr save-registers))))
      (lambda ()
	(push stack (get-contents reg))
	(advance-pc pc)))))

(define (make-restore inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst))
	(restore-entries (assoc '*restore* (machine 'instructions)))
	(restore-registers (assoc '*restore* (machine 'stack-registers))))
    (let ((reg (get-register machine reg-name)))
      (if (not (memq inst restore-entries))
	  (set-cdr! restore-entries (cons inst (cdr restore-entries)))) ;here!
      (if (not (memq reg-name restore-registers))
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
	  (if (not (memq inst perform-entries))
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

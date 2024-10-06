;;the information for the data paths should not require that the machine be run with start but should be
;;generated only once the machine is defined. that is, after the instructions have been assembled.

(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
	(instructions '((*assign*) (*test*) (*branch*) (*goto*) (*save*) (*restore*) (*perform*)))
	(goto-registers '(*head*))
	(save-restore-registers '(*head*))
	(register-sources '(*head*)))
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
	      ((eq? message 'save-restore-registers) save-restore-registers)
	      ((eq? message 'register-sources) register-sources)
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

(define (make-assign inst machine labels operations pc)
  (let ((target
         (get-register machine (assign-reg-name inst)))
        (value-exp (assign-value-exp inst))
	(assign-entries (assoc '*assign* (machine 'instructions))))
    (if (not (memq inst assign-entries))
	(set-cdr! assign-entries (cons inst (cdr assign-entries)))) ;add inst to instructions
    (let ((value-proc
           (if (operation-exp? value-exp)
               (make-operation-exp
                value-exp machine labels operations)
               (make-primitive-exp
                (car value-exp) machine labels))))
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
	(set-cdr! goto-entries (const inst (cdr goto-entries)))) ;here!
    (cond ((label-exp? dest)
           (let ((insts
                  (lookup-label labels
                                (label-exp-label dest))))
             (lambda () (set-contents! pc insts))))
          ((register-exp? dest)
           (let ((reg-name (register-exp-reg dest))
		 (reg (get-register machine reg-name))
		 (goto-registers (machine 'goto-registers)))
	     (if (not (memq reg-name goto-registers))
		 (set-cdr! goto-registers (cons reg-name (cdr goto-registers))))
             (lambda ()
               (set-contents! pc (get-contents reg)))))
          (else (error "Bad GOTO instruction -- ASSEMBLE"
                       inst)))))

(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst)))
	(save-entries (assoc '*save* (machine 'instructions))))
    (if (not (memq inst save-entries))
	(set-cdr! save-entries (cons inst (cdr save-entries)))) ;here!
    (lambda ()
      (push stack (get-contents reg))
      (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst)))
	(restore-entries (assoc '*restore* (machine 'instructions))))
    (if (not (memq inst restore-entries))
	(set-cdr! restore-entries (cons inst (cdr restore-entries)))) ;here!
    (lambda ()
      (set-contents! reg (pop stack))    
      (advance-pc pc))))

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

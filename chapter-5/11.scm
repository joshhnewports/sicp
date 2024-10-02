;;b
;;an item in the stack is (reg-name contents)

(define (make-save inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst)))
    (let ((reg (get-register machine reg-name)))
      (lambda ()
	(push stack (cons reg-name (get-contents reg)))
	(advance-pc pc)))))

(define (make-restore inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst)))
    (let ((reg (get-register machine reg-name)))
      (lambda ()
	(let ((top (pop stack)))                ;dont worry about side effects
	  (cond ((eq? (car top) reg-name)       ;top of stack from the same register?
		 (set-contents! reg (cdr top))  ;set-contents! of reg to the contents of the top of stack  
		 (advance-pc pc))
		(else (error "Restored value not from saved register -- RESTORE" inst reg-name))))))))

;;c
;;make-new-machine has a stack-table analogous to register-table.
;;initialize-operation should initialize the register stacks, as the exercised demands, and it is up to the machine
;;designer using make-machine to call this operation.
;;it is up to make-save and make-restore to fetch the correct stack that is associated with the register that is
;;saved or restored.
;;we shouldnt change make-stack or make-register.

(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (the-instruction-sequence '())
	(stack-table '()))                                            ;car is reg-name, cdr is the associated stack
    (let ((register-table (list (list 'pc pc) (list 'flag flag))))
      (let ((the-ops 
	     (list (list 'initialize-stack                            ;user must call this operation in their insts
			 (lambda ()
			   (for-each (lambda (register)
				       (set! stack-table              ;(car register) is the name of the register
					     (cons (list (car register) ((make-stack) 'initialize)) 
						   stack-table)))
				     register-table))))))
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
		((eq? message 'stack) stack-table)                       ;return stack-table
		((eq? message 'operations) the-ops)
		(else (error "Unknown request -- MACHINE" message))))
	dispatch))))

(define (make-save inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst)))
    (let ((reg (get-register machine reg-name))
	  (reg-stack (assoc reg-name stack)))    ;get the stack pair in the table associated with the register
      (lambda ()
	(if reg-stack
	    (begin (push (cdr reg-stack) (get-contents reg))  ;cdr reg-stack is the stack
		   (advance-pc pc))
	    (error "Stack not initialized -- SAVE" reg-name))))))

(define (make-restore inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst)))
    (let ((reg (get-register machine reg-name))
	  (reg-stack (assoc reg-name stack)))
      (lambda ()
	(if reg-stack
	    (begin (set-contents! (cdr reg-stack) (pop stack))
		   (advance-pc pc))
	    (error "Stack not initialized -- RESTORE" reg-name))))))
      

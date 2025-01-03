;;registers can be assumed by:
;;the assignment of a register, the assignment of an operation operating on registers,
;;the perform operating on registers, the test operating on registers,
;;the save of a register, and the restore of a register.
;;goto not necessary as that register must have been assigned to some label

;;i worked on this exercise during nights and saw a solution that was only a small change
;;to lookup-register. i overthought this completely.

(define (make-machine ops controller-text)
  (let ((machine (make-new-machine)))
    ((machine 'install-operations) ops)    
    ((machine 'install-instruction-sequence)
     (assemble controller-text machine))
    machine))

(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '()))
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name)                    ;modified
        (if (not (assoc name register-table))
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
      (define (lookup-register name)
        (let ((val (assoc name register-table)))
          (if val
              (cadr val)
              false)))
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
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

(define (operation-exp-reg-allocation machine inputs)
  (for-each
   (lambda (input)
     (if (register-exp? input)
	 ((machine 'allocate-register) (register-exp-reg input))))
   inputs))

(define (set-and-get-reg machine reg-name)
  ((machine 'allocate-register) reg-name)
  (get-register machine reg-name))

;;horrific side effects can happen. its important to allocate registers before calling
;;make-operation-exp or make-primitive-exp. this goes for the other procedures as well.
;;we could have changed make-operation-exp and make-primitive-exp and dealt with distinct cases
;;like the allocation of the target register in make-assign and the allocation of the registers in
;;make-save and make-restore, but it seems not great, personally, to mix an extension of the simulator in two
;;different levels of the system, those procedures in the case analysis of make-execution-procedure,
;;and those procedures at the lower-level being make-operation-exp and make-primitive-exp.

(define (make-assign inst machine labels operations pc)
  (let ((reg (get-register machine (assign-reg-name inst)))
        (value-exp (assign-value-exp inst)))
    (let ((target
	   (if reg
	       reg
	       (set-and-get-reg machine (assign-reg-name inst))))
	  (value-proc
	   (cond ((operation-exp? value-exp)
		  (operation-exp-reg-allocation machine (operation-exp-operands value-exp))
		  (make-operation-exp value-exp machine labels operations))
		 ((register-exp? value-exp)
		  ((machine 'allocate-register) (register-exp-reg value-exp))
		  (make-primitive-exp (car value-exp) machine labels))
		 (else (make-primitive-exp (car value-exp) machine labels)))))  ;in the case of a const exp
      (lambda ()
        (set-contents! target (value-proc))
        (advance-pc pc)))))

(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
    (if (operation-exp? condition)
	(begin
	  (operation-exp-reg-allocation                 ;allocate before evaluating condition-proc
	   machine
	   (operation-exp-operands condition))
          (let ((condition-proc
		 (make-operation-exp
                  condition machine labels operations)))
	    (lambda ()
	      (set-contents! flag (condition-proc))
	      (advance-pc pc))))
        (error "Bad TEST instruction -- ASSEMBLE" inst))))

(define (make-save inst machine stack pc)
  (let ((register (get-register machine (stack-inst-reg-name inst))))
    (let ((reg
	   (if register
	       register
	       (set-and-get-reg machine (stack-inst-reg-name inst)))))
      (lambda ()
	(push stack (get-contents reg))
	(advance-pc pc)))))

(define (make-restore inst machine stack pc)
  (let ((register (get-register machine (stack-inst-reg-name inst))))
    (let ((reg
	   (if register
	       register
	       (set-and-get-reg machine (stack-inst-reg-name inst)))))
      (lambda ()
	(set-contents! reg (pop stack))    
	(advance-pc pc)))))

(define (make-perform inst machine labels operations pc)
  (let ((action (perform-action inst)))
    (if (operation-exp? action)
	(begin
	  (operation-exp-reg-allocation
	   machine
	   (operation-exp-operands (operation-exp-operands action)))
          (let ((action-proc
		 (make-operation-exp
                  action machine labels operations)))
            (lambda ()
              (action-proc)
              (advance-pc pc))))
        (error "Bad PERFORM instruction -- ASSEMBLE" inst))))

;;usage
(define gcd-machine
  (make-machine
   (list (list 'rem remainder) (list '= =))
   '(test-b
       (test (op =) (reg b) (const 0))
       (branch (label gcd-done))
       (assign t (op rem) (reg a) (reg b))
       (assign a (reg b))
       (assign b (reg t))
       (goto (label test-b))
       gcd-done)))

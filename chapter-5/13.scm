;;registers can be assumed by:
;;the assignment of a register, the assignment of an operation operating on registers,
;;the perform operating on registers, the test operating on registers,
;;the save of a register, and the restore of a register.
;;goto not necessary as that register must have been assigned to some label

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
	 (if ((machine 'get-register) input)
	 

(define (make-assign inst machine labels operations pc)
  (let ((reg (get-register machine (assign-reg-name inst)))
        (value-exp (assign-value-exp inst)))
    (let ((target
	   (if reg
	       reg
	       (begin ((machine 'allocate-register)
		       (assign-reg-name inst))
		      (get-register machine (assign-reg-name inst)))))
	  (value-proc
           (if (operation-exp? value-exp)
	       (begin (operation-exp-reg-allocation
		       machine
		       (operation-exp-operands value-exp)) ;the list of inputs
		      (make-operation-exp
                       value-exp machine labels operations))
               (make-primitive-exp
                (car value-exp) machine labels))))
      (lambda ()
        (set-contents! target (value-proc))
        (advance-pc pc)))))

(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
    (if (operation-exp? condition)
        (let ((condition-proc
               (make-operation-exp
                condition machine labels operations)))
          (lambda ()
            (set-contents! flag (condition-proc))
            (advance-pc pc)))
        (error "Bad TEST instruction -- ASSEMBLE" inst))))
(define (test-condition test-instruction)

;;change only those instructions that use operations
;;assign, perform, test
;;or change make-operation-exp to error on labels

(define (make-assign inst machine labels operations pc)
  (let ((target (get-register machine (assign-reg-name inst)))
	(value-exp (assign-value-exp inst)))
    (let ((value-proc
	   (if (operation-exp? value-exp)
	       (if (no-labels? (operation-exp-operands value-exp))            ;prevent operating on labels
		   (make-operation-exp value-exp machine labels operations)))
		   (error "Cannot operate on labels -- ASSEMBLE" inst)        
	   (make-primitive-exp (car value-exp) machine labels)))
      (lambda ()
	(set-contents! target (value-proc))
	(advance-pc pc)))))

(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
    (if (operation-exp? condition)
	(if (no-labels? (operation-exp-operands condition))                   ;here
	    (let ((condition-proc (make-operation-exp condition machine labels operations)))
	      (lambda ()
		(set-contents! flag (condition-proc))
		(advance-pc pc)))
	    (error "Cannot operate on labels -- ASSEMBLE" inst))
	(error "Bad TEST instruction: ASSEMBLE" inst))))

(define (make-perform inst machine labels operations pc)
  (let ((action (perform-action inst)))
    (if (operation-exp? action)
	(if (no labels? (operation-exp-operands action))                      ;here
	    (let ((action-proc (make-operation-exp action machine labels operations)))
	      (lambda () (action-proc) (advance-pc pc)))
	    (error "Cannot operate on labels -- ASSEMBLE" inst))
	(error "Bad PERFORM instruction: ASSEMBLE" inst))))

(define (no-labels? operands)
  (cond ((null? operands) true)
	((label-exp? (car operands)) false)
	(else (any-labels? (cdr operands)))))

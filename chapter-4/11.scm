;;lets assume that the parameters should stay the same. then we need only change the bodies of the procedures.

;;we call make-bindings because recursively calling make-frame isnt conceptually helpful
(define (make-frame variables values)
  (define (make-bindings vars vals)
    (if (null? vars)
	'()
	(cons (cons (car vars) (car vals))
	      (make-bindings (cdr vars) (cdr vals)))))
  (make-bindings variables values))

(define (frame-variables frame)
  (define variables car)
  (select-from-bindings variables frame))

(define (frame-values frame)
  (define values cdr)
  (select-from-bindings values frame))

(define (select-from-bindings select frame)
  (if (null? frame)
      '()
      (let ((first-binding (car frame))    ;to help with the fact that a frame is just the bindings
	    (rest-bindings (cdr frame)))
	(cons (select first-binding)
	      (select-from-bindings select rest-bindings)))))

(define (add-binding-to-frame! var val frame)
  (set! frame (cons (cons var val) frame)))

;;general procedures

(define (lookup-in-frame var frame)
  (define (scan vars vals)
    (cond ((null? vars) false)
	  ((eq? var (car vars)) (car vals))
	  (else (scan (cdr vars) (cdr vals)))))
  (scan (frame-variables frame) (frame-values frame)))

(define (set-in-frame! var val frame)
  (lambda (null-exp)                             ;"inject" an expression into scan
    (define (scan vars vals)
      (cond ((null? vars) (null-exp))            ;expect null-exp to be a lambda
	    ((eq? var (car vars)) (set-car! vals val))
	    (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame) (frame-values frame))))

;;implementation for envs

(define (lookup-variable-value var env)
  (if (eq? env the-empty-environment)
      (error "Unbound variable" var)
      (let ((val lookup-in-frame var (first-frame env)))
	(if val
	    val
	    (lookup-variable-value var (enclosing-environment env))))))

(define (set-variable-value! var val env)
  (if (eq? env the-empty-environment)
      (error "Unbound variable -- SET!" var)
      ((set-in-frame! var val frame)
       (lambda () (set-variable-value! var val (enclosing-environment env))))))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    ((set-in-frame! var val frame)
     (lambda () (add-binding-to-frame! var val frame))))) ;we dont traverse through enclosing environments here

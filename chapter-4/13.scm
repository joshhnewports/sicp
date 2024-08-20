;;eval clause. make-unbound! is a special form so it should handle its own evaluation rule. it is not similar
;;to make-if or make-lambda or make-procedure.
((unbound? exp) (make-unbound! exp env))

(define (make-unbound! exp env)
  (let ((frame (first-frame env)) (var (unbound-var exp)))
    (let ((val (lookup-in-frame var frame)))
      (if val
	  (begin (set-car! frame (remove var (frame-variables frame)))
		 (set-cdr! frame (remove val (frame-values frame))))
	  (error "Cannot make unbound a variable not bounded" var)))))

(define (unbound? exp)
  (tagged-list? exp 'unbound!))

(define (unbound-var exp)
  (cadr exp))

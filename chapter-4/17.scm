(define (scan-out-defines body)
  (let ((define-exps (filter definition? body))
	(rest (filter (lambda (exp) (not (definition? exp))) body)))
    (list (make-begin define-exps) rest)))

;;probably not correct. here we make-begin of all the define expressions and e3, the rest, is last.

;;in the example fibonacci procedure, the body
(let fib-iter ((a 1)
	       (b 0)
	       (count n))
  (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))

;;shall be transformed to the begin of the procedure definition and the call to the procedure with some args:
(begin (define (fib-iter a b count)
	 (if (= count 0)
	     b
	     (fib-iter (+ a b) a (- count 1))))
       (fib-iter 1 0 n))

;;but there are likely many ways of solving this exercise

;;i realize now that we use cons to make applications. i did not do that before.
(define (let->combination exp)
  (if (named-let? exp)
      (sequence->exp (make-procedure-definition (named-let-variable exp)
						(select-from-defns let-var (named-let-defns exp))
						(named-let-body exp))
		     (cons (named-let-variable exp) (select-from-defns let-exp (named-let-defns exp)))) ;application
      (cons (make-lambda (select-from-defns let-var (let-defns exp)) (let-body exp))
	    (select-from-defns let-exp (let-defns exp)))))

(define (named-let? exp)
  (symbol? (cadr exp)))

(define (named-let-variable exp)
  (cadr exp))

(define (named-let-defns exp)
  (caddr exp))

(define (named-let-body exp)
  (cadddr exp))

;;satisfies definition? and turns into a lambda, satisfies lambda? and turns into a make-procedure.
(define (make-procedure-definition variable parameters body)
  (list 'define (cons variable parameters) body))

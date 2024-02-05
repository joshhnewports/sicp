(define (ccons a b)
  (* (fast-expt 2 a)
     (fast-expt 3 b)))

(define (log-ish y a) ;x = log_a y. it is log, but only in this context
  (define (iter-divide y x)
    (if (= (remainder y a) 0)
	(iter-divide (/ y a) (+ x 1))
	x))
  (iter-divide y 0))

(define (ccar k)
  (log-ish k 2))

(define (ccdr k)
  (log-ish k 3))

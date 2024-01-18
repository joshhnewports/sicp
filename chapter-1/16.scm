(define (fast-expt-iter b n a)
  (cond ((= n 1) (* a b))
	((even? n) (fast-expt-iter (square b)
				   (/ n 2)
				   a))
	(else (fast-expt-iter b
			      (- n 1)
			      (* a b)))))

(define (even? n)
  (= (remainder n 2) 0))

(define (fast-expt b n)
  (fast-expt-iter b n 1))

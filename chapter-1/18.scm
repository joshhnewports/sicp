(define (fast-mult-iter a b c)
  (cond ((= b 0) c)
	((even? b) (fast-mult-iter (double a)
				   (halve b)
				   c))
	(else (fast-mult-iter a
			      (- b 1)
			      (+ c a)))))

(define (fast-mult a b)
  (fast-mult-iter a b 0))

(define (even? n)
  (= (remainder n 2) 0))

(define (double n)
  (+ n n))

(define (halve n)
  (/ n 2))

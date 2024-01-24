(define (checked-square m n)
  (if (and (not (or (= m 1) ;nontrivial sqrt? n is not prime
		(= m (- n 1))))
	   (= (remainder (square m) n) 1))
      0
      (square m))) ;otherwise continue

(define (fast-prime? n times)
  (cond ((= times 0) true)
	((miller-rabin-test n) (fast-prime? n (- times 1)))
	(else false)))

(define (miller-rabin-test n)
  (define (try-it n a)
    (= (expmod a (- n 1) n) (remainder 1 n)))
  (try-it n (+ 1 (random (- n 1)))))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
	((even? exp) (remainder (checked-square (expmod base (/ exp 2) m)
						m)
				m))
	(else (remainder (* base (expmod base (- exp 1) m))
			 m))))

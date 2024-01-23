(define (carmichael? n)
  (if (and (not (prime? n))
	   (fools-fermat? n))
      true
      false))

(define (fools-fermat? n)
  (define (fermat-iter n a)
    (cond ((>= a n) true) ;exhausts all a < n? fools fermat.
	  ((not (= (expmod a n n) a)) false)
	  (else (fermat-iter n (+ a 1)))))
  (fermat-iter n 2))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
	((even? exp) (remainder (square (expmod base (/ exp 2) m))
				m))
	(else (remainder (* base (expmod base (- exp 1) m))
			 m))))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
	((divides? test-divisor n) test-divisor)
	(else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

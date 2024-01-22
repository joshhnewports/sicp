(define (search-for-primes lower-bound upper-bound)
  (if (even? lower-bound)
      (prime-range (+ lower-bound 1) upper-bound)
      (prime-range lower-bound upper-bound)))

(define (prime-range current limit)
  (cond ((> current limit)
	 (newline)
	 (display "END"))
	(else (timed-prime-test current)
	      (prime-range (+ current 2) limit))))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n) (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

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

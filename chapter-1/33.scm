(define (filtered-accumulate filter combiner null-value term a next b)
  (cond ((> a b) null-value)
	((filter a)
	 (combiner (term a)
		   (filtered-accumulate filter
					combiner
					null-value
					term
					(next a)
					next
					b)))
	(else (filtered-accumulate filter
				   combiner
				   null-value
				   term
				   (next a)
				   next
				   b))))

(define (sum-squares-primes a b)
  (filtered-accumulate prime? + 0 square a inc b))

(define (prod-relative-primes n)
  (define (relatively-prime? k)
    (= (gcd k n) 1))
  (filtered-accumulate relatively-prime? * 1 identity 1 inc (- n 1)))

(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
		(accumulate combiner
			    null-value
			    term
			    (next a)
			    next
			    b))))

(define (accumulate combiner null-value term a next b)
  (define (iter a accumulation)
    (if (> a b)
	accumulation
	(iter (next a)
	      (combiner (term a)
			accumulation))))
  (iter a null-value))

(define (sum term a next b)
  (accumulate + 0 term a next b))

(define (product term a next b)
  (accumulate * 1 term a next b))


(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
	 (product term (next a) next b))))

(define (product term a next b)
  (define (iter a result)
    (if (> a b)
	result
	(iter (next a) (* result (term a)))))
  (iter a 1))

(define (factorial n)
  (define (identity k) k)
  (define (inc k) (+ k 1))
  (product identity 1 inc n))

(define (pi-prod k n)
  (define (inc k) (+ k 1))
  (define (term k)
    (if (odd? k)
	(/ (+ k 1.0)
	   (+ k 2))
	(/ (+ k 2.0)
	   (+ k 1))))
  (product term k inc n))

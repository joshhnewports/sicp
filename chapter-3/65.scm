(define ln2-stream
  (partial-sums (ln2-summands 1)))

(define (ln2-summands n)
  (cons-stream (/ 1.0 n)
	       (stream-map - (ln2-summands (+ n 1))))) ;i personally like (scale-stream s -1) better

(define accelerated-ln2-stream
  (accelerated-sequence euler-transform ln2-stream))

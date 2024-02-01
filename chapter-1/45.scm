(define (n-th-root x n damps) ;dont know how many damps. sorry
  (fixed-point ((repeated average-damp damps) (lambda (y) (/ x (fast-expt y (- n 1)))))
	       1.0))

(define (make-segment p q) (cons p q))
(define (start-segment pq) (car pq))
(define (end-segment pq) (cdr pq))

(define (make-point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))

(define (midpoint-segment pq)
  (make-point (/ (+ (x-point (start-segment pq))
		    (x-point (end-segment pq)))
		 2)
	      (/ (+ (y-point (start-segment pq))
		    (y-point (end-segment pq)))
		 2)))
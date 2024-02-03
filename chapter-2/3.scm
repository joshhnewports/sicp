(define (perimeter r)
  (+ (length (side r 1))
     (length (side r 2))
     (length (side r 3))
     (length (side r 4))))

(define (area r)
  (* (length (side r 1))
     (length (side r 2))))

(define (length s) ;assume this was written for segments
  (distance (start-segment s) (end-segment s)))

(define (distance p q) ;assume this was written for points
  (sqrt (+ (square (- (x-point p) (x-point q)))
	   (square (- (y-point p) (y-point q))))))

;abstraction barrier

(define (side r n) ;returns n-th side of rectangle r
  (cond ((= n 1) (car (car r)))
	((= n 2) (cdr (car r)))
	((= n 3) (car (cdr r)))
	((= n 4) (cdr (cdr r)))))

(define (make-rectangle p q r s) ;takes four points and returns a pair of pairs of connected segments
  (cons (cons (make-segment p q)
	      (make-segment q r))
	(cons (make-segment r s)
	      (make-segment s p))))

;alternate representation. holds only points (smaller than segments) but constructs segments with each call to side
(define (side r n) ;returns the n-th side of rectangle r
  (let ((p (car (car r)))
	(q (cdr (car r)))
	(r (car (cdr r)))
	(s (cdr (cdr r))))
    (cond ((= n 1) (make-segment p q))
	  ((= n 2) (make-segment q r))
	  ((= n 3) (make-segment r s))
	  ((= n 4) (make-segment s p)))))

(define (make-rectangle p q r s) ;takes four points and returns a pair of pairs of points
  (cons (cons p q)
	(cons r s)))

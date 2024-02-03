(define (perimeter r)
  (+ (length (side r 1))
     (length (side r 2))
     (length (side r 3))
     (length (side r 4))))

(define (area r)
  (* (length (side r 1))
     (length (side r 2))))

(define (length s)
  (distance (start-segment s) (end-segment s)))

(define (distance p q)
  (sqrt (+ (square (- (x-point p) (x-point q)))
	   (square (- (y-point p) (y-point q))))))

;abstraction barrier

(define (side r n) 
  (cond ((= n 1) (car (car r)))
	((= n 2) (cdr (car r)))
	((= n 3) (car (cdr r)))
	((= n 4) (cdr (cdr r)))))

(define (make-rectangle p q r s)
  (cons (cons (make-segment p q)
	      (make-segment q r))
	(cons (make-segment r s)
	      (make-segment s p))))

(define (side r n)
  (let ((p (car (car r)))
	(q (cdr (car r)))
	(r (car (cdr r)))
	(s (cdr (cdr r))))
    (cond ((= n 1) (make-segment p q))
	  ((= n 2) (make-segment q r))
	  ((= n 3) (make-segment r s))
	  ((= n 4) (make-segment s p)))))

(define (make-rectangle p q r s)
  (cons (cons p q)
	(cons r s)))

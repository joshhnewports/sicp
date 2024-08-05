;;i didnt really understand the exercise

(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
	((stream-null? s2) s1)
	(else
	 (let ((w1 (weight (stream-car s1)))
	       (w2 (weight (stream-car s2))))
	   (cond ((< w1 w2)
		  (cons-stream (stream-car s1)
			       (merge-weighted (stream-cdr s1) s2 weight)))
		 ((> w1 w2)
		  (cons-stream (stream-car s2)
			       (merge-weighted s1 (stream-cdr s2) weight)))
		 (else
		  (cons-stream (stream-car s1)
			       (merge-weighted (stream-cdr s1) (stream-cdr s2) weight))))))))

(define (weighted-pairs s t weight)
  (cons-stream (list (stream-car s) (stream-car t))
	       (merge-weighted (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
			       (weighted-pairs (stream-cdr s) (stream-cdr t) weight))))

(define a (weighted-pairs integers integers (lambda (pair) (apply + pair))))

(define s (cons-stream 1 (cons-stream 2 3)))

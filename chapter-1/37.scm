(define (cont-frac n d k) ;recursive
  (define (next-term i)
    (if (> i k)
	0
	(/ (n i)
	   (+ (d i)
	      (next-term (+ i 1))))))
  (next-term 1))

(define (cont-frac n d k) ;iterative
  (define (iter i result)
    (if (< i 1)
	result
        (iter (- i 1)
	      (/ (n i)
		 (+ (d i)
		    result)))))
  (iter k 0))

(cont-frac (lambda (i) 1.0)
	   (lambda (i) 1.0)
	   11)
	 

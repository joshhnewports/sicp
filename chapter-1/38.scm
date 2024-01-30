(define e
  (+ 2
     (cont-frac (lambda (i) 1)
		(lambda (i)
		  (let ((q (/ (- i 2) 3))
			(r (remainder (- i 2) 3)))
		    (if (= r 0)
			(+ 2 (* 2.0 q))
			1)))
	        30))) ; 30 terms is good enough

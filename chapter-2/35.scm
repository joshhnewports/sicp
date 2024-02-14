(define (count-leaves t)
  (accumulate +
	      0
	      (map (lambda (tree)
		     (if (pair? tree)
			 (count-leaves tree)
			 1))
		   t)))

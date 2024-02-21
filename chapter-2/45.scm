(define (split relate by) ;the position of the painter is relative to some split by some means
  (lambda (painter n)
    (if (= n 0)
	painter
	(relate painter
		(by ((split relate by) painter (- n 1))
		    ((split relate by) painter (- n 1)))))))

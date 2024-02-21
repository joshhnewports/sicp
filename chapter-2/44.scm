(define (up-split painter n)
  (if (= n 0)
      painter
      (below painter
	     (beside (up-split painter (- n 1))
		     (up-split painter (- n 1))))))

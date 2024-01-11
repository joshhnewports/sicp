(define (pascal row col)
  (define edge?
    (or (= col 1) (= (- col 1) row)))
  (cond ((< row 0) 0)
	(edge? 1)
	(else (+ (pascal (- row 1) (- col 1))
		 (pascal (- row 1) col)))))


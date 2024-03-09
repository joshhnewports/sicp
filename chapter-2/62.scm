(define (union-set s t)
  (cond ((null? s) t)
	((null? t) s)
	((= (car s) (car t))
	 (cons (car s) (union-set (cdr s) (cdr t))))
	((< (car s) (car t))
	 (cons (car s) (union-set (cdr s) t)))
	((< (car t) (car s)) ;could be else, but this predicate makes the case clear
	 (cons (car t) (union-set s (cdr t))))))

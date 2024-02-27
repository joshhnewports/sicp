(define (equal? a b)
  (cond ((and (not (pair? a)) (not (pair? b)) (eq? a b)) true)
	((and (pair? a) (pair? b) (eq? (car a) (car b)))
	 (equal? (cdr a) (cdr b)))
	(else false)))

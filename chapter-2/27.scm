(define (deep-reverse items)
  (cond ((null? items) nil)
        ((not (pair? items)) items)
	(else
	 (append (deep-reverse (cdr items))
		 (list (deep-reverse (car items)))))))

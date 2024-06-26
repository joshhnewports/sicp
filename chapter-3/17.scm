(define (count-pairs x)
  (let ((aux '()))
    (define (count structure)
      (cond ((not (pair? structure)) 0)
	    ((memq structure aux) 0)
	    (else
	     (set! aux (cons structure aux))
	     (+ (count (car structure))
		(count (cdr structure))
		1))))
    (count x)))

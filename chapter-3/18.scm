;;only asks for successive cdrs, so we don't car here
(define (cycle? x)
  (define (iter structure aux)
    (cond ((not (pair? structure)) false)
	  ((memq structure aux) true)
	  (else (iter (cdr structure) (cons structure aux)))))
  (iter x '()))

(define (adjoin-set x set)
  (define (adjoin x s traversed-set)
    (cond ((null? s) (append set (list x))) ;at the end or null? x at the end
	  ((= x (car s)) set) ;x already exists? no change
	  ((< x (car s))
	   (append traversed-set (cons x s))) ;place x between the cdr'd list and the un-cdr'd list
	  (else (adjoin x (cdr s) (append traversed-set (list (car s))))))) ;build up a traversed set
  (adjoin x set '()))
			    
;;or we could find the difference of sets at the very end instead of building up a set the whole way through.

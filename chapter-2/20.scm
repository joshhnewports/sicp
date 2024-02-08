(define (same-parity . numbers)
  (define (parity numbers desired-parity?)
    (cond ((null? numbers) numbers)
	  ((desired-parity? (car numbers))
	   (cons (car numbers)
		 (parity (cdr numbers)
			 desired-parity?)))
	  (else
	   (parity (cdr numbers)
		   desired-parity?))))
  (parity numbers
	  (if (odd? (car numbers))
	      odd?
	      even?)))

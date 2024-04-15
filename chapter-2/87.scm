;;polynomial package
(define (=zero? poly)
  (define (zero? terms)
    (cond ((empty-termlist? terms)) true)
	  ((equ? (coeff (first-term terms)) 0)
	   (zero? (rest-terms terms)))
	  (else false))
  (zero? (term-list poly)))
	
(put '=zero? '(polynomial) =zero?)

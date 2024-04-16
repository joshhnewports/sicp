;;generic
(define (negate a)
  (apply-generic 'negate a))

;;ordinary
(define (negate n) (make-scheme-number (- n))
(put 'negate '(scheme-number)
     (lambda (num) (tag (negate num))))

;;rational
(define (negate rat)
  (make-rat (- (numer rat))
	    (denom rat)))
(put 'negate '(rational)
     (lambda (rat) (tag (negate rat))))

;;complex
(define (negate z)
  (make-from-real-imag (- (real-part z))
		       (- (imag-part z))))
(put 'negate '(complex)
     (lambda (z) (tag (negate z))))

;;polynomial
(define (negate-poly poly)
  (define (neg terms)
    (if (empty-termlist? terms)
	the-empty-termlist
	(let ((t (first-term terms)))
	  (adjoin-term
	   (make-term (order t)
		      (negate (coeff t)))
	   (neg (rest-terms terms))))))
  (term-list poly))
(put 'negate '(polynomial)
     (lambda (poly) (tag (negate-poly poly))))

(define (sub-terms L1 L2)
  (cond ((empty-termlist? L1) (negate L2))
	((empty-termlist? L2) L1)
	(else (add-terms L1 (negate L2)))))

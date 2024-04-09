(define (equ? a b)
  (apply-generic 'equ? a b))

;;complex package
(put 'equ? '(complex complex)
     (lambda (a b)
       (and (= (real-part a) (real-part b))
	    (= (imag-part a) (imag-part b)))))

;;rational package
(put 'equ? '(rational rational)
     (lambda (a b)
       (= (* (numer a) (denom b))
	  (* (numer b) (denom a)))))

;;ordinary package
(put 'equ? '(scheme-number scheme-number) =)

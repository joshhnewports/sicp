(define (=zero? num)
  (apply-generic '=zero? num))

;;complex package
(put '=zero? '(complex)
     (lambda (num)
       (and (= (real-part num) 0)
	    (= (imag-part num) 0))))

;;rational package
(put '=zero? '(rational)
     (lambda (num) (= (numer num) 0)))

;;ordinary package
(put '=zero? '(scheme-number)
     (lambda (num) (= num 0)))

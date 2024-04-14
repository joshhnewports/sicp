;;suppose we were to add two complex numbers where one's real part is rational and the other's is ordinary
;;then to add the real parts is to raise the ordinary to rational, and then to add the rationals.
;;apply-generic does the coercion, and the generic arithmetic procedures use apply-generic.
;;so we have each arithmetic operation be expressed in terms of generic arithmetic procedures.

;;complex package
(define (add-complex z1 z2)
  (make-from-real-imag (add (real-part z1) (real-part z2))
		       (add (imag-part z1) (imag-part z2))))
;;and so on

(define (sine x) (apply-generic 'sine x))
(define (cosine x) (apply-generic 'cosine x))

;;ordinary package
(put 'sine '(scheme-number)
     (lambda (x) (tag (sin x))))
(put 'cosine '(scheme-number)
     (lambda (x) (tag (cos x))))

;;rational package
(put 'sine '(rational)
     (lambda (x) (tag (sin (/ (numer x) (denom x))))))
(put 'cosine '(rational)
     (lambda (x) (tag (cos (/ (numer x) (denom x))))))

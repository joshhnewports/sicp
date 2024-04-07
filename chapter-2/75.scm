(define (make-from-mag-ang r a)
  (define (dispatch op)
    (cond ((eq? op 'magnitude) r)
	  ((eq? op 'angle) a)
	  ((eq? op 'real-part) (* r (cos a)))
	  ((eq? op 'imag-part) (* r (sin a)))
	  (else (error "Unknown op -- MAKE-FROM-MAG-ANG" op))))
  dispatch)

;;to help understand, suppose we have
(define (magnitude z)
  (apply-generic 'magnitude z))

(define z (make-from-mag-ang 2 5))

;;process
(magnitude z)
(magnitude (make-from-mag-ang 2 5))
(apply-generic 'magnitude (make-from-mag-ang 2 5))
((make-from-mag-ang 2 5) 'magnitude)
(dispatch 'magnitude)
2

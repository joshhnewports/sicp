;;X is the power series whose constant term is 1 and the rest is the mul-series of the negative of the rest of S
;;and X

(define (invert-unit-series S)
  (cons-stream 1 (mul-series (scale-stream (stream-cdr S) -1)
			     (invert-unit-series S))))

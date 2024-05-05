(define (or-gate a b output) 
  (let ((c (make-wire)) (d (make-wire)) (e (make-wire)))
    (inverter a c)
    (inverter b d)
    (and-gate c d e)
    (inverter e output)
    'ok))

;;if the signals carry simultaneously, then the delay of the or-gate is twice the time of the inverter-delay
;;plus the time of the and-gate-delay.

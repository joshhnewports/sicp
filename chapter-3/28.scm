(define (or-gate a b output)
  (define (or-action-procedure)
    (let ((new-value (logical-or (get-signal a) (get-signal b))))
      (after-delay or-gate-delay
		   (lambda ()
		     (set-signal! output new-value)))))
  (add-action! a or-action-procedure)
  (add-action! b or-action-procedure)
  'ok)

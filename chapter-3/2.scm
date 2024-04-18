(define (make-monitored f)
  (let ((counter 0))
    (lambda (m)
      (cond ((eq? m 'how-many-calls?) counter)
	    ((eq? m 'reset-count)
	     (set! counter 0) ;preferrably don't use the value of set as the value of the lambda
	     "Reset") ;so we return this
	    (else (set! counter (+ counter 1))
		  (f m))))))

((ramb? exp) (analyze-ramb exp))

(define (ramb? exp)
  (tagged-list? exp 'ramb))

(define (analyze-ramb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
	(if (null? choices)
	    (fail)
	    ((car choices)
	     env
	     succeed
	     (lambda () (try-next (cdr choices))))))
      (try-next (shuffle cprocs))))) ;shuffle


(define (shuffle ls)
  (define (shuffle-iter result items len) ;hold len so we don't recompute length each time
    (if (null? items)
	result
	(let ((shuffled-item (list-ref items (random len))))
	  (shuffle-iter (cons shuffled-item result)
			(remove shuffled-item items) ;no repeats but costly
			(- len 1)))))
  (shuffle-iter '() ls (length ls)))

;;assume requests are 'generate or ('reset <number>)

(define (random-numbers requests)
  (define (random-stream last-number reqs)
    (cond ((eq? (stream-car reqs) 'generate)
	   (cons-stream last-number (random-stream (rand-update last-number) (stream-cdr reqs))))
	  ((and (pair? (stream-car reqs)) (eq? (car (stream-car reqs)) 'reset))
	   (let ((reset-number (cdr (stream-car reqs))))
	     (cons-stream reset-number (random-stream (rand-update reset-number) (stream-cdr reqs)))))
	  (else (random-stream last-number (stream-cdr reqs))))) ;we could signal an error. here, we ignore it
  (random-stream random-init requests))

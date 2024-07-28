(define (integrate-series coefficients)
  (stream-map / coefficients integers))

(define cosine-series (cons-stream 1 

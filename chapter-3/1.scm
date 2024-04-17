(define (make-accumulator sum)
  (lambda (to-add)
    (set! sum (+ to-add sum))
    sum))

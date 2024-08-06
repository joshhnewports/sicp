(define ramanujan-numbers (ramanujan-stream ramanujan-pairs))

(define (ramanujan-stream pairs)
  (if (= (weight (stream-car pairs)) (weight (stream-car (stream-cdr pairs))))
      (cons-stream (weight (stream-car pairs)) (ramanujan-stream (stream-cdr pairs)))
      (ramanujan-stream (stream-cdr pairs))))
  
(define ramanujan-pairs
  (weighted-pairs integers integers (lambda (pair) (weight pair))))

(define (weight p) (+ (cube (car p)) (cube (cadr p))))

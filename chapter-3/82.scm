(define (estimate-integral P x1 x2 y1 y2)
  (define (random-stream low high)
    (cons-stream (random-in-range low high) (random-stream low high)))
  (scale-stream
   (monte-carlo (stream-map P (random-stream (min x1 x2) (max x1 x2)) (random-stream (min y1 y2) (max y1 y2)))
		0
		0)
   (* (abs (- x1 x2)) (abs (- y1 y2)))))

(define pi
  (estimate-integral (lambda (x y) (<= (+ (square x) (square y)) 1)) -1.0 1.0 -1.0 1.0))

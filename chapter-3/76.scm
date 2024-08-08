;;the solution to this exercise seems subjective

(define (make-zero-crossings sense-data smooth)
  (let ((smoothed-sense-data (smooth sense-data)))
    (stream-map sign-change-detector smoothed-sense-data (cons-stream 0 smoothed-sense-data))))

(define (smooth input-stream)
  (stream-map average input-stream (stream-cdr input-stream)))

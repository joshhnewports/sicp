;;horrible names!

(define integer-pairs
  (weighted-pairs integers integers (lambda (pair) (weight pair))))

(define (weight p)
  (+ (square (car p)) (square (cadr p))))

(define (three-sum-two-square-stream stream)
  (if (= (weight (stream-car stream))
	 (weight (stream-car (stream-cdr stream)))
	 (weight (stream-car (stream-cdr (stream-cdr stream)))))
      (cons-stream (weight (stream-car stream)) (three-sum-two-square-stream (stream-cdr stream)))
      (three-sum-two-square-stream (stream-cdr stream))))

(define three-sum-two-square-numbers (three-sum-two-square-stream integer-pairs))

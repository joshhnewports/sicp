(define (f-tree n)
  (if (< n 3)
      n
      (+ (f-tree (- n 1))
	 (* 2 (f-tree (- n 2)))
	 (* 3 (f-tree (- n 3))))))

(define (f-iter a b c m n)
  (cond ((< n 3) n)
	((= m 0) c)
	(else (f-iter b
		      c
		      (+ c (* 2 b) (* 3 a))
		      (- m 1)
		      n))))
  
(define (f n)
  (f-iter 0 1 2 (- n 2) n))

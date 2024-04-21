(define f
  (let ((n 0)
	(m 0))
    (lambda (x)
      (set! n m)
      (set! m x)
      n)))

;;left to right
(+ (f 0) (f 1)) ;n = 0, m = 0
(+ 0 (f 1)) ;n = 0, m = 0
(+ 0 0) ;n = 0, m = 1
0

;;right to left
(+ (f 0) (f 1)) ;n = 0, m = 0
(+ (f 0) 0) ;n = 0, m = 1
(+ 1 0) ;n = 1, m = 0
1

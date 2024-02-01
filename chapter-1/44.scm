(define (smooth f)
  (lambda (x)
    ((lambda (a b c) (/ (+ a b c) 3.0)) ;average of 3 numbers
     (f (- x dx)) (f x) (f (+ x dx)))))

(define (n-fold-smooth f n)
  ((repeated smooth n) f))

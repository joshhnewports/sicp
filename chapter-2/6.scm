(define one (lambda (f) (lambda (x) (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))
(define (+ n k) (lambda (f) (lambda (x) ((k f) ((n f) x)))))

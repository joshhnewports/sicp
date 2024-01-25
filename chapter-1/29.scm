(define (integral f a b n) ;(sum term lower next upper)
  (define h (/ (- b a) n))
  (define (add-h y) (+ h y))
  (define (coefficient i)
    
  (sum (coefficient f) (+ a h) add-h n)

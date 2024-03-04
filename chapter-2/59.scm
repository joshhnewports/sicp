(define (union-set s t) ;could check if t is null, then its s. but i enjoy this as we need only look at s!
  (if (null? s)
      t
      (adjoin-set (car s) (union-set (cdr s) t)))) ;adjoin elements of s until s is null

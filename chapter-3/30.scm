(define (ripple-carry-adder a b s c)
  (if (null? a)
      'ok
      (begin (full-adder (car a) (car b) c (car s) c)
	     (ripple-carry-adder (cdr a) (cdr b) (cdr s) c))))

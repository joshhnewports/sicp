(define (append x y)
  (if (null? x)
      y
      (cons (car x) (append (cdr x) y))))

(define (append! x y)
  (set-cdr! (last-pair x) y)
  x)

(define append!
  (make-machine
   '(x lp-x cdr-x y)
   (list (list 'cdr cdr) (list 'null? null?) (list 'set-cdr! set-cdr!))
   '((assign lp-x (reg x)) ;lp-x is not a copy of x, lp-x takes on the index of x so they are the same

     last-pair
     (assign cdr-x (op cdr) (reg lp-x))
     (test (op null?) (reg cdr-x))
     (branch (label append!))
     (assign lp-x (op cdr) (reg lp-x))
     (goto (label last-pair))
     
     append!
     (perform (op set-cdr!) (reg lp-x) (reg y)))))

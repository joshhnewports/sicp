;;cdr down x until its null, saving x each time. when x is null, repeatedly cons y with the car of the saved x
(define append-machine
  (make-machine
   '(x continue y)
   (list (list 'car car) (list 'cdr cdr) (list 'cons cons) (list 'null? null?))
   '((assign continue (label append-done))
     
     append-loop
     (test (op null?) (reg x))
     (branch (label null-case))
     (save continue)
     (save x) ;to take the car of
     (assign continue (label after-cdr))
     (assign x (op cdr) (reg x))
     (goto (label append-loop))
     
     after-cdr
     (restore x)
     (restore continue)
     (assign x (op car) (reg x))
     (assign y (op cons) (reg x) (reg y))
     (goto (reg continue))
     
     null-case
     (goto (reg continue))
     
     append-done))) ;val is in y

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

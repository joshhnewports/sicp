;;for procedure A, there is some control structure after computing the fib cdr case. this is intuitively given by the + operator whose instructions are dependent on the car and cdr having been computed. for procedure B, after computing the car, the count-leaves of the cdr needs no control structure to be dealt with afterward. the cdr case handles itself and needs only to return to caller, where the solution is in the register n.

;;it works! its a christmas miracle! no matter the level of abstraction, there is still magic.

;;a
(define cl-a
  (make-machine
   '(tree val continue)
   (list (list 'null? null?) (list 'pair? pair?) (list '+ +) (list 'car car) (list 'cdr cdr))
   '((assign continue (label cl-done))
     
     cl-loop
     (test (op null?) (reg tree))
     (branch (label null-case))
     (test (op pair?) (reg tree))
     (branch (label recursive-case))
     ;;(not (pair? tree))
     (assign val (const 1))
     (goto (reg continue))
     
     recursive-case
     (save continue)
     (assign continue (label after-car))
     (save tree)
     (assign tree (op car) (reg tree))
     (goto (label cl-loop))
     
     after-car 
     (restore tree)
     ;;(restore continue)
     ;;(save continue)
     ;;setup computation of (count-leaves (cdr tree))
     (save val) ;save (count-leaves (car tree))
     (assign continue (label after-cdr))
     (assign tree (op cdr) (reg tree))
     (goto (label cl-loop))
     
     after-cdr ;val = (count-leaves (cdr tree))
     (assign tree (reg val))
     (restore val) ;restore (count-leaves (car tree))
     (assign val (op +) (reg tree) (reg val)) ;(count-leaves tree)
     (restore continue) ;match save in recursive-case
     (goto (reg continue))
     
     null-case
     (assign val (const 0))
     (goto (reg continue))
     
     cl-done)))

;;b
(define cl-b
  (make-machine
   '(tree n continue)
   (list (list 'null? null?) (list 'pair? pair?) (list '+ +) (list 'car car) (list 'cdr cdr))
   '((assign continue (label cl-done))
     (assign n (const 0))
     
     cl-loop
     (test (op null?) (reg tree)) ;n is unchanged in this case
     (branch (label null-case))
     (test (op pair?) (reg tree))
     (branch (label recursive-case))
     ;;(not (pair? tree)), n is incremented in this case
     (assign n (op +) (reg n) (const 1))
     (goto (reg continue)) ;goto caller
     
     recursive-case
     (save continue) ;to return to caller
     (assign continue (label after-car))
     (save tree) ;to compute (cdr tree) later
     ;;now compute count-leaves of the car
     (assign tree (op car) (reg tree))
     (goto (label cl-loop))
     
     after-car
     (restore tree) ;get the tree to take the cdr of
     (restore continue) ;restore caller
     ;;no need to (save continue). we do not climb back up the tree in this procedure
     ;;setup computation of count-iter of the cdr
     ;;n has count-iter of the car
     (assign tree (op cdr) (reg tree))
     (goto (label cl-loop))

     null-case
     (goto (reg continue)) ;goto caller
     
     cl-done)))

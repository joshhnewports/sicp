;;a
(assign continue (label cl-done))

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
(goto cl-loop)

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

cl-done

;;b
(assign continue (label cl-done))
(assign n (const 0))

cl-loop
(test (op null?) (reg tree))
(branch (label null-case))
(test (op pair?) (reg tree))
(branch (label recursive-case))
;;(not (pair? tree))
(goto (reg continue)) ;value is in n

recursive-case
(save continue) ;to return to caller
(save tree) ;to compute (cdr tree) later
(save n)


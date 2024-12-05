;;sketch based on fib

(assign continue (label cl-done))

cl-loop
(test (op null?) (reg tree))
(branch (label null-case))
(test (op pair?) (reg tree))
(branch (label recursive-case))
;;(not (pair? tree))
(assign val (const 1))
(goto (reg continue))

after-car
(restore tree)
(restore continue)
(save continue)
;;setup computation of (count-leaves (cdr tree))
(save val)
(assign continue (label after-cdr))
(assign tree (op cdr) (reg tree))
(goto (label cl-loop))

after-cdr ;val has the value (count-leaves (car tree))
(assign tree (reg val))
(restore val)
(assign val (op +) (reg tree) (reg val))
(restore continue)
(goto (reg continue))

recursive-case
(save continue)
(assign continue (label after-car))
(save tree)
(assign tree (op car) (reg tree))
(goto cl-loop)

null-case
(assign val (const 0))
(goto (reg continue))


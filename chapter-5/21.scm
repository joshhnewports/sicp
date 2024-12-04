;;sketch based on fib

(assign continue (label cl-done))

cl-loop
(test (op null?) (reg tree))
(branch (label null-case))
(test (op pair?) (reg tree))
;;recursive case
(save continue)
(assign continue (label after-car))
(goto cl-loop)

after-car
(restore continue)
(save continue)
(save val)
(assign continue (label after-cdr))

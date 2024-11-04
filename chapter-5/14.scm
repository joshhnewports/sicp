(define factorial-machine
  (make-machine
   '(n continue val)
   (list (list '= =) (list '- -) (list '* *))
   '((perform (op initialize-stack))
     (assign continue (label fact-done))
     fact-loop
     (test (op =) (reg n) (const 1))
     (branch (label base-case))
     (save continue)
     (save n)
     (assign n (op -) (reg n) (const 1))
     (assign continue (label after-fact))
     (goto (label fact-loop))
     after-fact
     (restore n)
     (restore continue)
     (assign val (op *) (reg n) (reg val))
     (goto (reg continue))
     base-case
     (assign val (const 1))
     (goto (reg continue))
     fact-done
     (perform (op print-stack-statistics)))))

;;2 4 6 8 10 12
;;2 3 4 5  6  7

;;The formula for the number of total pushes and the max depth is 2(n - 1).

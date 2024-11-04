(define factorial-machine
  (make-machine
   '(n continue val)
   (list (list '= =) (list '- -) (list '* *))
   '((assign continue (label fact-done))
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

(set-register-contents! factorial-machine 'n 6)
(start factorial-machine)
(get-register-contents factorial-machine 'val)

;;2 6 12 20 30
;;2 3 4  5  6

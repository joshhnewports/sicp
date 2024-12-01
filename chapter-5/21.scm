;;trying to solve fibonacci first

(perform (op initialize-stack))

count-leaves
(test (op null?) (reg tree))
(branch (label base-case-0))
(test (op pair?) (reg tree))
(branch (label recursive-case))            ;pair?
(assign sum (op +) (reg sum) (const 1))    ;not a pair
(test (op null?) (reg the-stack))
(goto (label done))
(restore tree)
(assign tree (op car) tree)
(goto (label count-leaves))

base-case-0

;;;;;;;;;;

(define fib-machine
  (make-machine
   '(n val continue)
   (list (list '+ +) (list '- -) (list '< <))
   '((assign continue (label done))
     (assign val (const 0))
     
     fib-loop
     (test (op <) (reg n) (const 2))
     (branch (label base-case))
     (save continue)
     (assign continue (label fib-1))
     (save n)
     (assign n (op -) (reg n) (const 1))
     (goto (label fib-loop))

     fib-1
     (restore n)
     (restore continue)
     (assign continue (label fib-2))
     (assign n (op -) (reg n) (const 2))
     (goto (label fib-loop))

     fib-2
     (restore n)
     (assign n (op -) (reg n) (const 2))
     (restore continue)
     (goto (label fib-loop))

     base-case
     (assign val (op +) (reg val) (reg n))
     (goto (reg continue))

     done)))

(set-register-contents! fib-machine 'n 6)
(start fib-machine)

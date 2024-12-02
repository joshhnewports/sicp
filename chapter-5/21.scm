;;trying to solve fibonacci first

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
     (assign continue (label afterfib-1))
     (save n)
     (assign n (op -) (reg n) (const 1))
     (goto (label fib-loop))

     afterfib-1 ;after computing fib(n - 1)
     (restore n) ;get n for fib(n - 2)
     ;;prepare for fib(n - 2)
     (assign n (op -) (reg n) (const 2))
     (assign continue (label afterfib-2)) ;what to do after fib(n - 2)
     (goto (label fib-loop)) ;compute fib(n - 2)

     afterfib-2
     (restore n)
     (restore continue)
     (goto (reg continue))

     base-case
     (assign val (op +) (reg val) (reg n))
     (goto (reg continue))

     done)))

(set-register-contents! fib-machine 'n 6)
(start fib-machine)

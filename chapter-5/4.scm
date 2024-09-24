;;recursive
(controller
 (assign continue (label done))        ;where to return after computing expt. the machine is only expt, so its done

 expt                                  ;expand out expt process by saving a (label reduce-expt) to stack
 (test (op =) (reg n) (const 0))
 (branch (label base-case))
 (save continue)                       ;only continue needs to be saved, not n
 (assign continue (label reduce-expt)) ;by reaching this instruction that means that the process expanded
 (assign n (op -) (reg n) (const 1))
 (goto (label expt))

 reduce-expt                           ;reduce process by restoring a reduce-expt in stack
 (assign val (op *) (reg val) (reg b)) ;after base-case assigns val to 1, we multiply val by b
 (restore continue)                   
 (goto (reg continue))                 ;and if val is b^n, then continue should hold (label done), and we are done

 base-case
 (assign val (const 1))
 (goto (reg continue))                 ;either goes to done or begins to reduce the process
 
 done)

;;iterative
(controller
 (assign counter (reg n))
 (assign product (const 1))

 expt-iter
 (test (op =) (reg counter) (const 0))
 (branch (label done))
 (assign counter (op -) (reg counter) (const 1))
 (assign product (op *) (reg b) (reg product))
 (goto (label expt-iter))
 
 done) ;product

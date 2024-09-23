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

(controller
 (assign g (const 1.0))                  ;init guess
 
 good-enough?
 (assign a (op mul) (reg g) (reg g))     ;square guess
 (assign a (op sub) (reg a) (reg x))     ;a-x
 (test (op <) (reg a) (const 0))         ;a<0?
 (branch (label negate)) 
 (goto (label cont-good-enough?))

 negate
 (assign a (op sub) (reg a))             ;-a
 (goto (label cont-good-enough?))

 cont-good-enough?
 (test (op >) (const 0.001) (reg a))     ;satisfies?
 (branch (label done))
 (goto (label improve))

 improve
 (assign b (op div) (reg x) (reg g))     ;x/guess
 (assign b (op add) (reg g) (reg b))     ;x/guess + guess
 (assign g (op div) (reg b) (const 2))   ;guess<-improve-guess
 (goto (label good-enough?))             ;iter new guess

 done)                                   ;sqrt of x is guess

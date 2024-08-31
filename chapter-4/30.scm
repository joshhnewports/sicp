The proc argument in for-each will be forced since its the operator in an expression in the body.

With Cy's change, (p2 1) evaluates the thunk (thunk (set! x (cons x '(2))) <env>) which mutates the bound variable
x from (thunk 1 <env>) to (1 2). Note that (thunk 1 <env>) evaluates to 1 since cons is a primitive and arguments
to primitives are forced. So (1 2) is printed.
Without Cy's change, (p2 1) does not force the thunk (thunk (set! x (cons x '(2))) <env>), which leads to x being
returned and not mutated. Thus (thunk 1 <env>) is returned and the driver loop forces it before printing which
results in 1.

I dislike both approaches. I dislike that there must be a choice to made at all. Forcing, as in Cy's approach, lets
side effects happen as intended. However this does not seem as lazy as we may want the evaluator to be. If we keep
the evaluator lazy then it comes at the cost of not evaluating side effects.

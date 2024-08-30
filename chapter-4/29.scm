(square (id 10))

;;extend environment and bind x to (thunk (id 10) <env>) and evaluate body of square in this environment

(* (thunk (id 10) <env>) (thunk (id 10) <env>))

;;* is primitive so we apply actual-value to the operands. the leftmost operand is evaluated, incrementing count,
;;setting the value of x to (evaluated-thunk 10 <env>), and returning 10. this also changes the other operand
;;to (evaluated-thunk 10 <env>) since both operands are x. the rightmost operand is evaluated and returns 10
;;since it became an evaluated-thunk.

;;the response to (square (id 10)) is 100 because we get (* 10 10)

;;the response to count is 1 since after the leftmost operand was evaluated first it set all other instances of x
;;within the body of square to be memoized and count no longer gets incremented.

;;if the evaluator does not memoize then the side effect of modifying count will continue to exist, and since there
;;are two operands (thunk (id 10) <env>) then the incrementation will happen twice and count will be 2.

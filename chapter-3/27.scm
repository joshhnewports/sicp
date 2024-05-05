;;the result of (fib n) is computed in constant time for each call. the result is either 0, 1, or is the sum of the
;;previously computed numbers.

;;if we defined memo-fib to be (memoize fib), then when we get to the expression (result (f x)), the procedure
;;f is fib and not memo-fib. hence fib would compute normally without memoization, i.e. without looking up
;;the previously computed fib result.

(define (apply-proc proc x)
  (proc x))

(apply-proc (lambda (x) (* x x)) 5)
((thunk (lambda (x) (* x x)) <env>) (thunk 5 <env>)) ;the operator cannot be used by eval, it must be forced.
((lambda (x) (* x x)) 5)
25

;;eval does not recognize thunks but the above expression with the comment is recognized as an application.
;;eval uses actual-value to get the lambda expression from the thunk.

;;syntactically transform to an application set in the exp register, then goto eval-dispatch.
;;cons a lambda expression to the list of values

;;note the fall-throughs to labels

ev-let
(assign unev (op let-bindings) (reg exp))
(assign exp (op let-exp) (reg exp))
(assign argl (const ()))

ev-let-accum-vars
(test (op null?) (reg unev))
(branch (label ev-let-after-vars))
(save unev)
(assign unev (op first-var) (reg unev))
(assign argl (op adjoin-arg) (reg unev) (reg argl))
(restore unev)
(assign unev (op rest-bindings) (reg unev))
(goto (label ev-let-accum-vars))

ev-let-after-vars
(assign unev (op let-bindings) (reg exp))
(save argl)
(assign argl (const ()))

ev-let-accum-vals
(test (op null?) (reg unev))
(branch (label ev-let-after-vals))
(save unev)
(assign unev (op first-val) (reg unev))
(assign argl (op adjoin-arg) (reg unev) (reg argl))
(restore unev)
(assign unev (op rest-bindings)
 
(assign exp (op cons) (reg unev) (reg argl))
(goto (label eval-dispatch))

(let ((var val) (var val))
  exp)

((lambda (var var) exp) val val)

;;syntactically transform to an application set in the exp register, then goto eval-dispatch.
;;cons a lambda expression to the list of values
ev-let
(assign unev (op let-bindings) (reg exp))
(assign exp (op let-exp) (reg exp))
(assign argl (const ()))

ev-separate-let-bindings ;get vals in argl
(test (op null?) (reg unev))
(branch (label after-separate))
(save continue)
(save unev)
(assign continue (label ev-collect-let-bindings))


after-separate
(goto (reg continue))
 
(assign exp (op cons) (reg unev) (reg argl))
(goto (label eval-dispatch))

(let ((var val))
  exp)

((lambda (var) exp) val)

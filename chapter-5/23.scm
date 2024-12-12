ev-let
(assign unev (op let-bindings) (reg exp))
(assign exp (op let-exp) (reg exp))


(let ((var val))
  exp)

((lambda (var) exp) val)

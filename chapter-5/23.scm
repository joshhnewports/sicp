;;let
;;syntactically transform to an application set in the exp register, then goto eval-dispatch.
;;cons a lambda expression to the list of values

;;note the fall-throughs to labels

ev-let->lambda
(assign unev (op let-bindings) (reg exp))
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
(save argl)              ;save the vars
(assign argl (const ())) ;setup to collect the vals

ev-let-accum-vals
(test (op null?) (reg unev))
(branch (label ev-let-after-vals))
(save unev)
(assign unev (op first-val) (reg unev))
(assign argl (op adjoin-arg) (reg unev) (reg argl))
(restore unev)
(assign unev (op rest-bindings) (reg unev))
(goto (label ev-let-accum-vals))

ev-let-after-vals ;assume the operation make-lambda: (cons 'lambda (cons <argl> (cons <exp> '())))
(assign unev (reg argl)) ;vals
(restore argl)           ;vars
(assign exp (op let-exp) (reg exp))
(assign exp (op make-lambda) (reg argl) (reg exp)) ;(lambda <argl> <exp>)
(assign exp (op cons) (reg exp) (reg unev))        ;makes a combination ((lambda (vars) expr) vals)
(goto (label eval-dispatch))                       ;eval the combination

;;cond
;;syntactically transform to nested if expression set in the exp register, then goto eval-dispatch.

ev-cond->if
(test (op null?) (reg exp))
(branch (label ))
(save continue)
(assign unev (op first-clause) (reg exp))
(save unev)
(assign exp (op rest-clauses) (reg exp))

(goto (ev-cond->if))

(cond (p e)
      (p e)
      (else e))

(if p
    e
    (if p
	e
	e))

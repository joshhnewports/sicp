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
(save continue)
(assign continue (label ev-after-cond->if))

ev-cond-loop
(test (op null?) (reg exp))
(branch (label ev-cond-null-case)) ;no else clause
(assign unev (op first-clause) (reg exp))
(test (op else-clause?) (reg unev))
(branch (label ev-cond-else-case))
(save unev)
(assign exp (op rest-clauses) (reg exp))
(save continue)
(assign continue (label ev-cond-after-expand))
(goto (label ev-cond-loop))

ev-cond-after-expand
(restore continue)
(restore unev) ;clause
(assign argl (op cond-predicate) (reg unev)) ;use argl for space. not needed if we cons manually
(assign unev (op cond-actions) (reg unev))
(assign exp (op make-if) (reg argl) (reg unev) (reg exp))
(goto (reg continue))

ev-cond-null-case
(assign exp (const false))
(goto (reg continue))

ev-cond-else-case
(assign exp (op cond-actions) (reg unev))
(goto (reg continue))

ev-after-cond->if
(restore continue)
(goto (label eval-dispatch))

;;and
;;similar to cond

ev-and->if ;fallthrough
ev-and-loop
(test (op no-predicates?) (reg exp))
(branch (label ev-and-null-case))
(test (op last-predicate?) (reg exp))
(branch (label ev-and-last-case))
(assign unev (op first-predicate) (reg exp))
(save unev)
(assign exp (op rest-predicates) (reg exp))
(save continue)
(assign continue (label ev-and-after-expand))
(goto (label ev-and-loop))

ev-and-after-expand
(restore continue)
(restore unev)
(assign exp (op make-if) (reg unev) (reg exp) (const false))
(goto (reg continue))

ev-and-null-case
(assign exp (const true))
(goto (reg continue))

ev-and-last-case
(assign exp (op first-predicate) (reg exp))
(goto (reg continue))

;;or
ev-or->if;fallthrough
ev-or-loop
(test (op no-predicates?) (reg exp))
(branch (label ev-or-null-case))
(assign unev (op first-predicate) (reg exp))

(assign exp (op make-if) (reg unev) (reg unev) (reg exp))
(assign exp (op make-lambda) (reg unev) (reg exp))
(assign exp (op cons) (reg exp) (reg argl))

ev-or-null-case
(assign exp (const false))
(goto (reg continue))

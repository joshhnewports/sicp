ev-cond
(assign exp (op cond-clauses) (reg exp))

ev-cond-loop
(test (op no-clauses?) (reg exp))
(branch (label ev-cond-null-case))
(save exp) ;clauses
(assign exp (op first-clause) (reg exp))
(test (op else-clause?) (reg exp))
(branch (label ev-cond-else-case))
(save exp) ;first clause
(assign exp (op cond-predicate) (reg exp))
(save env)
(save continue)
(assign continue (label ev-cond-decide))
(goto (label eval-dispatch))

ev-cond-decide
(restore continue)
(restore env)
(restore exp) ;first clause
(assign unev (reg exp)) ;preserve clause in case the predicate is true
(restore exp) ;clauses
(test (op true?) (reg val))
(branch (label ev-cond-consequent))
(assign exp (op rest-clauses) (reg exp))
(goto (label ev-cond-loop))

ev-cond-consequent
(save continue)
(assign unev (op cond-actions) (reg exp))
(goto (label ev-sequence))

ev-cond-null-case
(assign exp (const false)) ;chapter 4 footnote 12
(goto (label eval-dispatch))

ev-cond-else-case
;;clear the clauses from the stack but keep exp the same
(assign unev (reg exp))
(restore exp)
(assign exp (reg unev))
(goto (label ev-cond-consequent))


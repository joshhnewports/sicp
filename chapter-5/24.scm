ev-cond
(assign exp (op cond-clauses) (reg exp))

ev-cond-loop
(test (op no-clauses?) (reg exp))
(branch (label ev-cond-null-case))
(save exp)
(save env)
(save continue)
(assign exp (op first-clause) (reg exp))
(assign exp (op cond-predicate) (reg exp))
(test (op else-predicate?) (reg exp))
(branch (label ev-cond-else-case))
(assign continue (label ev-cond-decide))
(goto (label eval-dispatch))

ev-cond-decide
(restore continue)
(restore env)
(restore exp)
(test (op true?) (reg val))
(branch (label ev-cond-consequent))
(assign exp (op rest-predicates) (reg exp))
(goto (label ev-cond-loop))

ev-cond-consequent
(save continue)
(assign unev (op cond-actions) (reg exp))
(goto (label ev-sequence))

ev-cond-null-case
(assign exp (const false)) ;chapter 4 footnote 12
(goto (label eval-dispatch))

ev-cond-else-case
(restore continue)
(restore env)
(restore exp)
(goto (label ev-cond-consequent))


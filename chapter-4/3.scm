;;expressions satisfying self-evaluating? and variable? must not have type tags. hence this is why those predicates
;;are not associated with the get table.
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
	((variable? exp) (lookup-variable-value exp env))
	(else ((get 'eval (type exp))
	       exp
	       env))))

(define (type exp)
  (car exp))

;;the idea is that with the data-directed method we do not have predicates anymore such as assignment? and if?.
;;instead we fetch the procedure that is the consequent expression of each clause without asking what
;;type of expression it is as get handles that.

;;if a procedure doesn't fit nicely taking exp and env as arguments, then we make a lambda that will coerce good
;;behavior.

;; quote only takes exp. here, we force it to take exp and env and ignore env.
(put 'eval 'quote (lambda (exp env) (text-of-quotation exp)))

;;eval-assignment, eval-definition, and eval-if take exp and env nicely so we return only these procedures.
(put 'eval 'set! eval-assignment)
(put 'eval 'define eval-definition)
(put 'eval 'if eval-if)

(put 'eval 'lambda (lambda (exp env)
		     (make-procedure (lambda-parameters exp)
				     (lambda-body exp)
				     env)))

(put 'eval 'begin (lambda (exp env) (eval-sequence (begin-actions exp) env)))
(put 'eval 'cond (lambda (exp env) (eval (cond->if exp) env)))

;;assuming we are using the syntax of the evaluated language from 4.2...
(put 'eval 'call (lambda (exp env)
		   (apply (eval (operator exp) env)
			  (list-of-values (operands exp) env))))

;;if we wished to, we could have written named procedures instead of lambdas. but we do not know what decisions
;;we may make in the future.

;;if we are not using the syntax of the evaluated language from 4.2, we could have
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
	((variable? exp) (lookup-variable-value exp env))
        ((get 'eval (type exp)) ((get 'eval (type exp)) exp env))
	((application? exp)
	 (apply (eval (operator exp) env)
		(list-of-values (operands exp) env)))
	(else
	 (error "Unknown expression type -- EVAL" exp))))

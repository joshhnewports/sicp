;;left->right
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((first-op (eval (first-operand exps) env)))
	(cons first-op
	      (list-of-values (rest-operands exps) env)))))

;;right->left
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((rest (list-of-values (rest-operands exps) env)))
	(cons (eval (first-operand exps) env)
	      rest))))

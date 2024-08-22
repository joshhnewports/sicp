(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
	     (env-loop (enclosing-environment env)))
	    ((eq? var (car vars))
	     (if (eq? (car vals) '*unassigned*)
		 (error "Not yet assigned" var)
		 (car vals)))
	    (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
	(error "Unbound variable" var)
	(let ((frame (first-frame env)))
	  (scan (frame-variables frame)
		(frame-values frame)))))
  (env-loop env))

(define (scan-out-defines body)
  (let ((vars (map definition-variable (filter definition? body))) ;generate list of variables for each def in body
	(vals (map definition-value (filter definition? body))))
    (let ((bindings (map (lambda (var) (list var '*unassigned*)) vars)) ;list not cons for our let representation
	  (set-exps (map (lambda (var val) (list 'set! var val)) vars vals)))
      (append (list 'let bindings) (append set-exps (filter (lambda (exp) (not (definition? exp))) body))))))
;;horrific nonsense to get the parentheses just right.
;;not necessary. but we do this to match the spec in the book.

(define (make-procedure parameters body env)
  (list 'procedure parameters (scan-out-defines body) env))

;;for a compound procedure, apply evals the procedure body of the procedure. if we apply a procedure multiple times,
;;it's best we not have to transform the body each time with scan-out-defines. so on construction we transform once.
;;we do this by modifying make-procedure.

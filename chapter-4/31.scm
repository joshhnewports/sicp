(define (apply procedure arguments env)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
          procedure
          (list-of-arg-values arguments env)))
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           (procedure-parameters procedure)
           (list-of-values arguments (procedure-parameters procedure) env) ;changed
           (procedure-environment procedure))))
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))

;;perform a certain procedure to an operand based on its respective parameter
(define (list-of-values ops params env)
  (if (no-operands? ops)
      '()
      (cons ((param-type-dispatch (first-parameter params)) (first-operand ops) env)
	    (list-of-values (rest-operands ops)
			    (rest-parameters params)
			    env))))

;;for the procedure above
(define (param-type-dispatch param)
  (cond ((strict? param) actual-value) 
	((lazy? param) delay-it)             ;param is lazy? make the operand a thunk
	((lazy-memo? param) memo-delay-it)   ;param is a lazy-memo? make the operand a memo-thunk
	(else (error "Ill-formed parameter" param))))

;;predicates on procedure parameters
(define (strict? param)
  (not (pair? param)))
(define (lazy? param)
  (eq? (parameter-type param) 'lazy))
(define (lazy-memo? param)
  (eq? (parameter-type param) 'lazy-memo))

;;delay for thunks and memo-thunks
(define (delay-it exp env)
  (list 'thunk exp env))
(define (memo-delay-it exp env)
  (list 'memo-thunk exp env))

;;selector for procedure parameters
(define (parameter-type param)
  (if (pair? param)
      (cadr param)))

;;force-it deals with the evaluation
(define (force-it obj)
  (cond ((thunk? obj) (actual-value (thunk-exp obj) (thunk-env obj))) ;lazy non-memoized thunks
	((memo-thunk? obj)                                            ;lazy memoized thunks
	 (let ((result (actual-value (thunk-exp obj) (thunk-env obj))))
	   (set-car! obj 'evaluated-thunk)
	   (set-car! (cdr obj) result)
	   (set-cdr! (cdr obj) '())
	   result))
	((evaluated-thunk? obj) (thunk-value obj))                    ;already evaluated memoized thunks
	(else obj)))                                                  ;anything, including strict

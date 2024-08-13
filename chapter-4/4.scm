;;it seems dangerous to evaluate a predicate more than once as there is assignment in this language.
;;also, returning true or false when an expression is meant to return its own value seems wrong!
;;x3v shows that evaluating (and 1 2) should return 2.

(define (eval-and predicates env)
  (cond ((no-predicates? predicates) true)
	((last-predicate? predicates)
	 (eval (first-predicate predicates) env))
	((eval (first-predicate predicates) env)
	 (eval-and (rest-predicates predicates) env))
	(else false)))

(define (eval-or predicates env)
  (if (no-predicates? predicates)
      false
      (let ((pred (eval (first-predicate predicates) env))) ;let to prevent double evaluation
	(if pred
	    pred
	    (eval-or (rest-predicates predicates) env)))))

;;if we use data-directed style
(put 'eval 'and eval-and)
(put 'eval 'or eval-or)

;;if not, then we are using predicates
(define (and? exp)
  (tagged-list? exp 'and))

(define (or? exp)
  (tagged-list? exp 'or))

;;selectors
(define (first-predicate preds)
  (car preds))

(define (rest-predicates preds)
  (cdr preds))

(define (no-predicates? preds)
  (null? preds))

(define (last-predicate? preds)
  (null? (cdr preds)))

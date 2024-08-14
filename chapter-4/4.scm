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

;;here we have eval-and and eval-or as derived expressions

(define (and->if exp)
  (expand-and (and-predicates exp)))

(define (and-predicates exp)
  (cdr exp))

;;after looking at the definition for cond, we see that cond doesn't have eval anywhere in it.
;;instead, it returns values that are assumed to be handed off back to eval. we do the same here.

(define (expand-and predicates)
  (cond ((no-predicates? predicates) true)
	((last-predicate? predicates)
	 (first-predicate predicates))
	(else (make-if (first-predicate predicates)
		       (expand-and (rest-predicates predicates))
		       false))))

(define (or->if exp)
  (expand-or (or-predicates exp)))

(define (or-predicates exp)
  (cdr exp))

;;returns an exp that is meant to pass the application? predicate in eval.
;;the car is a lambda which is to be applied to the operand (first-predicate predicates) under eval.
;;this is essentially a let in our interpreted language. we do not use the underlying scheme's let because
;;it would seem that derived expressions should be syntactic transformations and to not do any evaluation.
;;this is subjective but we try to emulate what the book has done.
;;we do this maneuver to avoid double evaluation.
(define (expand-or predicates)
  (if (no-predicates? predicates)
      false
      ((make-lambda (p)
		    (make-if p
			     p
			     (expand-or (rest-predicates predicates))))
       (first-predicate predicates))))

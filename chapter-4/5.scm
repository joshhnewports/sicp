(define (cond-test-recipient-clause? clause)
  (eq? (cadr clause) '=>))

(define (cond-test clause)
  (car clause))

(define (cond-recipient clause)
  (caddr clause))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (cond ((cond-else-clause? first)
               (if (null? rest)
                   (sequence->exp (cond-actions first))
                   (error "ELSE clause isn't last -- COND->IF" clauses)))
	      ((cond-test-recipient-clause? first)
	       ((make-lambda test                             ;another let maneuver to prevent double evaluation
			     (make-if test
				      (cond-recipient test)
				      (expand-clauses rest)))
		(cond-test first)))
	      (else (make-if (cond-predicate first)
			     (sequence->exp (cond-actions first))
			     (expand-clauses rest)))))))

(define (let*->nested-lets exp)
  (expand-let* (let-defns exp) (let-body exp)))

;;assumes we have at least one definition in let*
(define (expand-let* defns body)
  (if (last-defn? defns)
      (make-let (list (car defns)) body)
      (make-let (list (car defns)) (expand-let* (cdr defns) body))))

(define (last-defn? defns)
  (null? (cdr defns)))

(define (let*? exp)
  (tagged-list? exp 'let*))

;;defns is a list of name-expression pairs.
;;we could use cons like make-lambda, but im not sure what the difference is at this point.
(define (make-let defns body)
  (list 'let defns body))

;;it is sufficient to add the clause given

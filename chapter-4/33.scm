;;not satisfied with this

(define (text-of-quotation exp env)
  (if (pair? (cadr exp))
      (eval (make-list (cadr exp)) env)
      (cadr exp)))

(define (make-list exp)
  (if (null? exp)
      '()
      (list 'cons (car exp) (make-list (cdr exp)))))

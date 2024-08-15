(define (let? exp)
  (tagged-list? exp 'let))

(define (let-defns exp)
  (cadr exp))

(define (let-body exp)
  (caddr exp))

(define (let-var defn)
  (car defn))

;;assuming defn pairs are lists. if not, then we change this to cdr.
(define (let-exp defn)
  (cadr defn))

(define (let->combination exp)
  (cons (make-lambda (select-from-defns let-var (let-defns exp)) (let-body exp))
	(select-from-defns let-exp (let-defns exp))))

(define (select-from-defns select defns)
  (if (null? defns)
      '()
      (let ((first (car defns))
	    (rest (cdr defns)))
	(cons (select first)
	      (select-from-defns select defns)))))

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
	((let? exp) (eval (let->combination exp) env))      ;here!
        ((begin? exp) 
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))

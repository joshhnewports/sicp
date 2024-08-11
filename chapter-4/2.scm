Suppose exp is a special form, such as assignment. The predicate application? accepts exp and will try to apply the 'operator' to the 'operands'. This is of course incorrect behavior.

(define (application? exp)
  (tagged-list? exp 'call))

(define (operator exp)
  (cadr exp))

(define (operands exp)
  (cddr exp))

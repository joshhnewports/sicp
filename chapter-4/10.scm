;;polish scheme. 

;;eval clauses

(define (quoted? exp)
  (tagged-list? exp 'cytat))

(define (assignment? exp)
  (tagged-list? exp 'ustawić))

(define (definition? exp)
  (tagged-list? exp 'określić))

(define (if? exp)
  (tagged-list? exp 'jeśli))

(define (begin? exp)
  (tagged-list? exp 'zaczynać))

(define (cond? exp)
  (tagged-list exp 'stan))

;;make procedures

(define (make-if predicate consequent alternative)
  (list 'jeśli predicate consequent alternative))

(define (make-begin seq)
  (cons 'zaczynać seq))

;;thats all i will do.
;;besides making expressions in postfix notation, this is all i could come up with that is simple.
;;we must keep reading!

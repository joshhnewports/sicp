((unless? exp) (eval (unless->if exp)) env)

(define (unless->if exp)
  (make-if (unless-condition exp) (unless-exceptional-value exp) (unless-usual-value exp)))

(define (unless? exp)
  (tagged-list? exp 'unless))

(define (unless-condition exp)
  (cadr exp))

(define (unless-usual-value exp)
  (caddr exp))

(define (unless-exceptional-value exp)
  (cadddr exp))

If unless is implemented as a procedure then it has the evaluation properties of the language it is implemented in.
If unless is implemented as a special form then it could have a unique method of evaluating its arguments indepedent
of its underlying language. The authors do specify "where it might be useful", and this indeed COULD be useful.

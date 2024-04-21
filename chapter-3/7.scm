;;we use the notion of aliasing, as in the peter paul example from earlier. we could introduce a list of passwords
;;for an account, but instead we have make-joint simply be the same account that is accessible by a different
;;password.

(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch p m)
    (if (eq? p password)
	(cond ((eq? m 'withdraw) withdraw)
              ((eq? m 'deposit) deposit)
	      ((eq? m 'password) password) ;new. just returns password.
              (else (error "Unknown request -- MAKE-ACCOUNT"
			   m)))
        (lambda (amount) "Incorrect password")))
  dispatch)

;;we cannot make-joint of a make-joint, however. we can only make-joint of a make-account
(define (make-joint acc shared-pass access-pass)
  (define (access p m) ;access sets up the dispatch procedure for acc.
    (if (eq? p access-pass) ;if we use rosebud as our password,
	(acc shared-pass m) ;then we call the dispatch procedure of acc with acc's password and m.
        (error "Incorrect password" p)))
  (if (eq? (acc shared-pass 'password) shared-pass) ;compare acc password to shared-pass,
      access ;if so, then make-joint is access
      (error "No such account" shared-pass)))

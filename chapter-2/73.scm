;;a. We cannot assimilate the predicates because there is no operator type tag to get.
;;b

(define (make-sum a1 a2) (list '+ a1 a1))
(define (make-product m1 m2) (list '* m1 m2))

(define (sum operands var)
  (make-sum (deriv (car operands) var)
	    (deriv (cadr operands) var)))

(define (product operands var)
  (make-sum (make-product
	     (car operands)
	     (deriv (cadr operands) var))
	    (make-product
	     (cadr operands)
	     (deriv (car operands) var))))

(put 'deriv '+ sum)
(put 'deriv '* product)

;;c

(define (install-exponentiation-package)
  (define (base exp) (car exp))
  (define (exponent exp) (cadr exp))
  (define (make-exponentiation u n) (list '** u n))
  (define (exponent-rules u n)
    (cond ((and (number? n) (= 0 (- n 1))) 1)
	  ((and (number? n) (= 1 (- n 1))) u)
	  ((number? n) (make-exponentiation u (- n 1)))
	  (else (make-exponentiation u '(- n 1)))))
  (define (exponentiation operands var)
    (let ((u (base exp))
	  (n (exponent exp)))
      (make-product
       (make-product n
		   (exponent-rules u n))
       (deriv u var))))
  
  (put 'deriv '** exponentiation)
  'done)

;;d. We would have to rearrage the arguments to each put.

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
          (make-product (multiplier exp)
                        (deriv (multiplicand exp) var))
          (make-product (deriv (multiplier exp) var)
                        (multiplicand exp))))
	((exponentiation? exp)
	 (make-exponentiation (base exp) (exponent exp) var))
        (else
         (error "unknown expression type -- DERIV" exp))))

(define (exponentiation? exp)
  (and (pair? exp) (eq? (car exp) '**)))

(define (base exp) (cadr exp))

(define (exponent exp) (caddr exp))

(define (make-exponentiation u n var)
  (cond ((=number? n 0) 0)
	((=number? n 1) (deriv u var)
	 (else
	  (make-product n 
  ;;else its the product of exponent, the exponentiation of base raised to exponent-1, and the deriv of base

(define (sum? x)
  (and (pair? x) (eq? (cadr x) '+)))

(define (addend s)
  (car s))

(define (product? x)
  (and (pair? x) (eq? (cadr x) '*)))

(define (multiplier p)
  (car p))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
	((and (pair? m2) (sum? (multiplicand m2)))
	 (append (list (list m1 '* (car m2)) (cadr m2)) (multiplicand m2))) ;horrific!
        (else (list m1 '* m2))))

(define (multiplicand p)
  (if (eq? (cdddr p) '())
      (caddr p)
      (cddr p)))

(define (augend s)
  (if (eq? (cdddr s) '())
      (caddr s)
      (cddr s)))

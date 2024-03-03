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

;;(3 * 1 + 2) => ((3 * 1) + 2). list the multiplication then add the rest
;;addend is m1, the car of m2 needs to be listed with m1

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list (list m1 '* (car m2)) '* m2))))

(define (multiplicand p)
  (if (eq? (cdddr p) '())
      (caddr p)
      (cons '* (caddr p) (cdddr p))))

(define (augend s)
  (if (eq? (cdddr s) '())
      (caddr s)
      (cons '+ (caddr s) (cdddr s))))
;
(define (sum? x) (and (pair? x) (eq? (car x) '+)))
(define (product? x) (and (pair? x) (eq? (car x) '*)))
(define (addend s) (cadr s))
(define (multiplier p) (cadr p))

;;((x * y) * (x + 3)) => ((x * y) + (y * (x + 3)))
;;(* (* x y) (+ x 3)) => (+ (* x y) (* y (+ x 3)))

;;(x + 3 * (x + y + 2)) => (x + (3 * (x + y + 2)))
;;(3 + 1 * 2) => (3 + (1 * 2))
;;(3 * 1 + 2) => ((3 * 1) + 2). list the multiplication then add the rest


(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))

(define (augend s) (caddr s))
(define (multiplicand p) (caddr p))

(define (addend s)
  (let ((terms (cdr s)))
    (car terms)))

(define (augend s)
  (let ((terms (cdr s)))
    (if (one-term? (cdr terms))
	(cadr terms)
        (cons '+ (cdr terms)))))

(define (one-term? terms)
  (eq? (cdr terms) '()))

(define (multiplicand p)
  (let ((factors (cdr p)))
    (if (one-factor? (cdr factors))
	(cadr factors)
        (cons '* (cdr factors)))))

(define (one-factor? factors)
  (eq? (cdr factors) '()))

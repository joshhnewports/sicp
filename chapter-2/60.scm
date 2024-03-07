(define (element-of-set? x set)
  (cond ((null? set) false)
	((equal? x (car set)) true)
	(else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (cons x set))

(define (intersection-set s t)
  (cond ((or (null? s) (null? t)) '())
	((element-of-set? (car s) t)
	 (cons (car s) (intersection-set (cdr s) t)))
	(else (intersection-set (cdr s) t))))

(define (union-set s t)
  

(define (print-set set)
  (define (print-iter set result)
    (cond ((null? set) result)
	  ((element-of-set? (car set) result)
	   (print-iter (cdr set) result))
	  (else (print-iter (cdr set) (cons (car set) result)))))
  (print-iter set '()))

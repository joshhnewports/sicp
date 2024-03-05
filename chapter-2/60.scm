(define (element-of-set? x set)
  (cond ((null? set) false)
	((equal? x (car set)) true)
	(else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  

(define (print-set set)
  (define (print-iter set result)
    (cond ((null? set) result)
	  ((element-of-set? (car set) result)
	   (print-iter (cdr set) result))
	  (else (print-iter (cdr set) (cons (car set) result)))))
  (print-iter set '()))

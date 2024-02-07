(define (reverse items) ;i got mad so i did it three times
  (define n (length items))
  (define (reverse-helper result i)
    (if (= i n)
	result
	(reverse-helper (cons (list-ref items i)
			      result)
			(+ i 1))))
  (reverse-helper (list) 0))

(define (reverse items)
  (define (reverse-iter items result)
    (if (null? items)
	result
	(reverse-iter (cdr items) (cons (car items) result))))
  (reverse-iter items (list)))

(define (reverse items) ;initial thought, but it was with cons
  (if (null? items)
      items
      (append (reverse (cdr items)) (list (car items)))))

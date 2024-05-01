(define (front-ptr deque)
  (car deque))

(define (lower-front-ptr deque)
  (car (front-ptr deque)))

(define (rear-ptr deque)
  (cdr deque))

(define (lower-rear-ptr deque)
  (car (rear-ptr deque)))

(define (set-front-ptr! deque item)
  (set-car! deque item))

(define (set-rear-ptr! deque item)
  (set-cdr! deque item))

(define (make-deque)
  (cons '() '()))

(define (empty-deque? deque)
  (null? (front-ptr deque)))

(define (front-deque deque)
  (if (empty-deque? deque)
      (error "FRONT called with an empty deque" deque)
      (car (car (front-ptr deque)))))

(define (rear-deque deque)
  (if (empty-deque? deque)
      (error "REAR called with an empty deque" deque)
      (car (car (rear-ptr deque)))))

(define (insert-empty-deque! deque item)
  (let ((lower-pair (cons item '())))
    (let ((upper-pair (cons lower-pair (front-ptr deque))))
      (set-front-ptr! deque upper-pair)
      (set-rear-ptr! deque upper-pair)
      deque)))

(define (front-insert-deque! deque item)
  (if (empty-deque? deque)
      (insert-empty-deque! deque item)
      (begin
	(let ((lower-pair (cons item '())))
	  (let ((upper-pair (cons lower-pair (front-ptr deque))))
	    (set-cdr! (lower-front-ptr deque) upper-pair)
	    (set-front-ptr! deque upper-pair)
	    deque)))))

(define (rear-insert-deque! deque item)
  (if (empty-deque? deque)
      (insert-empty-deque! deque item)
      (begin
	(let ((lower-pair (cons item (rear-ptr deque))))
	  (let ((upper-pair (cons lower-pair '())))
	    (set-cdr! (rear-ptr deque) upper-pair)
	    (set-rear-ptr! deque upper-pair)
	    deque)))))
	    
(define (front-delete-deque! deque)
  (if (empty-deque? deque)
      (error "DELETE! called with an empty deque" deque)
      (begin (set-cdr! (lower-front-ptr deque) '())
	     (set-front-ptr! deque (cdr (front-ptr deque)))
	     deque)))

(define (rear-delete-deque! deque)
  (if (empty-deque? deque)
      (error "DELETE! called with an empty deque" deque)
      (begin (set-rear-ptr! deque (cdr (lower-rear-ptr deque)))
	     (if (null? (rear-ptr deque)) ;no previous pair?
		 (set-front-ptr! deque '()) ;must be empty after deleting
		 (set-cdr! (rear-ptr deque) '()))
	     deque)))

(define (print-deque deque)
  (define (helper seq)
    (if (null? seq)
	'()
	(cons (car (car seq)) (helper (cdr seq)))))
  (helper (car deque)))

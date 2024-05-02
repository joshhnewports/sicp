;;an n-dimensional table is a list whose cars are (n-1)-dimensional tables
;;a one-dimensional table is a list whose cars are pairs of keys and values
;;a table is one-dimensional if the list of keys has one key

(define (make-table)
  (list '*table*))

(define (insert! keys value table)
  (define (one-dimensional?) (null? (cdr keys)))
  (if (null? keys) ;only need to check once, but does it on each recurrence
      (error "No keys")
      (let ((key (car keys))
	    (backbone (cdr table)))
	(if (one-dimensional?)
            (let ((record (assoc key backbone)))
	      (if record
		  (set-cdr! record value)
		  (let ((new-record (cons key value)))
		    (set-cdr! table (cons new-record backbone)))))
	    (let ((subtable (assoc key backbone)))
	      (if subtable
		  (insert! (cdr keys) value subtable)
		  (let ((new-subtable (cons key '())))
		    (set-cdr! table (cons new-subtable backbone))
		    (insert! (cdr keys) value new-subtable)))))))
  'ok)

(define (lookup keys table)
  (define (one-dimensional?) (null? (cdr keys)))
  (if (null? keys)
      false
      (let ((key (car keys))
	    (backbone (cdr table)))
	(if (one-dimensional?)
	    (let ((record (assoc key backbone)))
	      (if record
		  (cdr record)
		  false))
	    (let ((subtable (assoc key backbone)))
	      (if subtable
		  (lookup (cdr keys) subtable)
		  false))))))

;;backbone is no longer a list but a binary tree

(define (make-tree entry left right)
  (list entry left right))
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))

;;an n-dimensional table is a list whose cars are (n-1)-dimensional tables
;;a one-dimensional table is a list whose cars are pairs of keys and values
;;a table is one-dimensional if the list of keys has one key

(define (make-table)
  (list '*table*))

;;assume lesser? and greater? are implemented
(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (car (entry records)))
	 (car records))
	((lesser? key (car (entry records)))
	 (assoc key (left-branch records)))
	((greater? key (car (entry records)))
	 (assoc key (right-branch records)))))

;;to insert a record, it must be the entry of a tree
;;to insert a tree, it must be in its sorted position in the tree and not at the start of the backbone
(define (insert! keys value table)
  (define (one-dimensional?) (null? (cdr keys)))
  (define (adjoin record t) ;also handles replacement
    (let ((key (car record)))
      (cond ((null? t)
	     (make-tree (record '() '())))
	    ((equal? key (car (entry t)))
	     (set-cdr! (entry t) value))
	    ((lesser? key (car (entry t)))
	     (adjoin record (left-branch t)))
	    ((greater? key (car (entry t)))
	     (adjoin record (right-branch t))))))
  (if (null? keys)
      (error "No keys" keys)
      (let ((key (car keys))
	    (backbone (cdr table)))
	(if (one-dimensional?)
            (let ((record (cons key value)))
	      (adjoin record backbone))
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

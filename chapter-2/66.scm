;;each record is a pair having a key and tree.
;;the data component of a record is the entry of the tree.
;;we do not change the representation of trees.
(define (make-record key tree)
  (cons key tree))

(define (data record)
  (entry (tree record)))

(define (tree record)
  (cdr record))
  
(define (key record)
  (car record))

(define (lookup given-key records)
  (cond ((null? records) false)
	((< given-key (key records))
	 (lookup given-key (left-branch (tree records))))
	((> given-key (key records))
	 (lookup given-key (right-branch (tree records))))
	(else (data records))))
	

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
	(list empty-board)
	(filter 
	 (lambda (positions) (safe? k positions))
	 (flatmap
	  (lambda (rest-of-queens)
	    (map (lambda (new-row)
		   (adjoin-position new-row k rest-of-queens))
		 (enumerate-interval 1 board-size)))
	  (queen-cols (- k 1))))))
  (queen-cols board-size))

;;(peaked) cons the queen (row, col) to the list of queens
(define (adjoin-position n-row k-col rest-of-queens)
  (cons (list n-row k-col) rest-of-queens))

(define empty-board nil)

(define (safe? k positions);assume only 1 queen in col
  (define (fetch-queen positions)
    (if (= k (car (cdr (car positions)))) ;the queen in the kth column?
	(car positions) ;return this queen
	(fetch-queen (cdr positions)))) ;try to fetch-queen from the next element
  (define (safe?-helper positions queen)
    (let ((queen-row (car queen))
	  (queen-col (car (cdr queen)))
	  (pos-row (car (car positions)))
	  (pos-col (car (cdr (car positions)))))
      (cond ((null? positions) false) ;out of positions? queen is not safe anywhere!
            ((= (car (car positions)) (car queen)) ;horizontally-unsafe?
	     (safe?-helper (cdr positions) queen))
	    ((not
	      (null?
	       (filter
		(lambda (c)
		  (and (or (= pos-row (- queen-row c))
			   (= pos-row (+ queen-row c)))
		       (= pos-col (- queen-col c))))
		(enumerate-interval 1 k))))
	     (safe?-helper (cdr positions) queen))
	    (else true))))
	     
		   
		   
	       
		   

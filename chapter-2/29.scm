(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

(define (left-branch mobile)
  (car mobile))

(define (right-branch mobile)
  (car (cdr mobile)))

(define (branch-length branch)
  (car branch))

(define (branch-structure branch)
  (car (cdr branch)))

;;------

(define (mobile? structure)
  (pair? structure))

;;------ all leaves are weights (numbers)

(define (total-weight structure)
  (if (not (mobile? structure))
       structure
      (+ (total-weight (branch-structure (left-branch structure)))
	 (total-weight (branch-structure (right-branch structure))))))

;;------

(define (balanced? structure)
  (if (not (mobile? structure))
      true
      (and (= (* (branch-length (left-branch structure))
		 (total-weight (branch-structure (left-branch structure))))
	      (* (branch-length (right-branch structure))
		 (total-weight (branch-structure (right-branch structure)))))
	   (balanced? (branch-structure (left-branch structure)))
	   (balanced? (branch-structure (right-branch structure))))))

;;------

(define (make-mobile left right)
  (cons left right))

(define (make-branch length structure)
  (cons length structure))

(define (left-branch mobile)
  (car mobile))

(define (right-branch mobile)
  (cdr mobile))

(define (branch-length branch)
  (car branch))

(define (branch-structure branch)
  (cdr branch))

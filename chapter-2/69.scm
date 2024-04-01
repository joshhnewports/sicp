;;note that just returning pairs instead of (car pairs) in the second clause
;;gives a list containing the desired tree instead of just the desired tree,
;;and that the sample-tree given in 2.67 is not of the former structure.
(define (successive-merge pairs)
  (cond ((null? pairs) '()) ;no pairs? nothing to merge.
        ((null? (cdr pairs)) (car pairs)) ;only one node in the set? take this node from the set
	(else ;otherwise, merge the set with the lowest weighted nodes combined and with those nodes removed
	 (successive-merge
	  (adjoin-set (make-code-tree (car pairs) (cadr pairs))
		      (cddr pairs))))))

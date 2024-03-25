(define (union-set s t)
  (list->tree (union (tree->list-1 s)
		     (tree->list-1 t))))
		 
(define (intersection-set s t)
  (list->tree (intersection (tree->list-1 s)
			    (tree->list-1 t))))

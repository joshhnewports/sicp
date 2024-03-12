;;The procedures produce the same results for the trees in Figure 2.16. As for every tree,
;;the procedures construct a list in the order of left, center, and right, so they produce the same result.

(define t '(7 (3 (1 () ())
		 (5 () ()))
	      (9 ()
		 (11 () ()))))

(define s '(3 (1 () ())
	      (7 (5 () ())
		 (9 ()
		    (11 () ())))))

(define u '(5 (3 (1 () ()) ())
	      (9 (7 () ())
		 (11 () ()))))

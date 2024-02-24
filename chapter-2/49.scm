(define outline
  (segments->painter (list (make-segment (make-vector 0 0) (make-vector 1 0))
			   (make-segment (make-vector 1 0) (make-vector 1 1))
			   (make-segment (make-vector 1 1) (make-vector 0 1))
			   (make-segment (make-vector 0 1) (make-vector 0 0)))))

(define x
  (segments->painter (list (make-segment (make-vector 0 0) (make-vector 1 1))
			   (make-segment (make-vector 0 1) (make-vector 1 0)))))

(define diamond
  (segments->painter (list (make-segment (make-vector 0 .5) (make-vector .5 0))
			   (make-segment (make-vector .5 0) (make-vector 1 .5))
			   (make-segment (make-vector 1 .5) (make-vector .5 1))
			   (make-segment (make-vector .5 1) (make-vector 0 .5))))) 

;wave?? i dont think so!

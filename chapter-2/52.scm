(define smile
  (segments->painter wave-seg-list
		     (make-segment (make-vect 0.45 0.9) (make-vect 0.45 0.8))
		     (make-segment (make-vect 0.55 0.9) (make-vect 0.55 0.8))
		     (make-segment (make-vect 0.45 0.75) (make-vect 0.5 0.7))
		     (make-segment (make-vect 0.5 0.7) (make-vect 0.55 0.75))))

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1)))
            (corner (corner-split painter (- n 1))))
        (beside (below painter up)
                (below right corner)))))

(define (square-limit painter n)
  (let ((combine4 (square-of-four identity flip-horiz
                                  flip-vert rotate180)))
    (combine4 (corner-split painter n))))

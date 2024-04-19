;;we have estimate-integral handle the randomness as opposed to the predicate having so, like in the cesaro-test

(define (in-unit-circle? x y) ;the predicate to be used
  (<= (+ (square x) (square y))
      1))

(define (estimate-integral p x1 x2 y1 y2 trials)
  (* (monte-carlo trials
		  (lambda ()
		    (let ((x (random-in-range x1 x2))
			  (y (random-in-range y1 y2)))
		      (p x y))))
     (* (- x2 x1) (- y2 y1))))

(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
           (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

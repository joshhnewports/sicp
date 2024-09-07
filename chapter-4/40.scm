(define (multiple-dwelling)
  (let ((cooper (amb 2 3 4 5)) ;restrict amb possibilities explicitly rather than using require
        (miller (amb 3 4 5)))
    (require (> miller cooper))
    (let ((fletcher (amb 2 3 4))) ;start searching through fletcher after ruling out bad possibilities for b, c, m
      (require (not (= (abs (- fletcher cooper)) 1)))
      (let ((smith (amb 1 2 3 4 5))) ;the same for smith
	(require (not (= (abs (- smith fletcher)) 1)))
	(let ((baker (amb 1 2 3 4)))
	  (require (distinct? (list baker cooper fletcher miller smith)))
	  (list (list 'baker baker)
		(list 'cooper cooper)
		(list 'fletcher fletcher)
		(list 'miller miller)
		(list 'smith smith)))))))

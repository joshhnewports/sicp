(define (extract-labels text)
  (if (null? text)
      (cons '() '())
      (let ((result (extract-labels (cdr text))))
	(let ((insts (car result)) (labels (cdr result)))
	  (let ((next-inst (car text)))
	    (if (symbol? next-inst)
		(let (lbl (assoc next-inst 
		(cons insts
		      (cons (make-label-entry next-inst insts)
			    labels))
		(cons (cons (make-instruction next-inst) insts)
		      labels)))))))

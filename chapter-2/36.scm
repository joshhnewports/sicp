(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map (lambda (seq)
				       (car seq))
				     seqs))
	    (accumulate-n op init (map (lambda (seq)
					 (cdr seq))
				       seqs)))))

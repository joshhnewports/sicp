;;a.
;;With scheme-numbers as arguments, the procedure exp will be applied.
;;With complex numbers as arguments, apply-generic will coerce the first complex to the type of the other complex
;;forever.

;;b.
;;Louis is incorrect, apply-generic would give an error as expected with Louis's change.

;;c.
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
		(if (not (eq? type1 type2)) ;used not so the error is not the consequent
                    (let ((t1->t2 (get-coercion type1 type2))
			  (t2->t1 (get-coercion type2 type1)))
                      (cond (t1->t2
                             (apply-generic op (t1->t2 a1) a2))
                            (t2->t1
                             (apply-generic op a1 (t2->t1 a2)))
                            (else
                             (error "No method for these types"
                                    (list op type-tags)))))
		    (error "Cannot coerce types"
			   type-tags))
		(error "No method for these types"
                       (list op type-tags))))))))

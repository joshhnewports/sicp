;;not doing this for apply-generic with an arbitrary number of args as i'm not confident in that implementation.
;;the successive raising happens on each apply-generic. we only ask if one type is higher than the other and we
;;raise by one level.
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
		(cond ((higher? type1 type2)
		       (apply-generic op a1 (raise a2)))
		      ((higher? type2 type1)
		       (apply-generic op (raise a1) a2))
		      (else (error "No method for these types"
				   (list op type-tags)))))
	      (error "No method for these types"
		     (list op type-tags)))
	  (error "No method for these types"
		 (list op type-tags))))))

(define (higher? type1 type2)
  (if (memq type1 (memq type2 types))
      true
      false))

;;types defined in ex 2.83 as (define types '(integer rational real complex))

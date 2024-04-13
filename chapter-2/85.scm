(define (project object)
  (apply-generic 'project object))

;;get reaches out of the package into the table, so all packages don't rely on any other and are self-contained
;;complex package
(define (project z)
  ((get 'make 'real) (real-part z)))
(put 'project '(complex) project)

;;real package. we treat rationals as reals unless we are told otherwise
(define (project r)
  ((get 'make 'rational) (contents r)))
(put 'project '(real) project)

;;rational package
(define (project rat)
  ((get 'make 'scheme-number)
   (round (/ (numer rat) (denom rat)))))
(put 'project '(rational) project)

(define (drop object)
  (if (equ? object (raise (project object)))
      (drop (project object))
      object))

;;if proc is applicable, then we drop all applied args
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (map drop (apply proc (map contents args)))
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

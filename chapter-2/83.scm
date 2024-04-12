(define (integer->rational int)
  (make-rational (contents int) 1))
(put-coercion 'integer 'rational integer->rational)

(define (rational->real rat)
  (make-real (contents rat)))
(put-coercion 'rational 'real rational->real)

(define (real->complex real)
  (make-complex-from-real-imag (contents real) 0))
(put-coercion 'real 'complex real->complex)

(define (raise object)
  (let ((type (type-tag object)))
    ((get-coercion type ((tower types) type)) object)))

(define types '(integer rational real complex)) ;add more types to this list if needed

(define (tower types)
  (lambda (type-to-raise)
    (let ((list-at-lookup (memq type-to-raise types)))
      (if (and list-at-lookup
	       (not (null? (cdr list-at-lookup)))) ;;memq succeeded and the cdr is not null?
	  (cadr types)
	  (error "Cannot raise type" type-to-raise)))))
	  

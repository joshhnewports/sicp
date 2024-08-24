;;accumulate and flatmap are procedures ive struggled with so ive ignored them. they would be useful here.
;;having a make-begin would simplify things greatly.
(define (letrec->let exp)
  (let ((bindings (letrec-bindings exp)))
    (append (list 'let
		  (map (lambda (var) (list var '*unassigned*))
		       (letrec-vars bindings)))
	    (append (map (lambda (var exp) (list 'set! var exp))
			 (letrec-vars bindings) (letrec-exps bindings))
		    (list (letrec-body exp))))))

(define (letrec-bindings exp)
  (cadr exp))

(define (letrec-body exp)
  (caddr exp))

(define (letrec-vars bindings)
  (map car bindings))

(define (letrec-exps bindings)
  (map cadr bindings))

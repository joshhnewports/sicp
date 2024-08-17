;;i will just design the while construct. we need to move on to learn about the rest of the evaluator!
;;after looking at others' work, it turns out everyone else also only designed the while construct. how humorous!

;;the specified syntax
(while <condition>
       <body-seq>)

;;shall be transformed to
((lambda ()
   (begin (define (loop)
	    (if <condition>
		(begin <body-seq>
		       (loop))
		'done))
	  (loop))))

;;the begin expression starts with a definition of the loop
;;then the next expression is to call the loop procedure
;;all wrapped inside of a lambda to prevent name conflicts (the loop procedure), and this lambda is then called.

(define (while? exp)
  (tagged-list? exp 'while))

(define (while-condition exp)
  (cadr exp))

(define (while-body exp)
  (caddr exp))

(define (while->combination exp)
  ((make-lambda
    '()
    (make-begin
     (list (make-procedure-definition
	    'loop
	    '()
	    (make-if (while-condition exp)
		     (sequence->exp (list (while-body exp) '(loop)))
		     'done))
	   '(loop))))))

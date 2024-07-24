(define sum 0)
(define (accum x) (set! sum (+ x sum)) sum)
(define seq
  (stream-map accum
	      (stream-enumerate-interval 1 20)))
(define y (stream-filter even? seq))
(define z
  (stream-filter (lambda (x) (= (remainder x 5) 0))
		 seq))

;;on definition of seq
(stream-map accum (stream-enumerate-interval 1 20))
(stream-map accum (cons-stream 1 (stream-enumerate-interval 2 20)))
(cons-stream 1 (stream-map accum (stream-cdr (cons-stream 1 (stream-enumerate-interval 2 20))))) ;sum = 1

;;(stream-enumerate-interval 2 20) under seq is memoized

;;on definition of y
(stream-filter even? (cons-stream 1 (stream-map accum (stream-cdr (cons-stream 1 (stream-enumerate-interval 2 20)))))) 
(stream-filter even? (stream-cdr (cons-stream 1 (stream-map accum (stream-cdr (cons-stream 1 (stream-enumerate-interval 2 20)))))))
(stream-filter even? (stream-map accum (stream-cdr (cons-stream 1 (stream-enumerate-interval 2 20)))))
(stream-filter even? (stream-map accum (stream-enumerate-interval 2 20)))
(stream-filter even? (stream-map accum (cons-stream 2 (stream-enumerate-interval 3 20))))
(stream-filter even? (cons-stream 3 (stream-map accum (stream-cdr (cons-stream 2 (stream-enumerate-interval 3 20)))))) ;sum = 3
(stream-filter even? (stream-cdr (cons-stream 3 (stream-map accum (stream-cdr (cons-stream 2 (stream-enumerate-interval 3 20)))))))
(stream-filter even? (stream-map accum (stream-cdr (cons-stream 2 (stream-enumerate-interval 3 20)))))
(stream-filter even? (stream-map accum (stream-enumerate-interval 3 20)))
(stream-filter even? (stream-map accum (cons-stream 3 (stream-enumerate-interval 4 20))))
(stream-filter even? (cons-stream 6 (stream-map accum (stream-cdr (cons-stream 3 (stream-enumerate-interval 4 20)))))) ;sum = 6
(cons-stream
 6
 (stream-filter even? (stream-cdr (cons-stream 6 (stream-map accum (stream-cdr (cons-stream 3 (stream-enumerate-interval 4 20))))))))

;;memoized under seq:
;;(stream-map accum (stream-cdr (cons-stream 1 (stream-enumerate-interval 2 20))))
;;(stream-map accum (stream-cdr (cons-stream 2 (stream-enumerate-interval 3 20))))
;;(stream-map accum (stream-cdr (cons-stream 3 (stream-enumerate-interval 4 20)))). not yet called
;;and know that y is defined in terms of seq

;;on definition of z. follow the memoizations until we get to (... (stream-enumerate-interval 4 20)...)
(stream-filter (lambda (x) (= (remainder x 5) 0))
	       (cons-stream 1 (stream-map accum (stream-cdr (cons-stream 1 (stream-enumerate-interval 2 20))))))
(stream-filter (lambda (x) (= (remainder x 5) 0))
	       (stream-cdr (cons-stream 1 (stream-map accum (stream-cdr (cons-stream 1 (stream-enumerate-interval 2 20)))))))
(stream-filter (lambda (x) (= (remainder x 5) 0))
	       (cons-stream 3 (stream-map accum (stream-cdr (cons-stream 2 (stream-enumerate-interval 3 20)))))) ;memoization
(stream-filter (lambda (x) (= (remainder x 5) 0))
	       (stream-cdr (cons-stream 3 (stream-map accum (stream-cdr (cons-stream 2 (stream-enumerate-interval 3 20)))))))
(stream-filter (lambda (x) (= (remainder x 5) 0))
	       (cons-stream 6 (stream-map accum (stream-cdr (cons-stream 3 (stream-enumerate-interval 4 20)))))) ;memoization
(stream-filter (lambda (x) (= (remainder x 5) 0))
	       (stream-cdr (cons-stream 6 (stream-map accum (stream-cdr (cons-stream 3 (stream-enumerate-interval 4 20)))))))
(stream-filter (lambda (x) (= (remainder x 5) 0))
	       (stream-map accum (stream-cdr (cons-stream 3 (stream-enumerate-interval 4 20)))))
(stream-filter (lambda (x) (= (remainder x 5) 0))
	       (stream-map accum (stream-enumerate-interval 4 20)))
(stream-filter (lambda (x) (= (remainder x 5) 0))
	       (stream-map accum (cons-stream 4 (stream-enumerate-interval 5 20))))
(stream-filter (lambda (x) (= (remainder x 5) 0))
	       (cons-stream 10 (stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20)))))) ;sum = 10
(cons-stream 10 (stream-filter
		 (lambda (x) (= (remainder x 5) 0))
		 (stream-cdr (cons-stream 10 (stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20))))))))

;;memoized:
;;(stream-map accum (stream-cdr (cons-stream 3 (stream-enumerate-interval 4 20)))). finally called
;;(stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20)))). not yet called

;;on stream-ref
(stream-ref y 7)

(stream-ref
 (cons-stream
  6
  (stream-filter even? (stream-cdr (cons-stream 6 (stream-map accum (stream-cdr (cons-stream 3 (stream-enumerate-interval 4 20))))))))
 7)

(stream-ref
 (stream-cdr
  (cons-stream
   6
   (stream-filter even? (stream-cdr (cons-stream 6 (stream-map accum (stream-cdr (cons-stream 3 (stream-enumerate-interval 4 20)))))))))
 6)

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 6 (stream-map accum (stream-cdr (cons-stream 3 (stream-enumerate-interval 4 20)))))))
 6)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 3 (stream-enumerate-interval 4 20))))) 6)
(stream-ref
 (stream-filter even? (cons-stream 10 (stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20)))))) 6) ;memoized

(stream-ref
 (cons-stream
  10
  (stream-filter even? (stream-cdr (cons-stream 10 (stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20))))))))
 6)

(stream-ref
 (stream-cdr
  (cons-stream
   10
   (stream-filter even? (stream-cdr (cons-stream 10 (stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20)))))))))
 5)

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 10 (stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20)))))))
 5)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20))))) 5)
(stream-ref (stream-filter even? (stream-map accum (stream-enumerate-interval 5 20))) 5)
(stream-ref (stream-filter even? (stream-map accum (cons-stream 5 (stream-enumerate-interval 6 20)))) 5)

(stream-ref
 (stream-filter even? (cons-stream 15 (stream-map accum (stream-cdr (cons-stream 5 (stream-enumerate-interval 6 20)))))) 5) ;sum = 15

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 15 (stream-map accum (stream-cdr (cons-stream 5 (stream-enumerate-interval 6 20))))))) 5)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 5 (stream-enumerate-interval 6 20))))) 5)
(stream-ref (stream-filter even? (stream-map accum (stream-enumerate-interval 6 20))) 5)
(stream-ref (stream-filter even? (stream-map accum (cons-stream 6 (stream-enumerate-interval 7 20)))) 5)

(stream-ref
 (stream-filter even? (cons-stream 21 (stream-map accum (stream-cdr (cons-stream 6 (stream-enumerate-interval 7 20)))))) 5) ;sum = 21

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 21 (stream-map accum (stream-cdr (cons-stream 6 (stream-enumerate-interval 7 20))))))) 5)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 6 (stream-enumerate-interval 7 20))))) 5)
(stream-ref (stream-filter even? (stream-map accum (stream-enumerate-interval 7 20))) 5)
(stream-ref (stream-filter even? (stream-map accum (cons-stream 7 (stream-enumerate-interval 8 20)))) 5)

(stream-ref
 (stream-filter even? (cons-stream 28 (stream-map accum (stream-cdr (cons-stream 7 (stream-enumerate-interval 8 20)))))) 5) ;sum = 28

(stream-ref
 (cons-stream
  28
  (stream-filter even? (stream-cdr (cons-stream 28 (stream-map accum (stream-cdr (cons-stream 7 (stream-enumerate-interval 8 20))))))))
 5)

(stream-ref
 (stream-cdr
  (cons-stream
   28
   (stream-filter even? (stream-cdr (cons-stream 28 (stream-map accum (stream-cdr (cons-stream 7 (stream-enumerate-interval 8 20)))))))))
 4)

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 28 (stream-map accum (stream-cdr (cons-stream 7 (stream-enumerate-interval 8 20))))))) 4)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 7 (stream-enumerate-interval 8 20))))) 4)
(stream-ref (stream-filter even? (stream-map accum (stream-enumerate-interval 8 20))) 4)
(stream-ref (stream-filter even? (stream-map accum (cons-stream 8 (stream-enumerate-interval 9 20)))) 4)

(stream-ref
 (stream-filter even? (cons-stream 36 (stream-map accum (stream-cdr (cons-stream 8 (stream-enumerate-interval 9 20)))))) 4) ;sum = 36

(stream-ref
 (cons-stream
  36
  (stream-filter even? (stream-cdr (cons-stream 36 (stream-map accum (stream-cdr (cons-stream 8 (stream-enumerate-interval 9 20))))))))
 4)

(stream-ref
 (stream-cdr
  (cons-stream
   36
   (stream-filter even? (stream-cdr (cons-stream 36 (stream-map accum (stream-cdr (cons-stream 8 (stream-enumerate-interval 9 20)))))))))
 3)

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 36 (stream-map accum (stream-cdr (cons-stream 8 (stream-enumerate-interval 9 20))))))) 3)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 8 (stream-enumerate-interval 9 20))))) 3)
(stream-ref (stream-filter even? (stream-map accum (stream-enumerate-interval 9 20))) 3)
(stream-ref (stream-filter even? (stream-map accum (cons-stream 9 (stream-enumerate-interval 10 20)))) 3)

(stream-ref
 (stream-filter even? (cons-stream 45 (stream-map accum (stream-cdr (cons-stream 9 (stream-enumerate-interval 10 20)))))) 3) ;sum = 45

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 45 (stream-map accum (stream-cdr (cons-stream 9 (stream-enumerate-interval 10 20))))))) 3)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 9 (stream-enumerate-interval 10 20))))) 3)
(stream-ref (stream-filter even? (stream-map accum (stream-enumerate-interval 10 20))) 3)
(stream-ref (stream-filter even? (stream-map accum (cons-stream 10 (stream-enumerate-interval 11 20)))) 3)

(stream-ref
 (stream-filter even? (cons-stream 55 (stream-map accum (stream-cdr (cons-stream 10 (stream-enumerate-interval 11 20)))))) 3) ;sum = 55

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 55 (stream-map accum (stream-cdr (cons-stream 10 (stream-enumerate-interval 11 20))))))) 3)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 10 (stream-enumerate-interval 11 20))))) 3)
(stream-ref (stream-filter even? (stream-map accum (stream-enumerate-interval 11 20))) 3)
(stream-ref (stream-filter even? (stream-map accum (cons-stream 11 (stream-enumerate-interval 12 20)))) 3)

(stream-ref
 (stream-filter even? (cons-stream 66 (stream-map accum (stream-cdr (cons-stream 11 (stream-enumerate-interval 12 20)))))) 3) ;sum = 66

(stream-ref
 (cons-stream
  66
  (stream-filter even? (stream-cdr (cons-stream 66 (stream-map accum (stream-cdr (cons-stream 11 (stream-enumerate-interval 12 20))))))))
 3)

(stream-ref
 (stream-cdr
  (cons-stream
   66
   (stream-filter even? (stream-cdr (cons-stream 66 (stream-map accum (stream-cdr (cons-stream 11 (stream-enumerate-interval 12 20)))))))))
 2)

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 66 (stream-map accum (stream-cdr (cons-stream 11 (stream-enumerate-interval 12 20)))))))
 2)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 11 (stream-enumerate-interval 12 20))))) 2)
(stream-ref (stream-filter even? (stream-map accum (stream-enumerate-interval 12 20))) 2)
(stream-ref (stream-filter even? (stream-map accum (cons-stream 12 (stream-enumerate-interval 13 20)))) 2)

(stream-ref
 (stream-filter even? (cons-stream 78 (stream-map accum (stream-cdr (cons-stream 12 (stream-enumerate-interval 13 20)))))) 2) ;sum = 78

(stream-ref
 (cons-stream
  78
  (stream-filter even? (stream-cdr (cons-stream 78 (stream-map accum (stream-cdr (cons-stream 12 (stream-enumerate-interval 13 20))))))))
 2)

(stream-ref
 (stream-cdr
  (cons-stream
   78
   (stream-filter even? (stream-cdr (cons-stream 78 (stream-map accum (stream-cdr (cons-stream 12 (stream-enumerate-interval 13 20)))))))))
 1)

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 78 (stream-map accum (stream-cdr (cons-stream 12 (stream-enumerate-interval 13 20))))))) 1)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 12 (stream-enumerate-interval 13 20))))) 1)
(stream-ref (stream-filter even? (stream-map accum (stream-enumerate-interval 13 20))) 1)
(stream-ref (stream-filter even? (stream-map accum (cons-stream 13 (stream-enumerate-interval 14 20)))) 1)

(stream-ref
 (stream-filter even? (cons-stream 91 (stream-map accum (stream-cdr (cons-stream 13 (stream-enumerate-interval 14 20)))))) 1) ;sum = 91

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 91 (stream-map accum (stream-cdr (cons-stream 13 (stream-enumerate-interval 14 20))))))) 1)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 13 (stream-enumerate-interval 14 20))))) 1)
(stream-ref (stream-filter even? (stream-map accum (stream-enumerate-interval 14 20))) 1)
(stream-ref (stream-filter even? (stream-map accum (cons-stream 14 (stream-enumerate-interval 15 20)))) 1)

(stream-ref
 (stream-filter even? (cons-stream 105 (stream-map accum (stream-cdr (cons-stream 14 (stream-enumerate-interval 15 20)))))) 1) ;sum = 105

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 105 (stream-map accum (stream-cdr (cons-stream 14 (stream-enumerate-interval 15 20))))))) 1)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 14 (stream-enumerate-interval 15 20))))) 1)
(stream-ref (stream-filter even? (stream-map accum (stream-enumerate-interval 15 20))) 1)
(stream-ref (stream-filter even? (stream-map accum (cons-stream 15 (stream-enumerate-interval 16 20)))) 1)

(stream-ref
 (stream-filter even? (cons-stream 120 (stream-map accum (stream-cdr (cons-stream 15 (stream-enumerate-interval 16 20)))))) 1) ;sum = 120

(stream-ref
 (cons-stream
  120
  (stream-filter even? (stream-cdr (cons-stream 120 (stream-map accum (stream-cdr (cons-stream 15 (stream-enumerate-interval 16 20))))))))
 1)

(stream-ref
 (stream-cdr
  (cons-stream
   120
   (stream-filter even? (stream-cdr (cons-stream 120 (stream-map accum (stream-cdr (cons-stream 15 (stream-enumerate-interval 16 20)))))))))
 0)

(stream-ref
 (stream-filter even? (stream-cdr (cons-stream 120 (stream-map accum (stream-cdr (cons-stream 15 (stream-enumerate-interval 16 20)))))))
 0)

(stream-ref (stream-filter even? (stream-map accum (stream-cdr (cons-stream 15 (stream-enumerate-interval 16 20))))) 0)
(stream-ref (stream-filter even? (stream-map accum (stream-enumerate-interval 16 20))) 0)
(stream-ref (stream-filter even? (stream-map accum (cons-stream 16 (stream-enumerate-interval 17 20)))) 0)

(stream-ref
 (stream-filter even? (cons-stream 136 (stream-map accum (stream-cdr (cons-stream 16 (stream-enumerate-interval 17 20)))))) 0) ;sum = 136

(stream-ref
 (cons-stream
  136
  (stream-filter even? (stream-cdr (cons-stream 136 (stream-map accum (stream-cdr (cons-stream 16 (stream-enumerate-interval 17 20))))))))
 0)

136

;;memoized: everything up to (stream-map accum (stream-cdr (cons-stream 16 (stream-enumerate-interval 17 20)))), and this was not called

;;on (display-stream z). 
(display-stream
 (cons-stream 10
	      (stream-filter
	       (lambda (x) (= (remainder x 5) 0))
	       (stream-cdr (cons-stream 10 (stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20)))))))))

(stream-for-each
 display-line
 (cons-stream 10
	      (stream-filter
	       (lambda (x) (= (remainder x 5) 0))
	       (stream-cdr (cons-stream 10 (stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20)))))))))

;;(display-line 10)
(stream-for-each
 display-line
 (stream-cdr
  (cons-stream
   10
   (stream-filter (lambda (x) (= (remainder x 5) 0))
		  (stream-cdr (cons-stream 10 (stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20))))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-cdr (cons-stream 10 (stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 4 (stream-enumerate-interval 5 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-enumerate-interval 5 20))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (cons-stream 5 (stream-enumerate-interval 6 20)))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 15 (stream-map accum (stream-cdr (cons-stream 5 (stream-enumerate-interval 6 20))))))) ;memoized

(stream-for-each
 display-line
 (cons-stream
  15
  (stream-filter (lambda (x) (= (remainder x 5) 0))
		 (stream-cdr (cons-stream 15 (stream-map accum (stream-cdr (cons-stream 5 (stream-enumerate-interval 6 20)))))))))

;;(display-line 15)
(stream-for-each
 display-line
 (stream-cdr
  (cons-stream
   15
   (stream-filter (lambda (x) (= (remainder x 5) 0))
		  (stream-cdr (cons-stream 15 (stream-map accum (stream-cdr (cons-stream 5 (stream-enumerate-interval 6 20))))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
	        (stream-cdr (cons-stream 15 (stream-map accum (stream-cdr (cons-stream 5 (stream-enumerate-interval 6 20))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 5 (stream-enumerate-interval 6 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 21 (stream-map accum (stream-cdr (cons-stream 6 (stream-enumerate-interval 7 20))))))) ;memoized

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-cdr (cons-stream 21 (stream-map accum (stream-cdr (cons-stream 6 (stream-enumerate-interval 7 20))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 6 (stream-enumerate-interval 7 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 28 (stream-map accum (stream-cdr (cons-stream 7 (stream-enumerate-interval 8 20))))))) ;memoized

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-cdr (cons-stream 28 (stream-map accum (stream-cdr (cons-stream 7 (stream-enumerate-interval 8 20))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 7 (stream-enumerate-interval 8 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 36 (stream-map accum (stream-cdr (cons-stream 8 (stream-enumerate-interval 9 20))))))) ;memoized

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-cdr (cons-stream 36 (stream-map accum (stream-cdr (cons-stream 8 (stream-enumerate-interval 9 20))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 8 (stream-enumerate-interval 9 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 45 (stream-map accum (stream-cdr (cons-stream 9 (stream-enumerate-interval 10 20))))))) ;memoized

(stream-for-each
 display-line
 (cons-stream
  45
  (stream-filter (lambda (x) (= (remainder x 5) 0))
		 (stream-cdr (cons-stream 45 (stream-map accum (stream-cdr (cons-stream 9 (stream-enumerate-interval 10 20)))))))))

;;(display-line 45)
(stream-for-each
 display-line
 (stream-cdr
  (cons-stream
   45
   (stream-filter (lambda (x) (= (remainder x 5) 0))
		  (stream-cdr (cons-stream 45 (stream-map accum (stream-cdr (cons-stream 9 (stream-enumerate-interval 10 20))))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-cdr (cons-stream 45 (stream-map accum (stream-cdr (cons-stream 9 (stream-enumerate-interval 10 20))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 9 (stream-enumerate-interval 10 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 55 (stream-map accum (stream-cdr (cons-stream 10 (stream-enumerate-interval 11 20))))))) ;memoized
 
(stream-for-each
 display-line
 (cons-stream
  55
  (stream-filter (lambda (x) (= (remainder x 5) 0))
		 (stream-cdr (cons-stream 55 (stream-map accum (stream-cdr (cons-stream 10 (stream-enumerate-interval 11 20)))))))))

;;(display-line 55)
(stream-for-each
 display-line
 (stream-cdr
  (cons-stream
   55
   (stream-filter (lambda (x) (= (remainder x 5) 0))
		  (stream-cdr (cons-stream 55 (stream-map accum (stream-cdr (cons-stream 10 (stream-enumerate-interval 11 20))))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-cdr (cons-stream 55 (stream-map accum (stream-cdr (cons-stream 10 (stream-enumerate-interval 11 20))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 10 (stream-enumerate-interval 11 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 66 (stream-map accum (stream-cdr (cons-stream 11 (stream-enumerate-interval 12 20)))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-cdr (cons-stream 66 (stream-map accum (stream-cdr (cons-stream 11 (stream-enumerate-interval 12 20))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 11 (stream-enumerate-interval 12 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 78 (stream-map accum (stream-cdr (cons-stream 12 (stream-enumerate-interval 13 20)))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-cdr (cons-stream 78 (stream-map accum (stream-cdr (cons-stream 12 (stream-enumerate-interval 13 20))))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 12 (stream-enumerate-interval 13 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 91 (stream-map accum (stream-cdr (cons-stream 13 (stream-enumerate-interval 14 20)))))))

;;for time, we will skip some intermediary steps

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 13 (stream-enumerate-interval 14 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 105 (stream-map accum (stream-cdr (cons-stream 14 (stream-enumerate-interval 15 20)))))))

(stream-for-each
 display-line
 (cons-stream
  105
  (stream-filter (lambda (x) (= (remainder x 5) 0))
		 (stream-map accum (stream-cdr (cons-stream 14 (stream-enumerate-interval 15 20)))))))

;;(display-line 105)
(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 14 (stream-enumerate-interval 15 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 120 (stream-map accum (stream-cdr (cons-stream 15 (stream-enumerate-interval 16 20)))))))

(stream-for-each
 display-line
 (cons-stream
  120
  (stream-filter (lambda (x) (= (remainder x 5) 0))
		 (stream-map accum (stream-cdr (cons-stream 15 (stream-enumerate-interval 16 20)))))))

;;(display-line 120)
(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 15 (stream-enumerate-interval 16 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 136 (stream-map accum (stream-cdr (cons-stream 16 (stream-enumerate-interval 17 20)))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 16 (stream-enumerate-interval 17 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 153 (stream-map accum (stream-cdr (cons-stream 17 (stream-enumerate-interval 18 20)))))))

;;skipping steps even further now

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 171 (stream-map accum (stream-cdr (cons-stream 18 (stream-enumerate-interval 19 20)))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 190 (stream-map accum (stream-cdr (cons-stream 19 (stream-enumerate-interval 20 20)))))))

(stream-for-each
 display-line
 (cons-stream
  190
  (stream-filter (lambda (x) (= (remainder x 5) 0))
		 (stream-map accum (stream-cdr (cons-stream 19 (stream-enumerate-interval 20 20)))))))

;;(display-line 190)
(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
	        (stream-map accum (stream-cdr (cons-stream 19 (stream-enumerate-interval 20 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(cons-stream 210 (stream-map accum (stream-cdr (cons-stream 20 (stream-enumerate-interval 21 20)))))))

(stream-for-each
 display-line
 (cons-stream
  210
  (stream-filter (lambda (x) (= (remainder x 5) 0))
		 (stream-map accum (stream-cdr (cons-stream 20 (stream-enumerate-interval 21 20)))))))

;;(display-line 210)
(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum (stream-cdr (cons-stream 20 (stream-enumerate-interval 21 20))))))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		(stream-map accum the-empty-stream)))

(stream-for-each
 display-line
 (stream-filter (lambda (x) (= (remainder x 5) 0))
		the-empty-stream))

(stream-for-each
 display-line
 the-empty-stream)

'done


;;This, so far, is the hardest exercise in the book. It required me to rethink the model of evaluation. Delayed evaluation is actually not that difficult to comprehend. I thought that the key difference between lists and streams was just that, the delayed evaluation. But the real difficulty lies in the memoization. Together, delayed evaluation and memoization are what make streams fundamentally different. In fact, being able to use streams as an abstraction like lists requires memoization. Without memoization the streams would produce different results than their list counterpart. After drawing this whole process I get that we really don't have to worry about the delayed evaluation or the memoization after all. Just treat them like lists. This tip would have saved me two months.

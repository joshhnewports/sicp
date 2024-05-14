(define x (stream-map show (stream-enumerate-interval 0 10)))

;;on definition of x
(stream-map show (cons 0 (delay (stream-enumerate-interval 1 10))))
(cons (show 0) (delay (stream-map show (force (cdr (cons 0 (delay (stream-enumerate-interval 1 10)))))))) ;=> 0

;;evaluate (stream-ref x 5)
(stream-ref x 5)
(stream-ref (cons (show 0) (delay (stream-map show (force (cdr (cons 0 (delay (stream-enumerate-interval 1 10)))))))) 5)

(stream-ref (force (cdr (cons (show 0) (delay (stream-map show (force (cdr (cons 0 (delay (stream-enumerate-interval 1 10)))))))))) 4)
(stream-ref (force (delay (stream-map show (force (cdr (cons 0 (delay (stream-enumerate-interval 1 10)))))))) 4)
(stream-ref (stream-map show (force (cdr (cons 0 (delay (stream-enumerate-interval 1 10)))))) 4)
(stream-ref (stream-map show (force (delay (stream-enumerate-interval 1 10)))) 4)
(stream-ref (stream-map show (stream-enumerate-interval 1 10)) 4)
(stream-ref (stream-map show (cons 1 (delay (stream-enumerate-interval 2 10)))) 4)
(stream-ref (cons (show 1) (delay (stream-map show (force (cdr (cons 1 (delay (stream-enumerate-interval 2 10)))))))) 4) ;=> 1

(stream-ref (force (cdr (cons (show 1) (delay (stream-map show (force (cdr (cons 1 (delay (stream-enumerate-interval 2 10)))))))))) 3)
(stream-ref (force (delay (stream-map show (force (cdr (cons 1 (delay (stream-enumerate-interval 2 10)))))))) 3)
(stream-ref (stream-map show (force (cdr (cons 1 (delay (stream-enumerate-interval 2 10)))))) 3)
(stream-ref (stream-map show (force (delay (stream-enumerate-interval 2 10)))) 3)
(stream-ref (stream-map show (stream-enumerate-interval 2 10)) 3)
(stream-ref (stream-map show (cons 2 (delay (stream-enumerate-interval 3 10)))) 3)
(stream-ref (cons (show 2) (delay (stream-map show (force (cdr (cons 2 (delay (stream-enumerate-interval 3 10)))))))) 3) ;=> 2

(stream-ref (force (cdr (cons (show 2) (delay (stream-map show (force (cdr (cons 2 (delay (stream-enumerate-interval 3 10)))))))))) 2)
(stream-ref (force (delay (stream-map show (force (cdr (cons 2 (delay (stream-enumerate-interval 3 10)))))))) 2)
(stream-ref (stream-map show (force (cdr (cons 2 (delay (stream-enumerate-interval 3 10)))))) 2)
(stream-ref (stream-map show (force (delay (stream-enumerate-interval 3 10)))) 2)
(stream-ref (stream-map show (stream-enumerate-interval 3 10)) 2)
(stream-ref (stream-map show (cons 3 (delay (stream-enumerate-interval 4 10)))) 2)
(stream-ref (cons (show 3) (delay (stream-map show (force (cdr (cons 3 (delay (stream-enumerate-interval 4 10)))))))) 2) ;=> 3

(stream-ref (force (cdr (cons (show 3) (delay (stream-map show (force (cdr (cons 3 (delay (stream-enumerate-interval 4 10)))))))))) 1)
(stream-ref (force (delay (stream-map show (force (cdr (cons 3 (delay (stream-enumerate-interval 4 10)))))))) 1)
(stream-ref (stream-map show (force (cdr (cons 3 (delay (stream-enumerate-interval 4 10)))))) 1)
(stream-ref (stream-map show (force (delay (stream-enumerate-interval 4 10)))) 1)
(stream-ref (stream-map show (stream-enumerate-interval 4 10)) 1)
(stream-ref (stream-map show (cons 4 (delay (stream-enumerate-interval 5 10)))) 1)
(stream-ref (cons (show 4) (delay (stream-map show (force (cdr (cons 4 (delay (stream-enumerate-interval 5 10)))))))) 1) ;=> 4

(stream-ref (force (cdr (cons (show 4) (delay (stream-map show (force (cdr (cons 4 (delay (stream-enumerate-interval 5 10)))))))))) 0)
(stream-ref (force (delay (stream-map show (force (cdr (cons 4 (delay (stream-enumerate-interval 5 10)))))))) 0)
(stream-ref (stream-map show (force (cdr (cons 4 (delay (stream-enumerate-interval 5 10)))))) 0)
(stream-ref (stream-map show (force (delay (stream-enumerate-interval 5 10)))) 0)
(stream-ref (stream-map show (stream-enumerate-interval 5 10)) 0)
(stream-ref (stream-map show (cons 5 (delay (stream-enumerate-interval 6 10)))) 0)
(stream-ref (cons (show 5) (delay (stream-map show (force (cdr (cons 5 (delay (stream-enumerate-interval 6 10)))))))) 0) ;=> 5

(stream-car (cons 5 (delay (stream-map show (force (cdr (cons 5 (delay (stream-enumerate-interval 6 10)))))))))
5

;;Hand-made trace of (stream-ref x 5). Possibly wrong.
;;I have substituted stream-cdr for (force (cdr ...)) and decided to keep (show x) instead of evaluating it to x as well as
;;showing the number show prints as a comment beside its line.

;;Now for (stream-ref x 7). We do the very same, except that (show x) is memoized for numbers 1 through 5
;;and their values are simply returned. We do not compute show, as in (proc), in the definition of memo-proc. Therefore we do not print
;;each number by means of (display-line x). Since 6 and 7 are unaffected by this, they are displayed.

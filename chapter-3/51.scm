(define x (stream-map show (stream-enumerate-interval 0 10)))

;;on definition of x
(stream-map show (cons-stream 0 (stream-enumerate-interval 1 10)))
(cons-stream 0 (stream-map show (cons-stream 1 (stream-enumerate-interval 2 10)))) ;=> 0

;;evaluate (stream-ref x 5)
(stream-ref x 5)
(stream-ref (cons-stream 0 (stream-map show (cons-stream 1 (stream-enumerate-interval 2 10)))) 5)
(stream-ref (cons-stream 1 (stream-map show (cons-stream 2 (stream-enumerate-interval 3 10)))) 4) ;=> 1
(stream-ref (cons-stream 2 (stream-map show (cons-stream 3 (stream-enumerate-interval 4 10)))) 3) ;=> 2
(stream-ref (cons-stream 3 (stream-map show (cons-stream 4 (stream-enumerate-interval 5 10)))) 2) ;=> 3
(stream-ref (cons-stream 4 (stream-map show (cons-stream 5 (stream-enumerate-interval 6 10)))) 1) ;=> 4
(stream-ref (cons-stream 5 (stream-map show (cons-stream 6 (stream-enumerate-interval 7 10)))) 0) ;=> 5
5

;;evaluate (stream-ref x 7)
(stream-ref x 7)
(stream-ref (cons-stream 0 (stream-map show (cons-stream 1 (stream-enumerate-interval 2 10)))) 7)
(stream-ref (cons-stream 1 (stream-map show (cons-stream 2 (stream-enumerate-interval 3 10)))) 6)
(stream-ref (cons-stream 2 (stream-map show (cons-stream 3 (stream-enumerate-interval 4 10)))) 5)
(stream-ref (cons-stream 3 (stream-map show (cons-stream 4 (stream-enumerate-interval 5 10)))) 4)
(stream-ref (cons-stream 4 (stream-map show (cons-stream 5 (stream-enumerate-interval 6 10)))) 3)
(stream-ref (cons-stream 5 (stream-map show (cons-stream 6 (stream-enumerate-interval 7 10)))) 2)
(stream-ref (cons-stream 6 (stream-map show (cons-stream 7 (stream-enumerate-interval 8 10)))) 1) ;=> 6
(stream-ref (cons-stream 7 (stream-map show (cons-stream 8 (stream-enumerate-interval 9 10)))) 0) ;=> 7
7

;;As to why when running the individual calls of stream-ref we do not change the state of x is because
;;the stream we have written above is not x but some textual way of representing the stream representing x.
;;Only on the calls (stream-ref x 5) and (stream-ref x 7) does the state of x change.

;;Suppose we define x then evaluate (stream-ref x 7). The numbers printed are 1 through 7.
;;Define x once more and evaluate (stream-ref x 5). Then evaluate (stream-ref x 7). The numbers printed are
;;6 and 7. This is because the display-line expression of show has been memoized out of the procedure and only
;;the returned value of (show x), that being x, is the value of each call of show to the first 5 numbers
;;of the stream.

;;We have, in this version, not written cons, delay, force, or stream-cdr, and simply just evaluated up front.

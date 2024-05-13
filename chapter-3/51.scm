(define x (stream-map show (stream-enumerate-interval 0 10)))

(stream-map show (cons 0 (delay (stream-enumerate-interval 1 10))))
(cons (show 0) (delay (stream-map show (force (cdr (cons 0 (delay (stream-enumerate-interval 1 10))))))))

(stream-ref (cons (show 0) (delay (stream-map show (force (cdr (cons 0 (delay (stream-enumerate-interval 1 10)))))))) 5)

(stream-ref (force (cdr (cons (show 0) (delay (stream-map show (force (cdr (cons 0 (delay (stream-enumerate-interval 1 10)))))))))) 4)
(stream-ref (force (delay (stream-map show (force (cdr (cons 0 (delay (stream-enumerate-interval 1 10)))))))) 4)
(stream-ref (stream-map show (force (cdr (cons 0 (delay (stream-enumerate-interval 1 10)))))) 4)
(stream-ref (stream-map show (force (delay (stream-enumerate-interval 1 10)))) 4)
(stream-ref (stream-map show (stream-enumerate-interval 1 10)) 4)
(stream-ref (stream-map show (cons 1 (delay (stream-enumerate-interval 2 10)))) 4)
(stream-ref (cons (show 1) (delay (stream-map show (force (cdr (cons 1 (delay (stream-enumerate-interval 2 10)))))))) 4)

(stream-ref (force (cdr (cons (show 1) (delay (stream-map show (force (cdr (cons 1 (delay (stream-enumerate-interval 2 10)))))))))) 3)
(stream-ref (force (delay (stream-map show (force (cdr (cons 1 (delay (stream-enumerate-interval 2 10)))))))) 3)
(stream-ref (stream-map show (force (cdr (cons 1 (delay (stream-enumerate-interval 2 10)))))) 3)
(stream-ref (stream-map show (force (delay (stream-enumerate-interval 2 10)))) 3)
(stream-ref (stream-map show (stream-enumerate-interval 2 10)) 3)
(stream-ref (stream-map show (cons 2 (delay (stream-enumerate-interval 3 10)))) 3)
(stream-ref (cons (show 2) (delay (stream-map show (force (cdr (cons 2 (delay (stream-enumerate-interval 3 10)))))))) 3)

(stream-ref (force (cdr (cons (show 2) (delay (stream-map show (force (cdr (cons 2 (delay (stream-enumerate-interval 3 10)))))))))) 2)
(stream-ref (force (delay (stream-map show (force (cdr (cons 2 (delay (stream-enumerate-interval 3 10)))))))) 2)
(stream-ref (stream-map show (force (cdr (cons 2 (delay (stream-enumerate-interval 3 10)))))) 2)
(stream-ref (stream-map show (force (delay (stream-enumerate-interval 3 10)))) 2)
(stream-ref (stream-map show (stream-enumerate-interval 3 10)) 2)
(stream-ref (stream-map show (cons 3 (delay (stream-enumerate-interval 4 10)))) 2)
(stream-ref (cons (show 3) (delay (stream-map show (force (cdr (cons 3 (delay (stream-enumerate-interval 4 10)))))))) 2)

(stream-ref (force (cdr (cons (show 3) (delay (stream-map show (force (cdr (cons 3 (delay (stream-enumerate-interval 4 10)))))))))) 1)
(stream-ref (force (delay (stream-map show (force (cdr (cons 3 (delay (stream-enumerate-interval 4 10)))))))) 1)
(stream-ref 

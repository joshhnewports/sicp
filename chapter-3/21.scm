;;when the Lisp printer writes a queue, it gives the list from the front-ptr cons'd to the list at the rear-ptr.
(define (print-queue queue) (front-ptr queue)) ;simply move the queue ptr to be what the front-ptr points at

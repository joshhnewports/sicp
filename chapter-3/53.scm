(define integers (cons-stream 1 (add-streams ones integers))) ;integers => 1

(define (add-streams s1 s2) (stream-map + s1 s2))

(stream-cdr (stream-cdr (stream-cdr integers)))
(stream-cdr (stream-cdr (stream-cdr (cons-stream 1 (add-streams ones integers)))))

(stream-cdr (stream-cdr (add-streams ones (cons-stream 1 (add-streams ones integers)))))

(stream-cdr (stream-cdr (cons-stream 2 (add-streams ones (cons-stream 1 (cons-stream 2 integers))))))


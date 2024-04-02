(define rock-alphabet
  '((a 2) (get 2) (sha 3) (wah 1) (boom 1) (job 2) (na 16) (yip 9)))

(define rock-huffman (generate-huffman-tree rock-alphabet))

(define rock-message
  '(get a job sha na na na na na na na na get a job sha na na na na na na na na
	wah yip yip yip yip yip yip yip yip yip sha boom))

(define rock-encoding (encode rock-message rock-huffman))

(define number-of-bits (length rock-encoding)) ;84

;;For a fixed-length code, log_2 8 = 3 bits per symbol.
;;To encode this song using a fixed-length code,
;;we would need at least (* (length rock-message) 3) = 108 bits.

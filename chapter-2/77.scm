(magnitude z) 
(magnitude (cons 'complex (cons 'rectangular (cons 3 4)))) ;expand z
(apply-generic 'magnitude (cons 'complex (cons 'rectangular (cons 3 4)))) ;magnitude calls apply-generic
(apply magnitude (list (cons 'rectangular (cons 3 4)))) ;gets complex magnitude procedure, which is just the general
					;magnitude procedure
(magnitude (cons 'rectangular (cons 3 4))) ;simply the general magnitude procedure on a rectangular number
(apply-generic 'magnitude (cons 'rectangular (cons 3 4))) ;magnitude calls apply-generic
(apply magnitude (list (cons 3 4))) ;apply rectangular magnitude
(sqrt (+ (square (real-part (cons 3 4)))
	 (square (imag-part (cons 3 4)))))
(sqrt (+ (square 3)
	 (square 4)))
5

;;apply-generic will repeatedly strip off a tag if a (put 'magnitude <type> magnitude) exists
;;until there is a magnitude procedure that operates as desired

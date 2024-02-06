(define (last-pair list) ;assume list is nonempty
  (if (null? (cdr list))
      list
      (last-pair (cdr list))))

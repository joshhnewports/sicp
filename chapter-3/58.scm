(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) den radix)))

schemewiki says this "is the floating-point representation of (/ num den) with radix as the base."

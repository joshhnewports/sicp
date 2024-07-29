(define (div-series s1 s2)
  (if (zero? (stream-car s2))
      (error "Division by zero" s2)
      (mul-series s1 (invert-unit-series s2))))

(define tangent-series
  (div-series sine-series cosine-series))

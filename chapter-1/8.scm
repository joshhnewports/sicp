(define (cbrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (cbrt-iter (improve guess x) x)))

(define (improve guess x)
  (/ (+ (/ x (square guess))
	(* 2 guess))
     3))

(define (good-enough? guess x)
  (< (abs (- (cube guess) x))
     (/ guess 100000)))

(define (cbrt x)
  (cbrt-iter 1.0 x))

(define (cube x)
  (* (square x) x))

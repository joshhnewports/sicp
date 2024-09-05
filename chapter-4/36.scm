In the procedure that uses an-integer-between, suppose i and j are values that satisfy. Suppose also that k has no
possible values between j and high. Then k will amb through all of these choices before backtracking to the most
recent choice point. We know it will backtrack at some point unlike the procedure with an-integer-starting-from.
With this, k may amb through all integers before backtracking. This is not adequate.

(define (pythagorean-triple)
  (let ((i (an-integer-starting-from 1)))
    (let ((j (an-integer-starting-from i)))
      (let ((k (an-integer-between (+ j 1) (+ i j))))
	(require (= (+ (* i i) (* j j)) (* k k)))
	(list i j k)))))

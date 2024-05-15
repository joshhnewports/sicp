;;(define seq ...) leaves sum at 1. 
;;(define y ...) generates 2 in seq, sets sum to 3, returns 3, and the filter of y rejects 3, generates 3 in seq,
;;sets sum to 6, returns 6, and the filter of y accepts 6.

;;Now seq = {1 3 6 ...} and y = {6 ...}.

;;(define z ...) generates 4 in seq, sets sum to 10, returns 10, and the filter of z accepts 10.

;;Now seq = {1 3 6 10 ...} and y = {6 ...} and z = {10 ...}

;;(stream-ref y 7) accepts 10, generates 5 in seq, sets sum to 15, returns 15, rejects 15, generates 6 in seq,
;;sets sum to 21, returns 21, rejects 21, generates 7 in seq, sets sum to 28, returns 28, accepts 28, generates
;;8 in seq, sets sum to 36, returns 36, accepts 36, generates 9 in seq, sets sum to 45, returns 45, rejects 45,
;;generates 10 in seq, sets sum to 55, returns 55, rejects 55, generates 11 in seq, sets sum to 66, returns 66,
;;accepts 66, generates 12 in seq, sets sum to 78, returns 78, accepts 78, generates 13 in seq, sets sum to 91,
;;returns 91, rejects 91, generates 14 in seq, sets sum to 105, returns 105, rejects 105, generates 15 in seq,
;;sets sum to 120, returns 120, accepts 120, generates 16 in seq, sets sum to 136, returns 136, accepts 136,
;;and the value of (stream-ref y 7) is 136.

;;Now seq = {1 3 6 10 15 21 28 36 45 55 66 78 91 105 120 136 ...} and y = {6 10 28 36 66 78 120 136 ...} and
;;z = {10 ...}

;;(display-stream z) accepts 15, 45, 55, 105, 120, generates 17 in seq, sets sum to 153, returns 153, rejects 153,
;;generates 18 in seq, sets sum to 171, returns 171, rejects 171, generates 19 in seq, sets sum to 190, returns 190,
;;accepts 190, generates 20 in seq, sets sum to 210, returns 210, accepts 210, and now seq has reached its limit.
;;This leaves z = {10 15 45 55 105 120 190 210}

;;Without memo-proc each time an element is referenced in seq will recompute (set! sum (+ x sum)).
;;With memo-proc, the resulting value, which is sum, is simply returned. Ultimately, sum would be much greater
;;than it is without memo-proc and the streams would change their elements' values with each stream-cdr call.

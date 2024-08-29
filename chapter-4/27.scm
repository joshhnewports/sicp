(define w (id (id 10)))

;;we apply id to (id 10). (id 10) becomes a thunk then the body of id is to be evaluated.
;;the first expression (set! count (+ count 1)) sets count to 1 and the thunk having expression (id 10) is returned
;;as the value of w.

;;the response to count is 1.

;;the response to w is 10. evaluating w calls lookup-variable-value and returns the thunk. with the change
;;to driver-loop, a thunk's value is its actual-value. this sets the thunk to an evaluated-thunk and sets the
;;expression of the evaluated-thunk to be the eval of the exp (id 10). this sets count to 2 and returns 10.
;;now the state-changing side effect is removed and repeated calls to w do not change count.

;;the reponse to count is 2.

;;factorial for n = 4

continue <- (label fact-done)

stack<-((label fact-done))
stack<-(4 (label fact-done))
n<-3
continue<-(label after-fact)
(goto (label fact-loop))

stack<-((label after-fact) 4 (label fact-done))
stack<-(3 (label after-fact) 4 (label fact-done))
n<-2
continue<-(label after-fact)
(goto (label fact-loop))

stack<-((label after-fact) 3 (label after-fact) 4 (label fact-done))
stack<-(2 (label after-fact) 3 (label after-fact) 4 (label fact-done))
n<-1
continue<-(label after-fact)
(goto (label fact-loop))

(branch (label base-case))

val<-1
(goto (reg continue))

n<-2
stack<-((label after-fact) 3 (label after-fact) 4 (label fact-done))
continue<-(label after-fact)
stack<-(3 (label after-fact) 4 (label fact-done))
val<-2
(goto (reg continue))

n<-3
stack<-((label after-fact) 4 (label fact-done))
continue<-(label after-fact)
stack<-(4 (label fact-done))
val<-6
(goto (reg continue))

n<-4
stack<-((label fact-done))
continue<-(label fact-done)
stack<-()
val<-24
(goto (reg continue))

fact-done

;;fibonacci for n = 4

continue<-(label fib-done)

stack<-((label fib-done))
continue<-(label afterfib-n-1)
stack<-(4 (label fib-done))
n<-3
(goto (label fib-loop))

stack<-((label afterfib-n-1) 4 (label fib-done))
continue<-(label afterfib-n-1)
stack<-(3 (label-afterfib-n-1) 4 (label fib-done))
n<-2
(goto (label fib-loop))

stack<-((label afterfib-n-1) 3 (label-afterfib-n-1) 4 (label fib-done))
continue<-(label afterfib-n-1)
stack<-(2 (label afterfib-n-1) 3 (label-afterfib-n-1) 4 (label fib-done))
n<-1
(goto (label fib-loop))

(branch (label immediate-answer))

val<-1
(goto (reg continue))

n<-2
stack<-((label afterfib-n-1) 3 (label-afterfib-n-1) 4 (label fib-done))
continue<-(label afterfib-n-1)
stack<-(3 (label-afterfib-n-1) 4 (label fib-done))
n<-0
stack<-((label afterfib-n-1) 3 (label-afterfib-n-1) 4 (label fib-done))
continue<-(label afterfib-n-2)
stack<-(1 (label afterfib-n-1) 3 (label-afterfib-n-1) 4 (label fib-done))
(goto (label fib-loop))

(branch (label immediate-answer))

val<-0
(goto (reg continue))

n<-0
val<-1
stack<-((label afterfib-n-1) 3 (label-afterfib-n-1) 4 (label fib-done))
continue<-(label afterfib-n-1)
stack<-(3 (label-afterfib-n-1) 4 (label fib-done))
val<-1
(goto (reg continue))

n<-3
stack<-((label-afterfib-n-1) 4 (label fib-done))
continue<-(label afterfib-n-1)
stack<-(4 (label fib-done))
n<-1
stack<-((label afterfib-n-1) 4 (label fib-done))
continue<-(label afterfib-n-2)
stack<-(1 (label afterfib-n-1) 4 (label fib-done))
(goto (label fib-loop))

(branch (label immediate-answer))

val<-1
(goto (reg continue))

n<-1
val<-1
stack<-((label afterfib-n-1) 4 (label fib-done))
continue<-(label afterfib-n-1)
stack<-(4 (label fib-done))
val<-2
(goto (reg continue))

n<-4
stack<-((label fib-done))
continue<-(label fib-done)
stack<-()
n<-2
stack<-((label fib-done))
continue<-(label afterfib-n-2)
stack<-(2 (label fib-done))
(goto (label fib-loop))

stack<-((label afterfib-n-2) 2 (label fib-done))
continue<-(label afterfib-n-1)
stack<-(2 (label afterfib-n-2) 2 (label fib-done))
n<-1
(goto (label fib-loop))

(branch (label immediate-answer))

val<-1
(goto (reg continue))

n<-2
stack<-((label afterfib-n-2) 2 (label fib-done))
continue<-(label afterfib-n-2)
stack<-(2 (label fib-done))
n<-0
stack<-((label afterfib-n-2) 2 (label fib-done))
continue<-(label afterfib-n-2)
stack<-(1 (label afterfib-n-2) 2 (label fib-done))
(goto (label fib-loop))

(branch (label immediate-answer))

val<-0
(goto (reg continue))

n<-0
val<-1
stack<-((label afterfib-n-2) 2 (label fib-done))
continue<-(label afterfib-n-2)
stack<-(2 (label fib-done))
val<-1
(goto (reg continue))

n<-1
val<-2
stack<-((label fib-done))
continue<-(label fib-done)
stack<-()
val<-3
(goto (reg continue))

fib-done

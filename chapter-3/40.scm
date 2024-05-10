We could change the order of some possibilities but multiplication is commutative so it is not necessary.

100: P_1 accesses x at 10 then P_2 sets x to 1000, then P_1 sets x to 100
1,000: P_2 accesses x at 10, then P_1 sets x to 100, then P_2 sets x to 1000
10,000: P_1 sets x to 100 then P_2 sets x to 10000
        P_1 accesses x at 10 and 1000 where P_2 executes in between, and P_1 sets x to 10000
        P_2 accesses x at 10, 10, and 100 where P_1 executes in between, and P_2 sets x to 10000
100,000: P_2 accesses x at 10, 100, and 100 where P_1 executes in between, and P_2 sets x to 100000
1,000,000: P_2 sets x to 1000 then P_1 sets x to 1000000

With serialization, P_1 sets x to 100 then P_2 sets x to 1,000,000 or P_2 sets x to 1000 and P_1 sets x to 1,000,000.

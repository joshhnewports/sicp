This procedure is considerably less efficient because the redundant computation comes from the lack of memoization. The name sqrt-stream is not bound to a stream but to a procedure. Hence calls to sqrt-stream create a new stream and do not refer to an already-existing stream where memoization can occur. Since the memoization cannot occur anyways, it would not matter if delay was defined not in terms of memo-proc.
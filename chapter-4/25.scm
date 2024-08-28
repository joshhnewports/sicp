In applicative-order, the usual-value expression will recurse forever because procedures are strict in
each argument. In normal-order, the body of the procedure begins to be evaluated before the arguments. Hence under
normal-order factorial has its control structure acting correctly.

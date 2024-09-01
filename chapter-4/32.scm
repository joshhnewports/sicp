Evaluating a stream evaluates its car and evaluating a lazy list does not evaluate its car. By Footnote 41 we get
lazy trees. If we designed a tree from a stream then the the left-most path down the tree, the car, is automatically
evaluated. By doing the same with lazy lists, subtrees evaluate only when forced.

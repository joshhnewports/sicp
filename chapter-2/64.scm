;;Since partial-tree returns a pair whose car is a tree and whose cdr is the list of elements not
;;included in the tree, then when n = 0 it returns a pair with an empty tree and the list of elements.
;;Otherwise, we take the partial tree of the first half of the list, the element in the middle of the list,
;;which we call this-entry, and we take the partial tree of the right half of the list.
;;We construct a pair such that the car is the tree having this-entry and the left and right tree, and the cdr
;;is the list of elements not in the tree.

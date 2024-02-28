;;The expression (car ''abracadabra) is (car (quote (quote abracadabra))).
;;The expression (quote (quote abracadabra)) evaluates to (quote abracadabra).
;;We get the car of the list (quote abracadabra), which is quote.

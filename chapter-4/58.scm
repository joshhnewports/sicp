(rule (big-shot ?person ?division)
      (and (job ?person (?division . ?x))
	   (job ?super (?division . ?y))
	   (not (supervisor ?person ?super))))

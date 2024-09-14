(meeting ?division (Friday ?time))

(rule (meeting-time ?person ?day-and-time)
      (and (job ?person (?division . ?x))
	   (or (meeting ?division ?day-and-time)
	       (meeting whole-company ?day-and-time))))

(meeting-time (Hacker Alyssa P) (Wednesday ?time))

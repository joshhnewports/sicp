(rule (can-replace ?person-1 ?person-2)
      (job ?person-1 (?division . ?job-1))
      (job ?person-2 (?division . ?job-2))
      (and (or (same ?job-1 ?job-2)
	       (and (job ?person-3 (?division . ?job-1))
		    (can-do-job ?job-1 ?job-2)))
	   (not (same person-1 person-2))))

(can-replace ?x (Fect Cy D))


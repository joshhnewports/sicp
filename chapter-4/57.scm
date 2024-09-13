;;originally misinterpreted the rule while reading
(rule (can-replace ?person-1 ?person-2)
      (and (job ?person-1 ?job-1)
	   (job ?person-2 ?job-2)
	   (or (same ?job-1 ?job-2)
	       (can-do-job ?job-1 ?job-2))
	   (not (same ?person-1 ?person-2))))

(can-replace ?x (Fect Cy D))

(and (salary ?person-1 ?amount-1)
     (salary ?person-2 ?amount-2)
     (lisp-value < ?amount-1 ?amount-2)
     (can-replace ?person-1 ?person-2))

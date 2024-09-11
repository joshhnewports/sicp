(and (supervisor ?p (Bitdiddle Ben))
     (address ?p ?a))

(and (salary ?p ?s)
     (salary (Bitdiddle Ben) ?bs)
     (lisp-value < ?s ?bs))

(and (supervisor ?p ?supervisor)
     (not (job ?supervisor (computer . ?type)))
     (job ?supervisor ?job))

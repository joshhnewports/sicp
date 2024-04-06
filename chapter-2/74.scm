;;each division has a file
;;each file contains a set of some structure
;;said set has elements being a record attached to an employee's name
;;said record itself a set of some structure
;;each record has information attached to identifiers such as address and salary

;;a. let for clarity.
(define (get-record employee file)
  (let ((file-tag (type-tag file))
	(set-of-records (records file)))
    ((get 'record file-tag) employee set-of-records)))

;;Each division must supply:
;;  a tag attached to their file that can be accessed by some procedure type-tag,
;;  a procedure records that accesses the set of records from their file,
;;  a procedure put into a table that is accessed by (get 'record file-tag)
;;  and takes employee and set-of-records as arguments.

;;b. let for clarity.
(define (get-salary record)
  (let ((record-tag (type-tag record)))
    ((get 'salary record-tag) record)))

;;usage: (get-salary (get-record employee file))
;;The record must have a tag so we get the salary procedure for this record's structure.

;;c.
(define (find-employee-record employee files)
  (if (null? files)
      false
      (let ((record (get-record employee (car files))))
	(if record
	    record
	    (find-employee-record employee (cdr files))))))

;;d.
;;The new personnel information must have a personnel records file with:
;;  a get-record procedure put into a table,
;;  procedures for getting record information, i.e. address, put into a table,
;;  tags for files and records.

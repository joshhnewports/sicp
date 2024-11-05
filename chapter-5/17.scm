(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
	(instructions-executed 0)
	(trace? false))
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name)
        (if (assoc name register-table)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
      (define (lookup-register name)
        (let ((val (assoc name register-table)))
          (if val
              (cadr val)
              (error "Unknown register:" name))))
      (define (trace inst)
	(if (not (null? (instruction-label inst)))
	    (begin (newline)
		   (display (instruction-label inst))))
	(newline)
	(display (instruction-text inst)))
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (let ((inst (car insts)))
		(if trace?
		    (trace inst))
		(set! instructions-executed (+ instructions-executed 1))
                ((instruction-execution-proc (car insts)))
                (execute)))))
      (define (dispatch message)
        (cond ((eq? message 'start)
	       (set! instructions-executed 0)
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)
              ((eq? message 'get-register) lookup-register)
              ((eq? message 'install-operations)
               (lambda (ops) (set! the-ops (append the-ops ops))))
              ((eq? message 'stack) stack)
              ((eq? message 'operations) the-ops)
	      ((eq? message 'instructions-executed) instructions-executed)
	      ((eq? message 'trace-on) (set! trace? true) 'trace-on)
	      ((eq? message 'trace-off) (set! trace? false) 'trace-off)
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

(define (update-insts! insts labels machine)
  (newline)
  (display labels)
  (let ((pc (get-register machine 'pc))
        (flag (get-register machine 'flag))
        (stack (machine 'stack))
        (ops (machine 'operations))
	(first-inst-labels (partition-labels labels)))
    ;(newline)
    ;(display "FIRST-INST-LABELS")
    ;(newline)
    ;(display first-inst-labels)
    (for-each
     (lambda (inst)
       (set-instruction-label! inst (lookup (instruction-text inst) first-inst-labels))
       (set-instruction-execution-proc! 
        inst
        (make-execution-procedure
         (instruction-text inst) labels machine
         pc flag stack ops)))
     insts)))

(define (lookup text labels)
  (cond ((null? labels) '())
	((equal? text (caar labels)) (cdar labels))
	(else (lookup text (cdr labels)))))

;;makes a list of conses with the first instruction after a label and the label
(define (partition-labels labels)
  (cond ((null? labels) '())
	((symbol? (caar labels))
	 (cons (cons (cadar labels) (caar labels))
	       (partition-labels (cdr labels))))
	(else (partition-labels (cdr labels)))))

(define (instruction-label inst)
  (caddr inst))
(define (set-instruction-label! inst label)
  (set-car! (cddr inst) label))
;;text, execution-proc, label
(define (make-instruction text)
  (list text '() '()))
(define (instruction-execution-proc inst)
  (cadr inst))
(define (set-instruction-execution-proc! inst proc)
  (set-car! (cdr inst) proc))


(set-register-contents! factorial-machine 'n 2)
(start factorial-machine)
(get-register-contents factorial-machine 'val)

(factorial-machine 'trace-on)

'((base-case ((assign val (const 1)) () ()) ((goto (reg continue)) () ())) (fact-done))

;;an item in the stack is (reg-name contents)

(define (make-save inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst)))
    (let ((reg (get-register machine reg-name)))
      (lambda ()
	(push stack (cons reg-name (get-contents reg)))
	(advance-pc pc)))))

(define (make-restore inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst)))
    (let ((reg (get-register machine reg-name)))
      (lambda ()
	(let ((top (pop stack)))                ;dont worry about side effects
	  (cond ((eq? (car top) reg-name)       ;top of stack from the same register?
		 (set-contents! reg (cdr top))  ;set-contents! of reg to the contents of the top of stack  
		 (advance-pc pc))
		(else (error "Restored value not from saved register -- RESTORE" inst reg-name))))))))

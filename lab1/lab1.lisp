(defparameter my-list '())

;; 1. Create a list
(setq my-list (list 1 #\A (cons 2 3) '(4 5) '()))

(format t "List: ~A~%" my-list)

;; 2. Get the head of the list
(format t "Head of the list: ~A~%" (first my-list))

;; 3. Get the tail of the list
(format t "Tail of the list: ~A~%" (cdr my-list))

;; 4. Get the third element of the list
(format t "Third element of the list: ~A~%" (third my-list))

;; 5. Get the last item in the list
(format t "Last item in the list: ~A~%" (car (last my-list)))

;; 6. ATOM and LISTP predicates
(format t "Is the first element an atom? ~A~%" (atom (first my-list)))
(format t "Is the third element an atom? ~A~%" (atom (second my-list)))
(format t "Is the fourth element a list? ~A~%" (listp (first my-list)))
(format t "Is the fifth element a list? ~A~%" (listp (third my-list)))

;; 7. Other predicates
(format t "Is the second element a character? ~A~%" (characterp (second my-list)))
(format t "Is the first element a number? ~A~%" (numberp (first my-list)))
(format t "Is the fifth element null? ~A~%" (null (fifth my-list)))

;; 8. Merge the created list with one of its nonempty sublists
(format t "Merged list: ~A~%" (append my-list (fourth my-list)))

(defparameter sub-list '())
(defparameter lab-task-list '())

(setq sub-list (list "A" 2 1))
(setq lab-task-list (list sub-list "B" (cdr sub-list) "C"))

(format t "Main list: ~A~%" lab-task-list)
(format t "Sub list: ~A~%" sub-list)

(setf (second sub-list) 99)
;;(setf (third (first lab-task-list)) 121)
(format t "Main list after changing sub list: ~A~%" lab-task-list)
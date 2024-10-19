
(defun group-triples (lst)
  (cond ((null lst) nil)
        ((< (length lst) 3) (list lst))
        (t (cons (list (first lst) (second lst) (third lst))
                 (group-triples (nthcdr 3 lst))))))

(defun my-member (item lst)
  (cond ((null lst) nil)
        ((eql item (car lst)) t)
        (t (my-member item (cdr lst)))))


(defun list-set-intersection-3 (lst1 lst2 lst3)
  (cond ((or (null lst1) (null lst2) (null lst3)) nil)
        ((and (my-member (car lst1) lst2) (my-member (car lst1) lst3))
         (cons (car lst1) (list-set-intersection-3 (cdr lst1) lst2 lst3)))
        (t (list-set-intersection-3 (cdr lst1) lst2 lst3))))


(defun check-group (name function input expected)
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (funcall function input) expected)
          name))


(defun check-intersection (name function input1 input2 input3 expected)
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (funcall function input1 input2 input3) expected)
          name))

(defun test-group-triples ()
  (check-group "test 1" #'group-triples '(a b c d e f g) '((a b c) (d e f) (g)))
  (check-group "test 2" #'group-triples '(1 2 3 4 5) '((1 2 3) (4 5)))
  (check-group "test 3" #'group-triples '(a b) '((a b)))
  (check-group "test 4" #'group-triples nil nil))

(defun test-list-set-intersection-3 ()
  (check-intersection  "test 1" #'list-set-intersection-3 '(1 2 3 4) '(3 4 5 6) '(1 3 4 6) '(3 4))
  (check-intersection  "test 2" #'list-set-intersection-3 '(1 2 3) '(2 3 4) '(3 4 5) '(3))
  (check-intersection  "test 3" #'list-set-intersection-3 '(1 2 3) '(4 5 6) '(7 8 9) nil)
  (check-intersection  "test 4" #'list-set-intersection-3 '(1 2 3) '(1 2 3) '(1 2 3) '(1 2 3)))



(defun run-tests ()
  (format t "Testing group-triples:~%")
  (test-group-triples)
  (format t "~%Testing list-set-intersection-3:~%")
  (test-list-set-intersection-3))
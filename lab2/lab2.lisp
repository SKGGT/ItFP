(defun remove-seconds-and-thirds (lst)
  (cond ((null lst) nil)
        ((null (cdr lst)) lst)
        ((null (cddr lst)) (list (car lst)))
        (t (cons (car lst) 
                 (remove-seconds-and-thirds (cdddr lst))))))

(defun member (item lst)
  (cond ((null lst) nil)
        ((eql item (car lst)) t)
        (t (member item (cdr lst)))))


(defun list-set-intersection (lst1 lst2)
  (cond ((null lst1) nil)
        ((member (car lst1) lst2)
         (cons (car lst1) 
               (list-set-intersection (cdr lst1) lst2)))
        (t (list-set-intersection (cdr lst1) lst2))))


(defun check-result-remove (name func input expected)
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (funcall func input) expected)
          name))

(defun check-result-intersection (name func input1 input2 expected)
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (funcall func input1 input2) expected)
          name))

(defun test-remove-seconds-and-thirds ()
  (check-result-remove "test 1" #'remove-seconds-and-thirds '(a b c d e f g) '(a d g))
  (check-result-remove "test 2" #'remove-seconds-and-thirds '(1 2 3 4 5) '(1 4))
  (check-result-remove "test 3" #'remove-seconds-and-thirds '(a b) '(a))
  (check-result-remove "test 4" #'remove-seconds-and-thirds '(a) '(a))
  (check-result-remove "test 5" #'remove-seconds-and-thirds nil nil))

(defun test-list-set-intersection ()
  (check-result-intersection "test 1" #'list-set-intersection '(1 2 3 4) '(3 4 5 6) '(3 4))
  (check-result-intersection "test 2" #'list-set-intersection '(a b c) '(d e f) nil)
  (check-result-intersection "test 3" #'list-set-intersection '(1 2 3) '(1 2 3) '(1 2 3))
  (check-result-intersection "test 4" #'list-set-intersection nil '(1 2 3) nil)
  (check-result-intersection "test 5" #'list-set-intersection '(1 2 3) nil nil))

(defun run-tests ()
  (format t "Testing remove-seconds-and-thirds:~%")
  (test-remove-seconds-and-thirds)
  (format t "~%Testing list-set-intersection:~%")
  (test-list-set-intersection))
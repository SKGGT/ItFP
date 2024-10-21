(defun functional-bubble-sort (lst)
  (if (null (cdr lst))
      lst
      (let ((rest (functional-bubble-sort (cdr lst))))
        (if (> (car lst) (car rest))
            (cons (car rest) (functional-bubble-sort (cons (car lst) (cdr rest))))
            (cons (car lst) rest)))))

(defun sort-list (lst)
  (when lst
      (functional-bubble-sort lst)))

(defun imperative-bubble-sort (lst)
  (let ((sorted-list (copy-list lst)))
    (loop named outer
          for i from 0 below (1- (length sorted-list))
          do (loop for j from 0 below (- (length sorted-list) i 1)
                   do (when (> (nth j sorted-list) (nth (1+ j) sorted-list))
                        (rotatef (nth j sorted-list) (nth (1+ j) sorted-list)))))
    sorted-list))


(defun check-result (name function input expected)
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (funcall function input) expected)
          name))

(defun test-functional-sort ()
  (check-result "test 1" #'sort-list '(1 2 3 5 3 0 2) '(0 1 2 2 3 3 5))
  (check-result "test 2" #'sort-list '(5 4 3 2 1) '(1 2 3 4 5))
  (check-result "test 3" #'sort-list nil nil))

(defun test-imperative-sort ()
  (check-result "test 1" #'imperative-bubble-sort '(1 2 3 5 3 0 2) '(0 1 2 2 3 3 5))
  (check-result "test 2" #'imperative-bubble-sort '(5 4 3 2 1) '(1 2 3 4 5))
  (check-result "test 3" #'imperative-bubble-sort nil nil))

(defun run-tests ()
  (format t "Testing functional-bubble-sort:~%")
  (test-functional-sort)
  (format t "~%Testing imperative-bubble-sort:~%")
  (test-imperative-sort))
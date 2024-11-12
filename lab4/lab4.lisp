(defun functional-sort (lst &key (key #'identity) (test #'>))
  (if (null (cdr lst))
      lst
      (let ((rest (functional-sort (cdr lst) :key key :test test)))
        (if (funcall test (funcall key (car lst)) (funcall key (car rest)))
            (cons (car rest) (functional-sort (cons (car lst) (cdr rest)) :key key :test test))
            (cons (car lst) rest)))))

(defun sort-list (lst &key (key #'identity) (test #'>))
  (when lst
    (functional-sort lst :key key :test test)))


(defun duplicate-elements-reducer (n &key (duplicate-p (constantly t)))
  (lambda (acc item)
    (if (funcall duplicate-p item)
        (nconc acc (make-list n :initial-element item))
        (nconc acc (list item)))))


(defun check-sort (name function input expected &key (key #'identity) (test #'>))
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (funcall function input :key key :test test) expected)
          name))


(defun check-duplicate-reducer (name reducer input expected &key (from-end nil) (initial-value nil))
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (reduce reducer input :from-end from-end :initial-value initial-value) expected)
          name))


(defun test-sort ()
  (format t "Testing sort:~%")
  (check-sort "test 1" #'sort-list '(1 2 3 5 3 0 2) '(0 1 2 2 3 3 5) :test #'>)
  (check-sort "test 2" #'sort-list '(5 4 3 2 1) '(1 2 3 4 5) :test #'>)
  (check-sort "test 3" #'sort-list '(1 2 3 4 5) '(5 4 3 2 1) :test #'<)
  (check-sort "test 4" #'sort-list '(1 2 3 4 5) '(5 4 3 2 1) :key (lambda (x) (* x -1)) :test #'>)
  (check-sort "test 5" #'sort-list nil nil))


(defun test-duplicate-elements-reducer ()
  (format t "Testing duplicate-elements-reducer:~%")

  (check-duplicate-reducer "test 1"
                           (duplicate-elements-reducer 2)
                           '(1 2 3)
                           '(1 1 2 2 3 3))

  (check-duplicate-reducer "test 2"
                           (duplicate-elements-reducer 3)
                           '(4 5)
                           '(4 4 4 5 5 5))

  (check-duplicate-reducer "test 3"
                           (duplicate-elements-reducer 2 :duplicate-p #'evenp)
                           '(1 2 3 4)
                           '(1 2 2 3 4 4))

  (check-duplicate-reducer "test 4"
                           (duplicate-elements-reducer 3 :duplicate-p #'oddp)
                           '(1 2 3)
                           '(1 1 1 2 3 3 3))


  (check-duplicate-reducer "test 5"
                           (duplicate-elements-reducer 1)
                           '(1 2 3)
                           '(1 2 3))

  (check-duplicate-reducer "test 6"
                           (duplicate-elements-reducer 2)
                           '(1 2)
                           '(0 1 1 2 2)
                           :initial-value '(0))

  (check-duplicate-reducer "test 7"
                           (duplicate-elements-reducer 2)
                           nil
                           nil))

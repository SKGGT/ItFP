<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 4</b><br/>
"Функції вищого порядку та замикання"<br/>
дисципліни "Вступ до функціонального програмування"
</p>

<p align="right"><b>Студент(-ка)</b>: <i>Коротич Олександр Сергійович КВ-11</i><p>
<p align="right"><b>Рік</b>: <i>2024</i><p>

## Хід виконання роботи:

## Загальне завдання:

Завдання складається з двох частин:
1. Переписати функціональну реалізацію алгоритму сортування з лабораторної
роботи 3 з такими змінами:
використати функції вищого порядку для роботи з послідовностями (де це доречно);
додати до інтерфейсу функції (та використання в реалізації) два ключових
параметра: key та test , що працюють аналогічно до того, як працюють
параметри з такими назвами в функціях, що працюють з послідовностями. При
цьому key має виконатись мінімальну кількість разів.
2. Реалізувати функцію, що створює замикання, яке працює згідно із завданням за
варіантом (див. п 4.1.2). Використання псевдо-функцій не забороняється, але, за
можливості, має бути мінімізоване.

## Варіан 10 першої частини

Алгоритм сортування обміном №1 (без оптимізацій) за незменшенням.

## Лістинг реалізації першої частини завдання
```lisp
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
```
### Тестові набори та утиліти першої частини
```lisp
(defun check-sort (name function input expected &key (key #'identity) (test #'>))
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (funcall function input :key key :test test) expected)
          name))

(defun test-sort ()
  (format t "Testing sort:~%")
  (check-sort "test 1" #'sort-list '(1 2 3 5 3 0 2) '(0 1 2 2 3 3 5) :test #'>)
  (check-sort "test 2" #'sort-list '(5 4 3 2 1) '(1 2 3 4 5) :test #'>)
  (check-sort "test 3" #'sort-list '(1 2 3 4 5) '(5 4 3 2 1) :test #'<)
  (check-sort "test 4" #'sort-list '(1 2 3 4 5) '(5 4 3 2 1) :key (lambda (x) (* x -1)) :test #'>)
  (check-sort "test 5" #'sort-list nil nil))
```
### Тестування першої частини
```lisp
* (test-sort)
Testing sort:
passed... test 1
passed... test 2
passed... test 3
passed... test 4
passed... test 5
NIL
```

## Варіант 10 другої частини

Написати функцію duplicate-elements-reducer , яка має один основний параметр n
та один ключовий параметр — функцію duplicate-p . duplicate-elements-reducer має
повернути функцію, яка при застосуванні в якості першого аргументу reduce робить
наступне: при обході списку, кожен елемент списка-аргумента reduce , для якого
функція duplicate-p повертає значення t (або не nil ), дублюється n разів. Якщо
користувач не передав функцію duplicate-p у duplicate-elements-fn , тоді
дублюються всі елементи вхідного списку. Обмеження, які накладаються на
використання функції-результату duplicate-elements-reducer при передачі у reduce
визначаються розробником (тобто, наприклад, необхідно чітко визначити, якими мають
бути значення ключових параметрів функції reduce from-end та initial-value ).

```
CL-USER> (reduce (duplicate-elements-reducer 2)

'(1 2 3)
:from-end ...
:initial-value ...)

(1 1 2 2 3 3)
CL-USER> (reduce (duplicate-elements-reducer 3 :key #'evenp)

'(1 2 3)
:from-end ...
:initial-value ...)

(1 2 2 2 3)
```

## Лістинг реалізації другої частини завдання
```lisp
(defun duplicate-elements-reducer (n &key (duplicate-p (constantly t)))
  (lambda (acc item)
    (if (funcall duplicate-p item)
        (nconc acc (make-list n :initial-element item))
        (nconc acc (list item)))))
```
### Тестові набори та утиліти другої частини
```lisp
(defun check-duplicate-reducer (name reducer input expected &key (from-end nil) (initial-value nil))
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (reduce reducer input :from-end from-end :initial-value initial-value) expected)
          name))

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
```
### Тестування другої частини 
```lisp
* (test-duplicate-elements-reducer)
Testing duplicate-elements-reducer:
passed... test 1
passed... test 2
passed... test 3
passed... test 4
passed... test 5
passed... test 6
passed... test 7
NIL
```
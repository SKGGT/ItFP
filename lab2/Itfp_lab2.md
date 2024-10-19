<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 2</b><br/>
"Рекурсія"<br/>
дисципліни "Вступ до функціонального програмування"
</p>

<p align="right"><b>Студент(-ка)</b>: <i>Коротич Олександр Сергійович КВ-11</i><p>
<p align="right"><b>Рік</b>: <i>2024</i><p>

## Хід виконання роботи:

## Загальне завдання:

Реалізуйте дві рекурсивні функції, що виконують деякі дії з вхідним(и) списком(-ами), за
можливості/необхідності використовуючи різні види рекурсії. Функції, які необхідно
реалізувати, задаються варіантом (п. 2.1.1). Вимоги до функцій:
1. Зміна списку згідно із завданням має відбуватись за рахунок конструювання нового
списку, а не зміни наявного (вхідного).
2. Не допускається використання функцій вищого порядку чи стандартних функцій
для роботи зі списками, що не наведені в четвертому розділі навчального
посібника.
3. Реалізована функція не має бути функцією вищого порядку, тобто приймати функції
в якості аргументів.
4. Не допускається використання псевдофункцій (деструктивного підходу).
5. Не допускається використання циклів.
Кожна реалізована функція має бути протестована для різних тестових наборів. Тести
мають бути оформленні у вигляді модульних тестів (див. п. 2.3).

## Варіан 10

1. Написати функцію group-triples , яка групує послідовні трійки елементів у
списки:
```lisp
CL-USER> (group-triples '(a b c d e f g))
((A B C) (D E F) (G))
```
2. Написати функцію list-set-intersection-3 , яка визначає перетин трьох множин,
заданих списками атомів:
```lisp
CL-USER> (list-set-intersection-3 '(1 2 3 4) '(3 4 5 6) '(1 3 4 6))
(3 4) ; порядок може відрізнятись
```

## Лістинг функції group-triples
```lisp
(defun group-triples (lst)
  (cond ((null lst) nil)
        ((< (length lst) 3) (list lst))
        (t (cons (list (first lst) (second lst) (third lst))
                 (group-triples (nthcdr 3 lst))))))
```
### Тестові набори
```lisp
(defun test-group-triples ()
  (check-group "test 1" #'group-triples '(a b c d e f g) '((a b c) (d e f) (g)))
  (check-group "test 2" #'group-triples '(1 2 3 4 5) '((1 2 3) (4 5)))
  (check-group "test 3" #'group-triples '(a b) '((a b)))
  (check-group "test 4" #'group-triples nil nil))
```
### Тестування
```lisp
* (test-group-triples)
passed... test 1
passed... test 2
passed... test 3
passed... test 4
NIL
```
## Лістинг функції list-set-intersection-3
```lisp
(defun my-member (item lst)
  (cond ((null lst) nil)
        ((eql item (car lst)) t)
        (t (my-member item (cdr lst)))))


(defun list-set-intersection-3 (lst1 lst2 lst3)
  (cond ((or (null lst1) (null lst2) (null lst3)) nil)
        ((and (my-member (car lst1) lst2) (my-member (car lst1) lst3))
         (cons (car lst1) (list-set-intersection-3 (cdr lst1) lst2 lst3)))
        (t (list-set-intersection-3 (cdr lst1) lst2 lst3))))
```
### Тестові набори
```lisp
(defun test-list-set-intersection-3 ()
  (check-intersection  "test 1" #'list-set-intersection-3 '(1 2 3 4) '(3 4 5 6) '(1 3 4 6) '(3 4))
  (check-intersection  "test 2" #'list-set-intersection-3 '(1 2 3) '(2 3 4) '(3 4 5) '(3))
  (check-intersection  "test 3" #'list-set-intersection-3 '(1 2 3) '(4 5 6) '(7 8 9) nil)
  (check-intersection  "test 4" #'list-set-intersection-3 '(1 2 3) '(1 2 3) '(1 2 3) '(1 2 3)))
```
### Тестування
```lisp
* (test-list-set-intersection-3)
passed... test 1
passed... test 2
passed... test 3
passed... test 4
NIL
```
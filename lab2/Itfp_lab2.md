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

## Варіан 2

Написати функцію remove-seconds-and-thirds , яка видаляє зі списку кожен другий
і третій елементи:
```lisp
CL-USER> (remove-seconds-and-thirds '(a b c d e f g))
(A D G)
```
2. Написати функцію list-set-intersection , яка визначає перетин двох множин,
заданих списками атомів:
```lisp
CL-USER> (list-set-intersection '(1 2 3 4) '(3 4 5 6))
(3 4) ; порядок може відрізнятись
```

## Лістинг функції remove-seconds-and-thirds
```lisp
(defun remove-seconds-and-thirds (lst)
  (cond ((null lst) nil)
        ((null (cdr lst)) lst)
        ((null (cddr lst)) (list (car lst)))
        (t (cons (car lst) 
                 (remove-seconds-and-thirds (cdddr lst))))))
```
### Тестові набори
```lisp
(defun test-remove-seconds-and-thirds ()
  (check-result-remove "test 1" #'remove-seconds-and-thirds '(a b c d e f g) '(a d g))
  (check-result-remove "test 2" #'remove-seconds-and-thirds '(1 2 3 4 5) '(1 4))
  (check-result-remove "test 3" #'remove-seconds-and-thirds '(a b) '(a))
  (check-result-remove "test 4" #'remove-seconds-and-thirds '(a) '(a))
  (check-result-remove "test 5" #'remove-seconds-and-thirds nil nil))
```
### Тестування
```lisp
* (test-remove-seconds-and-thirds)
passed... test 1
passed... test 2
passed... test 3
passed... test 4
passed... test 5
NIL
```
## Лістинг функції list-set-intersection
```lisp
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
```
### Тестові набори
```lisp
(defun test-list-set-intersection ()
  (check-result-intersection "test 1" #'list-set-intersection '(1 2 3 4) '(3 4 5 6) '(3 4))
  (check-result-intersection "test 2" #'list-set-intersection '(a b c) '(d e f) nil)
  (check-result-intersection "test 3" #'list-set-intersection '(1 2 3) '(1 2 3) '(1 2 3))
  (check-result-intersection "test 4" #'list-set-intersection nil '(1 2 3) nil)
  (check-result-intersection "test 5" #'list-set-intersection '(1 2 3) nil nil))
```
### Тестування
```lisp
* (test-list-set-intersection)
passed... test 1
passed... test 2
passed... test 3
passed... test 4
passed... test 5
NIL
```
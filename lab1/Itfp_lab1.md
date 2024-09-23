<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 1</b><br/>
"Обробка списків з використанням базових функцій"<br/>
дисципліни "Вступ до функціонального програмування"
</p>

<p align="right">**Студент(-ка)**: *Коротич Олександр Сергійович КВ-11*<p>
<p align="right">**Рік**: *2024*<p>

## Хід виконання роботи:

## Загальне завдання:

### 1. Створіть список з п'яти елементів, використовуючи функції LIST і CONS . Форма створення списку має бути одна — використання SET чи SETQ (або інших допоміжних форм) для збереження проміжних значень не допускається. Загальна кількість елементів (включно з підсписками та їх елементами) не має перевищувати 10-12 шт. (дуже великий список робити не потрібно). Збережіть створений список у якусь змінну з SET або SETQ . Список має містити (напряму або у підсписках): хоча б один символ, хоча б одне число, хоча б один не пустий підсписок, хоча б один пустий підсписок:
```lisp
(defparameter my-list '())
(setq my-list (list 1 #\A (cons 2 3) '(4 5) '()))
```
### 2. Отримайте голову списку:
```lisp
(format t "Head of the list: ~A~%" (first my-list))
```
### 3. Отримайте хвіст списку.
```lisp
(format t "Tail of the list: ~A~%" (last my-list))
```
### 4. Отримайте третій елемент списку.
```lisp
(format t "Third element of the list: ~A~%" (third my-list))
```
### 5. Отримайте останній елемент списку.
```lisp
(format t "Last item in the list: ~A~%" (car (last my-list)))
```
### 6. Використайте предикати ATOM та LISTP на різних елементах списку (по 2-3 приклади для кожної функції).
```lisp
(format t "Is the first element an atom? ~A~%" (atom (first my-list)))
(format t "Is the third element an atom? ~A~%" (atom (second my-list)))
(format t "Is the fourth element a list? ~A~%" (listp (first my-list)))
(format t "Is the fifth element a list? ~A~%" (listp (third my-list)))
```
### 7. Використайте на елементах списку 2-3 інших предикати з розглянутих у розділі 4 навчального посібника.
```lisp
(format t "Is the second element a character? ~A~%" (characterp (second my-list)))
(format t "Is the first element a number? ~A~%" (numberp (first my-list)))
(format t "Is the fifth element null? ~A~%" (null (fifth my-list)))
```
### 8. Об'єднайте створений список з одним із його непустих підсписків. Для цього використайте функцію APPEND 
```lisp
(format t "Merged list: ~A~%" (append my-list (fourth my-list)))
```
## Варіант 2
<p align="center">
<img src="lab-1-variant.png">
</p>
```lisp
;; Define lists
(defparameter sub_list '())
(defparameter lab_task_list '())
;; Set them
(setq sub_list (list "A" '(2 1)))
(setq lab_task_list (list sub_list "B" (second sub_list) "C"))

(format t "Main list: ~A~%" lab_task_list)
(format t "Sub list: ~A~%" sub_list)
;; Check if changes update
(setf (first (second sub_list)) 99)
(format t "Main list after changing sub list: ~A~%" lab_task_list)
```
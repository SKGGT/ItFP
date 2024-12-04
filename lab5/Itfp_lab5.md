<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 5</b><br/>
"Робота з базою даних"<br/>
дисципліни "Вступ до функціонального програмування"
</p>

<p align="right"><b>Студент(-ка)</b>: <i>Коротич Олександр Сергійович КВ-11</i><p>
<p align="right"><b>Рік</b>: <i>2024</i><p>

## Хід виконання роботи:

## Загальне завдання:

В роботі необхідно реалізувати утиліти для роботи з базою даних, заданою за варіантом
(п. 5.1.1). База даних складається з кількох таблиць. Таблиці представлені у вигляді CSV
файлів. При зчитуванні записів з таблиць, кожен запис має бути представлений певним
типом в залежності від варіанту: структурою, асоціативним списком або геш-таблицею.
1. Визначити структури або утиліти для створення записів з таблиць (в залежності від
типу записів, заданого варіантом).
2. Розробити утиліту(-и) для зчитування таблиць з файлів.
3. Розробити функцію select , яка отримує на вхід шлях до файлу з таблицею, а
також якийсь об'єкт, який дасть змогу зчитати записи конкретного типу або
структури. Це може бути ключ, список з якоюсь допоміжною інформацією, функція і
т. і. За потреби параметрів може бути кілька. select повертає лямбда-вираз,
який, в разі виклику, виконує "вибірку" записів з таблиці, шлях до якої було
передано у select . При цьому лямбда-вираз в якості ключових параметрів може
отримати на вхід значення полів записів таблиці, для того щоб обмежити вибірку
лише заданими значеннями (виконати фільтрування). Вибірка повертається у
вигляді списку записів.
4. Написати утиліту(-и) для запису вибірки (списку записів) у файл.
5. Написати функції для конвертування записів у інший тип (в залежності від варіанту):
структури у геш-таблиці
геш-таблиці у асоціативні списки
асоціативні списки у геш-таблиці
6. Написати функцію(-ї) для "красивого" виводу записів таблиці.

## Варіан 10 першої частини

База даних: Космічні апарати
Тип записів: Структура

## Лістинг реалізації завдання
```lisp
(defstruct company
  (id 0 :type integer)
  (name "" :type string)
  (country "" :type string))

(defstruct spacecraft
  (id 0 :type integer)
  (name "" :type string)
  (company-id 0 :type integer)
  (launch-year 0 :type integer)
  (mission-type "" :type string))

(defun parse-value (value)
  "Aux function for (read-csv-file). Converts the strings of data into their respective types."
  (cond
    ((string= value "") nil)
    ((every #'digit-char-p value)
     (parse-integer value))
    (t value)))


(defun read-csv-table (file-path)
  "Reads a csv file. Returns a list of structured data of all rows of the file."
  (with-open-file (stream file-path :direction :input)
      (let* ((result '()))
        (do ((line (read-line stream) (read-line stream nil 'eof)))
              ((eq line 'eof) nil (reverse result))
              (push (mapcar #'parse-value (uiop:split-string (string-right-trim '(#\Return) line) :separator '(#\,))) result)))))


(defun key-to-index (key record-type)
  "Aux function for (select). A table to get indexes for specified keys."
  (case record-type
    (:company (case key
                (:ID 0)
                (:NAME 1)
                (:COUNTRY 2)))
    (:spacecraft (case key
                    (:ID 0)
                    (:NAME 1)
                    (:COMPANY-ID 2)
                    (:LAUNCH-YEAR 3)
                    (:MISSION-TYPE 4)))))


(defun group-args (args)
  "Aux function for (select). Groups &rest args into pairs."
  (loop for (key value) on args by #'cddr
        collect (list key value)))


(defun select (file-path record-type)
  "Return a lambda function that selects elements from the csv file on call. Can be provided structure names and values to filter the selected data."
  (let ((rows (read-csv-table file-path)))
    (lambda (&rest filter-args)
      (let ((filtered-rows
              (if (null filter-args)
                  rows
                  (remove-if-not 
                   #'(lambda (row)
                       (every 
                        #'(lambda (arg-pair)
                            (let* ((key-index (key-to-index (first arg-pair) record-type))
                                   (value (second arg-pair)))
                              (equal (nth key-index row) value)))
                        (group-args filter-args)))
                   rows))))
        (mapcar 
         #'(lambda (row) 
             (case record-type
               (:company
                (make-company 
                 :id (first row)
                 :name (second row)
                 :country (third row)))
               (:spacecraft
                (make-spacecraft
                 :id (first row)
                 :name (second row)
                 :company-id (third row)
                 :launch-year (fourth row)
                 :mission-type (fifth row)))))
         filtered-rows)))))


(defun write-table-to-csv (records file-path)
  "Writes records to a file."
  (with-open-file (stream file-path 
                          :direction :output 
                          :if-exists :supersede)
    (dolist (record records)
      (format stream "~{~a~^,~}~%" 
              (typecase record
                (company 
                 (list (company-id record)
                       (company-name record)
                       (company-country record)))
                (spacecraft
                 (list (spacecraft-id record)
                       (spacecraft-name record)
                       (spacecraft-company-id record)
                       (spacecraft-launch-year record)
                       (spacecraft-mission-type record))))))))

(defun records-to-hash-table (records)
  "Converts records into a hash table."
  (mapcar 
   #'(lambda (record)
       (let ((hash (make-hash-table :test 'equal)))
         (typecase record
           (company 
            (setf (gethash :id hash) (company-id record)
                  (gethash :name hash) (company-name record)
                  (gethash :country hash) (company-country record)))
           (spacecraft
            (setf (gethash :id hash) (spacecraft-id record)
                  (gethash :name hash) (spacecraft-name record)
                  (gethash :company-id hash) (spacecraft-company-id record)
                  (gethash :launch-year hash) (spacecraft-launch-year record)
                  (gethash :mission-type hash) (spacecraft-mission-type record))))
         hash))
   records))

(defun print-table (records)
  "Pretty print for records."
  (dolist (record records)
    (format t "~&~A~%" 
            (typecase record
              (company 
               (format nil "Company: ID=~D, Name=~A, Country=~A" 
                       (company-id record)
                       (company-name record)
                       (company-country record)))
              (spacecraft
               (format nil "Spacecraft: ID=~D, Name=~A, Company ID=~D, Launch Year=~D, Mission Type=~A"
                       (spacecraft-id record)
                       (spacecraft-name record)
                       (spacecraft-company-id record)
                       (spacecraft-launch-year record)
                       (spacecraft-mission-type record)))))))
```
### Тестові набори та утиліти
```lisp
(defun check-read (name file-path expected)
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (read-csv-table file-path) expected)
          name))

(defun check-select (name input expected)
  (format t "~:[FAILED~;passed~]... ~a~%"
            (every #'equalp input expected)
            name))

(defun run-tests ()
  (format t "Tests:~%")
  (check-read "test 1" "./FP_lab5/tests/test_read.csv" '((0 "NameTest1" 1 2024 "ComNameTest1")))
  (check-select "test 2" (funcall (select "./FP_lab5/tests/test_select_craft.csv" :spacecraft) :id 0) (list (make-spacecraft :id 0 :name "SaturnV" :company-id 0 :launch-year 1965 :mission-type "Moon")))
  (check-select "test 3" (funcall (select "./FP_lab5/tests/test_select_craft.csv" :spacecraft) :id 2) (list (make-spacecraft :id 2 :name "James" :company-id 0 :launch-year 2021 :mission-type "Research")))
  (check-select "test 4" (funcall (select "./FP_lab5/tests/test_select_craft.csv" :spacecraft) :mission-type "Research") (list (make-spacecraft :id 2 :name "James" :company-id 0 :launch-year 2021 :mission-type "Research") (make-spacecraft :id 3 :name "Hubble" :company-id 0 :launch-year 1990 :mission-type "Research")))
  (check-select "test 5" (funcall (select "./FP_lab5/tests/test_select_craft.csv" :spacecraft) :company-id 0 :mission-type "Research") (list (make-spacecraft :id 2 :name "James" :company-id 0 :launch-year 2021 :mission-type "Research") (make-spacecraft :id 3 :name "Hubble" :company-id 0 :launch-year 1990 :mission-type "Research")))
  (format t "Full table:~%")
  (print-table (funcall (select "./FP_lab5/tests/test_select_craft.csv" :spacecraft))))
```
### Тестування
```lisp
> ‌‌(run-tests)
Tests:
passed... test 1
passed... test 2
passed... test 3
passed... test 4
passed... test 5
Full table:
Spacecraft: ID=0, Name=SaturnV, Company ID=0, Launch Year=1965, Mission Type=Moon
Spacecraft: ID=1, Name=Falcon9, Company ID=1, Launch Year=2021, Mission Type=CommercialSatellite
Spacecraft: ID=2, Name=James, Company ID=0, Launch Year=2021, Mission Type=Research
Spacecraft: ID=3, Name=Hubble, Company ID=0, Launch Year=1990, Mission Type=Research
```
# test_repo
Используем Postgres SQL 12.0.
Также потребуется Microsoft Excel для первичной обработки данных перед их загрузкой

Прежде всего сохранить файлы с данными в формате csv для загрузки их в базу данных. Также перед загрузкой убедиться в правильности выбранных формата данных, то есть не стоит ли в столбце с типом Boolean  даты. Исправляем форматы на нужные
С помощью фильтров смотрим можно увидеть все значения в столбце и определить подходящий, в зависимости от того, там текст, целое число или нецелое число или дата. Также в тех столбцах где нет пустых ячейках ставим ограничение NOT NULL

Комментарий:
Исправляем форматы на нужны - это вообще не инструкция. Это как в инструкции к прибору написать "использовать правильно"!

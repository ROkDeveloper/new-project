﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий базовой функциональности

// Заполняет переименования тех объектов метаданных, которые невозможно
// автоматически найти по типу, но ссылки на которые требуется сохранять
// в базе данных (например: подсистемы, роли).
//
// Подробнее: см. ОбщегоНазначения.ДобавитьПереименование().
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	Библиотека = "СтандартныеПодсистемы";
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.2.1.12",
		"Подсистема.НастройкаИАдминистрирование",
		"Подсистема.Администрирование",
		Библиотека);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов

// Определяет разделы, в которых доступна панель отчетов.
//   Подробнее - см. описание процедуры ИспользуемыеРазделы
//   общего модуля ВариантыОтчетов.
//
Процедура ПриОпределенииРазделовСВариантамиОтчетов(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.Администрирование, НСтр("ru = 'Отчеты администратора'"));
	
КонецПроцедуры

// Определяет разделы, в которых доступна команда вызова дополнительных отчетов.
//   Подробнее - см. описание функции РазделыДополнительныхОтчетов
//   общего модуля ДополнительныеОтчетыИОбработки.
//
Процедура ПриОпределенииРазделовСДополнительнымиОтчетами(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.Администрирование);
	
КонецПроцедуры

// Определяет разделы, в которых доступна команда вызова дополнительных обработок.
//   Подробнее - см. описание функции РазделыДополнительныхОбработок
//   общего модуля ДополнительныеОтчетыИОбработки.
//
Процедура ПриОпределенииРазделовСДополнительнымиОбработками(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.Администрирование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОбновления

Процедура УстановитьЗначениеЦеныПродажиПоУмолчанию() Экспорт
	
	КонстантаОбъект = Константы.НастройкаЗаполненияЦеныПродажи.СоздатьМенеджерЗначения();
	КонстантаОбъект.Значение = Перечисления.НастройкаЗаполненияЦеныПродажи.ПредыдущийДокумент;
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(КонстантаОбъект, Ложь, Ложь);
			
	                            
КонецПроцедуры

#КонецОбласти

#КонецЕсли

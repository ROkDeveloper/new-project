﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивДоговоров = Документы.ОтчетКомитентуОПродажах.ПолучитьМассивДоговоровОснования(Параметры.Основание);
	
	Если МассивДоговоров.Количество() = 0 Тогда
		Отказ = Истина;
	Иначе
		ПодготовитьФормуНаСервере(МассивДоговоров);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.СписокКомитентов.ТекущиеДанные;
	
	Если СтрокаТаблицы <> Неопределено Тогда
		
		ОткрытьДокументПоВыбранномуКомитенту(СтрокаТаблицы.Значение);
		
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере(ДоговораКомитентов)
	
	ЗначениеКопирования = Параметры.ЗначениеКопирования;
	ЗначенияЗаполнения  = Параметры.ЗначенияЗаполнения;
	Основание           = Параметры.Основание;
	
	Параметры.ЗначениеКопирования = Неопределено;
	Параметры.ЗначенияЗаполнения  = Неопределено;
	Параметры.Основание           = Неопределено;
	
	СтруктураКомитентов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ДоговораКомитентов, "Владелец");
	
	СписокКомитентов.Очистить();
	Для каждого ДоговорКомитента Из ДоговораКомитентов Цикл
		Комитент = СтруктураКомитентов.Получить(ДоговорКомитента);
		КомитентПредставление = "" + Комитент + " / " + ДоговорКомитента;
		СписокКомитентов.Добавить(
			Новый Структура("Комитент, ДоговорКомитента", Комитент, ДоговорКомитента), КомитентПредставление);
	КонецЦикла;
	
КонецПроцедуры
 
&НаКлиенте
Процедура СписокКомитентовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокКомитентов.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьДокументПоВыбранномуКомитенту(СтрокаТаблицы.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументПоВыбранномуКомитенту(ВыбранныйКомитент)
	
	ЗначенияЗаполнения.Вставить("Контрагент",         ВыбранныйКомитент.Комитент);
	ЗначенияЗаполнения.Вставить("ДоговорКонтрагента", ВыбранныйКомитент.ДоговорКомитента);
	ЗначенияЗаполнения.Вставить("Основание",          Основание);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",                Параметры.Ключ);
	СтруктураПараметров.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	
	Модифицированность = Ложь;
	Закрыть();
	
	ОткрытьФорму("Документ.ОтчетКомитентуОПродажах.Форма.ФормаДокументаОЗакупках", СтруктураПараметров, ВладелецФормы);
	
КонецПроцедуры

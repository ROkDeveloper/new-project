﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(Объект.УполномоченныйБанк) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(,, "Уполномоченный банк");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ПолеВыбораУполномоченногоБанка",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ПропуститьПроверку")
		И ПараметрыЗаписи.ПропуститьПроверку Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьДублиИГК = ЕстьДублиИГК(Объект.Код, Объект.Ссылка);
	Если ЕстьДублиИГК Тогда
		Отказ = Истина; // Примем решение позже, в зависимости от ответа пользователя
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект, ПараметрыЗаписи);
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Идентификатор контракта %1 уже указан в другом государственном контракте. Записать?'"),
			Объект.Код);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ПолеВыбораУполномоченногоБанкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = "999999999" Тогда
		СтандартнаяОбработка = Ложь;
		ВыбранноеЗначение = "";
		ПолеВыбораУполномоченногоБанка = "";
		Объект.УполномоченныйБанк = Неопределено;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораБанкаЗавершение", ЭтотОбъект);
		ОткрытьФорму("Справочник.Банки.ФормаВыбора",,,,,, ОписаниеОповещения);
	Иначе
		Объект.УполномоченныйБанк = УполномоченныйБанкОбработкаВыбораНаСервере(ВыбранноеЗначение, УполномоченныеБанки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеВыбораУполномоченногоБанкаОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.УполномоченныйБанк = Неопределено;
	
КонецПроцедуры
 
&НаКлиенте
Процедура ОбработкаВыбораБанкаЗавершение(ВыбранноеЗначение, ДополнительныеПараметра) Экспорт
	
	Объект.УполномоченныйБанк = ВыбранноеЗначение;
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		НастроитьСписокВыбораУполномоченныхБанков(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(ВыбранноеЗначение, ПараметрыЗаписи) Экспорт
	
	Если ВыбранноеЗначение = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи.Вставить("ПропуститьПроверку", Истина);
	Записать(ПараметрыЗаписи);
	
	Если ПараметрыЗаписи.Свойство("Закрыть") И ПараметрыЗаписи.Закрыть Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	НастроитьСписокВыбораУполномоченныхБанков(Объект.УполномоченныйБанк);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьСписокВыбораУполномоченныхБанков(ВыбранныйБанк)
	
	УполномоченныеБанки = Новый Структура;
	
	СписокВыбора = Элементы.ПолеВыбораУполномоченногоБанка.СписокВыбора;
	СписокВыбора.Очистить();
	
	// Распоряжение Правительства Российской Федерации от 03.06.2016 № 1135-р.
	БИКи = Новый Массив;
	БИКи.Добавить("044030790"); // ПАО "Банк «Санкт-Петербург". Рег.№ 436
	БИКи.Добавить("044030861"); // АО "АБ "РОССИЯ".             Рег.№ 328
	БИКи.Добавить("044525111"); // АО "РОССЕЛЬХОЗБАНК".         Рег.№ 3349
	БИКи.Добавить("044525187"); // БАНК ВТБ (ПАО).              Рег.№ 1000
	БИКи.Добавить("044525225"); // ПАО "СБЕРБАНК РОССИИ".       Рег.№ 1481
	БИКи.Добавить("044525823"); // БАНК ГПБ (АО).               Рег.№ 354
	БИКи.Добавить("044525880"); // Банк "ВБРР" (АО).            Рег.№ 3287
	БИКи.Добавить("044583162"); // АО АКБ "НОВИКОМБАНК".        Рег.№ 2546
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("БИКи", БИКи);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторБанков.Код КАК БИК,
	|	ЕСТЬNULL(Банки.Наименование, КлассификаторБанков.Наименование) КАК Наименование,
	|	ЕСТЬNULL(Банки.Ссылка, НЕОПРЕДЕЛЕНО) КАК Ссылка
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанков
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО КлассификаторБанков.Код = Банки.Код
	|			И КлассификаторБанков.КоррСчет = Банки.КоррСчет
	|			И (Банки.Код В (&БИКи))
	|ГДЕ
	|	КлассификаторБанков.Код В(&БИКи)
	|	И НЕ КлассификаторБанков.ДеятельностьПрекращена
	|	И НЕ КлассификаторБанков.ПометкаУдаления
	|	И НЕ Банки.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	БИК,
	|	Банки.РучноеИзменение";
	
	ВыбранныйБанкНеЯвляетсяУполномоченным = ЗначениеЗаполнено(ВыбранныйБанк);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокВыбора.Добавить(Выборка.БИК, Выборка.Наименование);
		
		БИК = "_" + Выборка.БИК;
		Если Выборка.Ссылка <> Неопределено И Не УполномоченныеБанки.Свойство(БИК) Тогда
			УполномоченныеБанки.Вставить(БИК, Выборка.Ссылка);
		КонецЕсли;
		
		Если ВыбранныйБанкНеЯвляетсяУполномоченным И ВыбранныйБанк.Код = Выборка.БИК Тогда
			ВыбранныйБанкНеЯвляетсяУполномоченным = Ложь;
			ПолеВыбораУполномоченногоБанка = Выборка.БИК;
		КонецЕсли;
	КонецЦикла;
	
	Если ВыбранныйБанкНеЯвляетсяУполномоченным Тогда
		СписокВыбора.Добавить(ВыбранныйБанк.Код, ВыбранныйБанк.Наименование);
		УполномоченныеБанки.Вставить("_" + ВыбранныйБанк.Код, ВыбранныйБанк);
		ПолеВыбораУполномоченногоБанка = ВыбранныйБанк.Код;
	КонецЕсли;
	
	СписокВыбора.Добавить("999999999", "<Другой уполномоченный банк...>");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УполномоченныйБанкОбработкаВыбораНаСервере(Знач ВыбранноеЗначение, УполномоченныеБанки)
	Перем Ссылка;
	
	Если УполномоченныеБанки.Свойство("_" + ВыбранноеЗначение, Ссылка) Тогда
		Возврат Ссылка;
	КонецЕсли;
	
	Ссылка = Справочники.Банки.СсылкаНаБанк(ВыбранноеЗначение);
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		ТаблицаБанков = Справочники.Банки.ПолучитьТаблицуБанковПоРеквизитам("Код", ВыбранноеЗначение);
		Для каждого ЭлементТаблицы Из ТаблицаБанков Цикл
			Если НЕ ЭлементТаблицы.Ссылка.ЭтоГруппа Тогда
				Ссылка = ЭлементТаблицы.Ссылка;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	УполномоченныеБанки.Вставить("_" + Ссылка.Код, Ссылка);
	
	Возврат Ссылка;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьДублиИГК(Знач ИГК, Знач Ссылка)
	ЕстьДубли = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Код",    ИГК);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ГосКонтракты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГосКонтракты КАК ГосКонтракты
	|ГДЕ
	|	ГосКонтракты.Код = &Код
	|	И ГосКонтракты.Ссылка <> &Ссылка";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЕстьДубли = Истина;
	КонецЕсли;
	
	Возврат ЕстьДубли;
	
КонецФункции
#КонецОбласти

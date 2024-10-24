﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТипыОснований = Документы.ТипВсеСсылки();
	
	ЭтоВыданныйСчетФактура = Ложь;
	Если Параметры.ЗначенияЗаполнения.ТипСчетаФактуры = "Выданный" Тогда 
		ЭтоВыданныйСчетФактура = Истина;
		ТипыОснований = УчетНДСПереопределяемый.ПолучитьСписокТиповПоВидуСчетаФактурыВыставленного(Параметры.ЗначенияЗаполнения.ВидСчетаФактуры, Параметры.ЗначенияЗаполнения.Исправление)
	ИначеЕсли Параметры.ЗначенияЗаполнения.ТипСчетаФактуры = "Полученный" Тогда
		ТипыОснований = УчетНДСПереопределяемый.ПолучитьСписокТиповПоВидуСчетаФактурыПолученного(Параметры.ЗначенияЗаполнения.ВидСчетаФактуры);
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Запрос = Новый Запрос;
	
	ОтборОрганизация = Параметры.Отбор.Организация;
	ДоступныеОрганизации = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(Ложь);
	Если ДоступныеОрганизации.Найти(Параметры.Отбор.Организация) = Неопределено Тогда
		// Для выполнения запроса в привилегированном режиме мы должны гарантировать, что настройки RLS допускают
		// чтение документов по организации.
		ОтборОрганизация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	ОтборКонтрагент  = Параметры.Отбор.Контрагент;
	
	Запрос.УстановитьПараметр("Организация",	ОтборОрганизация);
	Запрос.УстановитьПараметр("Контрагент",		ОтборКонтрагент);
	Запрос.УстановитьПараметр("ТекущийСчетФактура",	Параметры.ЗначенияЗаполнения.СчетФактура);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета);
	
	Запрос.Текст = ТекстЗапросаСтрокиОснований(ТипыОснований, ЭтоВыданныйСчетФактура);
	
	УстановитьПривилегированныйРежим(Истина);
	СтрокиОснований.Загрузить(Запрос.Выполнить().Выгрузить());
	УстановитьПривилегированныйРежим(Ложь);
	
	ТекущийДокумент = Параметры.Документ;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отбор = Новый Структура();
	Отбор.Вставить("Документ", ТекущийДокумент);
	
	Строки = СтрокиОснований.НайтиСтроки(Отбор);
	
	Если Строки.Количество() <> 0  Тогда
		Элементы.Список.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда 
		Документ = Элементы.Список.ТекущиеДанные.Документ;
		ПоказатьЗначение( , Документ);	
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработкаВыбораЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаВыбораЗначения()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВыбора = Новый Структура;
	СтруктураВыбора.Вставить("Документ", ТекущиеДанные.Документ);
	СтруктураВыбора.Вставить("Договор", ТекущиеДанные.ДоговорКонтрагента);
	
	ОповеститьОВыборе(СтруктураВыбора);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекстЗапросаСтрокиОснований(ТипыОснований, ЭтоВыданныйСчетФактура)
	
	ШаблонТекстаЗапроса = 
	"ВЫБРАТЬ
	|	ДокументыБезСчетаФактуры.ВидДокумента,
	|	ДокументыБезСчетаФактуры.Дата КАК Дата,
	|	ДокументыБезСчетаФактуры.Номер КАК Номер,
	|	ДокументыБезСчетаФактуры.Организация,
	|	ДокументыБезСчетаФактуры.Контрагент,
	|	ДокументыБезСчетаФактуры.СуммаДокумента,
	|	ДокументыБезСчетаФактуры.ВалютаДокумента,
	|	ДокументыБезСчетаФактуры.Документ КАК Документ,
	|	ВЫБОР
	|		КОГДА ДокументыБезСчетаФактуры.Документ.РучнаяКорректировка
	|			ТОГДА ВЫБОР
	|					КОГДА ДокументыБезСчетаФактуры.Документ.ПометкаУдаления
	|						ТОГДА 10
	|					КОГДА НЕ ДокументыБезСчетаФактуры.Документ.Проведен
	|						ТОГДА 9
	|					ИНАЧЕ 8
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ДокументыБезСчетаФактуры.Документ.ПометкаУдаления
	|					ТОГДА 2
	|				КОГДА ДокументыБезСчетаФактуры.Документ.Проведен
	|					ТОГДА 1
	|				ИНАЧЕ 0
	|			КОНЕЦ
	|	КОНЕЦ КАК СостояниеДокумента
	|ИЗ
	|	(ВЫБРАТЬ
	|		Документы.ВидДокумента КАК ВидДокумента,
	|		СчетаФактуры.Ссылка КАК СчетФактура,
	|		Документы.Документ КАК Документ,
	|		Документы.Дата КАК Дата,
	|		Документы.Номер КАК Номер,
	|		Документы.Организация КАК Организация,
	|		Документы.Контрагент КАК Контрагент,
	|		Документы.СуммаДокумента КАК СуммаДокумента,
	|		Документы.ВалютаДокумента КАК ВалютаДокумента
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ЗНАЧЕНИЕ(Документ.РегламентнаяОперация.ПустаяСсылка) КАК Документ,
	|			"""" КАК ВидДокумента,
	|			ДАТАВРЕМЯ(1, 1, 1) КАК Дата,
	|			"""" КАК Номер,
	|			ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) КАК Организация,
	|			ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|			0 КАК СуммаДокумента,
	|			ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДокумента) КАК Документы
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный КАК СчетаФактуры
	|			ПО Документы.Документ = СчетаФактуры.ДокументОснование
	|				И Документы.Контрагент = СчетаФактуры.Контрагент
	|				И (НЕ СчетаФактуры.ПометкаУдаления)
	|	ГДЕ
	|		Документы.Организация = &Организация
	|		И Документы.Контрагент = &Контрагент) КАК ДокументыБезСчетаФактуры
	|ГДЕ
	|	ЕСТЬNULL(ДокументыБезСчетаФактуры.СчетФактура, &ТекущийСчетФактура) = &ТекущийСчетФактура
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	// создаем подзапрос-источник данных об основаниях
	ПервыйПодзапрос = Истина;
	ТекстЗапросаОснований = "";
	Для Каждого ТипДокумента Из ТипыОснований Цикл
	
		ТекстЗапросаОснований = ТекстЗапросаОснований + ?(ПервыйПодзапрос, "", "
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		") + ТекстЗапросаПоТипуДокумента(ТипДокумента, ЭтоВыданныйСчетФактура, ПервыйПодзапрос);
	
		ПервыйПодзапрос = Ложь;
	
	КонецЦикла;
	// Заменяем пустой запрос на реальный запрос: текст подзапроса в ШаблонТекстаЗапроса должен совпадать с текстом по-умолчанию,
	// возращаемым функцией ТекстЗапросаПоТипуДокумента().
	ШаблонТекстаЗапроса = СтрЗаменить(ШаблонТекстаЗапроса, ТекстЗапросаПоТипуДокумента("", ЭтоВыданныйСчетФактура, Истина), ТекстЗапросаОснований);
	
	// Создаем подзапрос-источник данных о счете-фактуре.
	Если Не ЭтоВыданныйСчетФактура Тогда
		ШаблонТекстаЗапроса = СтрЗаменить(ШаблонТекстаЗапроса,
			"Документ.СчетФактураВыданный КАК СчетаФактуры",
			"Документ.СчетФактураПолученный КАК СчетаФактуры");
	КонецЕсли;
	
	Возврат ШаблонТекстаЗапроса;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекстЗапросаПоТипуДокумента(ТипДокумента, ЭтоВыданныйСчетФактура, ДобавитьИменаПолей = Ложь)

	// Список применяется для расстановки имен у полей подзапросов.
	ИменаПолейЗапроса = Новый Массив;
	ИменаПолейЗапроса.Добавить("Документ");
	ИменаПолейЗапроса.Добавить("ВидДокумента");
	ИменаПолейЗапроса.Добавить("Дата");
	ИменаПолейЗапроса.Добавить("Номер");
	ИменаПолейЗапроса.Добавить("Организация");
	ИменаПолейЗапроса.Добавить("Контрагент");
	ИменаПолейЗапроса.Добавить("СуммаДокумента");
	ИменаПолейЗапроса.Добавить("ВалютаДокумента");
	
	МетаданныеДокументов = Метаданные.Документы;
	
	Если ТипДокумента = Тип("ДокументСсылка.АвансовыйОтчет") И ПравоДоступа("Редактирование", МетаданныеДокументов.АвансовыйОтчет) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			АвансовыйОтчетОплатаПоставщикам.Ссылка,
	|			МАКСИМУМ(""Авансовый отчет""),
	|			АвансовыйОтчетОплатаПоставщикам.Ссылка.Дата,
	|			АвансовыйОтчетОплатаПоставщикам.Ссылка.Номер,
	|			АвансовыйОтчетОплатаПоставщикам.Ссылка.Организация,
	|			АвансовыйОтчетОплатаПоставщикам.Контрагент,
	|			СУММА(АвансовыйОтчетОплатаПоставщикам.Сумма),
	|			АвансовыйОтчетОплатаПоставщикам.Ссылка.ВалютаДокумента
	|		ИЗ
	|			Документ.АвансовыйОтчет.ОплатаПоставщикам КАК АвансовыйОтчетОплатаПоставщикам
	|		
	|		СГРУППИРОВАТЬ ПО
	|			АвансовыйОтчетОплатаПоставщикам.Контрагент,
	|			АвансовыйОтчетОплатаПоставщикам.Ссылка,
	|			АвансовыйОтчетОплатаПоставщикам.Ссылка.Дата,
	|			АвансовыйОтчетОплатаПоставщикам.Ссылка.Номер,
	|			АвансовыйОтчетОплатаПоставщикам.Ссылка.Организация,
	|			АвансовыйОтчетОплатаПоставщикам.Ссылка.ВалютаДокумента";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") И ПравоДоступа("Редактирование", МетаданныеДокументов.ВозвратТоваровОтПокупателя) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			ВозвратТоваровОтПокупателя.Ссылка,
	|			""Возврат товаров от покупателя"",
	|			ВозвратТоваровОтПокупателя.Дата,
	|			ВозвратТоваровОтПокупателя.Номер,
	|			ВозвратТоваровОтПокупателя.Организация,
	|			ВозвратТоваровОтПокупателя.Контрагент,
	|			ВозвратТоваровОтПокупателя.СуммаДокумента,
	|			ВозвратТоваровОтПокупателя.ВалютаДокумента
	|		ИЗ
	|			Документ.ВозвратТоваровОтПокупателя КАК ВозвратТоваровОтПокупателя";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ДокументРасчетовСКонтрагентом") И ПравоДоступа("Редактирование", МетаданныеДокументов.ДокументРасчетовСКонтрагентом) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			ДокументРасчетовСКонтрагентом.Ссылка,
	|			""Документ расчетов с контрагентами (ручной учет)"",
	|			ДокументРасчетовСКонтрагентом.Дата,
	|			ДокументРасчетовСКонтрагентом.Номер,
	|			ДокументРасчетовСКонтрагентом.Организация,
	|			ДокументРасчетовСКонтрагентом.Контрагент,
	|			ДокументРасчетовСКонтрагентом.СуммаДокумента,
	|			ДокументРасчетовСКонтрагентом.ВалютаДокумента
	|		ИЗ
	|			Документ.ДокументРасчетовСКонтрагентом КАК ДокументРасчетовСКонтрагентом";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.КорректировкаДолга") И ПравоДоступа("Редактирование", МетаданныеДокументов.КорректировкаДолга) Тогда
		Если ЭтоВыданныйСчетФактура Тогда
			ТекстЗапроса = "ВЫБРАТЬ
	|			КорректировкаДолгаКредиторскаяЗадолженность.Ссылка,
	|			""Корректировка долга"",
	|			КорректировкаДолгаКредиторскаяЗадолженность.Ссылка.Дата,
	|			КорректировкаДолгаКредиторскаяЗадолженность.Ссылка.Номер,
	|			КорректировкаДолгаКредиторскаяЗадолженность.Ссылка.Организация,
	|			КорректировкаДолгаКредиторскаяЗадолженность.Ссылка.КонтрагентКредитор,
	|			КорректировкаДолгаКредиторскаяЗадолженность.Сумма,
	|			КорректировкаДолгаКредиторскаяЗадолженность.Ссылка.ВалютаДокумента
	|		ИЗ
	|			Документ.КорректировкаДолга.КредиторскаяЗадолженность КАК КорректировкаДолгаКредиторскаяЗадолженность";
		Иначе
	    	ТекстЗапроса = "ВЫБРАТЬ
	|			КорректировкаДолгаДебиторскаяЗадолженность.Ссылка,
	|			""Корректировка долга"",
	|			КорректировкаДолгаДебиторскаяЗадолженность.Ссылка.Дата,
	|			КорректировкаДолгаДебиторскаяЗадолженность.Ссылка.Номер,
	|			КорректировкаДолгаДебиторскаяЗадолженность.Ссылка.Организация,
	|			КорректировкаДолгаДебиторскаяЗадолженность.Ссылка.КонтрагентДебитор,
	|			КорректировкаДолгаДебиторскаяЗадолженность.Сумма,
	|			КорректировкаДолгаДебиторскаяЗадолженность.Ссылка.ВалютаДокумента
	|		ИЗ
	|			Документ.КорректировкаДолга.ДебиторскаяЗадолженность КАК КорректировкаДолгаДебиторскаяЗадолженность";
		КонецЕсли;		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.КорректировкаПоступления") И ПравоДоступа("Редактирование", МетаданныеДокументов.КорректировкаПоступления) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			КорректировкаПоступления.Ссылка,
	|			""Корректировка поступления"",
	|			КорректировкаПоступления.Дата,
	|			КорректировкаПоступления.Номер,
	|			КорректировкаПоступления.Организация,
	|			КорректировкаПоступления.Контрагент,
	|			КорректировкаПоступления.СуммаДокумента,
	|			КорректировкаПоступления.ВалютаДокумента
	|		ИЗ
	|			Документ.КорректировкаПоступления КАК КорректировкаПоступления";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.КорректировкаРеализации") И ПравоДоступа("Редактирование", МетаданныеДокументов.КорректировкаРеализации) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			КорректировкаРеализации.Ссылка,
	|			""Корректировка реализации"",
	|			КорректировкаРеализации.Дата,
	|			КорректировкаРеализации.Номер,
	|			КорректировкаРеализации.Организация,
	|			КорректировкаРеализации.Контрагент,
	|			КорректировкаРеализации.СуммаДокумента,
	|			КорректировкаРеализации.ВалютаДокумента
	|		ИЗ
	|			Документ.КорректировкаРеализации КАК КорректировкаРеализации";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ОплатаПлатежнойКартой") И ПравоДоступа("Редактирование", МетаданныеДокументов.ОплатаПлатежнойКартой) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			ОплатаПлатежнойКартойРасшифровкаПлатежа.Ссылка,
	|			МАКСИМУМ(""Оплата платежной картой""),
	|			ОплатаПлатежнойКартойРасшифровкаПлатежа.Ссылка.Дата,
	|			ОплатаПлатежнойКартойРасшифровкаПлатежа.Ссылка.Номер,
	|			ОплатаПлатежнойКартойРасшифровкаПлатежа.Ссылка.Организация,
	|			ОплатаПлатежнойКартойРасшифровкаПлатежа.Ссылка.Контрагент,
	|			СУММА(ОплатаПлатежнойКартойРасшифровкаПлатежа.СуммаПлатежа),
	|			ОплатаПлатежнойКартойРасшифровкаПлатежа.Ссылка.ВалютаДокумента
	|		ИЗ
	|			Документ.ОплатаПлатежнойКартой.РасшифровкаПлатежа КАК ОплатаПлатежнойКартойРасшифровкаПлатежа
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ОплатаПлатежнойКартойРасшифровкаПлатежа.Ссылка.Контрагент,
	|			ОплатаПлатежнойКартойРасшифровкаПлатежа.Ссылка,
	|			ОплатаПлатежнойКартойРасшифровкаПлатежа.Ссылка.Дата,
	|			ОплатаПлатежнойКартойРасшифровкаПлатежа.Ссылка.Номер,
	|			ОплатаПлатежнойКартойРасшифровкаПлатежа.Ссылка.Организация,
	|			ОплатаПлатежнойКартойРасшифровкаПлатежа.Ссылка.ВалютаДокумента";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") И ПравоДоступа("Редактирование", МетаданныеДокументов.ОтчетКомиссионераОПродажах) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			ОтчетКомиссионераОПродажах.Ссылка,
	|			""Отчет комиссионера (агента) о продажах"",
	|			ОтчетКомиссионераОПродажах.Дата,
	|			ОтчетКомиссионераОПродажах.Номер,
	|			ОтчетКомиссионераОПродажах.Организация,
	|			ОтчетКомиссионераОПродажах.Контрагент,
	|			ОтчетКомиссионераОПродажах.СуммаДокумента,
	|			ОтчетКомиссионераОПродажах.ВалютаДокумента
	|		ИЗ
	|			Документ.ОтчетКомиссионераОПродажах КАК ОтчетКомиссионераОПродажах";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ОтчетКомитентуОПродажах") И ПравоДоступа("Редактирование", МетаданныеДокументов.ОтчетКомитентуОПродажах) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			ОтчетКомитентуОПродажах.Ссылка,
	|			""Отчет комитенту"",
	|			ОтчетКомитентуОПродажах.Дата,
	|			ОтчетКомитентуОПродажах.Номер,
	|			ОтчетКомитентуОПродажах.Организация,
	|			ОтчетКомитентуОПродажах.Контрагент,
	|			ОтчетКомитентуОПродажах.СуммаДокумента,
	|			ОтчетКомитентуОПродажах.ВалютаДокумента
	|		ИЗ
	|			Документ.ОтчетКомитентуОПродажах КАК ОтчетКомитентуОПродажах";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") И ПравоДоступа("Редактирование", МетаданныеДокументов.ОтчетОРозничныхПродажах) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			ОтчетОрозничныхПродажахПодарочныеСертификаты.Ссылка,
	|			МАКСИМУМ(""Продажа собственных подарочных сертификатов""),
	|			ОтчетОрозничныхПродажахПодарочныеСертификаты.Ссылка.Дата,
	|			ОтчетОрозничныхПродажахПодарочныеСертификаты.Ссылка.Номер,
	|			ОтчетОрозничныхПродажахПодарочныеСертификаты.Ссылка.Организация,
	|			ОтчетОрозничныхПродажахПодарочныеСертификаты.ВидОплаты.Контрагент,
	|			СУММА(ОтчетОрозничныхПродажахПодарочныеСертификаты.Сумма),
	|			&ВалютаРегламентированногоУчета
	|		ИЗ
	|			Документ.ОтчетОРозничныхПродажах.ПодарочныеСертификаты КАК ОтчетОрозничныхПродажахПодарочныеСертификаты
	|		ГДЕ
	|			ОтчетОрозничныхПродажахПодарочныеСертификаты.ВидОплаты.ТипОплаты = ЗНАЧЕНИЕ(Перечисление.ТипыОплат.ПодарочныйСертификатСобственный)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ОтчетОрозничныхПродажахПодарочныеСертификаты.Ссылка,
	|			ОтчетОрозничныхПродажахПодарочныеСертификаты.Ссылка.Дата,
	|			ОтчетОрозничныхПродажахПодарочныеСертификаты.Ссылка.Номер,
	|			ОтчетОрозничныхПродажахПодарочныеСертификаты.Ссылка.Организация,
	|			ОтчетОрозничныхПродажахПодарочныеСертификаты.ВидОплаты.Контрагент";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПоступлениеНаРасчетныйСчет") И ПравоДоступа("Редактирование", МетаданныеДокументов.ПоступлениеНаРасчетныйСчет) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка,
	|			МАКСИМУМ(""Поступление на расчетный счет""),
	|			ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка.Дата,
	|			ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка.Номер,
	|			ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка.Организация,
	|			ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка.Контрагент,
	|			СУММА(ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.СуммаПлатежа),
	|			ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка.ВалютаДокумента
	|		ИЗ
	|			Документ.ПоступлениеНаРасчетныйСчет.РасшифровкаПлатежа КАК ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка.Контрагент,
	|			ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка,
	|			ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка.Дата,
	|			ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка.Номер,
	|			ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка.Организация,
	|			ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка.ВалютаДокумента";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") И ПравоДоступа("Редактирование", МетаданныеДокументов.ПриходныйКассовыйОрдер) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка,
	|			МАКСИМУМ(""Поступление наличных""),
	|			ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Дата,
	|			ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Номер,
	|			ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Организация,
	|			ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Контрагент,
	|			СУММА(ПриходныйКассовыйОрдерРасшифровкаПлатежа.СуммаПлатежа),
	|			ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.ВалютаДокумента
	|		ИЗ
	|			Документ.ПриходныйКассовыйОрдер.РасшифровкаПлатежа КАК ПриходныйКассовыйОрдерРасшифровкаПлатежа
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка,
	|			ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Дата,
	|			ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Номер,
	|			ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Организация,
	|			ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Контрагент,
	|			ПриходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.ВалютаДокумента";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.РасходныйКассовыйОрдер") И ПравоДоступа("Редактирование", МетаданныеДокументов.РасходныйКассовыйОрдер) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка,
	|			МАКСИМУМ(""Выдача наличных""),
	|			РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Дата,
	|			РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Номер,
	|			РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Организация,
	|			РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Контрагент,
	|			СУММА(РасходныйКассовыйОрдерРасшифровкаПлатежа.СуммаПлатежа),
	|			РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.ВалютаДокумента
	|		ИЗ
	|			Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК РасходныйКассовыйОрдерРасшифровкаПлатежа
	|		
	|		СГРУППИРОВАТЬ ПО
	|			РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка,
	|			РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Дата,
	|			РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Номер,
	|			РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Организация,
	|			РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Контрагент,
	|			РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.ВалютаДокумента";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.СписаниеСРасчетногоСчета") И ПравоДоступа("Редактирование", МетаданныеДокументов.СписаниеСРасчетногоСчета) Тогда
	    ТекстЗапроса = "ВЫБРАТЬ
	|			СписаниеСРасчетногоСчетаРасшифровкаПлатежа.Ссылка,
	|			МАКСИМУМ(""Списание с расчетного счета""),
	|			СписаниеСРасчетногоСчетаРасшифровкаПлатежа.Ссылка.Дата,
	|			СписаниеСРасчетногоСчетаРасшифровкаПлатежа.Ссылка.Номер,
	|			СписаниеСРасчетногоСчетаРасшифровкаПлатежа.Ссылка.Организация,
	|			СписаниеСРасчетногоСчетаРасшифровкаПлатежа.Ссылка.Контрагент,
	|			СУММА(СписаниеСРасчетногоСчетаРасшифровкаПлатежа.СуммаПлатежа),
	|			СписаниеСРасчетногоСчетаРасшифровкаПлатежа.Ссылка.ВалютаДокумента
	|		ИЗ
	|			Документ.СписаниеСРасчетногоСчета.РасшифровкаПлатежа КАК СписаниеСРасчетногоСчетаРасшифровкаПлатежа
	|		
	|		СГРУППИРОВАТЬ ПО
	|			СписаниеСРасчетногоСчетаРасшифровкаПлатежа.Ссылка,
	|			СписаниеСРасчетногоСчетаРасшифровкаПлатежа.Ссылка.Дата,
	|			СписаниеСРасчетногоСчетаРасшифровкаПлатежа.Ссылка.Номер,
	|			СписаниеСРасчетногоСчетаРасшифровкаПлатежа.Ссылка.Организация,
	|			СписаниеСРасчетногоСчетаРасшифровкаПлатежа.Ссылка.Контрагент,
	|			СписаниеСРасчетногоСчетаРасшифровкаПлатежа.Ссылка.ВалютаДокумента";
	Иначе // текст запроса по-умолчанию
		ТекстЗапроса = "ВЫБРАТЬ
	|			ЗНАЧЕНИЕ(Документ.РегламентнаяОперация.ПустаяСсылка),
	|			"""",
	|			ДАТАВРЕМЯ(1, 1, 1),
	|			"""",
	|			ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка),
	|			ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),
	|			0,
	|			ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)";
	КонецЕсли;
	
	Если ДобавитьИменаПолей Тогда
	
		ТекстСИменамиПолей = СтрПолучитьСтроку(ТекстЗапроса, 1);
		ПолейВЗапросе = ИменаПолейЗапроса.Количество();
		Для НомерПоляЗапроса = 1 По ПолейВЗапросе Цикл
			
			СтрокаЗапроса = СтрПолучитьСтроку(ТекстЗапроса, 1 + НомерПоляЗапроса);
			ЕстьЗапятая = (Прав(СтрокаЗапроса, 1) = ",");
			СтрокаБезЗапятой = ?(ЕстьЗапятая, Лев(СтрокаЗапроса, СтрДлина(СтрокаЗапроса) - 1), СтрокаЗапроса);
			ТекстСИменамиПолей = ТекстСИменамиПолей + Символы.ПС + СтрокаБезЗапятой
				+ " КАК " + ИменаПолейЗапроса[НомерПоляЗапроса - 1]	+ ?(ЕстьЗапятая, ",", "");
			
		КонецЦикла;
		Для НомерСтрокиЗапроса = ПолейВЗапросе + 2 По СтрЧислоСтрок(ТекстЗапроса) Цикл
			ТекстСИменамиПолей = ТекстСИменамиПолей + Символы.ПС + СтрПолучитьСтроку(ТекстЗапроса, НомерСтрокиЗапроса);
		КонецЦикла;
		ТекстЗапроса = ТекстСИменамиПолей;
	
	КонецЕсли;
	
	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

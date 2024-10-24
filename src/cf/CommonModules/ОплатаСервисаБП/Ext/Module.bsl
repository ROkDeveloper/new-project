﻿#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при определении представления валюты оплаты сервиса.
// См. ОплатаСервисаПереопределяемый.ПриУстановкеПредставленияВалютыОплаты()
//
Процедура ПриУстановкеПредставленияВалютыОплаты(ПредставлениеВалютыОплаты) Экспорт
	
	ПредставлениеВалютыОплаты = ТарификацияБПКлиентСервер.ЗнакРубля();
	
КонецПроцедуры

// Вызывается при получении имени формы обработки ответа на запрос счета на оплату.
// См. ОплатаСервисаПереопределяемый.ПриПолученииИмениФормыОбработкиОтвета()
//
Процедура ПриПолученииИмениФормыОбработкиОтвета(ИмяФормыОбработкиОтвета) Экспорт
	
	ИмяФормыОбработкиОтвета = "Обработка.ОплатаСервисаБП.Форма.ОбработкаОтвета";
	
КонецПроцедуры

// Вызывается при определении возможности загрузки тарифов сервиса.
// См. ОплатаСервисаПереопределяемый.ПриОпределенииПоддержкиЗагрузкиТарифов()
//
Процедура ПриОпределенииПоддержкиЗагрузкиТарифов(Результат) Экспорт
	
	// Вызов этой процедуры происходит при выборе приложения в качестве
	// учетной системы биллинга в Менеджере сервиса.
	// Поэтому здесь включается биллинговая функциональность.
	
	Если НЕ Константы.ИспользоватьБиллинг.Получить() Тогда
		Константы.ИспользоватьБиллинг.Установить(Истина);
	КонецЕсли;
	
	// Установка признака отправки уведомлений покупателю (если призанк неопределен)
	Если ОплатаСервисаЭлектроннаяПочтаБП.УведомлятьПокупателяПоЭлектроннойПочте() = Неопределено Тогда
		ОплатаСервисаЭлектроннаяПочтаБП.УстановитьУведомлятьПокупателяПоЭлектроннойПочте(Истина);
	КонецЕсли;
	
	// Установка шаблонов писем по умолчанию (если не установлены)
	Если ПустаяСтрока(СокрЛП(ОплатаСервисаЭлектроннаяПочтаБП.ШаблонПисьмаВыставленСчет())) Тогда
		ОплатаСервисаЭлектроннаяПочтаБП.УстановитьШаблонПисьмаВыставленСчет(
			Обработки.НастройкиБиллинга.ПолучитьМакет("ШаблонПисьмаВыставленСчет").ПолучитьТекст());
	КонецЕсли;
	
	Если ПустаяСтрока(СокрЛП(ОплатаСервисаЭлектроннаяПочтаБП.ШаблонПисьмаПолученаОплата())) Тогда
		ОплатаСервисаЭлектроннаяПочтаБП.УстановитьШаблонПисьмаПолученаОплата(
			Обработки.НастройкиБиллинга.ПолучитьМакет("ШаблонПисьмаПолученаОплата").ПолучитьТекст());
	КонецЕсли;
	
	Если ПустаяСтрока(СокрЛП(ОплатаСервисаЭлектроннаяПочтаБП.ШаблонПисьмаОформленаПодписка())) Тогда
		ОплатаСервисаЭлектроннаяПочтаБП.УстановитьШаблонПисьмаОформленаПодписка(
			Обработки.НастройкиБиллинга.ПолучитьМакет("ШаблонПисьмаОформленаПодписка").ПолучитьТекст());
	КонецЕсли;
	
	Если ПустаяСтрока(СокрЛП(ОплатаСервисаЭлектроннаяПочтаБП.ШаблонПисьмаОшибка())) Тогда
		ОплатаСервисаЭлектроннаяПочтаБП.УстановитьШаблонПисьмаОшибка(
			Обработки.НастройкиБиллинга.ПолучитьМакет("ШаблонПисьмаОшибка").ПолучитьТекст());
	КонецЕсли;
	
	Результат = Истина;
	
КонецПроцедуры

// Вызывается при загрузке тарифов в информационную базу по данным менеджера сервиса.
// Метод является идемпотентным. Поддерживается повторное выполнение с получением аналогичного результата.
// См. ОплатаСервисаПереопределяемый.ПриОпределенииПоддержкиЗагрузкиТарифов()
//
Процедура ПриЗагрузкеТарифов(ИсходныеДанные) Экспорт
	
	ДанныеЗаполнения = Новый ТаблицаЗначений;
	ДанныеЗаполнения.Колонки.Добавить("Артикул", ОбщегоНазначения.ОписаниеТипаСтрока(25));
	ДанныеЗаполнения.Колонки.Добавить("Наименование", ОбщегоНазначения.ОписаниеТипаСтрока(100));
	ДанныеЗаполнения.Колонки.Добавить("НаименованиеПолное", ОбщегоНазначения.ОписаниеТипаСтрока(1000));
	ДанныеЗаполнения.Колонки.Добавить("Цена", ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
	
	ДобавитьСтрокиПоТарифам(ДанныеЗаполнения, ИсходныеДанные.ТарифыПровайдера, ПрефиксТарифаПровайдера());
	ДобавитьСтрокиПоТарифам(ДанныеЗаполнения, ИсходныеДанные.ТарифыОбслуживающейОрганизации, ПрефиксТарифаОбслуживающейОрганизации());
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИсходныеДанные.Артикул КАК Артикул,
	|	ИсходныеДанные.Наименование КАК Наименование,
	|	ИсходныеДанные.НаименованиеПолное КАК НаименованиеПолное,
	|	ИсходныеДанные.Цена КАК Цена
	|ПОМЕСТИТЬ ИсходныеДанные
	|ИЗ
	|	&ИсходныеДанные КАК ИсходныеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходныеДанные.Артикул КАК Артикул,
	|	ИсходныеДанные.Наименование КАК Наименование,
	|	ИсходныеДанные.НаименованиеПолное КАК НаименованиеПолное,
	|	ИсходныеДанные.Цена КАК Цена,
	|	Номенклатура.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(Номенклатура.Ссылка.Наименование, """") КАК НаименованиеНоменклатуры,
	|	ЕСТЬNULL(Номенклатура.Ссылка.НаименованиеПолное, """") КАК НаименованиеПолноеНоменклатуры
	|ПОМЕСТИТЬ ДанныеНоменклатуры
	|ИЗ
	|	ИсходныеДанные КАК ИсходныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	|		ПО ИсходныеДанные.Артикул = Номенклатура.Артикул
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеНоменклатуры.Артикул КАК Артикул,
	|	ДанныеНоменклатуры.Наименование КАК Наименование,
	|	ДанныеНоменклатуры.НаименованиеПолное КАК НаименованиеПолное,
	|	ДанныеНоменклатуры.Цена КАК Цена,
	|	ДанныеНоменклатуры.НаименованиеНоменклатуры КАК НаименованиеНоменклатуры,
	|	ДанныеНоменклатуры.НаименованиеПолноеНоменклатуры КАК НаименованиеПолноеНоменклатуры,
	|	ЕСТЬNULL(ДанныеНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Ссылка,
	|	ЕСТЬNULL(ЦеныНоменклатурыДокументов.Цена, 0) КАК ЦенаНоменклатуры
	|ИЗ
	|	ДанныеНоменклатуры КАК ДанныеНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыДокументов КАК ЦеныНоменклатурыДокументов
	|		ПО ДанныеНоменклатуры.Ссылка = ЦеныНоменклатурыДокументов.Номенклатура";
	Запрос.УстановитьПараметр("ИсходныеДанные", ДанныеЗаполнения);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Пока Выборка.Следующий() Цикл
		Если НЕ ЗначениеЗаполнено(Выборка.Ссылка) Тогда // Новая номенклатура
			ДанныеЗаполнения = Новый Структура;
			ДанныеЗаполнения.Вставить("Услуга", Истина);
			
			НоменклатураОбъект = Справочники.Номенклатура.СоздатьЭлемент();
			НоменклатураОбъект.Заполнить(ДанныеЗаполнения);
			НоменклатураОбъект.УстановитьНовыйКод();
			НоменклатураОбъект.Артикул = Выборка.Артикул;
			НоменклатураОбъект.ВидСтавкиНДС = Перечисления.ВидыСтавокНДС.БезНДС;
		ИначеЕсли Выборка.ЦенаНоменклатуры <> Выборка.Цена
			ИЛИ Выборка.НаименованиеНоменклатуры <> Выборка.Наименование
			ИЛИ ЗначениеЗаполнено(Выборка.НаименованиеПолное) И Выборка.НаименованиеПолноеНоменклатуры <> Выборка.НаименованиеПолное Тогда // Нужно актуализировать
			НоменклатураОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Иначе
			Продолжить;
		КонецЕсли;
		
		НоменклатураОбъект.Наименование = Выборка.Наименование;
		Если ЗначениеЗаполнено(Выборка.НаименованиеПолное) Тогда
			НоменклатураОбъект.НаименованиеПолное = Выборка.НаименованиеПолное;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(НоменклатураОбъект.НаименованиеПолное) Тогда
			НоменклатураОбъект.НаименованиеПолное = НоменклатураОбъект.Наименование;
		КонецЕсли;
		НоменклатураОбъект.Записать();
		
		Справочники.Номенклатура.УстановитьЦену(НоменклатураОбъект.Ссылка, Выборка.Цена);
	КонецЦикла;
	
КонецПроцедуры

// Вызывается при создании счета на оплату по запросу от менеджера сервиса.
// См. ОплатаСервисаПереопределяемый.ПриСозданииСчетаНаОплату()
//
Процедура ПриСозданииСчетаНаОплату(ДанныеЗапроса, СчетНаОплату, РезультатОбработки) Экспорт
	
	// Проверка возможности создания счета
	
	Попытка
		
		УстановитьПривилегированныйРежим(Истина);
		
		ИдентификаторСчета = ДанныеЗапроса.ИдентификаторСчета;
		КодПродавца = ДанныеЗапроса.КодПродавца;
		КодПокупателя = ДанныеЗапроса.КодПокупателя;
		ИННПокупателя= ДанныеЗапроса.ПубличныйИдентификаторПокупателя;
		Если ДанныеЗапроса.Свойство("client_organization") Тогда
			НаименованиеПокупателя = ДанныеЗапроса.client_organization;
		Иначе
			НаименованиеПокупателя = ДанныеЗапроса.НаименованиеПокупателя;
		КонецЕсли;
		ПочтаПокупателя = ДанныеЗапроса.ПочтаПокупателя;
		ТелефонПокупателя = ДанныеЗапроса.ТелефонПокупателя;
		Продление = ДанныеЗапроса.Продление;
		
		// Проверка корректности ИНН абонента. Сформировать электронный документ можно только с корректным ИНН.
		
		ЭтоЮрЛицо = СтрДлина(ИННПокупателя) < 12;
		РезультатПроверки = ИдентификационныеНомераНалогоплательщиков.ПроверитьСоответствиеТребованиямИНН(ИННПокупателя, ЭтоЮрЛицо);
		Если НЕ РезультатПроверки.СоответствуетТребованиям Тогда
			ОписаниеОшибки = СтрШаблон(НСтр("ru = 'Некорректное значение ИНН в сведениях абонента: %1
			|%2'"), ИННПокупателя, РезультатПроверки.ОписаниеОшибки);
			ВызватьИсключение ОписаниеОшибки;
		КонецЕсли;
		
		// Получение организации
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 2
		|	Организации.Ссылка КАК Организация
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	НЕ Организации.ПометкаУдаления";
		Выборка =  Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() = 1 Тогда
			Организация = Выборка.Организация;
		Иначе // в базе несколько организаций, нужная должна быть указана в настройках биллинга
			Организация = Организация();
			
			Если Организация.Пустая() Тогда
				ВызватьИсключение НСтр("ru = 'Не указана организация в настройках биллинга'");
			КонецЕсли;
		КонецЕсли;
		
		// Подготовка таблицы тарифов
		
		ДанныеЗапроса.Тарифы.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		Для каждого Строка Из ДанныеЗапроса.Тарифы Цикл
			Если ЗначениеЗаполнено(Строка.КодТарифаОбслуживающейОрганизации) Тогда
				Артикул = Артикул(ПрефиксТарифаОбслуживающейОрганизации(),
					Строка.КодПериодаДействия, Строка.КодТарифаОбслуживающейОрганизации);
			Иначе
				Артикул = Артикул(ПрефиксТарифаПровайдера(),
					Строка.КодПериодаДействия, Строка.КодТарифаПровайдера);
			КонецЕсли;
			Строка.Номенклатура = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул", Артикул);
			Если Строка.Номенклатура.Пустая() Тогда
				ВызватьИсключение СтрШаблон(НСтр("ru='Не найдена номенклатура с артикулом %1.'"), Артикул);
			КонецЕсли;
			
			Если Строка.Количество = 0 Тогда
				ВызватьИсключение СтрШаблон(НСтр("ru='Тариф с артикулом %1: количество не может быть равно.'"), Артикул);
			КонецЕсли;
		КонецЦикла;
		
	Исключение
		
		ОбработкаОшибки(СчетНаОплату, НСтр("ru = 'Создание счета на оплату сервиса'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), РезультатОбработки);
		
		Возврат;
		
	КонецПопытки;
	
	// Создание счета
	
	НачатьТранзакцию();
	
	Попытка
		
		// Создание/актуализация контрагента
		
		ДанныеЗаполнения = Новый Структура;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ИННПокупателя", ИННПокупателя);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Контрагенты.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ Контрагенты
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	НЕ Контрагенты.ПометкаУдаления
		|	И Контрагенты.ИНН = &ИННПокупателя
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДокументСчетНаОплатуПокупателю.Контрагент КАК Контрагент
		|ПОМЕСТИТЬ СчетНаОплатуПокупателю
		|ИЗ
		|	Документ.СчетНаОплатуПокупателю КАК ДокументСчетНаОплатуПокупателю
		|ГДЕ
		|	НЕ ДокументСчетНаОплатуПокупателю.ПометкаУдаления
		|	И ДокументСчетНаОплатуПокупателю.Контрагент В
		|			(ВЫБРАТЬ
		|				Контрагенты.Ссылка
		|			ИЗ
		|				Контрагенты)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДокументСчетНаОплатуПокупателю.Дата УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	1 КАК Приоритет,
		|	СчетНаОплатуПокупателю.Контрагент КАК Контрагент
		|ПОМЕСТИТЬ ПриоритетКонтрагентов
		|ИЗ
		|	СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	2,
		|	Контрагенты.Ссылка
		|ИЗ
		|	Контрагенты КАК Контрагенты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПриоритетКонтрагентов.Контрагент КАК Контрагент
		|ИЗ
		|	ПриоритетКонтрагентов КАК ПриоритетКонтрагентов
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПриоритетКонтрагентов.Приоритет";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Контрагент = Выборка.Контрагент;
			КонтрагентОбъект = Контрагент.ПолучитьОбъект();
		Иначе
			КонтрагентОбъект = Справочники.Контрагенты.СоздатьЭлемент();
			
			ДанныеЗаполнения.Вставить("ИНН", ИННПокупателя);
			ДанныеЗаполнения.Вставить("ЮридическоеФизическоеЛицо", ?(ЭтоЮрЛицо,
				Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо, Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо));
		КонецЕсли;
		
		ДанныеЗаполнения.Вставить("НаименованиеПолное", НаименованиеПокупателя);
		ДанныеЗаполнения.Вставить("Наименование", ОбщегоНазначенияБПКлиентСервер.НаименованиеПоСокращенномуНаименованию(НаименованиеПокупателя));
		
		КонтрагентОбъект.Заполнить(ДанныеЗаполнения);
		КонтрагентОбъект.Записать();
		
		Контрагент = КонтрагентОбъект.Ссылка;
		
		// Создание/актуализация счета
		
		СсылкаНаСчет = Документы.СчетНаОплатуПокупателю.ПолучитьСсылку(Новый УникальныйИдентификатор(ИдентификаторСчета));
		Если НЕ ОбщегоНазначения.СсылкаСуществует(СсылкаНаСчет) Тогда
			СчетОбъект = Документы.СчетНаОплатуПокупателю.СоздатьДокумент();
			СчетОбъект.УстановитьСсылкуНового(СсылкаНаСчет);
			СчетОбъект.Дата = ТекущаяДатаСеанса();
			СчетОбъект.УстановитьНовыйНомер();
		Иначе
			СчетОбъект = СсылкаНаСчет.ПолучитьОбъект();
		КонецЕсли;
		
		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("Организация", Организация);
		ДанныеЗаполнения.Вставить("Контрагент",  Контрагент);
		СчетОбъект.Заполнить(ДанныеЗаполнения);
		
		// Заполнение номенклатуры
		
		ПараметрыНоменклатуры = Новый Структура("Организация, Дата, Ссылка, ТипЦен, СуммаВключаетНДС,
			|ВалютаДокумента, КурсВзаиморасчетов, КратностьВзаиморасчетов, Склад, ДоговорКонтрагента,
			|ДокументБезНДС");
		ЗаполнитьЗначенияСвойств(ПараметрыНоменклатуры, СчетОбъект);
		ПараметрыНоменклатуры.ТипЦен = ПредопределенноеЗначение("Справочник.ТипыЦенНоменклатуры.ПустаяСсылка");
		ПараметрыНоменклатуры.Вставить("Реализация", Истина);
		ПараметрыНоменклатуры.Вставить("СпособЗаполненияЦены", Перечисления.СпособыЗаполненияЦен.ПоПродажнымЦенам);
		
		СчетОбъект.Товары.Очистить();
		
		Для каждого Строка Из ДанныеЗапроса.Тарифы Цикл
			СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
				Строка.Номенклатура, ПараметрыНоменклатуры, Ложь);
			
			ЦенаНоменклатуры = Строка.Сумма / Строка.Количество;
			
			НоваяСтрока = СчетОбъект.Товары.Добавить();
			НоваяСтрока.Номенклатура = Строка.Номенклатура;
			НоваяСтрока.Содержание = СодержаниеСтрокиСчета(СведенияОНоменклатуре.НаименованиеПолное, КодПокупателя);
			НоваяСтрока.Количество = Строка.Количество;
			НоваяСтрока.Цена = ЦенаНоменклатуры;
			
			Если СведенияОНоменклатуре <> Неопределено Тогда
				НоваяСтрока.СтавкаНДС = СведенияОНоменклатуре.СтавкаНДС;
				Если СведенияОНоменклатуре.Цена <> ЦенаНоменклатуры Тогда
					Справочники.Номенклатура.УстановитьЦену(Строка.Номенклатура, ЦенаНоменклатуры);
				КонецЕсли;
			КонецЕсли;
			
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(НоваяСтрока, 1);
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(НоваяСтрока, Истина);
		КонецЦикла;
		
		Для каждого Строка Из ДанныеЗапроса.Услуги Цикл
			НоваяСтрока = СчетОбъект.Товары.Добавить();
			НоваяСтрока.Номенклатура = Справочники.Номенклатура.НайтиПоНаименованию(Строка.Услуга);
			НоваяСтрока.Содержание = СодержаниеСтрокиСчета(Строка.Услуга, КодПокупателя);
			НоваяСтрока.Количество = 1;
			НоваяСтрока.Цена = Строка.Сумма;
			
			Если ЗначениеЗаполнено(НоваяСтрока.Номенклатура) Тогда
				СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
					НоваяСтрока.Номенклатура, ПараметрыНоменклатуры, Ложь);
				Если СведенияОНоменклатуре <> Неопределено Тогда
					НоваяСтрока.СтавкаНДС = СведенияОНоменклатуре.СтавкаНДС;
				КонецЕсли;
			КонецЕсли;
			
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(НоваяСтрока);
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(НоваяСтрока, Истина);
		КонецЦикла;
		
		СчетОбъект.Записать();
		
		// Запись дополнительных свойств счета
		
		СвойстваСчета = РегистрыСведений.СчетНаОплатуПокупателюОплатаСервиса.СоздатьМенеджерЗаписи();
		СвойстваСчета.Организация = СчетОбъект.Организация;
		СвойстваСчета.СчетНаОплатуПокупателю = СчетОбъект.Ссылка;
		СвойстваСчета.КодПокупателя = КодПокупателя;
		СвойстваСчета.ПочтаПокупателя = ПочтаПокупателя;
		СвойстваСчета.КодПродавца = КодПродавца;
		СвойстваСчета.Записать(Истина);
		
		// Отправка писем
		
		ПредставлениеТарифов = СтрСоединить(СчетОбъект.Товары.ВыгрузитьКолонку("Содержание"), Символы.ПС);
		ОплатаСервисаЭлектроннаяПочтаБП.ОтправитьПисьмоПродавцуСоСчетом(СчетОбъект.Ссылка, ПредставлениеТарифов, Продление,
			КодПокупателя, ПочтаПокупателя, ТелефонПокупателя);
		
		ОплатаСервисаЭлектроннаяПочтаБП.ОтправитьПисьмоПокупателюСоСчетом(СчетОбъект.Ссылка, ПочтаПокупателя);
		
		ЗафиксироватьТранзакцию();
		
		СчетНаОплату = СчетОбъект.Ссылка;
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ОбработкаОшибки(СчетНаОплату, НСтр("ru = 'Создание счета на оплату сервиса'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), РезультатОбработки);
		
	КонецПопытки;
	
КонецПроцедуры

// Устанавливает печатную форму счета на оплату.
// См. ОплатаСервиса.ПриПолученииПечатнойФормыСчетаНаОплату()
//
Процедура ПриПолученииПечатнойФормыСчетаНаОплату(ДанныеЗапроса, СчетНаОплату, ПечатнаяФорма, РезультатОбработки) экспорт
	
	Попытка
		
		СведенияСчетаНаОплату = Документы.СчетНаОплатуПокупателю.ПолучитьТаблицуСведенийСчетаНаОплату(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СчетНаОплату));
			
		ОбъектыПечати = Новый СписокЗначений;
		
		ПечатнаяФорма = ПечатьТорговыхДокументов.ПечатьСчетаНаОплату(СведенияСчетаНаОплату, ОбъектыПечати, Новый Структура);
		
		УправлениеПечатьюБП.ОчиститьФаксимильнуюПодписьИПечатьИзМакета(ПечатнаяФорма, ОбъектыПечати, СчетНаОплату);
		
	Исключение
		
		ОбработкаОшибки(СчетНаОплату, НСтр("ru ='Получение печатной формы счета на оплату сервиса'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), РезультатОбработки);
		
	КонецПопытки;
	
КонецПроцедуры

// Устанавливает двоичные данные счета на оплату.
// См. ОплатаСервиса.ПриПолученииДанныхСчетаНаОплату()
//
Процедура ПриПолученииДанныхСчетаНаОплату(ДанныеЗапроса, СчетНаОплату, Данные, РезультатОбработки) Экспорт
	
	Попытка
		
		Данные = Документы.СчетНаОплатуПокупателю.XML(СчетНаОплату);
		
	Исключение
		
		ОбработкаОшибки(СчетНаОплату, НСтр("ru ='Получение данных счета на оплату сервиса'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), РезультатОбработки);
		
	КонецПопытки;
	
КонецПроцедуры

// Устанавливает значение платежной ссылки счета на оплату.
// См. ОплатаСервиса.ПриПолученииДанныхСчетаНаОплату()
//
Процедура ПриПолученииПлатежнойСсылки(ДанныеЗапроса, СчетНаОплату, ПлатежнаяСсылка, РезультатОбработки) Экспорт
	
	Попытка
		
		ПлатежнаяСсылка = ОплатаСервисаПлатежнаяСистемаЮKassaБП.СоздатьПлатежнуюСсылкуПоСчету(СчетНаОплату);
		
	Исключение
		
		ОбработкаОшибки(СчетНаОплату, СтрШаблон(НСтр("ru ='Получение платежной ссылки счета на оплату сервиса'",
			СчетНаОплату)), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), РезультатОбработки);
		
	КонецПопытки;
	
КонецПроцедуры

// Устанавливает признак оплаты счета.
//
// Параметры:
//  Счет - ДокументСсылка.СчетНаОплатуПокупателю - Оплаченный счет
//
Процедура ПриОплатеСчета(Счет) Экспорт
	
	Попытка
		
		ДанныеОбОплате = ОплатаСервиса.ШаблонДанныхОтвета();
		ДанныеОбОплате.Вставить("paid", Истина);
		ИдентификаторСчета = Счет.УникальныйИдентификатор();
		Результат = ОплатаСервиса.ОтправитьОтветВУчетнуюСистемуБиллинга(ИдентификаторСчета, ДанныеОбОплате);
		
		Если Результат.КодСостояния < 200 ИЛИ Результат.КодСостояния > 299 Тогда
			ВызватьИсключение СтрШаблон("%1 %2", Результат.КодСостояния, Результат.ПолучитьТелоКакСтроку());
		КонецЕсли;
		
	Исключение
		
		ОбработкаОшибки(Счет, СтрШаблон(НСтр("ru ='Оплата счета на оплату сервиса'", Счет)),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецПроцедуры

// Возвращает префикс тарифа провайдера
//
// Возвращаемое значение:
//	Строка - Префикс тарифа провайдера
//
Функция ПрефиксТарифаПровайдера() Экспорт
	
	Возврат "PR";
	
КонецФункции

// Возвращает префикс тарифа обслуживающей организации
//
// Возвращаемое значение:
//	Строка - Префикс тарифа обслуживающей организации
//
Функция ПрефиксТарифаОбслуживающейОрганизации() Экспорт
	
	Возврат "SC";
	
КонецФункции

// Извлекает префикс тарифа из артикула.
//
// Параметры:
//	Артикул - Строка - Артикул
//
// Возвращаемое значение:
//	Строка - Префикс тарифа. Если формат артикула некорректный, возвращается Неопределено.
//
Функция ПрефиксТарифа(Артикул) Экспорт
	
	Элементы = СтрРазделить(Артикул, "-");
	Если Элементы.Количество() <> 3 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Элементы[0];
	
КонецФункции

// Извлекает код тарифа из артикула.
//
// Параметры:
//	Артикул - Строка - Артикул
//
// Возвращаемое значение:
//	Строка - Код тарифа. Если формат артикула некорректный, возвращается Неопределено.
//
Функция КодТарифа(Артикул) Экспорт
	
	Элементы = СтрРазделить(Артикул, "-");
	Если Элементы.Количество() <> 3 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Элементы[2];
	
КонецФункции

// Извлекает код периода действия из артикула.
//
// Параметры:
//	Артикул - Строка - Артикул
//
// Возвращаемое значение:
//	Строка - Код периода действия. Если формат артикула некорректный, возвращается Неопределено.
//
Функция КодПериодаДействия(Артикул) Экспорт
	
	Элементы = СтрРазделить(Артикул, "-");
	Если Элементы.Количество() <> 3 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Элементы[1];
	
КонецФункции

#Область Настройки

// Возвращает организацию, выставляющую счета.
//
// Возвращаемое значение:
//	СправочникСсылка.Организации - Организация
//
Функция Организация() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Организация = ОбщегоНазначенияБП.ПрочитатьДанныеИзХранилища(
		ВладелецДанныхВХранилище(),
		"Организация"
	);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Организация = Неопределено Тогда
		Возврат Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Организация;
	
КонецФункции

// Записывает организацию, выставляющую счета, в хранилище
//
// Параметры:
//	Организация - СправочникСсылка.Организации - Организация
//
Процедура УстановитьОрганизацию(Организация) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначенияБП.ЗаписатьДанныеВХранилище(
		ВладелецДанныхВХранилище(),
		Организация,
		"Организация"
	);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьСтрокиПоТарифам(ДанныеЗаполнения, Тарифы, Префикс)
	
	ЕстьКолонкаКраткоеОписание = Тарифы.Колонки.Найти("КраткоеОписание") <> Неопределено;
	
	Для каждого Тариф Из Тарифы Цикл
		Для каждого Период Из Тариф.ПериодыДействия Цикл
			НоваяСтрока = ДанныеЗаполнения.Добавить();
			НоваяСтрока.Артикул = Артикул(Префикс, Период.Код, Тариф.Код);
			НоваяСтрока.Наименование = СтрШаблон(НСтр("ru = '%1 на %2'"), Тариф.Наименование, Период.Наименование);
			Если ЕстьКолонкаКраткоеОписание И ЗначениеЗаполнено(Тариф.КраткоеОписание) Тогда
				НоваяСтрока.НаименованиеПолное = НоваяСтрока.КраткоеОписание;
			КонецЕсли;
			НоваяСтрока.Цена = Период.Сумма;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Функция СодержаниеСтрокиСчета(НаименованиеНоменклатуры, КодПокупателя)
	
	Возврат СтрШаблон(НСтр("ru = '%1. Регистрационный номер %2'"), НаименованиеНоменклатуры, КодПокупателя);
	
КонецФункции

Функция Артикул(Префикс, КодПериода, КодТарифа);
	
	Возврат СтрШаблон("%1-%2-%3", Префикс, КодПериода, КодТарифа);
	
КонецФункции

Функция ВладелецДанныхВХранилище()
	
	Возврат "ОплатаСервисаБП";
	
КонецФункции

Процедура ОбработкаОшибки(Счет, ЗаголовокОшибки, ОписаниеОшибки, РезультатОбработки = Неопределено)
	
	ПредставлениеОшибки = СтрШаблон("%1 %2:
		|%3", ЗаголовокОшибки, Счет, ОписаниеОшибки);
	
	ОплатаСервисаЖурналРегистрацииБП.ЗаписатьОшибку(ОписаниеОшибки);
	
	Если ТипЗнч(РезультатОбработки) = Тип("Структура") Тогда
		РезультатОбработки.Ошибка = Истина;
		РезультатОбработки.Сообщение = ОписаниеОшибки;
	КонецЕсли;
	
	ОплатаСервисаЭлектроннаяПочтаБП.ОтправитьПисьмоПродавцуОбОшибкеПриВыставленииСчета(Счет, ЗаголовокОшибки, ОписаниеОшибки);
	
КонецПроцедуры

#КонецОбласти
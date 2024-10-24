﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция ПолучитьСписокВидовОпераций(Дата, Основание)

	ИспользуетсяПостановлениеНДС1137 = УчетНДСПереопределяемый.ИспользуетсяПостановлениеНДС1137(Дата);
	ОсуществляетсяЗакупкаТоваровУслугДляКомитентов = ПолучитьФункциональнуюОпцию("ОсуществляетсяЗакупкаТоваровУслугДляКомитентов");
	
	СписокВидовОпераций = Новый СписокЗначений;
	
	СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыПолученного.НаПоступление, НСтр("ru = 'Счет-фактура на поступление'"));
	СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыПолученного.НаАванс, НСтр("ru = 'Счет-фактура на аванс'"));
	
	Если ИспользуетсяПостановлениеНДС1137 И ОсуществляетсяЗакупкаТоваровУслугДляКомитентов
		И ТипЗнч(Основание) <> Тип("ДокументСсылка.ОтчетКомитентуОПродажах") Тогда 
		СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыПолученного.НаАвансКомитента, НСтр("ru = 'Счет-фактура на аванс комитента на закупку'"));
	КонецЕсли;
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетКомитентуОПродажах") 
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ВидОперации") = ПредопределенноеЗначение("Перечисление.ВидыОперацийОтчетКомитентуОПродажах.ОтчетОПродажах") Тогда
		СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыПолученного.Корректировочный, НСтр("ru = 'Корректировочный счет-фактура...'"));
		СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыПолученного.ПустаяСсылка(), НСтр("ru = 'Исправление счета-фактуры...'"));
	КонецЕсли;
	
	Если Основание = Неопределено Тогда
		СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыПолученного.Корректировочный, НСтр("ru = 'Корректировочный счет-фактура...'"));
		СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыПолученного.ПустаяСсылка(), НСтр("ru = 'Исправление счета-фактуры...'"));
	КонецЕсли;
	
	Возврат СписокВидовОпераций;

КонецФункции

&НаКлиенте
Процедура НачатьЗамерВремени(ВидСчетаФактуры)

	// Для корректировочного счета-фактуры показывается сначала форма подбора исходного документа,
	// поэтому счетчик для него здесь не включаем.

	КлючеваяОперация = "";
	Если ВидСчетаФактуры = ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыПолученного.НаПоступление") Тогда
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
			КлючеваяОперация = "СозданиеФормыСчетФактураПолученныйБланкСтрогойОтчетности";
		Иначе
			КлючеваяОперация = "СозданиеФормыСчетФактураПолученныйНаПоступление";
		КонецЕсли;
	ИначеЕсли ВидСчетаФактуры = ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыПолученного.НаАванс")
		ИЛИ ВидСчетаФактуры = ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыПолученного.НаАвансКомитента")
		ИЛИ ВидСчетаФактуры = ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыПолученного.КорректировочныйНаАванс") Тогда
		КлючеваяОперация = "СозданиеФормыСчетФактураПолученныйНаАванс";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КлючеваяОперация) Тогда
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументВида(ВыбранныйВидСчетаФактуры)
	
	Если ТипЗнч(ЗначенияЗаполнения) <> Тип("Структура") Тогда
		ЗначенияЗаполнения = Новый Структура();
	КонецЕсли;

	ЗначенияЗаполнения.Вставить("ВидСчетаФактуры", ВыбранныйВидСчетаФактуры);
	Если ЗначениеЗаполнено(Основание) Тогда
		ЗначенияЗаполнения.Вставить("ДокументОснование", Основание);
	КонецЕсли;
	
	ЗначениеОтбора = Новый Структура();
	
	Если ЗначенияЗаполнения.Свойство("Организация") Тогда
		ЗначениеОтбора.Вставить("Организация", ЗначенияЗаполнения.Организация);
	КонецЕсли;
	
	Если ЗначенияЗаполнения.Свойство("Контрагент") Тогда 
		ЗначениеОтбора.Вставить("Контрагент", ЗначенияЗаполнения.Контрагент);
	КонецЕсли;
	
	ЗначениеОтбора.Вставить("Исправление", Ложь);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ", Ключ);
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		СтруктураПараметров.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	КонецЕсли;
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	СтруктураПараметров.Вставить("Отбор", ЗначениеОтбора);
	
	Модифицированность = Ложь;
	Закрыть();
	
	
	НачатьЗамерВремени(ВыбранныйВидСчетаФактуры);
	
	ОткрытьФорму("Документ.СчетФактураПолученный.Форма." + ФормыСчетовФактур[ВыбранныйВидСчетаФактуры], СтруктураПараметров, ВладелецФормы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.СписокВидовОпераций.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		
		ОткрытьДокументВида(СтрокаТаблицы.Значение);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВидовОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокВидовОпераций.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьДокументВида(СтрокаТаблицы.Значение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ЗначениеКопирования") Тогда
		ЗначениеКопирования = Параметры.ЗначениеКопирования;
	КонецЕсли;
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ЗначенияЗаполнения = Параметры.ЗначенияЗаполнения;
	КонецЕсли;
	
	Если Параметры.Свойство("Основание") Тогда
		Основание = Параметры.Основание;
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетКомитентуОПродажах")
			И ЗначенияЗаполнения = Неопределено Тогда
			
			РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "Организация, Контрагент");
			ЗначенияЗаполнения = Новый Структура("Организация, Контрагент, ИсправлениеСобственнойОшибки",
				РеквизитыОснования.Организация, РеквизитыОснования.Контрагент, Ложь);
			
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("Ключ") Тогда
		Ключ = Параметры.Ключ;
	КонецЕсли;
	
	ФормыСчетовФактур = Новый ФиксированноеСоответствие(
		Документы.СчетФактураПолученный.ПолучитьСоответствиеВидовСчетаФактурыФормам());
	
	ВидыОпераций = ПолучитьСписокВидовОпераций(ОбщегоНазначения.ТекущаяДатаПользователя(), Основание);
	Для Каждого ВидОперации Из ВидыОпераций Цикл
		НоваяОперация = СписокВидовОпераций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяОперация, ВидОперации);
	КонецЦикла;

	Если Параметры.Свойство("ВидСчетаФактуры") Тогда
		ВыделенныйЭлементСписка = СписокВидовОпераций.НайтиПоЗначению(Параметры.ВидСчетаФактуры);
		Если ВыделенныйЭлементСписка <> Неопределено Тогда
			Элементы.СписокВидовОпераций.ТекущаяСтрока = ВыделенныйЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

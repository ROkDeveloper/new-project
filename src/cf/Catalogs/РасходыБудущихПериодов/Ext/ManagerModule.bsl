﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОбновитьПараметрыСтатьиРасходыНаПлатон() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;

	
	СтатьяОбъект = Справочники.РасходыБудущихПериодов.РасходыНаПлатон.ПолучитьОбъект();
	СтатьяОбъект.ВидАктива = Перечисления.ВидыАктивовДляРБП.ПрочиеОборотныеАктивы;
	СтатьяОбъект.СпособПризнанияРасходов = Перечисления.СпособыПризнанияРасходов.ВОсобомПорядке;
	
	Попытка
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СтатьяОбъект);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы'"), 
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Статья затрат для указанного вида РБП. Если виду РБП соответствует несколько статей затрат,
// то возвращается пустая ссылка.
// 
// Параметры:
//  ВидРБП - ПеречислениеСсылка.ВидыРБП
// 
// Возвращаемое значение:
//  СправочникСсылка.СтатьиЗатрат
//
Функция СтатьяЗатратПоВидуРБП(ВидРБП) Экспорт
	
	СтатьяЗатрат = Справочники.СтатьиЗатрат.ПустаяСсылка();
	
	ВидРасходовНУ = ВидРасходовНУДляВидовРБП().Получить(ВидРБП);
	
	Если Не ЗначениеЗаполнено(ВидРасходовНУ) Тогда
		Возврат СтатьяЗатрат;
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтатьиЗатрат.Ссылка КАК СтатьяЗатрат
		|ИЗ
		|	Справочник.СтатьиЗатрат КАК СтатьиЗатрат
		|ГДЕ
		|	НЕ СтатьиЗатрат.ПометкаУдаления
		|	И СтатьиЗатрат.ВидРасходовНУ = &ВидРасходовНУ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка";
	
	Запрос.УстановитьПараметр("ВидРасходовНУ", ВидРасходовНУ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СтатьяЗатрат = Выборка.СтатьяЗатрат;
	КонецЕсли;

	Возврат СтатьяЗатрат;
	
КонецФункции

// Таблица изменений количества застрахованных лиц на случай смерти и утраты трудоспособности для указанного расхода будущих периодов.
// 
// Параметры:
//  РасходБудущихПериодов - СправочникСсылка.РасходыБудущихПериодов
// 
// Возвращаемое значение:
//  ТаблицаЗначений:
//    * ДатаНачалаДействия - Дата
//    * Количество - Число
//
Функция ИсторияКоличествоЗастрахованных(РасходБудущихПериодов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КоличествоЗастрахованных.ДатаНачалаДействия КАК ДатаНачалаДействия,
		|	КоличествоЗастрахованных.Количество КАК Количество
		|ИЗ
		|	РегистрСведений.КоличествоЗастрахованныхОтНесчастныхСлучаев КАК КоличествоЗастрахованных
		|ГДЕ
		|	КоличествоЗастрахованных.РасходыНаСтрахование = &РасходБудущихПериодов
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачалаДействия";
	
	Запрос.УстановитьПараметр("РасходБудущихПериодов", РасходБудущихПериодов);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция РасходыНУ() Экспорт
	
	СписокРасходов = Новый СписокЗначений();
	СписокРасходов.Добавить(Перечисления.ВидыРБП.УбыткиОтРеализацииАмортизируемогоИмущества);
	СписокРасходов.Добавить(Перечисления.ВидыРБП.УбыткиПрошлыхЛет);
	СписокРасходов.Добавить(Перечисления.ВидыРБП.УбыткиПрошлыхЛетОбслуживающихПроизводствИХозяйств);
	
	Возврат СписокРасходов;
	
КонецФункции

Функция ПрочиеРасходы() Экспорт
	
	СписокПрочихРасходов = РасходыНУ();
	СписокПрочихРасходов.Добавить(Перечисления.ВидыРБП.ОсвоениеПриродныхРесурсов);
	СписокПрочихРасходов.Добавить(Перечисления.ВидыРБП.Прочие);
	
	Возврат СписокПрочихРасходов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВидРасходовНУДляВидовРБП()
	
	СоответствиеРасходовНУ = Новый Соответствие();
	СоответствиеРасходовНУ.Вставить(Перечисления.ВидыРБП.ДолгосрочноеСтрахованиеЖизни,
		Перечисления.ВидыРасходовНУ.ДобровольноеСтрахованиеПоДоговорамДолгосрочногоСтрахованияЖизниРаботников);
	СоответствиеРасходовНУ.Вставить(Перечисления.ВидыРБП.ОсвоениеПриродныхРесурсов,
		Перечисления.ВидыРасходовНУ.ОсвоениеПриродныхРесурсов);
	СоответствиеРасходовНУ.Вставить(Перечисления.ВидыРБП.Прочие, Перечисления.ВидыРасходовНУ.ПрочиеРасходы);
	СоответствиеРасходовНУ.Вставить(Перечисления.ВидыРБП.ПрочиеВидыСтрахования,
		Перечисления.ВидыРасходовНУ.ОбязательноеИДобровольноеСтрахованиеИмущества);
	СоответствиеРасходовНУ.Вставить(Перечисления.ВидыРБП.СтрахованиеНаОплатуМедицинскихРасходов,
		Перечисления.ВидыРасходовНУ.ДобровольноеЛичноеСтрахование);
	СоответствиеРасходовНУ.Вставить(Перечисления.ВидыРБП.СтрахованиеНаСлучайСмертиИУтратыРаботоспособности,
		Перечисления.ВидыРасходовНУ.ДобровольноеЛичноеСтрахованиеНаСлучайСмертиИлиУтратыРаботоспособности);

	Возврат СоответствиеРасходовНУ;
	
КонецФункции

#КонецОбласти

#КонецЕсли
﻿// Содержимое модуля отличается в версиях ПРОФ и КОРП.
// В версии ПРОФ отсутствует:
// - тело экспортных процедур (остаются только сигнатуры методов)
// - неэкспортные процедуры и все функции.
// Поэтому не допускается реализация в модуле экспортных функций: вместо них следует использовать процедуры с возвращаемым параметром.

#Область ПрограммныйИнтерфейс

// Добавляет счет 29 "Обслуживающие производства и хозяйства" в перечень счетов,
// которые могут закрываться автоматически.
//
// Параметры:
//  СчетаРасходов - Массив из ПланСчетовСсылка.Хозрасчетный - дополняемый перечень счетов.
//
Процедура ДобавитьСчетОбслуживающиеПроизводства(СчетаРасходов) Экспорт
	
	Если Не ПоддерживаетсяСписаниеРасходовОбслуживающихПроизводств() Тогда
		Возврат;
	КонецЕсли;
	
	СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ОбслуживающиеПроизводства);
	
КонецПроцедуры

// Добавляет правило распределения для счета 29 "Обслуживающие производства и хозяйства"
// Используется при закрытии месяца
//
// Параметры:
//  Процессор - Структура - коллекция, используемая в ходе заполнения правил распределения.
// см. ПравилаРаспределенияРасходов.НовыйПроцессорЗаполненияПравилРаспределения()
//
Процедура ДобавитьПравилоОбслуживающиеПроизводства(Процессор) Экспорт
	
	Если Процессор.Закрытие.Роль <> Перечисления.РолиСчетовЗатрат.ПрочиеРасходы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПоддерживаетсяСписаниеРасходовОбслуживающихПроизводств() Тогда
		Возврат;
	КонецЕсли;

	// Имя правила используется также в ЕдиныеПравила, см. ДополнитьЕдиныеПравилаНалоговогоУчета()
	Правило = ПравилаРаспределенияРасходов.ДобавитьПравилоРаспределения(Процессор, "ОбслуживающиеПроизводства", "РаспределитьНаСубконто");
	Правило.Наименование       = НСтр("ru = 'Списать расходы обслуживающих производств и хозяйств'");
	Правило.СодержаниеПроводки = НСтр("ru = 'Закрытие счетов обслуживающих производств и хозяйств'", Процессор.КодЯзыка);
	
	ПредставлениеСчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПланыСчетов.Хозрасчетный.ПрочиеРасходы, "Код, Наименование");
	Правило.Описание = СтрШаблон(НСтр("ru = 'расходы обслуживающих производств и хозяйств списываются на счет %1 ""%2""'"),
		ПредставлениеСчета.Код,
		ПредставлениеСчета.Наименование);
	
	// Для разных видов деятельности разные статьи прочих расходов, но использовать будем одну статью.
	// Если статья не будет соответствовать виду деятельности, заполнять ее не будем
	Правило.ПоляИсточника.Вставить("ВидДеятельности", "ВидДеятельности");
	
	СтатьяРасходов = Справочники.ПрочиеДоходыИРасходы.ПредопределенныйЭлемент("РасходыОбслуживающихПроизводствИХозяйств");
	
	Правило.БазаРаспределения.Имя = "БазаРаспределения_ОбслуживающиеПроизводства";
	
	Если УчетнаяПолитика.ТолькоОсновнаяСистемаНалогообложения(
		Процессор.Настройки.Контекст.Организация, 
		Процессор.Настройки.Контекст.Период) Тогда
		ВидДеятельностиДляНУ = Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения;
	Иначе
		ВидДеятельностиДляНУ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтатьяРасходов, "ВидДеятельностиДляНалоговогоУчетаЗатрат");
	КонецЕсли;
	
	Если ВидДеятельностиДляНУ = Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения Тогда
		Правило.БазаРаспределения.ПараметрыЗапроса.Вставить("СтатьяРасходовОсновная", СтатьяРасходов);
		Правило.БазаРаспределения.ПараметрыЗапроса.Вставить("СтатьяРасходовОсобыйПорядок", Справочники.ПрочиеДоходыИРасходы.ПустаяСсылка());
	Иначе
		Правило.БазаРаспределения.ПараметрыЗапроса.Вставить("СтатьяРасходовОсновная", Справочники.ПрочиеДоходыИРасходы.ПустаяСсылка());
		Правило.БазаРаспределения.ПараметрыЗапроса.Вставить("СтатьяРасходовОсобыйПорядок", СтатьяРасходов);
	КонецЕсли;
	
	Правило.БазаРаспределения.ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения) КАК ВидДеятельности,
	|	&ПустоеПодразделение КАК Подразделение,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеРасходы) КАК Счет,
	|	&СтатьяРасходовОсновная КАК Субконто1,
	|	НЕОПРЕДЕЛЕНО КАК Субконто2,
	|	НЕОПРЕДЕЛЕНО КАК Субконто3,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК Номенклатура,
	|	1 КАК База
	|ПОМЕСТИТЬ БазаРаспределения_ОбслуживающиеПроизводства
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения),
	|	&ПустоеПодразделение,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеРасходы),
	|	&СтатьяРасходовОсобыйПорядок КАК Субконто1,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка),
	|	1
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВидДеятельности";
	
КонецПроцедуры

// Добавляет в перечень правил, одинаковых в бухгалтерском и налоговом учете,
// правило, создаваемое в ДобавитьПравилоОбслуживающиеПроизводства.
//
// Параметры:
//  ЕдиныеПравила - Массив из Строка - см. ПравилаРаспределенияРасходов.ЕдиныеПравилаНалоговогоУчета
//
Процедура ДополнитьЕдиныеПравилаНалоговогоУчета(ЕдиныеПравила) Экспорт
	
	Если Не ПоддерживаетсяСписаниеРасходовОбслуживающихПроизводств() Тогда
		Возврат;
	КонецЕсли;
	
	ЕдиныеПравила.Добавить("ОбслуживающиеПроизводства");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПоддерживаетсяСписаниеРасходовОбслуживающихПроизводств()
	
	Возврат ПолучитьФункциональнуюОпцию("РасширенныйФункционал");
	
КонецФункции

#КонецОбласти


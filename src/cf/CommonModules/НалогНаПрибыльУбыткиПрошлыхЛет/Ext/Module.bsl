﻿#Область ПрограммныйИнтерфейс

// Содержит артефакты, описывающие порядок учета убытков прошлых лет.
//
// Учет убытков прошлых лет для целей налогообложения устроен совсем не так, как это следует из правил бухгалтерского учета.
// А именно убытки прошлых лет к переносу на будущие годы отражаются по дебету счета 97 
// - либо по статьям РБП специального вида (устаревший вариант учета)
// - либо по статьям убытка (годам возникновения, УбыткиПрошлыхЛет - актуальный вариант учета)
// В первом случае год получения убытка зашифрован в периоде списания расхода - это год, предшествующий году начала списания.
//
// В бухгалтерском учете накопленный убыток отражается на счете 84.02.
// При этом в программе бухгалтерский учет убытка ведется сводно, а не по годам возникновения.
// 
// Поэтому здесь учитываются только суммы, отраженные по виду учета НУ.
//
// 
// Возвращаемое значение:
//  Структура
//
Функция ПорядокУчетаУбытковПрошлыхЛет() Экспорт
	
	ПорядокУчета = Новый Структура;
	ПорядокУчета.Вставить("СчетУчетаУбытков",          ПланыСчетов.Хозрасчетный.РасходыБудущихПериодов);
	ПорядокУчета.Вставить("ВидСтатьиРБП",              Перечисления.ВидыРБП.УбыткиПрошлыхЛет);
	ПорядокУчета.Вставить("СчетаУчетаУбытков",         БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПорядокУчета.СчетУчетаУбытков));
	ПорядокУчета.Вставить("СчетУчетаПрибыли",          ПланыСчетов.Хозрасчетный.ПрибылиИУбыткиНеЕНВД);
	ПорядокУчета.Вставить("ПредставлениеСчетаУбытков", Строка(ПорядокУчета.СчетУчетаУбытков));
	ПорядокУчета.Вставить("ПредставлениеВидаСтатьи",   Строка(ПорядокУчета.ВидСтатьиРБП));
	ПорядокУчета.Вставить("ПредставлениеСчетаПрибыли", Строка(ПорядокУчета.СчетУчетаПрибыли));
	ПорядокУчета.Вставить("СчетаУбыткиПрошлыхЛет",     СчетаУбыткиПрошлыхЛет(ПорядокУчета.СчетаУчетаУбытков));
	ПорядокУчета.Вставить("ПредставлениеСчетовУбытков",Новый Соответствие);
	
	Для Каждого Счет Из ПорядокУчета.СчетаУчетаУбытков Цикл
		ПорядокУчета.ПредставлениеСчетовУбытков.Вставить(Счет, Строка(Счет));
	КонецЦикла;
	
	Возврат ПорядокУчета;
	
КонецФункции

// Определяет сумму налогового убытка, полученного в текущем (переданном) периоде и перенесенного на будущее.
//
// Параметры:
//  НачалоПериода - Дата
//  КонецПериода  - Дата
//  Организации   - СправочникСсылка.Организации
// 
// Возвращаемое значение:
//  Сумма - сумма убытка
//
Функция УбытокПеренесенныйНаБудущее(НачалоПериода, КонецПериода, Организации) Экспорт
	
	ПорядокУчета = ПорядокУчетаУбытковПрошлыхЛет();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода",     НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",      КонецПериода);
	Запрос.УстановитьПараметр("Организации",       Организации);
	Запрос.УстановитьПараметр("СчетУчетаПрибыли",  ПорядокУчета.СчетУчетаПрибыли);
	Запрос.УстановитьПараметр("СчетаУчетаУбытков", ПорядокУчета.СчетаУчетаУбытков);
	Запрос.УстановитьПараметр("ВидСтатьиРБП",      ПорядокУчета.ВидСтатьиРБП);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПереносУбытка.СубконтоДт1 КАК СтатьяУбытка,
	|	СУММА(ПереносУбытка.СуммаНУОборотДт) КАК СуммаНУ
	|ПОМЕСТИТЬ СуммыУбыткаРБП
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, , 
	|			СчетДт В (&СчетаУчетаУбытков), 
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.РасходыБудущихПериодов), 
	|			СчетКт = &СчетУчетаПрибыли, , 
	|			Организация В (&Организации)) КАК ПереносУбытка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПереносУбытка.СубконтоДт1
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(СуммыУбыткаРБП.СуммаНУ), 0) КАК СуммаНУ
	|ИЗ
	|	СуммыУбыткаРБП КАК СуммыУбыткаРБП
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РасходыБудущихПериодов КАК РасходыБудущихПериодов
	|		ПО СуммыУбыткаРБП.СтатьяУбытка = РасходыБудущихПериодов.Ссылка
	|ГДЕ
	|	РасходыБудущихПериодов.ВидРБП = &ВидСтатьиРБП
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ПереносУбытка9711.СуммаНУОборотДт), 0)
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, , 
	|			СчетДт = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.УбыткиПрошлыхЛет), , 
	|			СчетКт = &СчетУчетаПрибыли, , 
	|			Организация В (&Организации)) КАК ПереносУбытка9711";
	
	СуммаУбытка = 0;
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СуммаУбытка = СуммаУбытка + Выборка.СуммаНУ;	
	КонецЦикла;
	
	Возврат СуммаУбытка;
	
КонецФункции

// Определяет сумму убытков прошлых лет, использованных (списанных) в текущем (переданном) периоде для уменьшения налоговой базы.
//
// Параметры:
//  НачалоПериода - Дата
//  КонецПериода  - Дата
//  Организации   - СправочникСсылка.Организации
// 
// Возвращаемое значение:
//  КоллекцияСумм - см. КоллекцииСумм.НовыйКоллекцияСумм() - коллекция сумм списаных убытков
//
Функция СписанныйУбытокПрошлыхЛет(НачалоПериода, КонецПериода, Организации) Экспорт
	
	ПорядокУчета = ПорядокУчетаУбытковПрошлыхЛет();
	
	ОписаниеСумм = НалогНаПрибыльБухгалтерскийУчет.ОписаниеКоллекцииСумм();
	КоллекцияСумм = КоллекцииСумм.НовыйКоллекцияСумм(ОписаниеСумм);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода",     НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",      КонецПериода);
	Запрос.УстановитьПараметр("Организации",       Организации);
	Запрос.УстановитьПараметр("СчетУчетаПрибыли",  ПорядокУчета.СчетУчетаПрибыли);
	Запрос.УстановитьПараметр("СчетаУчетаУбытков", ПорядокУчета.СчетаУчетаУбытков);
	Запрос.УстановитьПараметр("ВидСтатьиРБП",      ПорядокУчета.ВидСтатьиРБП);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасходыБудущихПериодов.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ СтатьиУбыткаРБП
	|ИЗ
	|	Справочник.РасходыБудущихПериодов КАК РасходыБудущихПериодов
	|ГДЕ
	|	РасходыБудущихПериодов.ВидРБП = &ВидСтатьиРБП
	|;
	|////////////////////////////////////////////////////////////////////////////////	
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(СуммыУбыткаРБП.СуммаНУОборотКт), 0) КАК СуммаНУ,
	|	ЕСТЬNULL(СУММА(СуммыУбыткаРБП.СуммаВРОборотКт), 0) КАК СуммаВР
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, , 
	|			СчетДт = &СчетУчетаПрибыли, , 
	|			СчетКт В (&СчетаУчетаУбытков), 
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.РасходыБудущихПериодов), 
	|			Организация В (&Организации)
	|			И СубконтоКт1 В
	|					(ВЫБРАТЬ
	|						СтатьиУбытка.Ссылка
	|					ИЗ
	|						СтатьиУбыткаРБП КАК СтатьиУбытка)) КАК СуммыУбыткаРБП
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(СуммыУбытка9711.СуммаНУОборотКт), 0),
	|	ЕСТЬNULL(СУММА(СуммыУбытка9711.СуммаВРОборотКт), 0)
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, , 
	|			СчетДт = &СчетУчетаПрибыли, , 
	|			СчетКт = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.УбыткиПрошлыхЛет), , 
	|			Организация В (&Организации)) КАК СуммыУбытка9711";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		КоллекцияСумм.СуммаНУ = КоллекцияСумм.СуммаНУ + Выборка.СуммаНУ;
		КоллекцияСумм.СуммаВР = КоллекцияСумм.СуммаВР + Выборка.СуммаВР;
	КонецЦикла;
	
	Возврат КоллекцияСумм;
	
КонецФункции

// Формирует проводки налогового учета по переносу убытка на будущее 
//
// Параметры:
//  Проводки - РегистрБухгалтерииНаборЗаписей.Хозрасчетный - содержит проводки операции закрытия месяца
//  Период - Дата - содержит дату начала месяца
//  Организация - СправочникСсылка.Организации 
// 
Процедура ПереносУбыткаНаБудущее(Проводки, Период, Организация) Экспорт
	
	КонецПериода = КонецГода(Период);
	
	// Выполняется только в последнем месяце года, и если организация зарегистрирована не в этом месяце.
	// Если компания зарегистрирована в декабре, то первый налоговый период захватит следующий год.
	Если КонецПериода <> КонецМесяца(Период) Тогда
		Возврат;
	КонецЕсли;
	
	НалоговыйПериод = НалоговыйУчет.БлижайшийНалоговыйПериод(Период, Организация);
	Если КонецПериода <> НалоговыйПериод.Конец Тогда
		Возврат;
	КонецЕсли;
	
	// Налоговая база может включать убытки, которые уменьшили налогооблагаемую базу текущего налогового периода.
	// Рассчитаем налоговую базу без учета убытков прошлых лет.
	НачалоПериода = НачалоМесяца(НалоговыйПериод.Начало);
	СписанныйУбыток = СписанныйУбытокПрошлыхЛет(НачалоПериода, КонецПериода, Организация);
	
	СуммаУбытка = - (РасчетНалогаНаПрибыль.НалоговаяБаза(НачалоПериода, КонецПериода, Организация)
		+ УбытокПеренесенныйНаБудущее(НачалоПериода, КонецПериода, Организация))
		- СписанныйУбыток.СуммаНУ;
	
	Если СуммаУбытка <= 0 Тогда
		Возврат;
	КонецЕсли; 
	
	СубконтоУбытка = Справочники.УбыткиПрошлыхЛет.СсылкаУбытокПериода(Период);
	ПорядокУчетаУбытков = ПорядокУчетаУбытковПрошлыхЛет();
	Содержание = НСтр("ru = 'Перенос убытка на будущее'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	Проводка = Проводки.Добавить();
	Проводка.Период = Период;
	Проводка.Организация = Организация;
	
	Проводка.СчетДт = ПланыСчетов.Хозрасчетный.УбыткиПрошлыхЛет;
	Проводка.СубконтоДт.УбыткиПрошлыхЛет = СубконтоУбытка;
	
	Проводка.СчетКт = ПорядокУчетаУбытков.СчетУчетаПрибыли;
	
	Проводка.СуммаНУДт = СуммаУбытка;
	Проводка.СуммаНУКт = СуммаУбытка;
	Проводка.Содержание = Содержание;
	
	Проводки.ЗаполнитьСуммыВременныхРазниц();
	Проводки.Записывать = Истина;
	
КонецПроцедуры

// Возвращает год перехода на новый счет учета убытков (97.11)
//
// Возвращаемое значение:
//  Дата
//
Функция ДатаПереходаНаОтдельныйСчетУчетаУбытков() Экспорт
	
	Возврат Дата(2021, 1, 1);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет субсчета на которых учет ведется с применением субконто УбыткиПрошлыхЛет
//
// Параметры:
//  ВсеСчетаУчетаУбытков - Массив из ПланСчетовСсылка.Хозрасчетный - субсчета, из перечня которых выбираются подходящие
// 
// Возвращаемое значение:
//  Массив из ПланСчетовСсылка.Хозрасчетный - субсчета из переданного перечня, на которых есть субконто УбыткиПрошлыхЛет
//
Функция СчетаУбыткиПрошлыхЛет(ВсеСчетаУчетаУбытков)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Счета", ВсеСчетаУчетаУбытков);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыСубконто.Ссылка КАК Счет
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидыСубконто
	|ГДЕ
	|	ВидыСубконто.Ссылка В(&Счета)
	|	И ВидыСубконто.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.УбыткиПрошлыхЛет)
	|	И ВидыСубконто.Суммовой
	|	И НЕ ВидыСубконто.ТолькоОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидыСубконто.Ссылка.Порядок,
	|	ВидыСубконто.Ссылка.Ссылка";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Счет");
	
КонецФункции

#КонецОбласти
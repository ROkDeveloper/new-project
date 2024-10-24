﻿#Область ПрограммныйИнтерфейс

Процедура ОбработкаПроведенияФормированиеЗаписейРаздела7ДекларацииНДС(Документ, Движения, Отказ) Экспорт
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(Документ);
	
	ПараметрыПроведения = ПодготовитьПараметрыПроведения(Документ.Ссылка, Отказ);
	
	Если Документ.РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	СформироватьДвиженияРаздела7ДекларацииНДС(
		ПараметрыПроведения.ТаблицаЗаписиРаздела7, Движения, Отказ);
		
	СформироватьДвиженияСписаниеНеоблагаемыхНДСОпераций(
		ПараметрыПроведения.ТаблицаНеоблагаемыеОперации, Движения, Отказ);
		
	РегистрыСведений.ВыполнениеРегламентныхОперацийНДС.СформироватьДвиженияФактВыполненияРегламентнойОперации(
		ПараметрыПроведения.ДанныеРегламентнойОперации, Отказ);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(Документ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПодготовкаПараметровПроведенияФормированияРаздела7

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента();
	Результат = Запрос.Выполнить();
	ПараметрыПроведения.Вставить("Реквизиты", Результат.Выгрузить());
	Реквизиты = ПараметрыПроведения.Реквизиты[0];
	
	Если НЕ УчетнаяПолитика.Существует(Реквизиты.Организация, Реквизиты.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация",                Реквизиты.Организация);
	Запрос.УстановитьПараметр("ДатаДокумента",              Реквизиты.Период);
	Запрос.УстановитьПараметр("ДатаГраница", Новый Граница(КонецДня(Реквизиты.Период), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("КодыРеализацийНеНаТерриторииРФ", 
		Справочники.КодыОперацийРаздела7ДекларацииПоНДС.КодыРеализацииНеНаТерриторииРФ());
	Запрос.УстановитьПараметр("ПравилаЗаполненияДекларацииС4кв2020", 
		УчетНДС.ПравилаЗаполненияДекларацииС4кв2020(Реквизиты.Период));
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаЗаписиРаздела7(НомераТаблиц)
		+ ТекстЗапросаНеоблагаемыеНДСОперации(НомераТаблиц)
		+ ТекстЗапросаПоФормированиюРегламентнойОперации(НомераТаблиц);
		
	Результат = Запрос.ВыполнитьПакет();
	
	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;
	
КонецФункции

Функция ТекстЗапросаПоФормированиюРегламентнойОперации(НомераТаблиц)

	НомераТаблиц.Вставить("ДанныеРегламентнойОперации", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(Реквизиты.Дата, КВАРТАЛ) КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.РегламентныеОперации.ФормированиеЗаписейРаздела7ДекларацииНДС) КАК РегламентнаяОперация
	|ИЗ
	|	Документ.ФормированиеЗаписейРаздела7ДекларацииНДС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаРеквизитыДокумента()

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.Ссылка КАК Регистратор
	|ИЗ
	|	Документ.ФормированиеЗаписейРаздела7ДекларацииНДС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции // ТекстЗапросаРеквизитыДокумента()

Функция ТекстЗапросаЗаписиРаздела7(НомераТаблиц)
	
	НомераТаблиц.Вставить("ТаблицаЗаписиРаздела7", НомераТаблиц.Количество());
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации КАК КодОперации,
	|	СУММА(ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаРеализации) КАК СуммаРеализации,
	|	СУММА(ВЫБОР
	|			КОГДА &ПравилаЗаполненияДекларацииС4кв2020
	|				ТОГДА ВЫБОР
	|						КОГДА ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации В (&КодыРеализацийНеНаТерриторииРФ)
	|							ТОГДА 0
	|						ИНАЧЕ ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаПриобретения
	|					КОНЕЦ
	|			КОГДА КодыОперацийРаздела7ДекларацииПоНДС.ОперацияНеПодлежитНалогообложению
	|				ТОГДА ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаПриобретения
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СуммаПриобретения,
	|	СУММА(ВЫБОР
	|			КОГДА &ПравилаЗаполненияДекларацииС4кв2020
	|				ТОГДА ВЫБОР
	|						КОГДА ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации В (&КодыРеализацийНеНаТерриторииРФ)
	|							ТОГДА 0
	|						ИНАЧЕ ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.НДСПрямой + ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.НДСРаспределенный
	|					КОНЕЦ
	|			КОГДА КодыОперацийРаздела7ДекларацииПоНДС.ОперацияНеПодлежитНалогообложению
	|				ТОГДА ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.НДСПрямой + ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.НДСРаспределенный
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СуммаНДС,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата КАК Период,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Ссылка КАК Регистратор,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Организация КАК Организация
	|ИЗ
	|	Документ.ФормированиеЗаписейРаздела7ДекларацииНДС.НеоблагаемыеНДСОперации КАК ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КодыОперацийРаздела7ДекларацииПоНДС КАК КодыОперацийРаздела7ДекларацииПоНДС
	|		ПО ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации = КодыОперацийРаздела7ДекларацииПоНДС.Ссылка
	|ГДЕ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Ссылка,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Организация";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаНеоблагаемыеНДСОперации(НомераТаблиц)
	
	НомераТаблиц.Вставить("НеоблагаемыеОперацииОстаткиПредварительная", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("НеоблагаемыеОперацииОстатки",     НомераТаблиц.Количество());
	НомераТаблиц.Вставить("НеоблагаемыеОперацииПоДокументу", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ТаблицаНеоблагаемыеОперации",     НомераТаблиц.Количество());
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	НДСНеоблагаемыеОперацииОстатки.Организация КАК Организация,
	|	НДСНеоблагаемыеОперацииОстатки.КодОперации КАК КодОперации,
	|	НДСНеоблагаемыеОперацииОстатки.Контрагент КАК Контрагент,
	|	НДСНеоблагаемыеОперацииОстатки.ДокументРеализации КАК ДокументРеализации,
	|	СУММА(НДСНеоблагаемыеОперацииОстатки.СуммаРеализацииБезНДСОстаток) КАК СуммаРеализации,
	|	СУММА(НДСНеоблагаемыеОперацииОстатки.СуммаПриобретенияБезНДСОстаток) КАК СуммаПриобретения,
	|	СУММА(НДСНеоблагаемыеОперацииОстатки.СуммаНДСНеПодлежащаяВычетуОстаток) КАК СуммаНДС
	|ПОМЕСТИТЬ НеоблагаемыеОперацииОстаткиПредварительная
	|ИЗ
	|	РегистрНакопления.НДСНеоблагаемыеОперации.Остатки(&ДатаГраница, Организация = &Организация) КАК НДСНеоблагаемыеОперацииОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	НДСНеоблагаемыеОперацииОстатки.Контрагент,
	|	НДСНеоблагаемыеОперацииОстатки.КодОперации,
	|	НДСНеоблагаемыеОперацииОстатки.Организация,
	|	НДСНеоблагаемыеОперацииОстатки.ДокументРеализации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НДСНеоблагаемыеОперации.Организация,
	|	НДСНеоблагаемыеОперации.КодОперации,
	|	НДСНеоблагаемыеОперации.Контрагент,
	|	НДСНеоблагаемыеОперации.ДокументРеализации,
	|	НДСНеоблагаемыеОперации.СуммаРеализацииБезНДС,
	|	НДСНеоблагаемыеОперации.СуммаПриобретенияБезНДС,
	|	НДСНеоблагаемыеОперации.СуммаНДСНеПодлежащаяВычету
	|ИЗ
	|	РегистрНакопления.НДСНеоблагаемыеОперации КАК НДСНеоблагаемыеОперации
	|ГДЕ
	|	НДСНеоблагаемыеОперации.Регистратор = &Ссылка
	|	И НДСНеоблагаемыеОперации.Активность
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Контрагент,
	|	ДокументРеализации,
	|	КодОперации,
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НеоблагаемыеОперацииОстаткиПредварительная.Организация,
	|	НеоблагаемыеОперацииОстаткиПредварительная.КодОперации,
	|	НеоблагаемыеОперацииОстаткиПредварительная.Контрагент,
	|	НеоблагаемыеОперацииОстаткиПредварительная.ДокументРеализации,
	|	СУММА(НеоблагаемыеОперацииОстаткиПредварительная.СуммаРеализации) КАК СуммаРеализации,
	|	СУММА(НеоблагаемыеОперацииОстаткиПредварительная.СуммаПриобретения) КАК СуммаПриобретения,
	|	СУММА(НеоблагаемыеОперацииОстаткиПредварительная.СуммаНДС) КАК СуммаНДС
	|ПОМЕСТИТЬ НеоблагаемыеОперацииОстатки
	|ИЗ
	|	НеоблагаемыеОперацииОстаткиПредварительная КАК НеоблагаемыеОперацииОстаткиПредварительная
	|ГДЕ
	|	(НеоблагаемыеОперацииОстаткиПредварительная.СуммаРеализации > 0
	|			ИЛИ НеоблагаемыеОперацииОстаткиПредварительная.СуммаПриобретения > 0
	|			ИЛИ НеоблагаемыеОперацииОстаткиПредварительная.СуммаНДС > 0)
	|
	|СГРУППИРОВАТЬ ПО
	|	НеоблагаемыеОперацииОстаткиПредварительная.ДокументРеализации,
	|	НеоблагаемыеОперацииОстаткиПредварительная.Организация,
	|	НеоблагаемыеОперацииОстаткиПредварительная.КодОперации,
	|	НеоблагаемыеОперацииОстаткиПредварительная.Контрагент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Организация КАК Организация,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Контрагент КАК Контрагент,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.ДокументРеализации КАК ДокументРеализации,
	|	СУММА(ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаРеализации) КАК СуммаРеализации,
	|	СУММА(ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.СуммаПриобретения) КАК СуммаПриобретения,
	|	СУММА(ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.НДСПрямой) КАК НДС,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации КАК КодОперации,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата КАК Период,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Ссылка КАК Регистратор
	|ПОМЕСТИТЬ НеоблагаемыеОперацииПоДокументу
	|ИЗ
	|	Документ.ФормированиеЗаписейРаздела7ДекларацииНДС.НеоблагаемыеНДСОперации КАК ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации
	|ГДЕ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.ДокументРеализации,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Контрагент,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Организация,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.КодОперации,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Организация,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),
	|	НЕОПРЕДЕЛЕНО,
	|	0,
	|	0,
	|	СУММА(ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.НДСРаспределенный),
	|	ЗНАЧЕНИЕ(Справочник.КодыОперацийРаздела7ДекларацииПоНДС.ПустаяСсылка),
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Ссылка
	|ИЗ
	|	Документ.ФормированиеЗаписейРаздела7ДекларацииНДС.НеоблагаемыеНДСОперации КАК ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации
	|ГДЕ
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Организация,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Дата,
	|	ФормированиеЗаписейРаздела7ДекларацииНДСНеоблагаемыеНДСОперации.Ссылка.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Контрагент,
	|	ДокументРеализации,
	|	КодОперации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НеоблагаемыеОперацииОстатки.Организация,
	|	НеоблагаемыеОперацииОстатки.КодОперации,
	|	НеоблагаемыеОперацииОстатки.Контрагент,
	|	НеоблагаемыеОперацииОстатки.ДокументРеализации,
	|	СУММА(ВЫБОР
	|			КОГДА НеоблагаемыеОперацииПоДокументу.СуммаРеализации > НеоблагаемыеОперацииОстатки.СуммаРеализации
	|				ТОГДА НеоблагаемыеОперацииОстатки.СуммаРеализации
	|			ИНАЧЕ НеоблагаемыеОперацииПоДокументу.СуммаРеализации
	|		КОНЕЦ) КАК СуммаРеализацииБезНДС,
	|	СУММА(ВЫБОР
	|			КОГДА НеоблагаемыеОперацииПоДокументу.СуммаПриобретения > НеоблагаемыеОперацииОстатки.СуммаПриобретения
	|				ТОГДА НеоблагаемыеОперацииОстатки.СуммаПриобретения
	|			ИНАЧЕ НеоблагаемыеОперацииПоДокументу.СуммаПриобретения
	|		КОНЕЦ) КАК СуммаПриобретенияБезНДС,
	|	СУММА(ВЫБОР
	|			КОГДА НеоблагаемыеОперацииПоДокументу.НДС > НеоблагаемыеОперацииОстатки.СуммаНДС
	|				ТОГДА НеоблагаемыеОперацииОстатки.СуммаНДС
	|			ИНАЧЕ НеоблагаемыеОперацииПоДокументу.НДС
	|		КОНЕЦ) КАК СуммаНДСНеПодлежащаяВычету,
	|	НеоблагаемыеОперацииПоДокументу.Период,
	|	НеоблагаемыеОперацииПоДокументу.Регистратор
	|ИЗ
	|	НеоблагаемыеОперацииОстатки КАК НеоблагаемыеОперацииОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НеоблагаемыеОперацииПоДокументу КАК НеоблагаемыеОперацииПоДокументу
	|		ПО НеоблагаемыеОперацииОстатки.Организация = НеоблагаемыеОперацииПоДокументу.Организация
	|			И НеоблагаемыеОперацииОстатки.КодОперации = НеоблагаемыеОперацииПоДокументу.КодОперации
	|			И НеоблагаемыеОперацииОстатки.Контрагент = НеоблагаемыеОперацииПоДокументу.Контрагент
	|			И НеоблагаемыеОперацииОстатки.ДокументРеализации = НеоблагаемыеОперацииПоДокументу.ДокументРеализации
	|
	|СГРУППИРОВАТЬ ПО
	|	НеоблагаемыеОперацииОстатки.КодОперации,
	|	НеоблагаемыеОперацииОстатки.ДокументРеализации,
	|	НеоблагаемыеОперацииОстатки.Организация,
	|	НеоблагаемыеОперацииОстатки.Контрагент,
	|	НеоблагаемыеОперацииПоДокументу.Период,
	|	НеоблагаемыеОперацииПоДокументу.Регистратор";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

#КонецОбласти

#Область ПроведениеДокументаФормированияРаздела7

// Формирование записей раздела 7 Декларации НДС
Процедура СформироватьДвиженияРаздела7ДекларацииНДС(ТаблицаДвижений, Движения, Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(ТаблицаДвижений) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыНДСЗаписиРаздела7Декларации(ТаблицаДвижений);
	
	Для Каждого СтрокаТаблицы Из Параметры.ТаблицаНДСЗаписиРаздела7Декларации Цикл
		Запись = Движения.НДСЗаписиРаздела7Декларации.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, СтрокаТаблицы);
	КонецЦикла;
	
	Движения.НДСЗаписиРаздела7Декларации.Записывать = Истина;
	
КонецПроцедуры

Функция ПодготовитьПараметрыНДСЗаписиРаздела7Декларации(ТаблицаДвижений)
	
	Параметры = Новый Структура;
	
	СписокОбязательныхКолонок = ""
	+ "Период,"            // <Дата> - период движений - дата документа
	+ "Регистратор,"       // <ДокументСсылка.ФормированиеЗаписейРаздела7ДекларацииНДС> - документ-регистратор движений
	+ "Организация,"       // <СправочникСсылка.Организации> - организация
	+ "КодОперации,"       // <СправочникСсылка.КодыОперацийРаздела7ДекларацииПоНДС> - код операции для раздела 7 Декларации 
	+ "СуммаРеализации,"   // <Число> 
	+ "СуммаПриобретения," // <Число>
	+ "СуммаНДС";          // <Число>
	
	Параметры.Вставить("ТаблицаНДСЗаписиРаздела7Декларации", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
			ТаблицаДвижений, СписокОбязательныхКолонок));
			
	Возврат Параметры;
	
КонецФункции

Процедура СформироватьДвиженияСписаниеНеоблагаемыхНДСОпераций(ТаблицаНеоблагаемыеОперации, Движения, Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(ТаблицаНеоблагаемыеОперации) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыСписаниеНеоблагаемыхОпераций(ТаблицаНеоблагаемыеОперации);
	
	Для Каждого СтрокаТаблицы Из Параметры.ТаблицаНеоблагаемыеОперации Цикл
		Запись = Движения.НДСНеоблагаемыеОперации.ДобавитьРасход();
		ЗаполнитьЗначенияСвойств(Запись, СтрокаТаблицы);
	КонецЦикла;
	
	Движения.НДСНеоблагаемыеОперации.Записывать = Истина;
	
КонецПроцедуры

Функция ПодготовитьПараметрыСписаниеНеоблагаемыхОпераций(ТаблицаНеоблагаемыеОперации)
	
	Параметры = Новый Структура;
	
	СписокОбязательныхКолонок = ""
	+ "Период,"                     // <Дата> - период движений - дата документа
	+ "Регистратор,"                // <ДокументСсылка.ФормированиеЗаписейРаздела7ДекларацииНДС> - документ-регистратор движений
	+ "Организация,"                // <СправочникСсылка.Организации> - организация
	+ "КодОперации,"                // <СправочникСсылка.КодыОперацийРаздела7ДекларацииПоНДС> - код операции для раздела 7 Декларации
	+ "Контрагент,"                 // <СправочникСсылка.Контрагенты>
	+ "ДокументРеализации,"         // <ДокументСсылка...>  - документ-регистратор необлагаемой НДС операции
	+ "СуммаРеализацииБезНДС,"      // <Число>
	+ "СуммаПриобретенияБезНДС,"    // <Число>
	+ "СуммаНДСНеПодлежащаяВычету"; // <Число>
	
	Параметры.Вставить("ТаблицаНеоблагаемыеОперации", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
			ТаблицаНеоблагаемыеОперации, СписокОбязательныхКолонок));
			
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#КонецОбласти

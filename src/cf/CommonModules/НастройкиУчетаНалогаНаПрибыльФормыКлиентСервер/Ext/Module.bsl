﻿
////////////////////////////////////////////////////////////////////////////////
// Универсальные методы для формы записи регистра и формы настройки налогов
//
// Клиент-серверные методы формы записи регистра сведений НастройкиУчетаНалогаНаПрибыль
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура УправлениеФормой(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Запись   = Форма.НастройкиУчетаНалогаНаПрибыль;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"СтавкиНалогаНаПрибыльВБюджетСубъектовРФ",
		"Доступность",
		Запись.ПрименяютсяРазныеСтавкиНалогаНаПрибыль);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"БазаРаспределенияКосвенныхРасходовПоВидамДеятельности",
		"Видимость",
		Форма.ПлательщикЕНВД);
		
	Форма.ПорядокПодачиДекларации = ?(Запись.УплачиватьНалогПоГруппамОбособленныхПодразделений, 1, 0);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"НалоговыеОрганыГруппОбособленныхПодразделений",
		"Доступность",
		Запись.УплачиватьНалогПоГруппамОбособленныхПодразделений);
		
	Форма.ВариантНастройкиПрямыхРасходов = Запись.ФормироватьСтоимостьПоПравиламБУ;
	
	УстановитьЗаголовокПереченьПрямыхЗатрат(Форма);
	
	Форма.Элементы.ПереченьПрямыхРасходов.Доступность = Не Запись.ФормироватьСтоимостьПоПравиламБУ;
	Форма.Элементы.ДекорацияЗаголовокСпособФормирования.Доступность = (Запись.Организация = Форма.ГоловнаяОрганизация);
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ВариантУчетаКурсовыхРазниц2022") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ОтложитьОтрицательныеКурсовыеРазницы2022",
			"Видимость",
			Форма.ВариантУчетаКурсовыхРазниц2022 = "Независимо");
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьЗаголовокПереченьПрямыхЗатрат(Форма) Экспорт
	
	Запись = Форма.НастройкиУчетаНалогаНаПрибыль;
	
	Форма.Элементы.ПереченьПрямыхРасходов.Заголовок =
	НастройкиУчетаНалогаНаПрибыльФормыВызовСервера.ЗаголовокПереченьПрямыхЗатрат(Запись.Организация, Запись.Период);

КонецПроцедуры

#КонецОбласти
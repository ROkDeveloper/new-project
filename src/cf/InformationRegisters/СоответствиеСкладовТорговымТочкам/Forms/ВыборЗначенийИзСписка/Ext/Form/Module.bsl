﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ПоказыватьОрганизации", ПоказыватьОрганизации);
	ВходящиеПараметры = Новый Структура("ЗаголовокФормыВыбора, ИмяТаблицыВыбора, МассивВыбранныхЗначений");
	ЗаполнитьЗначенияСвойств(ВходящиеПараметры, Параметры);
	
	Заголовок = ВходящиеПараметры.ЗаголовокФормыВыбора;
	
	ЗаполнитьСписокЗначенийДляВыбора(ВходящиеПараметры.ИмяТаблицыВыбора, ВходящиеПараметры.МассивВыбранныхЗначений);
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если НЕ ТолькоПросмотр И Поле.Имя <> Элементы.СписокПометка.Имя Тогда
		
		ВыбранноеЗначение = Список.НайтиПоИдентификатору(ВыбраннаяСтрока).Значение;
		ОповеститьОВыборе(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранноеЗначение));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьОтмеченные(Команда)
	
	ОтмеченныеЭлементы = ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(Список);
	ОповеститьОВыборе(ОтмеченныеЭлементы);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого СтрокаСписка Из Список Цикл
		ПоменятьПометку(СтрокаСписка, Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого СтрокаСписка Из Список Цикл
		ПоменятьПометку(СтрокаСписка, Ложь);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
	ВидимостьКолонкиОрганизация = ПоказыватьОрганизации
		И ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийБухгалтерскийУчет");
	
	Элементы.СписокОрганизация.Видимость = ВидимостьКолонкиОрганизация;
	
	Элементы.Список.Шапка = ВидимостьКолонкиОрганизация;
	
	Элементы.СписокВыбратьОтмеченные.Видимость = НЕ ТолькоПросмотр;
	Элементы.СписокУстановитьФлажки.Видимость  = НЕ ТолькоПросмотр;
	Элементы.СписокСнятьФлажки.Видимость       = НЕ ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоменятьПометку(СтрокаСписка, ЗначениеПометки)
	
	СтрокаСписка.Пометка = ЗначениеПометки;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЗначенийДляВыбора(ИмяТаблицыВыбора, ВыбранныеЗначения)
	
	ТаблицаЗначений = Неопределено;
	Если ИмяТаблицыВыбора = "Справочник.ТорговыеТочки" Тогда
		ТаблицаЗначений = ТаблицаВыбораТорговыхТочек(ВыбранныеЗначения);
	ИначеЕсли ИмяТаблицыВыбора = "Справочник.Склады" Тогда
		ТаблицаЗначений = ТаблицаВыбораСкладов(ВыбранныеЗначения);
	КонецЕсли;
	
	Если ТаблицаЗначений = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Список.Загрузить(ТаблицаЗначений);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТаблицаВыбораТорговыхТочек(ВыбранныеЗначения)
	
	// При выборе торговых точек пользователь должен видеть только те торговые точки,
	// которые принадлежат доступным ему организациям.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА ТорговыеТочки.Ссылка В (&ВыбранныеЗначения)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Пометка,
	|	ТорговыеТочки.Представление,
	|	ТорговыеТочки.Ссылка КАК Значение,
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.ТорговыеТочки КАК ТорговыеТочки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО Организации.Ссылка = ТорговыеТочки.Организация
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организации.Наименование,
	|	ТорговыеТочки.Наименование";
	
	Запрос.УстановитьПараметр("ВыбранныеЗначения", ВыбранныеЗначения);
	
	ТаблицаТорговыеТочки = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаТорговыеТочки;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТаблицаВыбораСкладов(ВыбранныеЗначения)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Склады.Ссылка В (&ВыбранныеЗначения)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Пометка,
	|	Склады.Представление,
	|	Склады.Ссылка КАК Значение
	|ИЗ
	|	Справочник.Склады КАК Склады
	|
	|УПОРЯДОЧИТЬ ПО
	|	Склады.Наименование";
	
	Запрос.УстановитьПараметр("ВыбранныеЗначения", ВыбранныеЗначения);
	
	ТаблицаСклады = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаСклады;
	
КонецФункции

#КонецОбласти

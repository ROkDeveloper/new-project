﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокВыбораСправочников();
	
	УстановитьЗначенияПоУмолчанию();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипСправочникаПриИзменении(Элемент)
	
	УстановитьСтраницуВводаДанныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	ЭтоУслуга = ЭтоУслуга(ВидНоменклатуры);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ЗначенияРеквизитов = Новый Структура;
	ЗначенияРеквизитов.Вставить("ТипСправочника", ТипСправочника());
	
	Если Справочник = ЗначениеНоменклатура() Тогда
		ДополнитьЗначениямиРеквизитовНоменклатуры(ЗначенияРеквизитов);
	ИначеЕсли Справочник = ЗначениеОсновныеСредства() Тогда
		ДополнитьЗначениямиРеквизитовОсновныхСредств(ЗначенияРеквизитов);
	ИначеЕсли Справочник = ЗначениеОбъектыСтроительства() Тогда
		ДополнитьЗначениямиРеквизитовОбъектовСтроительства(ЗначенияРеквизитов);
	КонецЕсли;
	
	Закрыть(ЗначенияРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораСправочников()
	
	СписокВыбора = Элементы.Справочник.СписокВыбора;
	
	СписокВыбора.Добавить(ЗначениеНоменклатура(), "Номенклатура");
	
	ЕстьОС                   = Истина;
	ЕстьОбъектыСтроительства = Истина;
		
	Если Параметры.Свойство("ТипыНоменклатуры") Тогда
		ЕстьОС = ЕстьОС 
			И Параметры.ТипыНоменклатуры.СодержитТип(Тип("СправочникСсылка.ОсновныеСредства"));
		ЕстьОбъектыСтроительства = ЕстьОбъектыСтроительства 
			И Параметры.ТипыНоменклатуры.СодержитТип(Тип("СправочникСсылка.ОбъектыСтроительства"));
	КонецЕсли;
	
	Если ЕстьОС Тогда
		СписокВыбора.Добавить(ЗначениеОсновныеСредства(), "Основные средства");
	КонецЕсли;
	Если ЕстьОбъектыСтроительства Тогда
		СписокВыбора.Добавить(ЗначениеОбъектыСтроительства(), "Объекты строительства");
	КонецЕсли;
	
	УстановитьСправочникПоУмолчанию();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()
	
	ВидНоменклатуры = Справочники.ВидыНоменклатуры.НайтиСоздатьЭлементыТовар();
	
	ЭтоУслуга = ЭтоУслуга(ВидНоменклатуры);
	
	ЕдиницаИзмеренияПоУмолчанию = Справочники.КлассификаторЕдиницИзмерения.ПолучитьЕдиницуИзмеренияПоУмолчанию();
	
	СтавкаНДСПоУмолчанию = УчетНДСКлиентСервер.СтавкаНДСПоУмолчанию(ТекущаяДатаСеанса());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСправочникПоУмолчанию()
	
	Справочник = ЗначениеНоменклатура();
	
	УстановитьСтраницуВводаДанныхРеквизитов(ЭтотОбъект);
	
	Если Элементы.Справочник.СписокВыбора.Количество() = 1 Тогда
		Элементы.Справочник.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСтраницуВводаДанныхРеквизитов(Форма)
	
	Элементы = Форма.Элементы;
	Справочник = Форма.Справочник;
	
	Если Справочник = ЗначениеНоменклатура() Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаНоменклатуры;
	ИначеЕсли Справочник = ЗначениеОсновныеСредства() Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаОсновнхыСредств;
	ИначеЕсли Справочник = ЗначениеОбъектыСтроительства() Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаОбъектыСтроительства;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьЗначениямиРеквизитовНоменклатуры(ЗначенияРеквизитов)
	
	ЗначенияРеквизитов.Вставить("ВидНоменклатуры"            , ВидНоменклатуры);
	ЗначенияРеквизитов.Вставить("ЭтоУслуга"                  , ЭтоУслуга);
	ЗначенияРеквизитов.Вставить("СтавкаНДСПоУмолчанию"       , СтавкаНДСПоУмолчанию);
	ЗначенияРеквизитов.Вставить("ЕдиницаИзмеренияПоУмолчанию", ЕдиницаИзмеренияПоУмолчанию);
	ЗначенияРеквизитов.Вставить("Родитель"                   , РодительНоменклатуры);
	ЗначенияРеквизитов.Вставить("НоменклатурнаяГруппа"       , НоменклатурнаяГруппа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьЗначениямиРеквизитовОсновныхСредств(ЗначенияРеквизитов)
	
	ЗначенияРеквизитов.Вставить("ГруппаОС", ГруппаОС);
	ЗначенияРеквизитов.Вставить("Родитель", РодительОС);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьЗначениямиРеквизитовОбъектовСтроительства(ЗначенияРеквизитов)
	
	ЗначенияРеквизитов.Вставить("Родитель", РодительОбъектыСтроительства);
	
КонецПроцедуры

&НаКлиенте
Функция ТипСправочника()
	
	Результат = Неопределено;
	
	Если Справочник = ЗначениеНоменклатура() Тогда
		Результат = Тип("СправочникСсылка.Номенклатура");
	ИначеЕсли Справочник = ЗначениеОсновныеСредства() Тогда
		Результат = Тип("СправочникСсылка.ОсновныеСредства");
	ИначеЕсли Справочник = ЗначениеОбъектыСтроительства() Тогда
		Результат = Тип("СправочникСсылка.ОбъектыСтроительства");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеНоменклатура()
	
	Возврат "Номенклатура";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеОсновныеСредства()
	
	Возврат "ОсновныеСредства";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеОбъектыСтроительства()
	
	Возврат "ОбъектыСтроительства";
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоУслуга(ВидНоменклатуры)
	
	Если Не ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидНоменклатуры, "Услуга");
	
КонецФункции

#КонецОбласти

﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	КодРегионаРегистрации = Формат(Запись.КодРегиона, "ЧЦ=2; ЧН=; ЧВН=");
	НастройкиУчетаНалогаНаПрибыльФормы.ЗаполнитьСписокВыбораРегиона(Элементы.КодРегионаРегистрации.СписокВыбора, Истина);
		
	ДатаИзмененияСтрокой = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		НачалоМесяца(Запись.Период),
		КонецМесяца(Запись.Период),
		Истина);	
				
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыОповещения = Новый Структура("Организация, КодРегиона, Период");
	ЗаполнитьЗначенияСвойств(ПараметрыОповещения, Запись);
	
	//оповестим форму настройки налоговых органов по регионам
	Оповестить("Запись_НастройкиНалогаНаПрибыльГруппыОбособленныхПодразделений", ПараметрыОповещения);
		
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(КодРегионаРегистрации) ИЛИ КодРегионаРегистрации = "00" Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", "Регион");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КодРегионаРегистрации", , Отказ);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДатаИзмененияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ДатаИзмененияСтрокойЗавершениеВыбора", ЭтотОбъект);
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("НачалоПериода", НачалоМесяца(Запись.Период));
	ПараметрыВыбора.Вставить("КонецПериода",  КонецМесяца(Запись.Период));
	ПараметрыВыбора.Вставить("ВидПериода",    ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц"));
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбора, ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИзмененияСтрокойОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КодРегионаПриИзменении(Элемент)
	
	Запись.КодРегиона = КодРегионаРегистрации;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДатаИзмененияСтрокойЗавершениеВыбора(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ДатаИзмененияСтрокой = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		НачалоМесяца(РезультатВыбора.НачалоПериода),
		КонецМесяца(РезультатВыбора.НачалоПериода),
		Истина);
		
	Запись.Период = РезультатВыбора.НачалоПериода;
	
КонецПроцедуры

#КонецОбласти
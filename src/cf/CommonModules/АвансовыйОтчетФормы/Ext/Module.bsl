﻿
#Область ОбработчикиСобытийФормы

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Форма.Объект, Форма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(Форма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(Форма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
				
КонецПроцедуры

Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(Форма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЗаголовокФормы(Форма) Экспорт
	
	Объект = Форма.Объект;

	ТекстЗаголовка = НСтр("ru = 'Авансовый отчет'");
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийАвансовыйОтчет.Командировка Тогда
		ТекстЗаголовка = ТекстЗаголовка + НСтр("ru = ' по командировке'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстЗаголовка = ТекстЗаголовка + СтрШаблон(
			НСтр("ru=' %1 от %2'"), Объект.Номер, Объект.Дата);
	Иначе
		ТекстЗаголовка = ТекстЗаголовка + НСтр("ru = ' (создание)'");
	КонецЕсли;
	
	Форма.Заголовок = ТекстЗаголовка;

КонецПроцедуры

#КонецОбласти

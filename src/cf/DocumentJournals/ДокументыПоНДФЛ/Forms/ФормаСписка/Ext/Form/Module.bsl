﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьОтборыПриСозданииНаСервере(Параметры);
	
	СтруктураПараметровОтбора = Новый Структура();
	ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "ФизическоеЛицо",
		Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"), НСтр("ru = 'Сотрудник'"));
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,
		СтруктураПараметровОтбора, "СписокКритерииОтбора", "Организация", Ложь);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Элементы.КоманднаяПанельФормы);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Список);
	// Конец КадровыйЭДО
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"БП.ЖурналДокументов.ДокументыПоНДФЛ",
		"ФормаСписка",
		НСтр("ru = 'Новости: Документы по НДФЛ'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
	ПомеченныеНаУдалениеСервер.СкрытьПомеченныеНаУдаление(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// КадровыйЭДО
	КадровыйЭДОКлиент.ОбработкаОповещенияВФормеСписка(
		ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец КадровыйЭДО
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОсновнаяОрганизация = Параметр;
		Если ОсновнаяОрганизация <> ОтборОрганизация Тогда
			ОтборОрганизация                 = ОсновнаяОрганизация;
			ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
			УстановитьВосстановленныеОтборы();
		КонецЕсли;
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СтруктураОтбора = Неопределено;
	Если Параметры.Свойство("Отбор", СтруктураОтбора) И ЗначениеЗаполнено(СтруктураОтбора) Тогда
		
		Если СтруктураОтбора.Свойство("Организация") И ЗначениеЗаполнено(СтруктураОтбора.Организация) Тогда
			ОтборОрганизация = СтруктураОтбора.Организация;
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
			Параметры.Отбор.Удалить("Организация");
		КонецЕсли;
	Иначе
		Если ОтборОрганизация <> ОсновнаяОрганизация Тогда
			ОтборОрганизация = ОсновнаяОрганизация;
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		ИначеЕсли НЕ ОтборОрганизацияИспользование Тогда
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьВосстановленныеОтборы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПараметрОтбораПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ПараметрОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Параметр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, Параметр, "", "Сотрудник");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыОткрытия.ЗначенияЗаполнения);
	
	Отказ = Истина;
	ОткрытьФорму(ПараметрыОткрытия.ОписаниеФормы, ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
	ОтборыСписков.СброситьИспользованиеПользовательскихОтборовВНастройке(Настройки);
	
	ПомеченныеНаУдалениеСервер.УдалитьОтборПометкаУдаления(Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// КадровыйЭДО
	КадровыйЭДО.СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ПомеченныеНаУдалениеКлиент.ПриИзмененииСписка(ЭтотОбъект, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// БлокировкаИзмененияОбъектов

&НаКлиенте
Процедура Подключаемый_РазблокироватьОбъекты(Команда)
	БлокировкаИзмененияОбъектовКлиент.РазблокироватьОбъектыСписка(ЭтотОбъект, Список, Элементы.Список.ВыделенныеСтроки);
КонецПроцедуры

// Конец БлокировкаИзмененияОбъектов

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтотОбъект,
		Команда
	);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеФункцииИПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыПриСозданииНаСервере(Параметры)
	
	ВходящийОтборПоОрганизации = Ложь;
	СтруктураОтбора = Неопределено;
	Если Параметры.Свойство("Отбор", СтруктураОтбора) И ТипЗнч(СтруктураОтбора) = Тип("Структура") Тогда
		ВходящийОтборПоОрганизации = СтруктураОтбора.Свойство("Организация", ОтборОрганизация);
		ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
		ЗаполнитьОтборПриОткрытииИзПараметров(Параметры.Отбор);
	КонецЕсли;
	
	ОсновнаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
	Если НЕ ВходящийОтборПоОрганизации И ОтборОрганизация <> ОсновнаяОрганизация Тогда
		ОтборОрганизация                 = ОсновнаяОрганизация;
		ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
	КонецЕсли;
	
	УстановитьВосстановленныеОтборы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтборПриОткрытииИзПараметров(Отбор)
	
	// Нужно переложить отборы из параметров в отдельную структуру,
	// которую потом будем использовать в ПриЗагрузкеДанныхИзНастроекНаСервере
	// Так как мы устанавливаем отбор самостоятельно, то нужно очистить те поля
	// структуры "Параметры.Отбор", для которых установлен отбор из кода.
	// Если не очистить поля - то будет вызвана ошибка пересечения отборов.
	
	ОтборыПриОткрытии = Новый Структура;
	
	Если Отбор.Свойство("Организация")
		И ЗначениеЗаполнено(Отбор.Организация) Тогда
		
		ОтборыПриОткрытии.Вставить("Организация", Отбор.Организация);
		Отбор.Удалить("Организация");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВосстановленныеОтборы()
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
КонецПроцедуры

&НаСервере
Процедура ОтборОрганизацияПриИзмененииСервер()
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	УстановитьВосстановленныеОтборы();
	
КонецПроцедуры

#КонецОбласти
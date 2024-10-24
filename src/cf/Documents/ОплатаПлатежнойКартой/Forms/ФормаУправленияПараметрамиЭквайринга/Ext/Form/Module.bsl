﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Эквайер           = Параметры.Эквайер;
	ДоговорЭквайринга = Параметры.ДоговорЭквайринга;
	СчетРасчетов      = Параметры.СчетРасчетов;
	Организация       = Параметры.Организация;
	
	ЭтаФорма.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ВестиУчетПоДоговорам = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоговорЭквайрингаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗначенияЗаполнения = Новый Структура;
	ВидыДоговора = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"));

	ЗначенияЗаполнения.Вставить("Организация", Организация);
	ЗначенияЗаполнения.Вставить("Владелец",    Эквайер);
	ЗначенияЗаполнения.Вставить("ВидДоговора", Новый ФиксированныйМассив(ВидыДоговора));
	ЗначенияЗаполнения.Вставить("ВалютаВзаиморасчетов", ВалютаРегламентированногоУчета);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ДоговорЭквайринга);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ДоговорЭквайрингаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВидыДоговора = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"));
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Организация", Организация);
	СтруктураОтбора.Вставить("Владелец",    Эквайер);
	СтруктураОтбора.Вставить("ВидДоговора", Новый ФиксированныйМассив(ВидыДоговора));
	СтруктураОтбора.Вставить("ВалютаВзаиморасчетов", ВалютаРегламентированногоУчета);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаВыбора", ПараметрыФормы, Элемент);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Принять(Команда)
	
	ПараметрыВозврата = Новый Структура;
	
	Если НЕ ВестиУчетПоДоговорам И НЕ ЗначениеЗаполнено(ДоговорЭквайринга) Тогда
		ДоговорЭквайринга = НайтиСоздатьДоговорЭквайринга(Организация, Эквайер);
	КонецЕсли;
	
	ПараметрыВозврата.Вставить("Эквайер", Эквайер);
	ПараметрыВозврата.Вставить("ДоговорЭквайринга", ДоговорЭквайринга);
	ПараметрыВозврата.Вставить("СчетКасса", СчетРасчетов);
	ПараметрыВозврата.Вставить("Модифицированность", Модифицированность);
	
	ЭтаФорма.Закрыть(ПараметрыВозврата);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиСоздатьДоговорЭквайринга(Знач Организация, Знач Эквайер)
	
	ПараметрыДоговора = Новый Структура;
	ПараметрыДоговора.Вставить("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.Прочее);
	ПараметрыДоговора.Вставить("Организация", Организация);
	ПараметрыДоговора.Вставить("Владелец",    Эквайер);
	
	ДоговорЭквайринга = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
		ДоговорЭквайринга, 
		ПараметрыДоговора.Владелец, 
		ПараметрыДоговора.Организация, 
		ПараметрыДоговора.ВидДоговора);
	
	Если НЕ ЗначениеЗаполнено(ДоговорЭквайринга) Тогда
		ПараметрыСоздания = Новый Структура("ЗначенияЗаполнения", ПараметрыДоговора);
		ДоговорЭквайринга = РаботаСДоговорамиКонтрагентовБПВызовСервера.СоздатьОсновнойДоговорКонтрагента(ПараметрыСоздания);
	КонецЕсли;
	
	Возврат ДоговорЭквайринга;
	
КонецФункции

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
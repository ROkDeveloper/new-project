﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПомеченныеНаУдалениеСервер.СкрытьПомеченныеНаУдаление(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ПомеченныеНаУдалениеКлиент.ПриИзмененииСписка(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки, ИспользуютсяСтандартныеНастройки)
	
	ПомеченныеНаУдалениеСервер.УдалитьОтборПометкаУдаления(Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	
	Если Копирование Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	Для каждого ЭлементОтбора Из Список.Отбор.Элементы Цикл
		
		Если НЕ ЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			ЗначенияЗаполнения.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение);
		КонецЕсли;
		
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
			ЗначенияЗаполнения.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение[0].Значение);
		КонецЕсли;
		
	КонецЦикла;
	
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ВидСобытияОСДоступныеЗначения = ПолучитьДоступныеЗначенияВидСобытияОС();
	
	Если ВидСобытияОСДоступныеЗначения.Количество() > 0 Тогда
		ПараметрыФормы.Вставить("ВидСобытияОСДоступныеЗначения", ВидСобытияОСДоступныеЗначения)
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СобытияОС.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элемент.ТекущаяСтрока);
	
	ВидСобытияОСДоступныеЗначения = ПолучитьДоступныеЗначенияВидСобытияОС();
	
	Если ВидСобытияОСДоступныеЗначения.Количество() > 0 Тогда
		ПараметрыФормы.Вставить("ВидСобытияОСДоступныеЗначения", ВидСобытияОСДоступныеЗначения)
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СобытияОС.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьДоступныеЗначенияВидСобытияОС()
	
	ВидДоговораДоступныеЗначения = Новый Массив;
	
	Для каждого ЭлементОтбора Из Список.Отбор.Элементы Цикл
		
		Если НЕ ЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если Строка(ЭлементОтбора.ЛевоеЗначение) <> "ВидСобытияОС" Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			ВидДоговораДоступныеЗначения.Добавить(ЭлементОтбора.ПравоеЗначение);
		КонецЕсли;
		
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
			Для каждого ЭлементСпискаЗначений Из ЭлементОтбора.ПравоеЗначение Цикл
				ВидДоговораДоступныеЗначения.Добавить(ЭлементСпискаЗначений.Значение);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВидДоговораДоступныеЗначения;
	
КонецФункции

#КонецОбласти
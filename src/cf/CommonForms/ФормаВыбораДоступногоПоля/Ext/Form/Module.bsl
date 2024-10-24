﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Режим = Параметры.Режим;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Параметры.СхемаКомпоновкиДанных));
	НастройкиКомпоновщика = КомпоновщикНастроек.Настройки;
	
	Элементы.ГруппаДоступныеПоляВыбор.Видимость       = Ложь;
	Элементы.ГруппаДоступныеПоляГруппировка.Видимость = Ложь;
	Элементы.ГруппаДоступныеПоляОтбор.Видимость       = Ложь;
	Элементы.ГруппаДоступныеПоляПорядок.Видимость     = Ложь;
	
	Если Режим = "Группировка" Тогда
		
		Заголовок = НСтр("ru = 'Выбор поля группировки'");
		Элементы.ГруппаДоступныеПоляГруппировка.Видимость = Истина;
		ДоступныеПоляЭлементы = Элементы.ДоступныеПоляПолейГруппировок;
		ДоступныеПоляНастройки = НастройкиКомпоновщика.ДоступныеПоляГруппировок;
		
		ФиктивнаяСтрокаГруппировка = НастройкиКомпоновщика.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		Элементы.Настройки.ТекущаяСтрока = НастройкиКомпоновщика.ПолучитьИдентификаторПоОбъекту(ФиктивнаяСтрокаГруппировка);

	ИначеЕсли Режим = "Выбор" Тогда
		
		Заголовок = НСтр("ru = 'Выбор поля'");
		Элементы.ГруппаДоступныеПоляВыбор.Видимость = Истина;
		ДоступныеПоляЭлементы = Элементы.ДоступныеПоляВыбора;
		ДоступныеПоляНастройки = НастройкиКомпоновщика.ДоступныеПоляВыбора;
		
	ИначеЕсли Режим = "Отбор" Тогда	
		
		Заголовок = НСтр("ru = 'Выбор поля отбора'");
		Элементы.ГруппаДоступныеПоляОтбор.Видимость = Истина;
		ДоступныеПоляЭлементы = Элементы.ДоступныеПоляОтбора;
		ДоступныеПоляНастройки = НастройкиКомпоновщика.ДоступныеПоляОтбора;
		
	ИначеЕсли Режим = "Порядок" Тогда
		
		Заголовок = НСтр("ru = 'Выбор поля сортировки'");
		Элементы.ГруппаДоступныеПоляПорядок.Видимость = Истина;
		ДоступныеПоляЭлементы = Элементы.ДоступныеПоляПорядка;
		ДоступныеПоляНастройки = НастройкиКомпоновщика.ДоступныеПоляПорядка;
		
	Иначе
		ВызватьИсключение НСтр("ru = 'Неверный режим вызова формы'");
	КонецЕсли;
	
	Для Каждого Поле Из Параметры.ИсключенныеПоля Цикл
		
		Ограничение = ДоступныеПоляЭлементы.ОграниченияИспользования.Добавить();	
		Ограничение.Поле = Новый ПолеКомпоновкиДанных(Поле);
		Ограничение.Доступность = Ложь;

	КонецЦикла;
	
	Если Параметры.ТекущаяСтрока <> Неопределено Тогда
		
		ДоступноеПоле = ДоступныеПоляНастройки.НайтиПоле(Новый ПолеКомпоновкиДанных(Параметры.ТекущаяСтрока));
		Если ДоступноеПоле <> Неопределено Тогда
			
			Идентификатор = ДоступныеПоляНастройки.ПолучитьИдентификаторПоОбъекту(ДоступноеПоле);
			ДоступныеПоляЭлементы.ТекущаяСтрока = Идентификатор;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ТекущиеДанные = Неопределено;
	Если Режим = "Группировка" Тогда
		ТекущиеДанные = Элементы.ДоступныеПоляПолейГруппировок.ТекущаяСтрока;
		ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок.ПолучитьОбъектПоИдентификатору(ТекущиеДанные);
	ИначеЕсли Режим = "Выбор" Тогда
		ТекущиеДанные = Элементы.ДоступныеПоляВыбора.ТекущаяСтрока;
		ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.ПолучитьОбъектПоИдентификатору(ТекущиеДанные);
	ИначеЕсли Режим = "Отбор" Тогда
		ТекущиеДанные = Элементы.ДоступныеПоляОтбора.ТекущаяСтрока;
		ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.ПолучитьОбъектПоИдентификатору(ТекущиеДанные);
	ИначеЕсли Режим = "Порядок" Тогда
		ТекущиеДанные = Элементы.ДоступныеПоляПорядка.ТекущаяСтрока;
		ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(ТекущиеДанные);
	КонецЕсли;
	
	Если Не ДоступноеПоле.Папка Тогда
		ПараметрыВыбранногоПоля = Новый Структура;
		ПараметрыВыбранногоПоля.Вставить("Поле"     , Строка(ДоступноеПоле.Поле));
		ПараметрыВыбранногоПоля.Вставить("Заголовок", ДоступноеПоле.Заголовок);
		Если Режим = "Отбор" Тогда
			Если ДоступноеПоле.ДоступныеВидыСравнения.Количество() > 0 Тогда
				ПараметрыВыбранногоПоля.Вставить("ВидСравнения", ДоступноеПоле.ДоступныеВидыСравнения[0].Значение);
			Иначе
				ПараметрыВыбранногоПоля.Вставить("ВидСравнения", ВидСравненияКомпоновкиДанных.Равно);
			КонецЕсли;
		КонецЕсли;
		
		Закрыть(ПараметрыВыбранногоПоля);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПоляПолейГруппировокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КомандаОК(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПоляВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КомандаОК(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПоляПорядкаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КомандаОК(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПоляОтбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КомандаОК(Неопределено);
	
КонецПроцедуры

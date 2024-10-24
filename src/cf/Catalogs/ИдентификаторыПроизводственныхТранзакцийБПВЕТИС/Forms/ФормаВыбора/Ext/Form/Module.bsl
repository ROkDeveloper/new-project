﻿

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ДокументОснование"		, ДокументОснование);
	Параметры.Свойство("ХозяйствующийСубъект"	, ХозяйствующийСубъект);
	Параметры.Свойство("Предприятие"			, Предприятие);

	СписокСостояний = Новый Массив;
	СписокСостояний.Добавить("Активна");
	СписокСостояний.Добавить("Не активна");
	
	ЭлементОтбора 					= Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Состояние");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.РежимОтображения	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.ПравоеЗначение 	= СписокСостояний;
	
	ЭлементОтбора 					= Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("ХозяйствующийСубъект");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.РежимОтображения	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.ПравоеЗначение 	= ХозяйствующийСубъект;
	
	ЭлементОтбора 					= Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Предприятие");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.РежимОтображения	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.ПравоеЗначение 	= Предприятие;

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПараметрыЗаполнения = ПолучитьПараметрыЗаполнения();
	ОткрытьФорму("Справочник.ИдентификаторыПроизводственныхТранзакцийБПВЕТИС.Форма.ФормаЭлемента", ПараметрыЗаполнения, Элемент)
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыЗаполнения()
	
	Возврат Новый Структура("ДокументОснование, ХозяйствующийСубъект, Предприятие", ДокументОснование, ХозяйствующийСубъект, Предприятие);
	 	
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СозданаНоваяПроизводственнаяТранзакция" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

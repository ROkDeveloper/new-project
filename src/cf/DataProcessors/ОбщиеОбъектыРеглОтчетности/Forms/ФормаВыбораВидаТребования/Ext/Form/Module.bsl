﻿
&НаКлиенте
Перем ПараметрыВыбора;

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Параметры.Организация);
	ПараметрыФормы.Вставить("ДатаНачалаПериодаВида", Параметры.ДатаНачалаПериодаВида);
	ПараметрыФормы.Вставить("ДатаКонцаПериодаВида", Параметры.ДатаКонцаПериодаВида);
	
	ДеревоВсехИспользуемыхВидовТребований = ДеревоВсехИспользуемыхВидовТребований();
	
	ДеревоВсехИспользуемыхВидовТребованийПоПолучателям = ЗаполнитьДеревоВидовТребованийПоПолучателям(ДеревоВсехИспользуемыхВидовТребований);
	ДеревоВсехИспользуемыхВидовТребованийБезГруппировки = ЗаполнитьДеревоВидовТребованийБезГруппировки(ДеревоВсехИспользуемыхВидовТребований);
	
	ЗначениеВДанныеФормы(ДеревоВсехИспользуемыхВидовТребований, ДеревоВидовТребованийПоПолучателям);
	ЗначениеВДанныеФормы(ДеревоВсехИспользуемыхВидовТребований, ДеревоВидовТребованийБезГруппировки);
	
	ДеревоВидовТребованийГруппировка = 0;
	
	Если ДеревоВидовТребованийГруппировка = 0 Тогда      // группировка по получателям
		КопироватьДанныеФормы(ДеревоВидовТребованийПоПолучателям, ДеревоВидовТребований);
	ИначеЕсли ДеревоВидовТребованийГруппировка = 1 Тогда // без группировки
		КопироватьДанныеФормы(ДеревоВидовТребованийБезГруппировки, ДеревоВидовТребований);
	КонецЕсли;
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Организация", Параметры.Организация);
	
	Элементы.ГруппаВидыСписков.ТекущаяСтраница = Элементы["ГруппаДеревоВидовТребований"];
	
	УправлениеЭУДереваВидовТребований(Элементы, ДеревоВидовТребованийГруппировка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьВидыТребований();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВидыТребований()
	
	ТекДеревоВидовТребований = ОпределитьТекущееДерево();
	
	Если ТекДеревоВидовТребований.ТекущиеДанные <> Неопределено
		И НЕ ТекДеревоВидовТребований.ТекущиеДанные.НаименованиеВида = ТекДеревоВидовТребований.ТекущиеДанные.ТипПолучателя Тогда
		
		СписокВидовТребований = Новый СписокЗначений;
		СписокВидовТребований.Вставить(
			0, ТекДеревоВидовТребований.ТекущиеДанные.НаименованиеВида, ТекДеревоВидовТребований.ТекущиеДанные.НаименованиеВида);
		Закрыть(СписокВидовТребований);
	Иначе
		СписокВидовТребований = Новый Структура;
		СписокВидовТребований.Вставить("Корень", ТекДеревоВидовТребований.ТекущиеДанные.НаименованиеВида);
		ВидыТребований = ПолучитьДеревоВидовТребованийВыборНаСервере(ТекДеревоВидовТребований.ТекущиеДанные.НаименованиеВида);
		СписокВидовТребований.Вставить("ВидыТребований", ВидыТребований);
		Закрыть(СписокВидовТребований);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВидовТребованийГруппировкаПриИзменении(Элемент)
	
	Если ДеревоВидовТребованийГруппировка = 1 Тогда // группировка по получателям
		ЗаполнитьДеревоВидовТребованийИзДругогоДерева(ДеревоВидовТребованийПоПолучателям);
	ИначеЕсли ДеревоВидовТребованийГруппировка = 2 Тогда // без группировки
		ЗаполнитьДеревоВидовТребованийИзДругогоДерева(ДеревоВидовТребованийБезГруппировки);
	КонецЕсли;
	
	УправлениеЭУ();
	УправлениеЭУДереваВидовТребований(Элементы, ДеревоВидовТребованийГруппировка);
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВидовТребованийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьВидыТребований();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВидовТребованийПриАктивизацииСтроки(Элемент)
	
	Если ЭтаФорма.ТекущийЭлемент = Элементы.СтрокаПоиска Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеЭУ();
	УправлениеЭУДереваВидовТребований(Элементы, ДеревоВидовТребованийГруппировка);
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДеревоВидовТребованийВыборНаСервере(НаименованиеВида)
	
	Объект = РеквизитФормыВЗначение("ДеревоВидовТребований");
	
	КолСтрок = Объект.Строки.Количество();
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Отправитель", НаименованиеВида);
	НайденныеСтроки = Объект.Строки.НайтиСтроки(ПараметрыОтбора);
	НайденныеСтрокиВидаТребования = НайденныеСтроки[0].Строки.НайтиСтроки(ПараметрыОтбора);
	
	СписокВидовТребований = Новый СписокЗначений;
	Для Каждого Эл из НайденныеСтрокиВидаТребования Цикл
		НаименованиеВида = Эл.НаименованиеВида;
		СписокВидовТребований.Добавить(НаименованиеВида, НаименованиеВида);
	КонецЦикла;
	
	Возврат СписокВидовТребований;
	
КонецФункции

&НаКлиенте
Процедура ГруппаВидыСписковПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УправлениеЭУ();
	УправлениеЭУДереваВидовТребований(Элементы, ДеревоВидовТребованийГруппировка);
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Функция ОпределитьТекущееДерево()
	
	Возврат Элементы.ДеревоВидовТребований;
	
КонецФункции

&НаКлиенте
Процедура УправлениеЭУ(АктивизироватьДеревоВидовТребований = Истина)
	
	ТекДеревоВидовТребований = ОпределитьТекущееДерево();
	
	ДоступностьЭУ = (ТекДеревоВидовТребований.ТекущиеДанные <> Неопределено);
	
	ТекДеревоВидовТребований.КонтекстноеМеню.ПодчиненныеЭлементы[0].Доступность = ДоступностьЭУ;
	
	Элементы.Выбрать.Доступность = ДоступностьЭУ;
	
	Если ТекДеревоВидовТребований.Имя = "ДеревоВидовТребований" И ТекДеревоВидовТребований.Отображение = ОтображениеТаблицы.Дерево Тогда
		ЭлементыПервогоУровня = ДеревоВидовТребований.ПолучитьЭлементы();
		Если ЭлементыПервогоУровня.Количество() <= 5 Тогда
			Для Каждого ЭлементПервогоУровня Из ЭлементыПервогоУровня Цикл
				Если НЕ ЗначениеЗаполнено(ЭлементПервогоУровня.НаименованиеВида) Тогда
					Элементы.ДеревоВидовТребований.Развернуть(ЭлементПервогоУровня.ПолучитьИдентификатор(), Истина);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если АктивизироватьДеревоВидовТребований Тогда
		ЭтаФорма.ТекущийЭлемент = ТекДеревоВидовТребований;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭУДереваВидовТребований(Элементы, ДеревоВидовТребованийГруппировка)
	
	Если ДеревоВидовТребованийГруппировка = 1 Тогда // группировка по получателям
		
		Элементы.ДеревоВидовТребованийОтправитель.Видимость = Ложь;
		Элементы.ДеревоВидовТребований.Отображение = ОтображениеТаблицы.Дерево;
		
	ИначеЕсли ДеревоВидовТребованийГруппировка = 2 Тогда // без группировки
		
		Элементы.ДеревоВидовТребованийОтправитель.Видимость = Истина;
		Элементы.ДеревоВидовТребований.Отображение = ОтображениеТаблицы.Список;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДеревоВсехИспользуемыхВидовТребований()
	
	КоличествоЭлементовВДеревеВидовТребований = 0;
	
	ДеревоВсехИспользуемыхВидовТребований = ДеревоВидовТребований();
	
	// Добавим дополнительные колонки для соответствия данным формы
	ДеревоВсехИспользуемыхВидовТребований.Колонки.Добавить("Отправитель",     Новый ОписаниеТипов("Строка"));
	ДеревоВсехИспользуемыхВидовТребований.Колонки.Добавить("Пометка",        Новый ОписаниеТипов("Число"));
	ДеревоВсехИспользуемыхВидовТребований.Колонки.Добавить("ИндексКартинки", Новый ОписаниеТипов("Число"));
	
	ОбработатьДеревоВидовТребований(ДеревоВсехИспользуемыхВидовТребований);
	
	Для каждого СтрокаПервогоУровня Из ДеревоВсехИспользуемыхВидовТребований.Строки Цикл
	
		СтрокаПервогоУровня.Строки.Сортировать("НаименованиеВида", Истина);
		
	КонецЦикла;
	
	Возврат ДеревоВсехИспользуемыхВидовТребований;
	
КонецФункции

&НаСервере
Функция ДеревоВидовТребований()
	
	Запрос = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Журнал.Ссылка) = ТИП(Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов)
	|				И ТИПЗНАЧЕНИЯ(ВЫРАЗИТЬ(Журнал.Ссылка КАК Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов).ВидДокумента) = ТИП(Перечисление.ВидыНалоговыхДокументов)
	|			ТОГДА ВЫРАЗИТЬ(ВЫРАЗИТЬ(Журнал.Ссылка КАК Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов).ВидДокумента КАК Перечисление.ВидыНалоговыхДокументов)
	|		КОГДА ТИПЗНАЧЕНИЯ(Журнал.Ссылка) = ТИП(Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов)
	|				И ТИПЗНАЧЕНИЯ(ВЫРАЗИТЬ(Журнал.Ссылка КАК Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов).ВидДокумента) = ТИП(СТРОКА)
	|			ТОГДА ВЫРАЗИТЬ(ВЫРАЗИТЬ(Журнал.Ссылка КАК Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов).ВидДокумента КАК СТРОКА(200))
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК НаименованиеВида,
	|	Журнал.ВидКонтролирующегоОргана КАК ТипПолучателя
	|ИЗ
	|	РегистрСведений.ЖурналОтправокВКонтролирующиеОрганы КАК Журнал
	|ГДЕ
	|	Журнал.СтраницаЖурнала = ЗНАЧЕНИЕ(Перечисление.СтраницыЖурналаОтчетность.Входящие)
	|	И ВЫБОР
	|			КОГДА ТИПЗНАЧЕНИЯ(Журнал.Ссылка) = ТИП(Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов)
	|					И ТИПЗНАЧЕНИЯ(ВЫРАЗИТЬ(Журнал.Ссылка КАК Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов).ВидДокумента) = ТИП(Перечисление.ВидыНалоговыхДокументов)
	|				ТОГДА ВЫРАЗИТЬ(ВЫРАЗИТЬ(Журнал.Ссылка КАК Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов).ВидДокумента КАК Перечисление.ВидыНалоговыхДокументов)
	|			КОГДА ТИПЗНАЧЕНИЯ(Журнал.Ссылка) = ТИП(Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов)
	|					И ТИПЗНАЧЕНИЯ(ВЫРАЗИТЬ(Журнал.Ссылка КАК Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов).ВидДокумента) = ТИП(СТРОКА)
	|				ТОГДА ВЫРАЗИТЬ(ВЫРАЗИТЬ(Журнал.Ссылка КАК Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов).ВидДокумента КАК СТРОКА(200))
	|			ИНАЧЕ """"
	|		КОНЕЦ <> """"";
	
	ТекстОбъединения = "ОБЪЕДИНИТЬ ВСЕ";
	
	ТекстЗапросаСФР = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Требование.ВидДокументаФСС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыКонтролирующихОрганов.ФСС)
	|ИЗ
	|	Документ.ВходящийДокументСЭДОФСС КАК Требование
	|ГДЕ
	|	НЕ Требование.Ссылка = ЗНАЧЕНИЕ(Документ.ВходящийДокументСЭДОФСС.ПустаяССылка)";
	
	ТекстУпорядочить = "
	|УПОРЯДОЧИТЬ ПО
	|	НаименованиеВида";
	
	ТекстИтогов = "
	|ИТОГИ ПО
	|	ТипПолучателя";
	
	ТекстУсловия = "";
	ТекстУсловияСФР = "";
	
	Если НЕ Параметры = Неопределено Тогда
		
		ЕстьПараметры = Ложь;
		
		Если НЕ Параметры.Организация = Справочники.Организации.ПустаяСсылка() Тогда
			ТекстУсловия = Символы.ПС + "	И Журнал.Организация = &Организация ";
			ТекстУсловияСФР = Символы.ПС + "	И Требование.Организация = &Организация ";
			Запрос.УстановитьПараметр("Организация", Параметры.Организация);
			ЕстьПараметры = Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.ДатаНачалаПериодаВида)Тогда
			ТекстУсловия = ТекстУсловия + Символы.ПС + "	" + ?(ЕстьПараметры, "И ", "") + "Журнал.ДатаНачала >= &НачалоПериода";
			ТекстУсловияСФР = ТекстУсловияСФР + Символы.ПС + "	" + ?(ЕстьПараметры, "И ", "") + "Требование.ВходящаяДата >= &НачалоПериода";
			Запрос.УстановитьПараметр("НачалоПериода", Параметры.ДатаНачалаПериодаВида);
			ЕстьПараметры = Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.ДатаКонцаПериодаВида)Тогда
			ТекстУсловия = ТекстУсловия + Символы.ПС + "	" + ?(ЕстьПараметры, "И ", "") + "Журнал.ДатаОкончания <= &КонецПериода";
			ТекстУсловияСФР = ТекстУсловияСФР + Символы.ПС + "	" + ?(ЕстьПараметры, "И ", "") + "Требование.ВходящаяДата <= &КонецПериода";
			Запрос.УстановитьПараметр("КонецПериода", Параметры.ДатаКонцаПериодаВида);
			ЕстьПараметры = Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекстУсловия) Тогда
			ТекстЗапроса = ТекстЗапроса + ТекстУсловия;
			ТекстЗапросаСФР = ТекстЗапросаСФР + ТекстУсловияСФР;
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса + Символы.ПС + ТекстОбъединения + Символы.ПС + ТекстЗапросаСФР + ТекстУпорядочить + Символы.ПС + ТекстИтогов;
	
	Возврат Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
КонецФункции

&НаСервере
Процедура ОбработатьДеревоВидовТребований(Узел)
	
	СтрокиДерева = Узел.Строки;
	
	КолСтрок = СтрокиДерева.Количество();
	
	Для Инд = 1 По КолСтрок Цикл
		
		ОбрИндекс = КолСтрок - Инд;
		СтрокаДерева = СтрокиДерева.Получить(ОбрИндекс);
		
		ОбработатьДеревоВидовТребований(СтрокаДерева);
		
		Если ЗначениеЗаполнено(СтрокаДерева.НаименованиеВида) Тогда
			
			СтрокаДерева.Отправитель = Строка(СтрокаДерева.ТипПолучателя);
			СтрокаДерева.Родитель.Отправитель = Строка(СтрокаДерева.ТипПолучателя);
			
			СтрокаДерева.ИндексКартинки = 1;
			
			КоличествоЭлементовВДеревеВидовТребований = КоличествоЭлементовВДеревеВидовТребований + 1;
			
			СтрокаДерева.Пометка = 0;
		Иначе
			СтрокаДерева.ИндексКартинки = 0;
			СтрокаДерева.Пометка = -1;
			СтрокаДерева.НаименованиеВида = Строка(СтрокаДерева.ТипПолучателя);
			СтрокаДерева.Отправитель = Строка(СтрокаДерева.ТипПолучателя);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДеревоВидовТребованийПоПолучателям(ДеревоВсехИспользуемыхВидовТребований)
	
	ТаблицаГруппДляСортировки = Новый ТаблицаЗначений;
	ТаблицаГруппДляСортировки.Колонки.Добавить("Поиск",      Новый ОписаниеТипов("Строка"));
	ТаблицаГруппДляСортировки.Колонки.Добавить("Замена",     Новый ОписаниеТипов("Строка"));
	ТаблицаГруппДляСортировки.Колонки.Добавить("Сортировка", Новый ОписаниеТипов("Строка"));
	ТаблицаГруппДляСортировки.Колонки.Добавить("СтрокаВДереве");
	
	СтрокаТаблицы = ТаблицаГруппДляСортировки.Добавить();
	СтрокаТаблицы.Поиск = "ФНС";
	СтрокаТаблицы.Замена = "ФНС";
	СтрокаТаблицы.Сортировка = "001.ФНС";
	СтрокаТаблицы = ТаблицаГруппДляСортировки.Добавить();
	СтрокаТаблицы.Поиск = "ПФР";
	СтрокаТаблицы.Замена = "СФР (бывш. ПФР)";
	СтрокаТаблицы.Сортировка = "002.ПФР";
	СтрокаТаблицы = ТаблицаГруппДляСортировки.Добавить();
	СтрокаТаблицы.Поиск = "ФСС";
	СтрокаТаблицы.Замена = "СФР (бывш. ФСС)";
	СтрокаТаблицы.Сортировка = "003.ФСС";
	СтрокаТаблицы = ТаблицаГруппДляСортировки.Добавить();
	СтрокаТаблицы.Поиск = "Росстат";
	СтрокаТаблицы.Замена = "Росстат";
	СтрокаТаблицы.Сортировка = "004.Росстат";
	СтрокаТаблицы = ТаблицаГруппДляСортировки.Добавить();
	СтрокаТаблицы.Поиск = "Росалкогольрегулирование"; // служба переименована, но проверку предыдущего наименования сохраним
	СтрокаТаблицы.Замена = "Росалкогольтабакконтроль";
	СтрокаТаблицы.Сортировка = "005.Росалкогольтабакконтроль";
	СтрокаТаблицы = ТаблицаГруппДляСортировки.Добавить();
	СтрокаТаблицы.Поиск = "Росалкогольтабакконтроль"; 
	СтрокаТаблицы.Замена = "Росалкогольтабакконтроль";
	СтрокаТаблицы.Сортировка = "005.Росалкогольтабакконтроль";
	СтрокаТаблицы = ТаблицаГруппДляСортировки.Добавить();
	СтрокаТаблицы.Поиск = "Банк России";
	СтрокаТаблицы.Замена = "Банк России";
	СтрокаТаблицы.Сортировка = "006.БанкРоссии";
	СтрокаТаблицы = ТаблицаГруппДляСортировки.Добавить();
	СтрокаТаблицы.Поиск = "яяя";
	СтрокаТаблицы.Замена = "Другие получатели";
	СтрокаТаблицы.Сортировка = "яяя";
	
	ДеревоЗначенийДляСортировки = ДеревоВсехИспользуемыхВидовТребований.Скопировать();
	ДеревоЗначенийДляСортировки.Строки.Очистить();
	
	ЗаполнитьДеревоЗначенийПоПолучателям(ДеревоВсехИспользуемыхВидовТребований, ДеревоЗначенийДляСортировки);
	
	ВсеГруппыПолучателей = ДеревоЗначенийДляСортировки.Строки.НайтиСтроки(Новый Структура("НаименованиеВида", ""), Истина);
	
	Для каждого ГруппаПолучателя Из ВсеГруппыПолучателей Цикл
		НайденныеСтроки = ТаблицаГруппДляСортировки.НайтиСтроки(Новый Структура("Поиск", ГруппаПолучателя.Наименование));
		Если НайденныеСтроки.Количество() > 0 Тогда
			НайденныеСтроки[0].СтрокаВДереве = ГруппаПолучателя;
			ГруппаПолучателя.Наименование = НайденныеСтроки[0].Сортировка;
		КонецЕсли;
	КонецЦикла;
	
	ДеревоЗначенийДляСортировки.Строки.Сортировать("НаименованиеВида", Истина);
	
	Возврат ДеревоЗначенийДляСортировки;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьДеревоЗначенийПоПолучателям(Узел, ДеревоРезультата)
	
	СтрокиУзла = Узел.Строки;
	
	Для каждого СтрокаДерева Из СтрокиУзла Цикл
	
		ЗаполнитьДеревоЗначенийПоПолучателям(СтрокаДерева, ДеревоРезультата);
		
		Если ЗначениеЗаполнено(СтрокаДерева.НаименованиеВида) Тогда
			
			Отправитель = ?(ЗначениеЗаполнено(СтрокаДерева.ТипПолучателя), СтрокаДерева.ТипПолучателя, "яяя");
			
			НайденныеГруппыПолучателя = ДеревоРезультата.Строки.НайтиСтроки(Новый Структура("НаименованиеВида, ТипПолучателя", "", Отправитель), Истина);
			Если НайденныеГруппыПолучателя.Количество() > 0 Тогда
				НайденнаяГруппаПолучателя = НайденныеГруппыПолучателя[0];
			Иначе
				НайденнаяГруппаПолучателя = ДеревоРезультата.Строки.Добавить();
				НайденнаяГруппаПолучателя.НаименованиеВида = Отправитель;
				НайденнаяГруппаПолучателя.Пометка = -1;
			КонецЕсли;
			
			НоваяСтрокаДерева = НайденнаяГруппаПолучателя.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДерева, СтрокаДерева);
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДеревоВидовТребованийБезГруппировки(ДеревоВсехИспользуемыхВидовТребований)
	
	ДеревоЗначенийДляСортировки = ДеревоВсехИспользуемыхВидовТребований.Скопировать();
	ДеревоЗначенийДляСортировки.Строки.Очистить();
	
	ЗаполнитьДеревоЗначенийБезГруппировки(ДеревоВсехИспользуемыхВидовТребований, ДеревоЗначенийДляСортировки);
	
	ДеревоЗначенийДляСортировки.Строки.Сортировать("НаименованиеВида, Отправитель", Истина);
	
	Возврат ДеревоЗначенийДляСортировки;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьДеревоЗначенийБезГруппировки(Узел, ДеревоРезультата)
	
	СтрокиУзла = Узел.Строки;
	
	Для каждого СтрокаДерева Из СтрокиУзла Цикл
	
		ЗаполнитьДеревоЗначенийБезГруппировки(СтрокаДерева, ДеревоРезультата);
		
		Если ЗначениеЗаполнено(СтрокаДерева.НаименованиеВида) Тогда
			
			НоваяСтрокаДерева = ДеревоРезультата.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДерева, СтрокаДерева);
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДеревоВидовТребованийИзДругогоДерева(ИсходноеДеревоВидовТребований)
	
	ДеревоВидовТребований.ПолучитьЭлементы().Очистить();
	
	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		КопироватьДанныеФормыУдовлетворяющиеСтрокеПоиска(ИсходноеДеревоВидовТребований, ДеревоВидовТребований);
	Иначе
		КопироватьДанныеФормы(ИсходноеДеревоВидовТребований, ДеревоВидовТребований);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьДанныеФормыУдовлетворяющиеСтрокеПоиска(ЭлементДереваИсточник, ЭлементДереваПриемник)
	
	СтрокаПоискаВРег = ВРег(СтрокаПоиска);
	
	СтрокиИсточника = ЭлементДереваИсточник.ПолучитьЭлементы();
	
	СтрокиПриемника = ЭлементДереваПриемник.ПолучитьЭлементы();
	
	Для Каждого СтрокаИсточника Из СтрокиИсточника Цикл
		
		ЭтоГруппа = СтрокаИсточника.ЭтоГруппа = Истина;
		
		Если НЕ ЭтоГруппа Тогда
			Если СтрНайти(ВРег(СтрокаИсточника.Наименование), СтрокаПоискаВРег) = 0 Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		НоваяСтрокаПриемника = СтрокиПриемника.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаПриемника, СтрокаИсточника);
		
		КопироватьДанныеФормыУдовлетворяющиеСтрокеПоиска(СтрокаИсточника, НоваяСтрокаПриемника);
		
		Если ЭтоГруппа И НоваяСтрокаПриемника.ПолучитьЭлементы().Количество() = 0 Тогда
			СтрокиПриемника.Удалить(НоваяСтрокаПриемника);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Элемент.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.НеИспользовать;
	
	СтрокаПоиска = Текст;
	
	СтрокаПоискаОбработка();
	
	ЭтаФорма.ТекущийЭлемент = Элемент;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Элемент.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.Авто;
	
	СтрокаПоиска = "";
	
	СтрокаПоискаОбработка();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОбработка()
	
	Если ДеревоВидовТребованийГруппировка = 1 Тогда      // группировка по получателям
		ЗаполнитьДеревоВидовТребованийИзДругогоДерева(ДеревоВидовТребованийПоПолучателям);
	ИначеЕсли ДеревоВидовТребованийГруппировка = 2 Тогда // без группировки
		ЗаполнитьДеревоВидовТребованийИзДругогоДерева(ДеревоВидовТребованийБезГруппировки);
	КонецЕсли;
	
	УправлениеЭУ(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	ХранилищеНастроекДанныхФорм.Сохранить(ЭтаФорма.ИмяФормы, "ФормаОтчетность_ФормаВыбораВидаТребований_ТекущаяСтраница", Элементы.ГруппаВидыСписков.ТекущаяСтраница.Имя);
	ХранилищеНастроекДанныхФорм.Сохранить(ЭтаФорма.ИмяФормы, "ФормаОтчетность_ФормаВыбораВидаТребований_ДеревоВидовТребованийГруппировка", ДеревоВидовТребованийГруппировка);
	
КонецПроцедуры

#КонецОбласти

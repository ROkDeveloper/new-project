﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаГлобальныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
		АвтоЗаголовок = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
	
	ТарификацияБП.РазместитьИнформациюОбОграниченииПоКоличествуОбъектов(ЭтотОбъект);
	
	АдресХранилищаНастройкиДинСпискаДляРеестра = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ПомеченныеНаУдалениеСервер.СкрытьПомеченныеНаУдаление(ЭтотОбъект);
	
	Если Параметры.ФормаОткрытаИзКарточкиСотрудника Тогда
		Элементы.ГруппаОтборПоСотруднику.Видимость = Ложь;
		Элементы.Сотрудник.Видимость               = Ложь;
	КонецЕсли;
	
	УстановитьОтборСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Передача(Команда)
	
	СтруктураПараметров = ПолучитьПараметрыФормыДокумента();
	СтруктураПараметров.ЗначенияЗаполнения.Вставить("ВидОперации",
		ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходМатериалов.ПередачаСотруднику"));
	ОткрытьФорму("Документ.ТребованиеНакладная.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Списание(Команда)
	
	СтруктураПараметров = ПолучитьПараметрыФормыДокумента();
	СтруктураПараметров.ЗначенияЗаполнения.Вставить("ВидОперации",
		ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеТоваров.СписаниеССотрудника"));
	ОткрытьФорму("Документ.СписаниеТоваров.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Перемещение(Команда)
	
	СтруктураПараметров = ПолучитьПараметрыФормыДокумента();
	СтруктураПараметров.ЗначенияЗаполнения.Вставить("ВидОперации",
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПеремещениеТоваров.ПередачаМеждуСотрудниками"));
	ОткрытьФорму("Документ.ПеремещениеТоваров.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыВыданныеСотрудникам(Команда)
	
	Вариант = Новый Структура;
	Вариант.Вставить("ИмяОтчета",    "МатериалыВыданныеСотрудникам");
	Вариант.Вставить("КлючВарианта", "МатериалыВыданныеСотрудникам");
	
	БухгалтерскиеОтчетыКлиент.ОткрытьВариантОтчета(Вариант);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ПомеченныеНаУдалениеКлиент.ПриИзмененииСписка(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
	ОтборыСписков.СброситьИспользованиеПользовательскихОтборовВНастройке(Настройки);
	
	ПомеченныеНаУдалениеСервер.УдалитьОтборПометкаУдаления(Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСотрудникИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Сотрудник");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСотрудникПриИзменении(Элемент)
	
	ОтборСотрудникИспользование = ЗначениеЗаполнено(ОтборСотрудник);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Сотрудник");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если УправлениеПечатьюБПКлиентСервер.ЭтоИмяКомандыРеестрДокументов(Команда.Имя) Тогда
		НастройкиДинамическогоСписка();
	КонецЕсли;
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастройкиДинамическогоСписка()
	
	Отчеты.РеестрДокументов.НастройкиДинамическогоСписка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыФормыДокумента()
		
	СтруктураПараметров = Новый Структура;
	ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервере
Процедура УстановитьОтборСписка()
	
	МассивВидовОпераций = Новый Массив;
	МассивВидовОпераций.Добавить(Перечисления.ВидыОперацийРасходМатериалов.ПередачаСотруднику);
	МассивВидовОпераций.Добавить(Перечисления.ВидыОперацийСписаниеТоваров.СписаниеССотрудника);
	МассивВидовОпераций.Добавить(Перечисления.ВидыОперацийПеремещениеТоваров.ПередачаМеждуСотрудниками);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"ВидОперации",
		МассивВидовОпераций,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
	
КонецПроцедуры

#КонецОбласти

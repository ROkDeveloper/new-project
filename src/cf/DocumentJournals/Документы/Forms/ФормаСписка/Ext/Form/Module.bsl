﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПодменюДиректБанк", "Видимость", Ложь);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"СтатусОплатыПоУмолчанию", Перечисления.СтатусОплатыСчета.СтатусНовогоДокумента());
	Список.Параметры.УстановитьЗначениеПараметра(
		"СтатусРеализацииПоУмолчанию", Перечисления.СтатусыДокументовРеализации.СтатусНовогоДокумента());
	Список.Параметры.УстановитьЗначениеПараметра(
		"СтатусПоступленияПоУмолчанию", Перечисления.СтатусыДокументовПоступления.СтатусНовогоДокумента());
	Список.Параметры.УстановитьЗначениеПараметра(
		"СтатусКоммерческогоПредложенияПоУмолчанию", Перечисления.СтатусыКоммерческогоПредложения.СтатусНовогоДокумента());
		
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеДокументаАктРеализация", НСтр("ru='Акт (реализация услуг)'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеДокументаУПДРеализацияУслуг", НСтр("ru='УПД (реализация услуг)'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеДокументаНакладнаяРеализация", НСтр("ru='Накладная (реализация товаров)'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеДокументаУПДРеализацияТоваров", НСтр("ru='УПД (реализация товаров)'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеДокументаРеализация", НСтр("ru='Реализация'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеДокументаАктПоступление", НСтр("ru='Акт (поступление услуг)'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеДокументаУПДПоступлениеУслуг", НСтр("ru='УПД (поступление услуг)'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеДокументаНакладнаяПоступление", НСтр("ru='Накладная (поступление товаров)'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеДокументаУПДПоступлениеТоваров", НСтр("ru='УПД (поступление товаров)'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеДокументаНакладнаяТопливо", НСтр("ru='Накладная (топливо)'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеДокументаУПДТопливо", НСтр("ru='УПД (топливо)'"));
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеДокументаПоступление", НСтр("ru='Поступление'"));
	
	ЕстьПравоИзменениеСчетПокупателю          = ПравоДоступа("Изменение", Метаданные.Документы.СчетНаОплатуПокупателю);
	ЕстьПравоИзменениеРеализацияТоваровУслуг  = ПравоДоступа("Изменение", Метаданные.Документы.РеализацияТоваровУслуг);
	ЕстьПравоИзменениеСчетПоставщика          = ПравоДоступа("Изменение", Метаданные.Документы.СчетНаОплатуПоставщика);
	ЕстьПравоИзменениеПоступлениеТоваровУслуг = ПравоДоступа("Изменение", Метаданные.Документы.ПоступлениеТоваровУслуг);
	ЕстьПравоИзменениеПлатежноеПоручение      = ПравоДоступа("Изменение", Метаданные.Документы.ПлатежноеПоручение);
	ЕстьПравоИзменениеАктСверкиВзаиморасчетов = ПравоДоступа("Изменение", Метаданные.Документы.АктСверкиВзаиморасчетов);
	ЕстьПравоИзменениеКоммерческогоПредложения = ПравоДоступа("Изменение", Метаданные.Документы.КоммерческоеПредложение);
	
	МожноРедактировать = ЕстьПравоИзменениеСчетПокупателю
		И ЕстьПравоИзменениеРеализацияТоваровУслуг
		И ЕстьПравоИзменениеСчетПоставщика
		И ЕстьПравоИзменениеПоступлениеТоваровУслуг
		И ЕстьПравоИзменениеПлатежноеПоручение
		И ЕстьПравоИзменениеАктСверкиВзаиморасчетов
		И ЕстьПравоИзменениеКоммерческогоПредложения;
	
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.Список.ИзменятьСоставСтрок                        = МожноРедактировать;
	Элементы.СоздатьСчетПокупателю.Видимость                   = ЕстьПравоИзменениеСчетПокупателю;
	Элементы.СоздатьАктРеализация.Видимость                    = ЕстьПравоИзменениеРеализацияТоваровУслуг;
	Элементы.СоздатьНакладнуюРеализация.Видимость              = ЕстьПравоИзменениеРеализацияТоваровУслуг;
	Элементы.СоздатьНакладнуюПередача.Видимость                = ЕстьПравоИзменениеРеализацияТоваровУслуг;

	Элементы.СоздатьСчетПоставщика.Видимость                   = ЕстьПравоИзменениеСчетПоставщика;
	
	ДоступныеЗначенияОперацийПоступления = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.СписокДоступныхЗначений();

	ОперацияПоступлениеУслуг = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Услуги;
	ОперацияПоступлениеУслугДоступна = 
		ДоступныеЗначенияОперацийПоступления.НайтиПоЗначению(ОперацияПоступлениеУслуг) <> Неопределено;
		
	Элементы.СоздатьАктПоступление.Видимость                 =
		ЕстьПравоИзменениеПоступлениеТоваровУслуг И ОперацияПоступлениеУслугДоступна;
	
	ОперацияПоступлениеТоваров = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Товары;
	ОперацияПоступлениеТоваровДоступна = 
		ДоступныеЗначенияОперацийПоступления.НайтиПоЗначению(ОперацияПоступлениеТоваров) <> Неопределено;

	Элементы.СоздатьНакладнуюПоступление.Видимость             =
		ЕстьПравоИзменениеПоступлениеТоваровУслуг И ОперацияПоступлениеТоваровДоступна;
		
	Элементы.СоздатьПлатежноеПоручение.Видимость               = ЕстьПравоИзменениеПлатежноеПоручение;
	Элементы.СоздатьАктСверки.Видимость                        = ЕстьПравоИзменениеАктСверкиВзаиморасчетов;
	Элементы.СоздатьКоммерческоеПредложение.Видимость          = ЕстьПравоИзменениеКоммерческогоПредложения;
	
	ТипыДокументовОтправляемыхПоЭлектроннойПочте = Метаданные.ОбщиеКоманды.ОтправитьПоЭлектроннойПочте.ТипПараметраКоманды;
	
	ОбщегоНазначенияБП.УстановитьВидимостьКолонокДополнительнойИнформации(ЭтотОбъект);
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.ЖурналДокументов.Документы",
		"ФормаСпискаПростойИнтерфейс",
		НСтр("ru='Новости: Документы'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
	ТарификацияБП.РазместитьИнформациюОбОграниченииПоКоличествуОбъектов(ЭтотОбъект);
	
	ПомеченныеНаУдалениеСервер.СкрытьПомеченныеНаУдаление(ЭтотОбъект);
	
	Элементы.ЗагрузитьИзИнтернетМагазина.Видимость = ОбменСИнтернетМагазином.ДоступенОбменСИнтернетМагазином();
	
	УправлениеПанельюПодсказки.ПриСозданииНаСервере(ЭтотОбъект);
	
	// РекламныйСервис
	РекламныйСервис.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РекламныйСервис
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьБаннер", 1, Истина);
	ПодключитьОбработчикОжидания("ПоказатьИнформациюОПравеПримененияСпецрежима", 0.1, Истина);
	
	// РекламныйСервис
	РекламныйСервисКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец РекламныйСервис
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	УправлениеПанельюПодсказкиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ПерсонализированныеПредложенияСервисовКлиент.ПерейтиПоСсылкеБаннера(
		НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, Баннер, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьАктПоступление(Команда)
	
	СтруктураПараметров = ПолучитьПараметрыФормыДокумента(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Услуги"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьАктРеализация(Команда)
	
	СтруктураПараметров = ПолучитьПараметрыФормыДокумента(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийРеализацияТоваров.Услуги"));
	ОткрытьФорму("Документ.РеализацияТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьАктСверки(Команда)
	
	СтруктураПараметров = ПолучитьПараметрыФормыДокумента();
	ОткрытьФорму("Документ.АктСверкиВзаиморасчетов.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНакладнуюПоступление(Команда)
	
	СтруктураПараметров = ПолучитьПараметрыФормыДокумента(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Товары"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНакладнуюРеализация(Команда)
	
	СтруктураПараметров = ПолучитьПараметрыФормыДокумента(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийРеализацияТоваров.Товары"));
	ОткрытьФорму("Документ.РеализацияТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПлатежноеПоручение(Команда)
	
	СтруктураПараметров = ПолучитьПараметрыФормыДокумента();
	ОткрытьФорму("Документ.ПлатежноеПоручение.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСчетПокупателю(Команда)

	СтруктураПараметров = ПолучитьПараметрыФормыДокумента();
	ОткрытьФорму("Документ.СчетНаОплатуПокупателю.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСчетПоставщика(Команда)

	СтруктураПараметров = ПолучитьПараметрыФормыДокумента();
	ОткрытьФорму("Документ.СчетНаОплатуПоставщика.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКоммерческоеПредложение(Команда)
	
	СтруктураПараметров = ПолучитьПараметрыФормыДокумента();
	ОткрытьФорму("Документ.КоммерческоеПредложение.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтотОбъект,
		Команда
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзИнтернетМагазина(Команда)
	
	Элементы.ГруппаРезультатОбменаСИнтернетМагазином.Видимость = Ложь;
	
	ОбработчикПослеВыполненияОбмена = Новый ОписаниеОповещения("ОбработатьПослеВыполненияОбменаСИнтернетМагазином", ЭтотОбъект);
	ОбменСИнтернетМагазиномКлиент.ВыполнитьОбменСИнтернетМагазином(ЭтотОбъект, ОбработчикПослеВыполненияОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьПодсказок(Команда)
	
	ИзменитьВидимостьПодсказокНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьПанельПодсказок(Команда)
	
	ИзменитьВидимостьПодсказокНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНакладнуюПередача(Команда)
	
	СтруктураПараметров = ПолучитьПараметрыФормыДокумента(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийРеализацияТоваров.ПередачаТоваров"));
	ОткрытьФорму("Документ.РеализацияТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗакрытьБаннерНажатие(Элемент)
	
	ОтключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер");
	
	ПерсонализированныеПредложенияСервисовКлиент.ЗакрытьБаннер(ЭтотОбъект, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущийБаннерНажатие(Элемент)
	
	ОтключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер");
	
	ПерсонализированныеПредложенияСервисовКлиент.УстановитьРежимОжиданияНаБаннере(ЭтотОбъект);
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьПредыдущийБаннер", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СледующийБаннерНажатие(Элемент)
	
	ОтключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер");
	
	ПерсонализированныеПредложенияСервисовКлиент.УстановитьРежимОжиданияНаБаннере(ЭтотОбъект);
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ПомеченныеНаУдалениеКлиент.ПриИзмененииСписка(ЭтотОбъект, Элемент);
	ПодключитьОбработчикОжидания("ПоказатьИнформациюОПравеПримененияСпецрежима", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
	Если Элемент.ВыделенныеСтроки.Количество() = 0 Тогда
		ДоступнаОтправкаПоЭлектроннойПочте = Ложь;
	Иначе
		ДоступнаОтправкаПоЭлектроннойПочте = Истина;
		ТипПервогоВыделенногоДокумента = ТипЗнч(Элемент.ВыделенныеСтроки[0]);
		Для каждого Документ Из Элемент.ВыделенныеСтроки Цикл
			Если НЕ ТипЗнч(Документ) = ТипПервогоВыделенногоДокумента // выбраны документы разных типов
				ИЛИ НЕ ТипыДокументовОтправляемыхПоЭлектроннойПочте.СодержитТип(ТипЗнч(Документ)) Тогда
				ДоступнаОтправкаПоЭлектроннойПочте = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Элементы.ОтправитьПоЭлектроннойПочте.Доступность = ДоступнаОтправкаПоЭлектроннойПочте;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки, ИспользуютсяСтандартныеНастройки)
	
	ПомеченныеНаУдалениеСервер.УдалитьОтборПометкаУдаления(Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьРезультатОбменаСИнтернетМагазиномНажатие(Элемент)
	Элементы.ГруппаРезультатОбменаСИнтернетМагазином.Видимость = Ложь;
	УстановитьУсловноеОформление();
КонецПроцедуры

#Область Панель_Подсказки

&НаКлиенте
Процедура НавигацияВПрограммеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	УправлениеПанельюПодсказкиКлиент.НавигацияВПрограммеОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительнаяФункциональностьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	УправлениеПанельюПодсказкиКлиент.ДополнительнаяФункциональностьОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылка,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СоветПоРаботе1ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	УправлениеПанельюПодсказкиКлиент.СоветПоРаботеОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СоветПоРаботе2ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	УправлениеПанельюПодсказкиКлиент.СоветПоРаботеОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СоветПоРаботе3ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	УправлениеПанельюПодсказкиКлиент.СоветПоРаботеОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СоветПоРаботе4ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	УправлениеПанельюПодсказкиКлиент.СоветПоРаботеОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПодробнееНажатие(Элемент)
	
	КонтрольПраваПримененияСпецрежимаКлиент.ПодробнееНажатие(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьПараметрыФормыДокумента(ВидОперации = Неопределено)
	
	Если ЗначениеЗаполнено(ВидОперации) Тогда
		Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Товары") Тогда
			КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугТовары";
		ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Услуги") Тогда
			КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугУслуги";
		ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРеализацияТоваров.Товары") Тогда
			КлючеваяОперация = "СозданиеФормыРеализацияТоваровУслугТовары";
		ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРеализацияТоваров.Услуги") Тогда
			КлючеваяОперация = "СозданиеФормыРеализацияТоваровУслугУслуги";
		КонецЕсли;
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;

	СтруктураПараметров = Новый Структура;
	ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	Если ЗначениеЗаполнено(ВидОперации) Тогда
		ЗначенияЗаполнения.Вставить("ВидОперации", ВидОперации);
	КонецЕсли;
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление(ВыделяемыеЗначения = Неопределено)
	
	УсловноеОформление.Элементы.Очистить();
	
	Если НЕ ЗначениеЗаполнено(ВыделяемыеЗначения) Тогда
		Возврат;
	КонецЕсли;
	
	СписокВыделенияЗначений = Новый СписокЗначений();
	СписокВыделенияЗначений.ЗагрузитьЗначения(ВыделяемыеЗначения);
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Список");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.Ссылка", ВидСравненияКомпоновкиДанных.ВСписке, СписокВыделенияЗначений);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(Новый Шрифт(),,, Истина));
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьПодсказокНаСервере()
	
	УправлениеПанельюПодсказки.ИзменитьВидимостьПодсказок(ЭтотОбъект);
	
КонецПроцедуры

#Область ПравоПримененияСпецрежима

&НаКлиенте
Процедура ПоказатьИнформациюОПравеПримененияСпецрежима()
	
	ОсновнаяОрганизация = ОсновнаяОрганизацияПользователя();
	
	Если Не ЗначениеЗаполнено(ОсновнаяОрганизация)
		Или Не КонтрольПраваПримененияСпецрежимаКлиент.Контролировать(ОсновнаяОрганизация) Тогда
		
		Элементы.ИнформацияОПравеПримененияСпецрежима.Видимость = Ложь;
	Иначе
		ПоказатьИнформациюОПравеПримененияСпецрежимаНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьИнформациюОПравеПримененияСпецрежимаНаСервере()
	
	ИнформацияОПравеПримененияСпецрежима = КонтрольПраваПримененияСпецрежима.ИнформацияОПравеПримененияСпецрежима(
		ОсновнаяОрганизацияПользователя(),
		КонтрольПраваПримененияСпецрежима.ИмяПоказателяСпецрежимаТовары());
		
	СсылкаНаПояснение = ИнформацияОПравеПримененияСпецрежима.СсылкаНаПояснение;
	
	Элементы.ИнформацияОПравеПримененияСпецрежима.Видимость = ИнформацияОПравеПримененияСпецрежима.Показать;
	Элементы.ИнформацияОПравеПримененияСпецрежима.ЦветФона = ИнформацияОПравеПримененияСпецрежима.ЦветФонаГруппы;
	Элементы.ТекстИнформации.Заголовок = ИнформацияОПравеПримененияСпецрежима.ТекстИнформации;
	Элементы.ТекстИнформацииРасширеннаяПодсказка.Заголовок = ИнформацияОПравеПримененияСпецрежима.ПодсказкаТекстИнформации;
	
	Элементы.Подробнее.Видимость = ЗначениеЗаполнено(СсылкаНаПояснение);
	
КонецПроцедуры

&НаСервере
Функция ОсновнаяОрганизацияПользователя()
	
	НастройкиПоУмолчанию = Список.КомпоновщикНастроек.ПолучитьНастройки();
	
	Если НастройкиПоУмолчанию.Отбор.Элементы.Количество() > 0 Тогда
		
		ПолеОтбораОрганизация = Новый ПолеКомпоновкиДанных("Организация");
		Для Каждого ЭлементОтбора Из НастройкиПоУмолчанию.Отбор.Элементы Цикл
			Если ЭлементОтбора.Использование И ЭлементОтбора.ЛевоеЗначение = ПолеОтбораОрганизация Тогда
				Возврат ЭлементОтбора.ПравоеЗначение;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Справочники.Организации.ОрганизацияПоУмолчанию();
	
КонецФункции

#КонецОбласти

#Область РекламныйСервис

&НаКлиенте
Процедура Подключаемый_ЗаполнитьРекламныйНоситель()
	РекламныйСервисКлиент.ЗаполнитьРекламныйНоситель(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПоказатьКнопкуЗакрытьРекламу()
	РекламныйСервисКлиент.ПоказатьКнопкуЗакрытьРекламу(ЭтотОбъект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_МакетРекламныйСервисПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РекламныйСервисКлиент.МакетРекламныйСервисНажатие(ЭтотОбъект, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_КомандаЗакрытьРекламу()
	РекламныйСервисКлиент.КомандаЗакрытьРекламу(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

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

#КонецОбласти

#Область Баннер

&НаКлиенте
Процедура Подключаемый_УстановитьБаннер()
	
	УстановитьБаннер();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьСледующийБаннер()
	
	// Поскольку обработчик может вызываться не только интерактивно пользователем,
	// но и автоматически по таймеру, меняем баннер при условии, что форма находится в фокусе.
	Если НЕ ВводДоступен() Тогда
		ПодключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер",
			ПерсонализированныеПредложенияСервисовКлиент.ИнтервалПереключенияБаннеров(), Истина);
		Возврат;
	КонецЕсли;
	
	УстановитьБаннер();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьПредыдущийБаннер()
	
	УстановитьБаннер(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьБаннер(ПоказатьПредыдущий = Ложь)
	
	ДлительнаяОперация = ПолучитьБаннерНаСервере(ПоказатьПредыдущий);
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус <> "Ошибка" Тогда
		
		НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
		
		Обработчик = Новый ОписаниеОповещения("ПослеПолученияБаннераВФоне", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, НастройкиОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияБаннераВФоне(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		УстановитьБаннерНаФорме(ДлительнаяОперация.АдресРезультата);
		ПодключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер",
			ПерсонализированныеПредложенияСервисовКлиент.ИнтервалПереключенияБаннеров(), Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьБаннерНаСервере(ПоказатьПредыдущий)
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение баннера в фоне'");
	НастройкиЗапуска.ЗапуститьВФоне = Истина;
	НастройкиЗапуска.ОжидатьЗавершение = 0;
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("Организация", Неопределено);
	СтруктураПараметров.Вставить("Размещение", ПерсонализированныеПредложенияСервисов.ИмяРазмещенияДокументы());
	СтруктураПараметров.Вставить("ПоказатьПредыдущий", ПоказатьПредыдущий);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"ПерсонализированныеПредложенияСервисов.ПолучитьБаннер",
		СтруктураПараметров,
		НастройкиЗапуска);
	
КонецФункции

&НаСервере
Процедура УстановитьБаннерНаФорме(АдресРезультата)
	
	ПерсонализированныеПредложенияСервисов.УстановитьБаннерНаФорме(ЭтотОбъект, АдресРезультата);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстРезультатОбменаСИнтернетМагазиномОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбменСИнтернетМагазиномКлиент.ПоказатьРезультатВыполненияОбмена(РезультатОбменаСИнтернетМагазином);
КонецПроцедуры

#КонецОбласти

#Область ИнтернетМагазин
&НаКлиенте
Процедура ОбработатьПослеВыполненияОбменаСИнтернетМагазином(Результат, ДопПараметры) Экспорт
	
	ПослеВыполненияОбменаСИнтернетМагазиномНаСервере(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ПослеВыполненияОбменаСИнтернетМагазиномНаСервере(Результат)
	
	СписокВыделенияИнтернетМагазин = Новый Массив;
	
	РезультатОбменаСИнтернетМагазином = Результат;
	
	РезультатЗагрузки = ПолучитьИзВременногоХранилища(Результат);
	
	Если РезультатЗагрузки.Успешно Тогда
		Обработано = РезультатЗагрузки.СтатистикаЗагрузки.Заказы.Обработано;
		Если Обработано > 0 Тогда
			ШаблонСообщения = НСтр("ru = 'Загрузка выполнена успешно.'");
			ТекстСообщения = Новый ФорматированнаяСтрока(
				Новый ФорматированнаяСтрока(ШаблонСообщения),
				Новый ФорматированнаяСтрока("Подробнее",,,, "#Подробнее"));
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СписокВыделенияИнтернетМагазин, РезультатЗагрузки.СтатистикаЗагрузки.Заказы.Создано);
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СписокВыделенияИнтернетМагазин, РезультатЗагрузки.СтатистикаЗагрузки.Заказы.Обновлено, Истина);
		Иначе
			ТекстСообщения = НСтр("ru = 'В интернет-магазине нет заказов к загрузке'")
		КонецЕсли;
	Иначе
		ШаблонСообщения = НСтр("ru = 'Не удалось выполнить обмен с интернет-магазином.'");
		ТекстСообщения = Новый ФорматированнаяСтрока(
			Новый ФорматированнаяСтрока(ШаблонСообщения),
			Новый ФорматированнаяСтрока("Подробнее",,,, "#Подробнее"));
	КонецЕсли;
	
	Элементы.ТекстРезультатОбменаСИнтернетМагазином.Заголовок = ТекстСообщения;
	Элементы.ГруппаРезультатОбменаСИнтернетМагазином.Видимость = Истина;
	
	УстановитьУсловноеОформление(СписокВыделенияИнтернетМагазин);

КонецПроцедуры

#КонецОбласти

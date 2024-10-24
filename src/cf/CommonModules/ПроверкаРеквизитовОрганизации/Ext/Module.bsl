﻿
#Область ПрограммныйИнтерфейс

// Проверяет заполненность реквизитов основного банковского счета организации и заполняет банковский счет в документе,
// если это необходимо. Вызывается из события формы документа ПередЗаписьюНаСервере
//
// Параметры:
//  Организация  - СправочникСсылка.Организации - Организация, для которой требуется выполнить проверку
//  Счет         - СправочникСсылка.БанковскиеСчета - банковский счет, выбранный в документе
//  ИспользоватьНесколькоБанковскихСчетовОрганизации - Булево - значение одноименной функциональной опции
//  Отказ        - Булево - Флаг отказа от продолжения работы после выполнения проверки заполнения
//  ПараметрыЗаписи - Структура - содержит параметры записи из события формы документа ПередЗаписьюНаСервере
// ВыводитьПредупреждение - Булево - признак необходимости вывода предупреждения о незаполненном банковском счете
//
Процедура ПередЗаписьюНаСервере(Организация, Счет, ИспользоватьНесколькоБанковскихСчетовОрганизации, Отказ, ПараметрыЗаписи, ВыводитьПредупреждение = Истина) Экспорт
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение
		И НЕ ИспользоватьНесколькоБанковскихСчетовОрганизации
		И НЕ ЗначениеЗаполнено(Счет) Тогда
		
		ОсновнойБанковскийСчетОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ОсновнойБанковскийСчет");
		
		Если НЕ ЗначениеЗаполнено(ОсновнойБанковскийСчетОрганизации) Тогда
			Если ВыводитьПредупреждение Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Реквизиты банковского счета не заполнены'"),, "РеквизитыОрганизацииСсылка",, Отказ);
			КонецЕсли;
		Иначе
			Счет = ОсновнойБанковскийСчетОрганизации;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет заполненность реквизитов основного банковского счета организации, если это необходимо.
// Вызывается из события модуля документа ОбработкаПроверкиЗаполнения
//
// Параметры
//  Организация  - СправочникСсылка.Организации - Организация, для которой требуется выполнить проверку
//  Счет         - СправочникСсылка.БанковскиеСчета - банковский счет, выбранный в документе
//  ИспользоватьНесколькоБанковскихСчетовОрганизации - Булево - значение одноименной функциональной опции
//  Отказ        - Булево - Флаг отказа от продолжения работы после выполнения проверки заполнения
//
Процедура ОбработкаПроверкиЗаполнения(Организация, Счет, ИспользоватьНесколькоБанковскихСчетовОрганизации, Отказ) Экспорт
	
	Если НЕ ИспользоватьНесколькоБанковскихСчетовОрганизации
		И НЕ ЗначениеЗаполнено(Счет) Тогда
		
		Если НЕ ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ОсновнойБанковскийСчет")) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Реквизиты банковского счета не заполнены'"), ,"РеквизитыОрганизацииСсылка", ,Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОсновнойБанковскийСчетОрганизацииЗаполнен(Организация) Экспорт
	
	ОсновнойБанковскийСчет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ОсновнойБанковскийСчет");
	
	Возврат ЗначениеЗаполнено(ОсновнойБанковскийСчет);
	
КонецФункции

Функция СтрокаСообщенияНеЗаполненБанковскийСчет() Экспорт
	
	Возврат Новый ФорматированнаяСтрока(
		НСтр("ru = 'Укажите основной банковский счет в '"),
		Новый ФорматированнаяСтрока(НСтр("ru = 'реквизитах организации'"),,,,"РеквизитыОрганизацииСсылка"));
	
КонецФункции

Функция РеквизитыДляОтчетностиЗаполнены(ИмяОтчета, Организация, ПериодОтчета, НезаполненныеРеквизиты) Экспорт
	
	ПроверяемыеРеквизиты = РегламентированнаяОтчетностьБП.РеквизитыОбязательныеДляОтчета(ИмяОтчета,
		Организация,
		ПериодОтчета);
	
	Если ЗначениеЗаполнено(ПроверяемыеРеквизиты) Тогда
		Возврат ОрганизацииФормыДляОтчетности.РеквизитыЗаполнены(Организация, ПроверяемыеРеквизиты, НезаполненныеРеквизиты);
	Иначе // Проверять нечего
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Функция возвращает строку с сообщением о необходимости дозаполнить реквизиты для отчетности
// 
// Параметры:
//    ТекстДействия - Строка, Неопределено - Текст, который необходимо подставить в строку, например "подготовить отчет"
// 
// Возвращаемое значение:
//    Форматированная строка
//
Функция СтрокаСообщенияНеЗаполненыРеквизитыДляОтчетности(Организация, ТекстДействия = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
	Иначе
		ЮридическоеФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЮридическоеФизическоеЛицо");
	КонецЕсли;
	
	Если ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		ТекстОписанияСведений = НСтр("ru = 'сведения о себе'");
	Иначе
		ТекстОписанияСведений = НСтр("ru = 'сведения об организации'");
	КонецЕсли;
	
	ГиперссылкаСведенияОСебе = Новый ФорматированнаяСтрока(ТекстОписанияСведений,,,,"РеквизитыОрганизацииДляОтчетности");
	
	Если ТекстДействия = Неопределено Тогда
		ТекстДействия = НСтр("ru = 'подготовить отчет'");
	КонецЕсли;
	
	ЭлементыСообщенияОбОшибке = Новый Массив;
	ЭлементыСообщенияОбОшибке.Добавить(СтрШаблон(НСтр("ru = 'Чтобы %1, укажите'"), ТекстДействия));
	ЭлементыСообщенияОбОшибке.Добавить(" ");
	ЭлементыСообщенияОбОшибке.Добавить(ГиперссылкаСведенияОСебе);
	
	Возврат Новый ФорматированнаяСтрока(ЭлементыСообщенияОбОшибке);
	
КонецФункции

Функция ТекстОшибкиЗаполненияРеквизитов(Организация, НезаполненныеРеквизиты, ТекстОписанияОбъектаПроверки = Неопределено, ВыводитьОписаниеВсехРеквизитов = Ложь) Экспорт
	
	Если ТекстОписанияОбъектаПроверки = Неопределено Тогда
		ТекстОписанияОбъектаПроверки = НСтр("ru = 'отчета'");
	КонецЕсли;
	
	ЭтоЮрлицо = ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Организация);
	
	ЮридическоеФизическоеЛицо = ?(ЭтоЮрлицо, Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо, Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
	
	// Если не заполнено 3 реквизита или менее - перечисляем их явно.
	// Если больше - ограничиваемся общим текстом.
	
	Если ТипЗнч(НезаполненныеРеквизиты) = Тип("Массив")
		И (НезаполненныеРеквизиты.Количество() <= 3 Или ВыводитьОписаниеВсехРеквизитов) Тогда
		
		ЗаголовкиНезаполненных = Новый Массив;
		
		// Названия незаполненных реквизитов перечисляем в порядке их следования на форме.
		ОписаниеРеквизитов = ОрганизацииФормыДляОтчетности.ОписаниеРеквизитовФормы(ЮридическоеФизическоеЛицо);
		
		Для каждого ОписаниеРеквизита Из ОписаниеРеквизитов Цикл
			Если НезаполненныеРеквизиты.Найти(ОписаниеРеквизита.Имя) <> Неопределено Тогда
				ЗаголовкиНезаполненных.Добавить(ОписаниеРеквизита.Заголовок);
			КонецЕсли;
		КонецЦикла;
		
		СтрокаРеквизиты = СтрСоединить(ЗаголовкиНезаполненных, ", ");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не заполнены реквизиты %1, необходимые для %2: %3'"),
			?(ЭтоЮрлицо, НСтр("ru = 'организации'"), НСтр("ru = 'предпринимателя'")),
			ТекстОписанияОбъектаПроверки,
			СтрокаРеквизиты);
		
	Иначе
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не заполнены реквизиты %1, необходимые для %2'"),
			?(ЭтоЮрлицо, НСтр("ru = 'организации'"), НСтр("ru = 'предпринимателя'")),
			ТекстОписанияОбъектаПроверки);
		
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

Процедура СообщитьОбОшибкеЗаполненияРеквизитовДляОтчетности(Организация, НезаполненныеРеквизиты, ИмяЭлементаФормы, Отказ, ТекстОписанияОбъектаПроверки = Неопределено) Экспорт
	
	ТекстСообщения = ТекстОшибкиЗаполненияРеквизитов(
		Организация, НезаполненныеРеквизиты, ТекстОписанияОбъектаПроверки);
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , ИмяЭлементаФормы, , Отказ);
	
КонецПроцедуры

#КонецОбласти


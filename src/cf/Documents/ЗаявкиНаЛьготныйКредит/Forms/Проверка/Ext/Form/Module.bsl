﻿

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) 
		И РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
		Модуль 		= ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
		Организация = Модуль.ОрганизацияПоУмолчанию();
		
		ОрганизацияПриИзмененииНаСервере();
		
	КонецЕсли;
	
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ЗапускПроверкиОрганизации();
	КонецЕсли;
	
	ЛьготныеКредитыКлиент.ПолучитьБанки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИзмениласьОрганизация = 
		ИмяСобытия = "Запись_Организации" 
		И ТипЗнч(Источник) = Тип("СправочникСсылка.Организации") 
		И Источник = Организация;
	
	Если ИзмениласьОрганизация Тогда
		
		ОрганизацияПриИзменении(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура БанкиСсылкаНажатие(Элемент)
	
	ЛьготныеКредитыКлиент.БанкиСсылкаНажатие(ЭтотОбъект);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Проверить(Команда)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Укажите организацию'"));
		Возврат;
	КонецЕсли;
	
	ЗапускПроверкиОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапускПроверкиОрганизации()
	
	Если Не ЗначениеЗаполнено(ИНН) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Укажите ИНН организации'"));
		Возврат;
	КонецЕсли;
	
	ОчиститьРезультатыПроверки();
	
	ВыполняетсяПроверка = Истина;
	ПроверкаВыполнена = Ложь;
	
	ИзменитьОформлениеФормы();
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьОрганизацию", 1, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьРезультатыПроверки()
	
	РаботаетВПострадавшейОтрасли = Ложь;
	РаботаетБолееГода = Ложь;
	Действующая = Ложь;
	ЧисленностьСотрудников = 0;
	ЛимитКредита = 0;
	ОрганизацияПострадалаОтПандемии = Ложь;
	ТекстОшибкиПроверкиОрганизации = "";
	ЕстьЗаявка = Ложь;
	Банк = "";
	СтатусЗаявки = Неопределено;
	ТекстОшибкиСервера = "";
	ПроверкаВыполнена = Ложь;
	ВыполняетсяПроверка = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ОчиститьРезультатыПроверки();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Реквизиты = Документы.ЗаявкиНаЛьготныйКредит.РеквизитыОрганизации(Организация);
		ИНН = Реквизиты.ИННЮЛ;
	Иначе
		ИНН = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверкаОрганизации

&НаКлиенте
Процедура Подключаемый_ПроверитьОрганизацию()
	ПроверитьОрганизацию();
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОрганизацию()
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПроверитьОрганизацию_ПроверитьСостояние",
		ЭтотОбъект); 
		
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.Интервал = 1;
	
	ДлительнаяОперация = НачатьПроверкуОрганизации();
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОрганизацию_ПроверитьСостояние(ДлительнаяОперация, ВходящийКонтекст) Экспорт
	
	Если ДлительнаяОперация <> Неопределено И
		(ДлительнаяОперация.Статус = "Выполнено") Тогда
		
		Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Результат);
		ТекстОшибкиСервера = Результат.ОписаниеОшибки;
		
		Если НЕ ЗначениеЗаполнено(ТекстОшибкиСервера) Тогда
			ОпределитьТекстОшибкиПроверкиОрганизации();
		КонецЕсли;
		
		ВыполняетсяПроверка = Ложь;
		ПроверкаВыполнена = Истина;
		
		ИзменитьОформлениеФормы();
			
	ИначеЕсли ДлительнаяОперация = Неопределено
		ИЛИ ДлительнаяОперация.Статус = "Ошибка" Тогда
		
		ВыполняетсяПроверка = Ложь;
		ПроверкаВыполнена = Ложь;
		
		ИзменитьОформлениеФормы();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НачатьПроверкуОрганизации()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = Проверка, может ли организация подать заявку на льготный кредит'");
	ПараметрыВыполнения.ОжидатьЗавершение = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Документы.ЗаявкиНаЛьготныйКредит.ПроверитьДоступностьКредитаВФоне", 
		ИНН, 
		ПараметрыВыполнения);

КонецФункции

#КонецОбласти

&НаСервере
Процедура ИзменитьОформлениеФормы()
	
	ИзменитьОформлениеРезультатаПроверки();
	ИзменитьОформлениепанелиПроверки();
	ИзменитьОформлениеОрганизации();
	ИзменитьОформлениеЧисленности();
	ИзменитьОформлениеЛимита();
	ИзменитьОформлениеЗаявки();
	ИзменитьОформлениеБанков();
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеРезультатаПроверки()
	
	Если ОрганизацияПострадалаОтПандемии И НЕ ЗначениеЗаполнено(ТекстОшибкиПроверкиОрганизации) Тогда
		Элементы.РезультатПроверки.Заголовок = 
			НСтр("ru = 'По данным ФНС, организация соответствует критериям, дающим право на получение льготного кредита.'")
			+ Символы.ПС + Символы.ПС;
		Элементы.РезультатПроверки.ЦветТекста = Новый Цвет;
	Иначе
		Элементы.РезультатПроверки.Заголовок = ТекстОшибкиПроверкиОрганизации;
		Элементы.РезультатПроверки.ЦветТекста = ЦветаСтиля.ЦветОшибкиОтправкиБРО;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениепанелиПроверки()
	
	ПоказатьРезультатПроверки = 
		ЗначениеЗаполнено(Организация) 
		И НЕ ВыполняетсяПроверка
		И ПроверкаВыполнена
		И (ОрганизацияПострадалаОтПандемии ИЛИ ЗначениеЗаполнено(ТекстОшибкиПроверкиОрганизации));
		
	Элементы.ГруппаРезультатПроверки.Видимость = ПоказатьРезультатПроверки;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеЧисленности()
	
	Элементы.Численность.Заголовок = Строка(ЧисленностьСотрудников) + НСтр("ru = ' чел.'");
	Элементы.ГруппаЧисленность.Видимость = НЕ ЗначениеЗаполнено(ТекстОшибкиПроверкиОрганизации) И ОрганизацияПострадалаОтПандемии;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеЛимита()
	
	Элементы.Сумма.Заголовок = НСтр("ru = 'до '") + Строка(ЛимитКредита) + НСтр("ru = ' руб. '");
	Элементы.ГруппаСумма.Видимость = НЕ ЗначениеЗаполнено(ТекстОшибкиПроверкиОрганизации) И ОрганизацияПострадалаОтПандемии;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеОрганизации()
	
	Если ВыполняетсяПроверка Тогда
		ПоказатьБубликПроверки();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) 
		ИЛИ НЕ ЗначениеЗаполнено(ТекстОшибкиСервера) И НЕ ВыполняетсяПроверка Тогда
		СкрытьПанельПроверкиОрганизации();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибкиСервера) И ПроверкаВыполнена Тогда
		ПоказатьТекстОшибкиОрганизации();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СкрытьПанельПроверкиОрганизации()
	
	Элементы.ГруппаПодсказкаОрганизации.Видимость = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьБубликПроверки()
	
	Элементы.ГруппаПодсказкаОрганизации.Видимость = Истина;
	Элементы.Бублик.Видимость = Истина;
	Элементы.ТекстОшибкиСервера.Заголовок = НСтр("ru = 'Пожалуйста, подождите...'");
	Элементы.ТекстОшибкиСервера.ЦветТекста = Новый Цвет();
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьТекстОшибкиПроверкиОрганизации()
	
	Если НЕ ЗначениеЗаполнено(ТекстОшибкиПроверкиОрганизации)
		И НЕ ОрганизацияПострадалаОтПандемии Тогда
		
		Заготовка = НСтр("ru = 'По данным ФНС, организация не соответствует критериям, дающим право на получение льготного кредита'");
		
		Если НЕ РаботаетВПострадавшейОтрасли Тогда
			
			ТекстОшибкиПроверкиОрганизации = 
				Заготовка + ": "
				+ Символы.ПС + НСтр("ru = 'организация не работает в отрасли, пострадавшей от пандемии'");
				
		ИначеЕсли НЕ РаботаетБолееГода Тогда
				
			ТекстОшибкиПроверкиОрганизации = 
				Заготовка + ": "
				+ Символы.ПС + НСтр("ru = 'организация действует менее года в отрасли, пострадавшей от пандемии'");
			
		ИначеЕсли НЕ Действующая Тогда
				
			ТекстОшибкиПроверкиОрганизации = 
				Заготовка + ": "
				+ Символы.ПС + НСтр("ru = 'организация не является действующей'");
			
		ИначеЕсли ЧисленностьСотрудников = 0 Тогда
				
			ТекстОшибкиПроверкиОрганизации = 
				Заготовка + ": "
				+ Символы.ПС + НСтр("ru = 'численность сотрудников равна 0'");
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекстОшибкиОрганизации()
		
	Элементы.ГруппаПодсказкаОрганизации.Видимость = Истина;
	Элементы.Бублик.Видимость = Ложь;
	Элементы.ТекстОшибкиСервера.Заголовок =  ТекстОшибкиСервера;
	Элементы.ТекстОшибкиСервера.ЦветТекста = ЦветаСтиля.ЦветОшибкиОтправкиБРО;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеЗаявки()
	
	Элементы.ГруппаЗаявка.Видимость = ЕстьЗаявка И НЕ ЗначениеЗаполнено(ТекстОшибкиПроверкиОрганизации) И ОрганизацияПострадалаОтПандемии;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеБанков()
	
	ПоказыватьБанки = 
		(СтатусЗаявки = Перечисления.СостоянияЛьготныхЗаявок.ОтклоненоБанком
		ИЛИ НЕ ЗначениеЗаполнено(СтатусЗаявки))
		И НЕ ЗначениеЗаполнено(ТекстОшибкиПроверкиОрганизации);
		
	Элементы.ГруппаБанки.Видимость = ПоказыватьБанки И ОрганизацияПострадалаОтПандемии;
		
КонецПроцедуры

#КонецОбласти









﻿&НаКлиенте
Перем ПараметрыОбработчикаОжиданияАктуализации Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	СформироватьПриОткрытии = Параметры.СформироватьПриОткрытии;
	Если СформироватьПриОткрытии И Не Отчет.РежимРасшифровки Тогда
		// Отключаем стандартное формирование отчета.
		// Формирование отчета запустится в событии ПриОткрытии.
		Параметры.СформироватьПриОткрытии = Ложь;
	КонецЕсли;
	
	КонтекстныйВызов = Параметры.КонтекстныйВызов;
	СрокЗадачи = Параметры.СрокЗадачи;
	
	Если Параметры.Свойство("Период") Тогда
		Отчет.НачалоПериода = НачалоМесяца(Параметры.Период);
		Отчет.КонецПериода = КонецМесяца(Параметры.Период);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		Отчет.Организация = Параметры.Организация;
	КонецЕсли;
	
	Если Не КонтекстныйВызов Тогда
		УстановитьОтборСчетаПоУмолчанию(ЭтотОбъект);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	Если Не ИнформационнаяБазаФайловая Или СформироватьПриОткрытии Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
		ПодключитьОбработчикОжидания("Подключаемый_СформироватьПриОткрытии",
			БухгалтерскиеОтчетыКлиент.ИнтервалЗапускаФормированияОтчетаПриОткрытии(), Истина);
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтотОбъект, Отказ);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(
		ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Отчет.РежимРасшифровки);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.РассылкиОтчетов.Форма.НастройкаРассылкиБП" Тогда
		ОбработкаНастройкиРассылкиОтчета(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки, ИспользуютсяСтандартныеНастройки)
	
	Если ИспользуютсяСтандартныеНастройки Тогда
		Возврат;
	КонецЕсли;
	
	Если Не КомпоновщикИнициализирован Тогда
		ПользовательскиеНастройки = ПоместитьВоВременноеХранилище(Настройки, УникальныйИдентификатор);
		ИнициализироватьКомпоновщикаНастроек();
	КонецЕсли;
	
	Если Не КонтекстныйВызов Тогда
		БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервереВОтчетеРуководителю(
			ЭтотОбъект, Настройки);
	КонецЕсли;
	
	Если ИнформационнаяБазаФайловая Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если КонтекстныйВызов Тогда
		Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
	Иначе
		УстановитьОтборСчетаПоУмолчанию(ЭтотОбъект);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Не КонтекстныйВызов Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из Настройки Цикл
		Если СтрНайти(Элемент.Ключ, "Отчет") <> 0 Тогда
			ЧастиИмени = СтрРазделить(Элемент.Ключ, ".");
			ИмяРеквизита = ЧастиИмени[ЧастиИмени.ВГраница()];
			ЗначениеРеквизита = Неопределено;
			Если Отчет.Свойство(ИмяРеквизита, ЗначениеРеквизита) Тогда
				Настройки[Элемент.Ключ] = ЗначениеРеквизита;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БухгалтерскийУчетКлиентПереопределяемый.ОбработкаОповещенияАктуализации(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация,
		Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтотОбъект, Элемент);
	
	УстановитьОтборСчетаПоУмолчанию(ЭтотОбъект);
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка,
		ПолеОрганизация, СоответствиеОрганизаций);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, 
		СоответствиеОрганизаций, Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если Область.Гиперссылка
		И ТипЗнч(Область.Расшифровка) = Тип("Строка")
		И Лев(Область.Расшифровка, 5) = "e1cib" Тогда
	
		СтандартнаяОбработка = Ложь;
		
		ПерейтиПоНавигационнойСсылке(Область.Расшифровка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(
		ЭтотОбъект, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизации(Элемент)
	
	БухгалтерскиеОтчетыКлиент.НачатьРасчетСуммыВыделенныхЯчеек(
		Элементы.Результат,
		ЭтотОбъект,
		"Подключаемый_РезультатПриАктивизацииПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтотОбъект, Элемент, Ложь);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПараметрыВыбораЗначенияОтбора();
	БухгалтерскиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ПараметрыАктуализации = ЗакрытиеМесяцаКлиентСервер.НовыйПараметрыАктуализацииОтчета();
	ПараметрыАктуализации.Вставить("Организация",                       Отчет.Организация);
	ПараметрыАктуализации.Вставить("ВключатьОбособленныеПодразделения", Отчет.ВключатьОбособленныеПодразделения);
	ПараметрыАктуализации.Вставить("ДатаАктуальности",                  ДатаАктуальности);
	ПараметрыАктуализации.Вставить("ДатаОкончанияАктуализации",         Отчет.КонецПериода);

	ЗакрытиеМесяцаКлиент.ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки(
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ЭтотОбъект,
		ПараметрыАктуализации);
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоДоходыАУСНПриИзменении(Элемент)
	
	Отчет.ПоказыватьТолькоДоходыАУСН = ПоказыватьТолькоДоходыАУСН = 1;
	
	ЗапуститьФормированиеОтчета();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГруппировка

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(
		ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДополнительныеПоля

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(
		ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСортировка

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ЗапуститьФормированиеОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Актуализировать(Команда)
	
	БухгалтерскийУчетКлиентПереопределяемый.Актуализировать(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьАктуализацию(Команда)
	
	БухгалтерскийУчетКлиентПереопределяемый.ОтменитьАктуализацию(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНажатие(Элемент)
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализации(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ПараметрыВыбора.Вставить("ВыборКварталов", Ложь);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	БухгалтерскиеОтчетыКлиент.ОтчетСохранитьКак(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	ОтправкаПочтовыхСообщенийКлиент.ОтправитьОтчет(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРассылкуОтчета(Команда)
	
	ЗаполнитьНастройкиОтчетаДляРассылки();
	
	РассылкаОтчетовБПКлиент.НастроитьРассылкуИзОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализироватьКомпоновщикаНастроек();
	КонецЕсли;
	
	ОткрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьПояснениеКЗадаче(Команда)

	ЗакрытьПояснениеКЗадачеНаСервере();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_СформироватьПриОткрытии()
	
	ЗапуститьФормированиеОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	Название = ?(
		ЗначениеЗаполнено(Форма.ПредставлениеТекущегоВарианта),
		Форма.ПредставлениеТекущегоВарианта,
		НСтр("ru = 'Банковские операции АУСН'"));
	
	ЗаголовокОтчета = Название + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		Отчет.НачалоПериода, Отчет.КонецПериода);
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = СтрШаблон("%1 %2", ЗаголовокОтчета, БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(
			Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения));
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФормированиеОтчета()
	
	ОчиститьСообщения();
	
	ДлительнаяОперация = СформироватьОтчетНаСервере();
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус <> "Ошибка" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		
		ОповещениеоЗавершении = Новый ОписаниеОповещения("СформироватьОтчетЗавершение", ЭтотОбъект);
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеоЗавершении, ПараметрыОжидания);
		
		СкрытьНастройки();
	Иначе
		ПоказатьОшибкиФормирования(ДлительнаяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	БухгалтерскиеОтчеты.ЗаписатьОперациюБизнесСтатистики(
		ЭтотОбъект, "СформироватьОтчет", НастройкиОтчетаДляСтатистики());
	
	Настройки = Отчет.КомпоновщикНастроек.Настройки;
	Настройки.Отбор.ИдентификаторПользовательскойНастройки              = "";
	Настройки.Порядок.ИдентификаторПользовательскойНастройки            = "";
	Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = "";
	Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);

	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания =
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтотОбъект);
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет", ПараметрыОтчета, ПараметрыВыполнения);
	
	ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчетаНаСервере()
	
	ПараметрыОтчета = Отчеты.БанковскиеОперацииАУСН.ПустыеПараметрыКомпоновкиОтчета();
	
	ПараметрыОтчета.НачалоПериода                     = Отчет.НачалоПериода;
	ПараметрыОтчета.КонецПериода                      = Отчет.КонецПериода;
	ПараметрыОтчета.Организация                       = Отчет.Организация;
	ПараметрыОтчета.БанковскийСчет                    = Отчет.БанковскийСчет;
	ПараметрыОтчета.ВключатьОбособленныеПодразделения = Отчет.ВключатьОбособленныеПодразделения;
	ПараметрыОтчета.РазмещениеДополнительныхПолей     = Отчет.РазмещениеДополнительныхПолей;
	ПараметрыОтчета.ПоказыватьТолькоДоходыАУСН        = Отчет.ПоказыватьТолькоДоходыАУСН;
	
	ПараметрыОтчета.Группировка                       = Отчет.Группировка.Выгрузить();
	ПараметрыОтчета.ДополнительныеПоля                = Отчет.ДополнительныеПоля.Выгрузить();
	
	ПараметрыОтчета.ВыводитьЗаголовок                 = ВыводитьЗаголовок;
	ПараметрыОтчета.ВыводитьПодвал                    = ВыводитьПодвал;
	ПараметрыОтчета.МакетОформления                   = МакетОформления;
	ПараметрыОтчета.РежимРасшифровки                  = Отчет.РежимРасшифровки;
	ПараметрыОтчета.ДанныеРасшифровки                 = ДанныеРасшифровки;
	ПараметрыОтчета.СхемаКомпоновкиДанных             = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	ПараметрыОтчета.ИдентификаторОтчета               = БухгалтерскиеОтчеты.ИмяОтчета(ЭтотОбъект);
	ПараметрыОтчета.НастройкиКомпоновкиДанных         = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, Элементы.Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОшибкиФормирования(ДлительнаяОперация)
	
	ЗаписатьОшибкуВЖурналРегистрации(ДлительнаяОперация.ПодробноеПредставлениеОшибки);
	
	СообщениеОбОшибке = СтрШаблон(НСтр("ru = 'Отчет не сформирован! %1'"), ДлительнаяОперация.КраткоеПредставлениеОшибки);
	ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке);
	
	ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
	ОтображениеСостояния.Видимость = Истина;
	ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	ОтображениеСостояния.Текст = СообщениеОбОшибке;
	ОтображениеСостояния.Картинка = Новый Картинка;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки)
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Банковские операции АУСН'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Предупреждение,
		Метаданные.Отчеты.БанковскиеОперацииАУСН,
		,
		ТекстОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетЗавершение(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат; // Отменена
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус <> "Ошибка" Тогда
		ЗагрузитьПодготовленныеДанныеНаСервере(ДлительнаяОперация.АдресРезультата);
		БухгалтерскийУчетКлиентПереопределяемый.ПослеФормированияОтчета(ЭтотОбъект);
	Иначе
		ПоказатьОшибкиФормирования(ДлительнаяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеНаСервере(АдресХранилища)

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат           = РезультатВыполнения.Результат;
	ДанныеРасшифровки   = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаНастройкиРассылкиОтчета(ВыбранноеЗначение)
	
	РассылкаОтчетовБП.ФормаОтчетаОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Функция НастройкиОтчетаДляСтатистики()
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	
	НастройкиДляСтатистики = БухгалтерскиеОтчеты.ПоказателиОтчетаРуководителяДляСтатистики(ПараметрыОтчета);
	
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет);
	
	Возврат ОбщегоНазначенияБП.ЗначениеВСтрокуJSON(НастройкиДляСтатистики, ПараметрыЗаписиJSON);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьНастройкиОтчетаДляРассылки()
	
	// Для получения корректных настроек, необходимо предварительно инициализировать компоновщик настроек.
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализироватьКомпоновщикаНастроек();
	КонецЕсли;
	
	РассылкаОтчетовБП.ЗаполнитьНастройкиОтчетаДляРассылки(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКомпоновщикаНастроек()
	
	БухгалтерскиеОтчетыВызовСервера.ИнициализацияКомпоновщикаНастроек(ЭтотОбъект, Истина, КлючТекущегоВарианта);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройки()
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
КонецПроцедуры

&НаКлиенте
Функция ПараметрыВыбораЗначенияОтбора()
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Организация", Отчет.Организация);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Период");
	
	Если Режим = "Выбор" Тогда
		Для Каждого ДоступноеПоле Из Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Если ДоступноеПоле.Ресурс Тогда
				СписокПолей.Добавить(Строка(ДоступноеПоле.Поле));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Режим = "Группировка" ИЛИ Режим = "Выбор" Тогда
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтотОбъект, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервереБезКонтекста
Функция БанковскийСчетПоУмолчанию(Организация)
	
	Если Справочники.БанковскиеСчета.ИспользуетсяНесколькоБанковскихСчетовОрганизации(Организация) Тогда
		Возврат БухгалтерскийУчетПереопределяемый.ПолучитьБанковскийСчетПоУмолчанию(Организация);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСчетаПоУмолчанию(Форма)
	
	Организация = Форма.Отчет.Организация;
	ОтборПоСчету = Неопределено;
	Если ЗначениеЗаполнено(Организация) Тогда
		ОтборПоСчету = БанковскийСчетПоУмолчанию(Организация);
	КонецЕсли;
	Форма.Отчет.БанковскийСчет = ОтборПоСчету;
	Форма.Элементы.БанковскийСчет.Видимость = ОтборПоСчету <> Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура ЗакрытьПояснениеКЗадачеНаСервере()

	ОбщегоНазначенияБП.ЗаписатьДанныеВХранилище(
		ВладелецХранилищаДанных(),
		Ложь,
		СтрШаблон(ШаблонКлючаХраненияСостоянияПоясненияЗадачи(), Формат(Отчет.НачалоПериода, "ДФ=MM_yyyy;")));
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПоказыватьПояснениеЗадачи(КонтекстныйВызов, Период)

	ДанныеИзХранилища = ОбщегоНазначенияБП.ПрочитатьДанныеИзХранилища(
		ВладелецХранилищаДанных(),
		СтрШаблон(ШаблонКлючаХраненияСостоянияПоясненияЗадачи(), Формат(Период, "ДФ=MM_yyyy;")));
	
	Если ДанныеИзХранилища = Неопределено Тогда
		Возврат КонтекстныйВызов;
	КонецЕсли;
	
	Возврат (ДанныеИзХранилища = Истина);
	
КонецФункции

&НаСервереБезКонтекста
Функция ШаблонКлючаХраненияСостоянияПоясненияЗадачи()

	Возврат "Видимость_%1";
КонецФункции

&НаСервереБезКонтекста
Функция ВладелецХранилищаДанных()

	Возврат "ПроверкаБанковскихОперацийАУСН";

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	КонтекстныйВызов = Форма.КонтекстныйВызов;
	Отчет = Форма.Отчет;
	БанковскиеСчета = Форма.Параметры.БанковскиеСчетаДляСверки;
	КоличествоБанковскихСчетов = БанковскиеСчета.Количество();
	Если КоличествоБанковскихСчетов > 0 Тогда
		// Пользуемся тем, что список счетов упорядочен по пометке от Ложь к Истина.
		ЕстьБанкБезИнтеграции = Не БанковскиеСчета[0].Пометка;
		ЕстьБанкСИнтеграцией = БанковскиеСчета[КоличествоБанковскихСчетов - 1].Пометка;
		
	Иначе
		
		ЕстьБанкБезИнтеграции = Истина;
		ЕстьБанкСИнтеграцией = Ложь;
		
	КонецЕсли;
		
	Элементы.ГруппаПоясненияКЗадаче.Видимость = ЕстьБанкБезИнтеграции
		И ПоказыватьПояснениеЗадачи(КонтекстныйВызов, Отчет.НачалоПериода);
	
	Если ЕстьБанкБезИнтеграции И КонтекстныйВызов Тогда
		
		ТекстПояснения = Новый Массив;
		ТекстПояснения.Добавить(НСтр("ru = 'Банк передаёт в налоговый орган сведения о проведенных операциях, на основании которых будет рассчитана сумма налога.'"));
		Если ЕстьБанкСИнтеграцией Тогда
		
			МногоБанковБезИнтеграции = (КоличествоБанковскихСчетов > 1) И Не БанковскиеСчета[1].Пометка;
			Если МногоБанковБезИнтеграции Тогда
				ТекстПояснения.Добавить(НСтр("ru = 'Есть банки, у которых отсутствует интеграция с 1С.'"));
			Иначе
				ТекстПояснения.Добавить(
					СтрШаблон(НСтр("ru = 'У банка <b>%1</b> отсутствует интеграция с 1С.'"), БанковскиеСчета[0].Представление));
			КонецЕсли;
		
		КонецЕсли;
		ТекстПояснения.Добавить(
			НСтр("ru = 'Вы можете скорректировать сведения об операциях через личный кабинет банка не позднее <b>%1</b>'"));
		
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
			ЗаголовокПояснениеКЗадаче = СтроковыеФункции.ФорматированнаяСтрока(СтрСоединить(ТекстПояснения, Символы.ПС),
				Формат(Форма.СрокЗадачи, "ДЛФ=DD;"));
		#Иначе
			ЗаголовокПояснениеКЗадаче = СтроковыеФункцииКлиент.ФорматированнаяСтрока(СтрСоединить(ТекстПояснения, Символы.ПС),
				Формат(Форма.СрокЗадачи, "ДЛФ=DD;"));
		#КонецЕсли
		
		Элементы.ПояснениеКЗадаче.Заголовок = ЗаголовокПояснениеКЗадаче;
		
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(Форма);
	
	ПрименяетсяАУСНДоходыЗаПериод = ПрименяетсяАУСНДоходыЗаПериод(Отчет.Организация, Отчет.НачалоПериода, Отчет.КонецПериода);
	
	Форма.ПоказыватьТолькоДоходыАУСН = ?(ПрименяетсяАУСНДоходыЗаПериод, 1, 0);
	
	Отчет.ПоказыватьТолькоДоходыАУСН = ПрименяетсяАУСНДоходыЗаПериод;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"ТолькоДоходыАУСН",
		"Видимость",
		Отчет.ПоказыватьТолькоДоходыАУСН);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьАктуальность()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьАктуальность(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеАктуализации()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьВыполнениеАктуализацииОтчета(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьЗавершениеАктуализации()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьЗавершениеАктуализации(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеМесяцаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "СформироватьОтчет" Тогда
		
		БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализации(ЭтотОбъект);
		Активизировать();
		СформироватьОтчет("");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрименяетсяАУСНДоходыЗаПериод(Знач Организация, Знач НачалоПериода, Знач КонецПериода)
	
	Возврат УчетнаяПолитика.ПрименяетсяАУСНДоходыЗаПериод(Организация, НачалоПериода, КонецПериода);
	
КонецФункции

#КонецОбласти
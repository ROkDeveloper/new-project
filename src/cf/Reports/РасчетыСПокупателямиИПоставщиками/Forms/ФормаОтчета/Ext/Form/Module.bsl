﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжиданияАктуализации Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СформироватьПриОткрытии = Параметры.СформироватьПриОткрытии;
	Если СформироватьПриОткрытии И Не Отчет.РежимРасшифровки Тогда
		// Отключаем стандартное формирование отчета.
		// Формирование отчета запустится в событии ПриОткрытии.
		Параметры.СформироватьПриОткрытии = Ложь;
	КонецЕсли;
	
	БыстрыеНастройкиОтчетовСервер.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ИнформационнаяБазаФайловая Или СформироватьПриОткрытии Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
		ПодключитьОбработчикОжидания("Подключаемый_СформироватьПриОткрытии",
			БухгалтерскиеОтчетыКлиент.ИнтервалЗапускаФормированияОтчетаПриОткрытии(), Истина);
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Отчет.РежимРасшифровки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки, ИспользуютсяСтандартныеНастройки)
	
	Если ИспользуютсяСтандартныеНастройки Тогда
		Возврат;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервереВОтчетеРуководителю(
		ЭтотОбъект, Настройки);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если ИнформационнаяБазаФайловая Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.УстановитьНастройкиПоУмолчанию(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БухгалтерскийУчетКлиентПереопределяемый.ОбработкаОповещенияАктуализации(
		ЭтотОбъект, Отчет.Организация, Отчет.Период, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.РассылкиОтчетов.Форма.НастройкаРассылкиБП" Тогда
		ОбработкаНастройкиРассылкиОтчета(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(
			Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация,
		Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтаФорма, Элемент);
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);
	
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
Процедура ПредложениеПоделитьсяМнениемОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтправитьОтзывПоЭлектроннойПочте", ЭтотОбъект);
	РаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);

КонецПроцедуры

#Область ОбработчикиСобытийГруппыГруппировка

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
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
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийГруппыОтборы

&НаКлиенте
Процедура НастройкаСчетовУчетаРасчетовНажатие(Элемент)
	
	БухгалтерскиеОтчетыКлиент.РедактироватьСписокСчетовИсключаемыхИзРасчетаЗадолженности(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент, Ложь);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	БухгалтерскиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(
		ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийГруппыДополнительныеПоля

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(
			Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(
			Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(
		ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
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

#КонецОбласти

#Область ОбработчикиСобытийГруппыСортировка

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийГруппыОформление

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(
		Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовБыстрогоОформления

&НаКлиенте
Процедура МакетОформленияБыстрыеНастройкиПриИзменении(Элемент)
		
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки,
		"МакетОформления", МакетОформления);
	
	ПриИзмененииНастройки();

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокБыстрыеНастройкиПриИзменении(Элемент)
	
	ПриИзмененииНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалБыстрыеНастройкиПриИзменении(Элемент)
	
	ПриИзмененииНастройки();

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийПоляТабличногоДокументаРезультат

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
		ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
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

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ЗапуститьФормированиеОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьАктуальность()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьАктуальность(ЭтотОбъект, Отчет.Организация, Отчет.Период);

КонецПроцедуры

&НаКлиенте
Процедура Актуализировать(Команда)
	
	БухгалтерскийУчетКлиентПереопределяемый.Актуализировать(ЭтотОбъект, Отчет.Организация, Отчет.Период);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеАктуализации()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьВыполнениеАктуализацииОтчета(
		ЭтотОбъект, Отчет.Организация, Отчет.Период);

КонецПроцедуры

&НаКлиенте
Процедура ОтменитьАктуализацию(Команда)
	
	БухгалтерскийУчетКлиентПереопределяемый.ОтменитьАктуализацию(ЭтотОбъект, Отчет.Организация, Отчет.Период);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ПараметрыАктуализации = ЗакрытиеМесяцаКлиентСервер.НовыйПараметрыАктуализацииОтчета();
	ПараметрыАктуализации.Вставить("Организация",                       Отчет.Организация);
	ПараметрыАктуализации.Вставить("ВключатьОбособленныеПодразделения", Отчет.ВключатьОбособленныеПодразделения);
	ПараметрыАктуализации.Вставить("ДатаАктуальности",                  ДатаАктуальности);
	ПараметрыАктуализации.Вставить("ДатаОкончанияАктуализации",         Отчет.Период);

	ЗакрытиеМесяцаКлиент.ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки(
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ЭтотОбъект,
		ПараметрыАктуализации);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеМесяцаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "СформироватьОтчет" Тогда
		
		БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализации(ЭтотОбъект);
		Активизировать();
		СформироватьОтчет("");
		
	КонецЕсли;
	
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
Процедура СкрытьНажатие(Элемент)
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализации(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьЗавершениеАктуализации()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьЗавершениеАктуализации(ЭтотОбъект, Отчет.Организация, Отчет.Период);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ОткрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРассылкуОтчета(Команда)
	
	ЗаполнитьНастройкиОтчетаДляРассылки();
	
	РассылкаОтчетовБПКлиент.НастроитьРассылкуИзОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьБыстрыеНастройки(Команда)

	БыстрыеНастройкиОтчетовКлиент.ПереключитьВидимостьБыстрыхНастроек(ЭтотОбъект);
	
	Если ПоказыватьБыстрыеНастройки Тогда 
		ПоказатьБыстрыеНастройкиНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьПараметрыОтчетаНаСервере()
	
	ПараметрыОтчета = Отчеты.РасчетыСПокупателямиИПоставщиками.ПустыеПараметрыКомпоновкиОтчета();
	
	ПараметрыОтчета.Период                            = Отчет.Период;
	ПараметрыОтчета.Организация                       = Отчет.Организация;
	ПараметрыОтчета.ВключатьОбособленныеПодразделения = Отчет.ВключатьОбособленныеПодразделения;
	ПараметрыОтчета.РазмещениеДополнительныхПолей     = Отчет.РазмещениеДополнительныхПолей;
	ПараметрыОтчета.Группировка                       = Отчет.Группировка.Выгрузить();
	ПараметрыОтчета.ДополнительныеПоля                = Отчет.ДополнительныеПоля.Выгрузить();
	
	ПараметрыОтчета.ВыводитьЗаголовок                 = ВыводитьЗаголовок;
	ПараметрыОтчета.ВыводитьПодвал                    = ВыводитьПодвал;
	ПараметрыОтчета.МакетОформления                   = МакетОформления;
	ПараметрыОтчета.РежимРасшифровки                  = Отчет.РежимРасшифровки;
	ПараметрыОтчета.ДанныеРасшифровки                 = ДанныеРасшифровки;
	ПараметрыОтчета.СхемаКомпоновкиДанных             = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	ПараметрыОтчета.ИдентификаторОтчета               = БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтотОбъект);
	ПараметрыОтчета.НастройкиКомпоновкиДанных         = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	Название = ?(ЗначениеЗаполнено(Форма.ПредставлениеТекущегоВарианта), Форма.ПредставлениеТекущегоВарианта,
		НСтр("ru = 'Расчеты с покупателями и поставщиками'"));
	ЗаголовокОтчета = СтрШаблон(НСтр("ru = '%1 на %2'"), Название, Формат(Отчет.Период, "ДЛФ=D"));

	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = СтрШаблон(НСтр("ru = '%1 %2'"), ЗаголовокОтчета,
			БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(
				Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения));
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Период");
	СписокПолей.Добавить("ИспользоватьСрокиОплаты");
	СписокПолей.Добавить("Счет");
	СписокПолей.Добавить("ЭтоАванс");
	
	Если Режим = "Группировка" ИЛИ Режим = "Выбор" Тогда
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

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
	
	Возврат РезультатВыполнения;
	
КонецФункции

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
Процедура ОткрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
	// Обновим панель быстрых настроек, если она видна
	Если ПоказыватьБыстрыеНастройки Тогда
		ПоказатьБыстрыеНастройкиНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора()
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Организация"       , Отчет.Организация);
	СписокПараметров.Вставить("Контрагент"        , Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_СформироватьПриОткрытии()
	
	ЗапуститьФормированиеОтчета();
	
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
		
		ОписаниеОповещения = Новый ОписаниеОповещения("СформироватьОтчетЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
		
		СкрытьНастройки();
	Иначе
		ПоказатьОшибкиФормирования(ДлительнаяОперация);
	КонецЕсли;
	
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
		НСтр("ru = 'Отчеты руководителя.Расчеты с покупателями и посатвщиками'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Предупреждение,
		Метаданные.Отчеты.РасчетыСПокупателямиИПоставщиками,
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
	Иначе
		ПоказатьОшибкиФормирования(ДлительнаяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаНастройкиРассылкиОтчета(ВыбранноеЗначение)
	
	РассылкаОтчетовБП.ФормаОтчетаОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиОтчетаДляРассылки()
	
	РассылкаОтчетовБП.ЗаполнитьНастройкиОтчетаДляРассылки(ЭтотОбъект);
	
КонецПроцедуры

#Область БизнесСтатистика

&НаСервере
Функция НастройкиОтчетаДляСтатистики()
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	
	НастройкиДляСтатистики = БухгалтерскиеОтчеты.ПоказателиОтчетаРуководителяДляСтатистики(ПараметрыОтчета);
	
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет);
	
	Возврат ОбщегоНазначенияБП.ЗначениеВСтрокуJSON(НастройкиДляСтатистики, ПараметрыЗаписиJSON);
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ПоказатьБыстрыеНастройкиНаСервере()
	
	ГруппыНастроек = Новый Структура;
	ГруппыНастроек.Вставить("Отбор", Элементы.БыстрыеОтборы);
	ГруппыНастроек.Вставить("Оформление", Элементы.БыстроеОформление);

	БыстрыеНастройкиОтчетовСервер.ПоказатьБыстрыеНастройкиНаСервере(ЭтотОбъект, ГруппыНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииНастройки()

	Если Отчет.ФормироватьОтчетПриИзмененииНастроек Тогда
		ЗапуститьФормированиеОтчета();
	Иначе
		Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОчисткаОтбора(Элемент)
	
	Если Не СоответствиеПолейОтчетаИРеквизитов.Свойство(Элемент.Имя) Тогда
		Возврат;
	КонецЕсли;

	ИмяРеквизита = Элемент.Имя;
	ОчиститьОтборНаСервере(ИмяРеквизита);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьОтборПриИзменении(Элемент)
	
	Если Не СоответствиеПолейОтчетаИРеквизитов.Свойство(Элемент.Имя) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизита = Элемент.Имя;
	УстановитьОтборПриИзмененииНаСервере(ИмяРеквизита);

	ПриИзмененииНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	БыстрыеНастройкиОтчетовКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора,
		СтандартнаяОбработка, СписокПараметров);

КонецПроцедуры

&НаСервере
Процедура ОчиститьОтборНаСервере(ИмяРеквизита)
	
	БыстрыеНастройкиОтчетовСервер.ОчиститьОтборНаСервере(ЭтотОбъект, ИмяРеквизита);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПриИзмененииНаСервере(ИмяРеквизита)

	ГруппыНастроек = Новый Структура;
	ГруппыНастроек.Вставить("Отбор", Элементы.БыстрыеОтборы);
	
	БыстрыеНастройкиОтчетовСервер.УстановитьОтборПриИзмененииНаСервере(ЭтотОбъект, ГруппыНастроек, ИмяРеквизита);
	
КонецПроцедуры

#Область ОбратнаяСвязь

&НаКлиенте
Процедура ОтправитьОтзывПоЭлектроннойПочте(УчетнаяЗаписьНастроена, ДополнительныеПараметры) Экспорт
	
	Если УчетнаяЗаписьНастроена <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	БыстрыеНастройкиОтчетовКлиент.ОтправитьОтзывПоЭлектроннойПочте();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
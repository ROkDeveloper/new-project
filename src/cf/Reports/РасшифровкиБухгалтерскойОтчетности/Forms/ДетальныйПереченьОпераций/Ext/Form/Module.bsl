﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РегламентированныйОтчет = Параметры.РегламентированныйОтчет;
	ИмяМакетаОтчета = Параметры.ИмяМакетаОтчета;
	ПрефиксИдентификатораДанных = Параметры.ПрефиксИдентификатораДанных;
	
	Заголовок = Параметры.ЗаголовокОтчета;
	
	НомерСекции = 1;
	СформироватьСтраницуПеречня();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеДокументаОтчетаВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если СтрНайти(Область.Имя, "Навигация") = 1 Тогда
		ПерейтиНаСегментОтчета(Область.Имя);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПерейтиНаСегментОтчета(ИмяКомандыПерехода)
	
	ВыборкаСегментов = ВыборкаСегментовОтчета();
	ВсегоСегментов = ВыборкаСегментов.Количество();
	
	АктивныйСегмент = НомерСекции;
	
	Если ИмяКомандыПерехода = "НавигацияПервый"
	   И АктивныйСегмент <> 1 Тогда
		НомерСекции = 1;
		СформироватьСтраницуПеречня();
	КонецЕсли;
	
	Если ИмяКомандыПерехода = "НавигацияПредыдущий"
	   И АктивныйСегмент > 1 Тогда
		НомерСекции = НомерСекции - 1;
		СформироватьСтраницуПеречня();
	КонецЕсли;
	
	Если ИмяКомандыПерехода = "НавигацияСледующий"
	   И АктивныйСегмент < ВсегоСегментов Тогда
		НомерСекции = НомерСекции + 1;
		СформироватьСтраницуПеречня();
	КонецЕсли;
	
	Если ИмяКомандыПерехода = "НавигацияПоследний"
	   И АктивныйСегмент <> ВсегоСегментов Тогда
		НомерСекции = ВсегоСегментов;
		СформироватьСтраницуПеречня();
	КонецЕсли;
	
КонецПроцедуры

#Область ИнтерфейсОбращенияКМодулюМенеджера

&НаСервере
Процедура СформироватьСтраницуПеречня()
	
	КонтекстФормирования = Отчеты.РасшифровкиБухгалтерскойОтчетности.НовыйКонтекстФормирования();
	КонтекстФормирования.РегламентированныйОтчет = РегламентированныйОтчет;
	КонтекстФормирования.ПрефиксИдентификатораДанных = ПрефиксИдентификатораДанных;
	КонтекстФормирования.НомерСекции = НомерСекции;
	КонтекстФормирования.ИмяМакетаОтчета = ИмяМакетаОтчета;
	КонтекстФормирования.ПолеДокументаОтчета = ПолеДокументаОтчета;
	
	Отчеты.РасшифровкиБухгалтерскойОтчетности.СформироватьСтраницуПеречняБанковскихОпераций(
		КонтекстФормирования);
	
КонецПроцедуры

&НаСервере
Функция ВыборкаСегментовОтчета()
	
	Возврат Отчеты.РасшифровкиБухгалтерскойОтчетности.ВыборкаСегментовОтчета(
		РегламентированныйОтчет, ПрефиксИдентификатораДанных);
	
КонецФункции

#КонецОбласти

#КонецОбласти

﻿


#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЛьготныеКредитыКлиент.ПолучитьБанки(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БанкиСсылкаНажатие(Элемент)
	
	ЛьготныеКредитыКлиент.БанкиСсылкаНажатие(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация1ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Документ.ЗаявкиНаЛьготныйКредит.Форма.Проверка", , , Новый УникальныйИдентификатор);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы


#КонецОбласти

#Область ОбработчикиКомандФормы


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти







﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Период     = Параметры.Период;
	КодРегиона = Параметры.КодРегиона;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияПояснениеОбработкаНавигационнойСсылки(Элемент, ТекстСсылки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТекстСсылки = "ОткрытьЗаконРегиона" Тогда
		АдресСтатьиИТС = УчетУСНКлиентСервер.СсылкаНаРазделИТСРегиональныеСтавкиУСН(КодРегиона, Период);
		ПерейтиПоНавигационнойСсылке(АдресСтатьиИТС);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПримерЗаконаНажатие(Элемент)
	Закрыть();
КонецПроцедуры

#КонецОбласти

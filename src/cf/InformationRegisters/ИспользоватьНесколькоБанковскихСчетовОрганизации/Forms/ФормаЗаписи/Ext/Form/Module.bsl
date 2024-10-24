﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Отказ = ОтказИнтерактивногоИзменения(Запись.Организация, Запись.Используется);
	Если Отказ Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'У организации %1 нельзя отключить использование банковских счетов'"),
			Запись.Организация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ОтказИнтерактивногоИзменения(Знач Организация, Знач Используется)
	
	Если Используется ИЛИ НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат РегистрыСведений.ИспользоватьНесколькоБанковскихСчетовОрганизации.ОтказИнтерактивногоИзменения(Организация);
	
КонецФункции

#КонецОбласти

﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	// Приводим периоды к началу месяца.
	Для Каждого Запись Из ЭтотОбъект Цикл
		Запись.Период               = НачалоМесяца(Запись.Период);
		Запись.ПериодВзаиморасчетов = НачалоМесяца(Запись.ПериодВзаиморасчетов);
	КонецЦикла;
	
	УчетНачисленнойЗарплаты.ОчиститьВидыДоходовИсполнительногоПроизводстваНабораЗаписей(ЭтотОбъект, "Период, ПериодВзаиморасчетов");
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
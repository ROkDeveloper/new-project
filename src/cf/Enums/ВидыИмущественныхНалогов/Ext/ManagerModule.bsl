﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция КодНалогаВЗадачахБухгалтера(Налог) Экспорт 

	КодНалога = "";
	
	Если Налог = ТранспортныйНалог Тогда
		КодНалога = ЗадачиБухгалтераКлиентСервер.КодЗадачиТранспортныйНалог();
	ИначеЕсли Налог = ЗемельныйНалог Тогда	
		КодНалога = ЗадачиБухгалтераКлиентСервер.КодЗадачиЗемельныйНалог();
	ИначеЕсли Налог = НалогНаИмущество Тогда	
		КодНалога = ЗадачиБухгалтераКлиентСервер.КодЗадачиНалогНаИмущество();
	КонецЕсли; 

	Возврат КодНалога;
	
КонецФункции

Функция НалогПоЗадачеБухгалтера(ЗадачаБухгалтера) Экспорт 

	Налог = ПустаяСсылка();
	КодНалога = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗадачаБухгалтера, "Код");
	
	Если КодНалога = ЗадачиБухгалтераКлиентСервер.КодЗадачиТранспортныйНалог() Тогда
		Налог = ТранспортныйНалог;
	ИначеЕсли КодНалога = ЗадачиБухгалтераКлиентСервер.КодЗадачиЗемельныйНалог() Тогда
		Налог = ЗемельныйНалог;	
	ИначеЕсли КодНалога = ЗадачиБухгалтераКлиентСервер.КодЗадачиНалогНаИмущество() Тогда
		Налог = НалогНаИмущество;	
	КонецЕсли; 

	Возврат Налог;
	
КонецФункции

#КонецОбласти

#КонецЕсли

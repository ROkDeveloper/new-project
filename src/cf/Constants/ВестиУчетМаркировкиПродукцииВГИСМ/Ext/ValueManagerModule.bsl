﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТарификацияБП.КонстантаФункциональностиПередЗаписью(Метаданные().Имя, Значение, Отказ);

КонецПроцедуры

//ГИСМБП
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Если Значение Тогда
		Константы.ИспользоватьЭлектронныеПодписи.Установить(Истина);
	Иначе
		Константы.ИспользоватьКонтрольныеЗнакиГИСМ.Установить(Ложь);
	КонецЕсли;
	
КонецПроцедуры
//Конец ГИСМБП

#КонецОбласти

#КонецЕсли
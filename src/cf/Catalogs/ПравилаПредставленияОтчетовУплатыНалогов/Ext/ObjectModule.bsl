﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Устанавливает значение свойства ОтправкаОтчетаОграничена в соответствие с информацией о возможностях отправки.
// Следует вызвать до записи объекта.
// Не используется обработчик ПередЗаписью, потому что изменение справочника предполагается в обработчиках обновления,
// при этом запись выполняется в цикле и подлежащее установке значение свойства можно эффективно определить вне цикла.
//
// Параметры:
//  УстанавливаемоеЗначение	 - Булево - Истина, если отправка отчета ограничена.
//                           - Неопределено - процедура сама определит значение.
//
Процедура УстановитьОтправкаОтчетаОграничена(Знач УстанавливаемоеЗначение = Неопределено) Экспорт
	
	// Свойство применяется только для отчетов.
	// Чтобы не проверять это при использовании, сбросим его для не-отчетов.
	Если Действие <> Перечисления.ВидыДействийКалендаряБухгалтера.Отчет Тогда
		ОтправкаОтчетаОграничена = Ложь;
		Возврат;
	КонецЕсли;
	
	Если УстанавливаемоеЗначение = Неопределено Тогда
		
		КодЗадачи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "Код");
		Если Не ЗначениеЗаполнено(КодЗадачи) Тогда
			УстанавливаемоеЗначение = Ложь;
		Иначе
			УстанавливаемоеЗначение = ВыполнениеЗадачБухгалтера.ОтправкаОтчетаОграничена(КодЗадачи, Код);
		КонецЕсли;
		
	КонецЕсли;
	
	ОтправкаОтчетаОграничена = УстанавливаемоеЗначение;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

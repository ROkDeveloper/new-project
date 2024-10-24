﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

Функция ТаблицаСоответствияВидовОплат(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпособыОнлайнОплатыИнтернетМагазина.НаименованиеСпособаОплаты КАК НаименованиеСпособаОплаты,
	|	СпособыОнлайнОплатыИнтернетМагазина.ИдентификаторСпособаОплаты КАК ИдентификаторСпособаОплаты,
	|	СпособыОнлайнОплатыИнтернетМагазина.ВидОплатыПлатежнойКартой КАК ВидОплатыПлатежнойКартой
	|ИЗ
	|	РегистрСведений.СпособыОнлайнОплатыИнтернетМагазина КАК СпособыОнлайнОплатыИнтернетМагазина
	|ГДЕ
	|	СпособыОнлайнОплатыИнтернетМагазина.Организация = &Организация";
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПредставлениеСтрокой(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпособыОнлайнОплатыИнтернетМагазина.НаименованиеСпособаОплаты КАК НаименованиеСпособаОплаты
	|ИЗ
	|	РегистрСведений.СпособыОнлайнОплатыИнтернетМагазина КАК СпособыОнлайнОплатыИнтернетМагазина
	|ГДЕ
	|	СпособыОнлайнОплатыИнтернетМагазина.Организация = &Организация";
	Запрос.УстановитьПараметр("Организация", Организация);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат "";
	Иначе
		Возврат СтрСоединить(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("НаименованиеСпособаОплаты"), ", ");
	КонецЕсли;
	
КонецФункции
#КонецОбласти

#КонецЕсли
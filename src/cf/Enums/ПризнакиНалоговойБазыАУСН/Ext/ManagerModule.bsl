﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает идентификатор признака налоговой базы АУСН в формате ФНС
//
// Параметры:
//  Признак - ПеречислениеСссылка.ПризнакиНалоговойБазыАУСН
//
// Возвращаемое значение:
//  Число - числовой идентификатор признака налоговой базы
//
Функция Идентификатор(Признак) Экспорт
	
	Если Не ЗначениеЗаполнено(Признак) Тогда
		Возврат 0;
	КонецЕсли;
	
	ВсеПризнаки = ВсеПризнакиНалоговойБазы();
	Идентификатор = ВсеПризнаки.Получить(Признак);
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Идентификатор = 0;
	КонецЕсли;
	
	Возврат Идентификатор;
	
КонецФункции

// Возвращает значение перечисления по числовому идентификатору.
//
// Параметры:
//  Идентификатор - Число - идентификатр признака налоговой базы
//
// Возвращаемое значение:
//  ПеречислениеСссылка.ПризнакиНалоговойБазыАУСН - значение перечисления
//
Функция ЗначениеПоИдентификатору(Идентификатор) Экспорт
	
	ВсеПризнаки = ВсеПризнакиНалоговойБазы();
	Для Каждого Признак Из ВсеПризнаки Цикл
		Если Признак.Значение = Идентификатор Тогда
			Возврат Признак.Ключ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВсеПризнакиНалоговойБазы()
	
	Признаки = Новый Соответствие;
	Признаки.Вставить(Приход, 1);
	Признаки.Вставить(ВозвратПрихода, 2);
	Признаки.Вставить(Расход, 3);
	Признаки.Вставить(ВозвратРасхода, 4);
	Признаки.Вставить(НеНалоговаяБаза, 5);
	
	Возврат Признаки; 
	
КонецФункции

#КонецОбласти

#КонецЕсли
﻿
#Область ПрограммныйИнтерфейс

// Проверяет, что расширение выбранного файла поддерживается механизмом загрузки данных из файла.
//
// Параметры:
//   РасширениеФайла - Строка - расширение файла без точки.
//
// Возвращаемое значение:
//   Булево - результат проверки расширения файла среди списка поддерживаемых.
//
Функция РасширениеФайлаПоддерживается(РасширениеФайла) Экспорт
	
	Если ПустаяСтрока(РасширениеФайла) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДопустимыеРасширения = СтрРазделить("xls,xlsx,mxl,ods,csv", ",");
	
	Возврат ДопустимыеРасширения.Найти(НРег(РасширениеФайла)) <> Неопределено;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗаголовкаНесопоставленнойКолонки() Экспорт
	
	Возврат НСтр("ru = 'Укажите реквизит'");
	
КонецФункции

// Процедура управляет состоянием поля табличного документа.
//
// Параметры:
//  ПолеТабличногоДокумента - ПолеФормы - поле формы с видом ПолеТабличногоДокумента,
//                            для которого необходимо установить состояние.
//  Состояние               - Строка - задает вид состояния.
//
Процедура УстановитьСостояниеПоляТабличногоДокумента(ПолеТабличногоДокумента, Состояние = "НеИспользовать") Экспорт
	
	Если ТипЗнч(ПолеТабличногоДокумента) = Тип("ПолеФормы")
		И ПолеТабличногоДокумента.Вид = ВидПоляФормы.ПолеТабличногоДокумента Тогда
		ОтображениеСостояния = ПолеТабличногоДокумента.ОтображениеСостояния;
		Если ВРег(Состояние) = "НЕИСПОЛЬЗОВАТЬ" Тогда
			ОтображениеСостояния.Видимость                      = Ложь;
			ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
			ОтображениеСостояния.Картинка                       = Новый Картинка;
			ОтображениеСостояния.Текст                          = "";
		ИначеЕсли ВРег(Состояние) = "ОЖИДАНИЕ" Тогда
			ОтображениеСостояния.Видимость                      = Истина;
			ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
			ОтображениеСостояния.Картинка                       = БиблиотекаКартинок.ДлительнаяОперация48;
			ОтображениеСостояния.Текст                          = НСтр("ru = 'Пожалуйста, подождите...'");
		Иначе
			ВызватьИсключение(НСтр("ru = 'Недопустимое значение параметра (параметр номер ''2'')'"));
		КонецЕсли;
	Иначе
		ВызватьИсключение(НСтр("ru = 'Недопустимое значение параметра (параметр номер ''1'')'"));
	КонецЕсли;
	
КонецПроцедуры

Функция СтатистикаСтатусовСтрокТаблицы(ТаблицаСоСтатусами) Экспорт
	
	Статистика = Новый Структура("Всего, Найденные, Новые, Дубли", 0, 0, 0, 0);
	
	Если ТипЗнч(ТаблицаСоСтатусами) <> Тип("ДанныеФормыКоллекция") Тогда
		Возврат Статистика;
	КонецЕсли;
	
	Статистика.Всего = ТаблицаСоСтатусами.Количество();
	
	Для Каждого СтрокаТаблицы Из ТаблицаСоСтатусами Цикл
		
		Если СтрокаТаблицы.Статус = СтатусНайденный() Тогда
			Статистика.Найденные = Статистика.Найденные + 1;
		ИначеЕсли СтрокаТаблицы.Статус = СтатусДубль() Тогда
			Статистика.Дубли = Статистика.Дубли + 1;
		ИначеЕсли СтрокаТаблицы.Статус = СтатусНовый() Тогда
			Статистика.Новые = Статистика.Новые + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Статистика;
	
КонецФункции

Функция ТекстСКоличеством(Текст, Количество) Экспорт
	
	Если Количество = 0 Тогда
		Возврат Текст;
	Иначе
		Возврат Текст + " (" + Формат(Количество, "ЧГ=0") + ")";
	КонецЕсли;
	
КонецФункции

#Область СтатусыСтрок

Функция СтатусНайденный() Экспорт
	
	Возврат 0;
	
КонецФункции

Функция СтатусДубль() Экспорт
	
	Возврат 1;
	
КонецФункции

Функция СтатусНовый() Экспорт
	
	Возврат 2;
	
КонецФункции

#КонецОбласти

#КонецОбласти

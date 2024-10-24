﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ЗаполнятьДатуУдержания(Объект) Экспорт
	
	ЗаполнятьДатуУдержания = Ложь;
	
	Если Год(Объект.Месяц) > 2023 Тогда
		ЗаполнятьДатуУдержания = Истина;
	Иначе
		НачалоПередачиЧастичныхУведомленийПоНДФЛ = УчетЗарплаты.ДатаНачалаПередачиЧастичныхУведомленийПоНДФЛ();
		Если ЗначениеЗаполнено(НачалоПередачиЧастичныхУведомленийПоНДФЛ) Тогда
			ЗаполнятьДатуУдержания = (Год(Объект.Месяц) = 2023
			И НачалоМесяца(Объект.Месяц) >= НачалоМесяца(НачалоПередачиЧастичныхУведомленийПоНДФЛ)
			И Объект.Дата >= НачалоПередачиЧастичныхУведомленийПоНДФЛ);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗаполнятьДатуУдержания;
	
КонецФункции

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

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - Массив - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати - СписокЗначений - значение - ссылка на объект.
//                                            представление - имя области, в которой был выведен объект (выходной параметр);
//  ПараметрыВывода - Структура - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроведениеДокумента

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	МенеджерВременныхТаблиц  = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ПодготовитьПараметрыРеквизитыДокумента(Запрос, ПараметрыПроведения, Отказ);
	
	Реквизиты = ПараметрыПроведения.ТаблицаРеквизиты[0];
	Если НЕ УчетнаяПолитика.Существует(Реквизиты.Организация, Реквизиты.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат = Запрос.ВыполнитьПакет();

	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	УдержанныйНДФЛПоДокументу = УчетЗарплаты.УдержанныйНДФЛПоДокументу(Реквизиты.Организация, Реквизиты.Регистратор);
	ПараметрыПроведения.Вставить("УдержанныйНДФЛ", УдержанныйНДФЛПоДокументу);
	
	Возврат ПараметрыПроведения;
	
КонецФункции

Процедура ПодготовитьПараметрыРеквизитыДокумента(Запрос, ПараметрыПроведения, Отказ)
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Месяц КАК Месяц,
	|	Реквизиты.Организация КАК Организация
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.СведенияОбУдержанномНДФЛ КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Период КАК Период,
	|	Реквизиты.Регистратор КАК Регистратор,
	|	Реквизиты.Месяц КАК Месяц,
	|	Реквизиты.Организация КАК Организация
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	ТаблицаРеквизиты = Запрос.Выполнить().Выгрузить();
	
	ПараметрыПроведения.Вставить("ТаблицаРеквизиты", ТаблицаРеквизиты);
	
КонецПроцедуры

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)

	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Период КАК Период,
	|	Реквизиты.Регистратор КАК Регистратор,
	|	Реквизиты.Месяц КАК Месяц,
	|	Реквизиты.Организация КАК Организация
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ПодготовитьТаблицуУдержанногоНалога(Реквизиты, ТаблицаУдержанныйНДФЛ) Экспорт
	
	НачалоПростогоУчета = ЕдиныйНалоговыйСчет.НачалоПростогоУчета();
	
	ТаблицаНалога = УчетЗарплаты.НоваяТаблицаУдержанногоНДФЛДляОтраженияВУчете();
	Для Каждого СтрокаТаблицы Из ТаблицаУдержанныйНДФЛ Цикл
		Если СтрокаТаблицы.СрокУплаты < НачалоПростогоУчета Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ТаблицаНалога.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		НоваяСтрока.СчетУчета = Справочники.ВидыНалоговИПлатежейВБюджет.СчетУчета(НоваяСтрока.Налог);
	КонецЦикла;
	
	Возврат ТаблицаНалога;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиОбновления

Процедура ЗаполнитьСуммуДокумента() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СведенияОбУдержанномНДФЛНДФЛ.Ссылка КАК Ссылка,
	|	СведенияОбУдержанномНДФЛНДФЛ.Ссылка.СуммаДокумента КАК СуммаДокумента,
	|	СУММА(СведенияОбУдержанномНДФЛНДФЛ.Сумма) КАК СуммаСтрок
	|ПОМЕСТИТЬ ВТТаблицаДокументов
	|ИЗ
	|	Документ.СведенияОбУдержанномНДФЛ.НДФЛ КАК СведенияОбУдержанномНДФЛНДФЛ
	|ГДЕ
	|	СведенияОбУдержанномНДФЛНДФЛ.Ссылка.СуммаДокумента = 0
	|
	|СГРУППИРОВАТЬ ПО
	|	СведенияОбУдержанномНДФЛНДФЛ.Ссылка,
	|	СведенияОбУдержанномНДФЛНДФЛ.Ссылка.СуммаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТТаблицаДокументов.Ссылка КАК Ссылка,
	|	ВТТаблицаДокументов.СуммаСтрок КАК СуммаСтрок
	|ИЗ
	|	ВТТаблицаДокументов КАК ВТТаблицаДокументов
	|ГДЕ
	|	ВТТаблицаДокументов.СуммаДокумента <> ВТТаблицаДокументов.СуммаСтрок";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();
		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Попытка
			ДокументОбъект.СуммаДокумента = Выборка.СуммаСтрок;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект);
			ЗафиксироватьТранзакцию();
		Исключение
			ШаблонСообщения = НСтр("ru = 'Не удалось обработать документ %1
									|%2'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, Выборка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Сведения об удержанном НДФЛ: обновление'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Документы.СведенияОбУдержанномНДФЛ,, 
				ТекстСообщения);
			
			ОтменитьТранзакцию();
			Продолжить;
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
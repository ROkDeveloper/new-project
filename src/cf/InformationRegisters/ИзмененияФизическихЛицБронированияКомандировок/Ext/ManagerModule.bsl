﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗарегистрироватьСотрудниковВСпискеОтправки(СистемаБронирования, ФизическоеЛицо) Экспорт

	Если СистемаБронирования = Неопределено Или ФизическоеЛицо = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ФизическоеЛицо) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Список = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	ИначеЕсли ТипЗнч(ФизическоеЛицо) = Тип("Массив") Тогда
		Список = ФизическоеЛицо;
	КонецЕсли;

	Запись = РегистрыСведений.ИзмененияФизическихЛицБронированияКомандировок.СоздатьМенеджерЗаписи();
	Для Каждого Элемент Из Список Цикл
		Запись.СистемаБронирования = СистемаБронирования;
		Запись.ФизическоеЛицо = Элемент;
		Запись.Прочитать();
		Если Не Запись.Выбран() Тогда
			Запись.СистемаБронирования = СистемаБронирования;
			Запись.ФизическоеЛицо = Элемент;
		КонецЕсли;
		УстановитьПривилегированныйРежим(Истина);
		Запись.Записать();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЦикла;

КонецПроцедуры

Процедура УдалитьСотрудниковИзСпискаОтправки(СистемаБронирования, ФизическоеЛицо) Экспорт

	Если СистемаБронирования = Неопределено Или ФизическоеЛицо = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ФизическоеЛицо) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Список = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	ИначеЕсли ТипЗнч(ФизическоеЛицо) = Тип("Массив") Тогда
		Список = ФизическоеЛицо;
	КонецЕсли;

	Для Каждого Элемент Из Список Цикл
		Запись = РегистрыСведений.ИзмененияФизическихЛицБронированияКомандировок.СоздатьМенеджерЗаписи();
		Запись.СистемаБронирования = СистемаБронирования;
		Запись.ФизическоеЛицо = Элемент;
		Запись.Прочитать();
		Если Запись.Выбран() Тогда
			УстановитьПривилегированныйРежим(Истина);
			Запись.Удалить();
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Функция СотрудникВключенВСписокОтправки(СистемаБронирования, ФизическоеЛицо) Экспорт

	Запись = РегистрыСведений.ИзмененияФизическихЛицБронированияКомандировок.СоздатьМенеджерЗаписи();
	Запись.СистемаБронирования = СистемаБронирования;
	Запись.ФизическоеЛицо = ФизическоеЛицо;
	Запись.Прочитать();

	Возврат Запись.Выбран();

КонецФункции

#КонецОбласти

#КонецЕсли
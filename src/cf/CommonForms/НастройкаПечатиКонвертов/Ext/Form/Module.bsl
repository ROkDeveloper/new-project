﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектыПечати = Параметры.ОбъектыПечати;
	Если ОбъектыПечати.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru='Непосредственное открытие этой формы не предусмотрено.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	СведенияОПолучателеКонверта = Параметры.СведенияОПолучателеКонверта;
	Организация = Параметры.Организация;
	
	ПроверитьВозможностьПечати(ОбъектыПечати);
	
	ФорматыПочтовыхКонвертов = Новый Структура;
	ФорматыПочтовыхКонвертов.Вставить("C4", Перечисления.ФорматыПочтовыхКонвертов.C4);
	ФорматыПочтовыхКонвертов.Вставить("C5", Перечисления.ФорматыПочтовыхКонвертов.C5);
	ФорматыПочтовыхКонвертов.Вставить("DL", Перечисления.ФорматыПочтовыхКонвертов.DL);
	
	ОбъектПечати = ОбъектыПечати[0];
	
	ИспользуетсяОднаОрганизация = Не Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	ВОбъектеПечатиЕстьОрганизация = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ОбъектПечати, "Организация");
	
	Если ИспользуетсяОднаОрганизация Тогда
		Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	ФорматКонверта = Перечисления.ФорматыПочтовыхКонвертов.C5;
	ФорматКонвертаПриИзменении(ЭтотОбъект);
	
	АдресОбъектовПечати = ПоместитьВоВременноеХранилище(ОбъектыПечати, УникальныйИдентификатор);
	
	НадписьФормат = НСтр("ru='Формат:'");
	Элементы.Организация.Видимость = Не (ВОбъектеПечатиЕстьОрганизация 
		Или ИспользуетсяОднаОрганизация Или ЗначениеЗаполнено(Параметры.Организация));
	Элементы.ВидАдресаКонтрагента.Видимость = НЕ ЗначениеЗаполнено(СведенияОПолучателеКонверта);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НаименованиеБраузера = РегламентированнаяОтчетностьКлиент.ВебБраузер();
	Если ЗначениеЗаполнено(НаименованиеБраузера) Тогда
		Элементы.ГруппаОсобенностиПечатиВВебКлиенте.Видимость = Истина;
		СообщитьПользователюОсобенностиПечатиВВебБраузере(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ФорматКонвертаПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НеТребуютПроверки = Новый Массив;
	
	Если ВОбъектеПечатиЕстьОрганизация Или ИспользуетсяОднаОрганизация Тогда
		НеТребуютПроверки.Добавить("Организация");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СведенияОПолучателеКонверта) Тогда
		НеТребуютПроверки.Добавить("ВидАдресаКонтрагента");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НеТребуютПроверки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФорматКонвертаС4ПриИзменении(Элемент)
	
	ФорматКонвертаПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматКонвертаС5ПриИзменении(Элемент)
	
	ФорматКонвертаПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматКонвертаDLПриИзменении(Элемент)
	
	ФорматКонвертаПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КонвертC4Нажатие(Элемент)
	
	ФорматКонверта = ФорматыПочтовыхКонвертов.C4;
	ФорматКонвертаПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КонвертC5Нажатие(Элемент)
	
	ФорматКонверта = ФорматыПочтовыхКонвертов.C5;
	ФорматКонвертаПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КонвертDLНажатие(Элемент)
	
	ФорматКонверта = ФорматыПочтовыхКонвертов.DL;
	ФорматКонвертаПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечататьЛоготипРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Организация) И (ИспользуетсяОднаОрганизация Или Элементы.Организация.Видимость) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Организация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПродолжить(Команда)
	
	ОбъектыПечати = ПолучитьОбъектыПечати();
	
	Если Не ЗначениеЗаполнено(ОбъектыПечати) Тогда
		Возврат;
	КонецЕсли;
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ПечатьКонвертов");
	
	ИмяМакета = ИмяМакета();
	
	ПараметрыПечати = Новый Структура();
	ПараметрыПечати.Вставить("ФорматКонверта"      , ФорматКонверта);
	ПараметрыПечати.Вставить("ПечататьЛоготип"     , ПечататьЛоготип);
	ПараметрыПечати.Вставить("ВидАдресаКонтрагента", ВидАдресаКонтрагента);
	ПараметрыПечати.Вставить("Организация"         , Организация);
	ПараметрыПечати.Вставить("ИмяМакета"           , ИмяМакета);
	ПараметрыПечати.Вставить("ЗаголокФормы"        , НСтр("ru='Печать конверта'"));
	Если ЗначениеЗаполнено(СведенияОПолучателеКонверта) Тогда
		ПараметрыПечати.Вставить("СведенияОПолучателеКонверта", СведенияОПолучателеКонверта);
	КонецЕсли;
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.Контрагенты",
		ИмяМакета,
		ОбъектыПечати,
		ЭтотОбъект,
		ПараметрыПечати);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ИмяМакета()
	
	Результат = "";
	
	Если ФорматКонверта = ПредопределенноеЗначение("Перечисление.ФорматыПочтовыхКонвертов.C4") Тогда
		Результат = "ПФ_MXL_КонвертC4";
	ИначеЕсли ФорматКонверта = ПредопределенноеЗначение("Перечисление.ФорматыПочтовыхКонвертов.C5") Тогда
		Результат = "ПФ_MXL_КонвертС5";
	ИначеЕсли ФорматКонверта = ПредопределенноеЗначение("Перечисление.ФорматыПочтовыхКонвертов.DL") Тогда
		Результат = "ПФ_MXL_КонвертDL";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ФорматКонвертаПриИзменении(Форма)
	
	ФорматыПочтовыхКонвертов = Форма.ФорматыПочтовыхКонвертов;
	ФорматКонверта           = Форма.ФорматКонверта;
	Элементы                 = Форма.Элементы;
	
	Для Каждого Формат Из ФорматыПочтовыхКонвертов Цикл
		ЭтоВыбранныйФормат = Формат.Значение = ФорматКонверта;
		Элементы["Конверт" + Формат.Значение].Видимость = Не ЭтоВыбранныйФормат;
		Элементы["Конверт" + Формат.Значение + "Выбран"].Видимость = ЭтоВыбранныйФормат;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Форма.НаименованиеБраузера) Тогда
		СообщитьПользователюОсобенностиПечатиВВебБраузере(Форма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьВозможностьПечати(ОбъектыПечати)
	
	ОбъектыПечати = УдалитьГруппыИзОбъектовПечати(ОбъектыПечати);
	Если ОбъектыПечати.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Конверт может быть напечатан только для элементов справочника.'");
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Функция УдалитьГруппыИзОбъектовПечати(ОбъектыПечати)
	
	Если ТипЗнч(ОбъектыПечати[0]) <> Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат ОбъектыПечати;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОбъектыПечати", ОбъектыПечати);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	НЕ Контрагенты.ЭтоГруппа
	|	И Контрагенты.Ссылка В(&ОбъектыПечати)";
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса.ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаСервере
Функция ПолучитьОбъектыПечати()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПолучитьИзВременногоХранилища(АдресОбъектовПечати);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура СообщитьПользователюОсобенностиПечатиВВебБраузере(Форма)
	
	РазмерБумаги = РазмерБумаги(Форма);
	
	Если Форма.НаименованиеБраузера = "CHROME" Тогда
		ТекстСообщения = НСтр("ru='На следующем шаге, в окне предпросмотра, выберите размер бумаги'") + " " + РазмерБумаги;
		
	ИначеЕсли Форма.НаименованиеБраузера = "MSIE" Тогда
		ТекстСообщения = НСтр("ru='На следующем шаге выберите в Параметрах страницы размер бумаги'") + " " + РазмерБумаги;
		
	Иначе
		ТекстСообщения = НСтр("ru='На следующем шаге выберите в Свойствах принтера размер бумаги'") + " " + РазмерБумаги;
		
	КонецЕсли;
	
	Форма.Элементы.ТекстОсобенностиПечатиВВебКлиенте.Заголовок = ТекстСообщения;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РазмерБумаги(Форма)
	
	Если Форма.ФорматКонверта = ПредопределенноеЗначение("Перечисление.ФорматыПочтовыхКонвертов.C4") Тогда
		Результат = "Envelope C4";
	ИначеЕсли Форма.ФорматКонверта = ПредопределенноеЗначение("Перечисление.ФорматыПочтовыхКонвертов.C5") Тогда
		Результат = "Envelope C5";
	Иначе
		Результат = "Envelope DL";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

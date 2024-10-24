﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИдентификаторУстройстваККТ = Параметры.ИдентификаторУстройстваККТ;
	КодыСистемыНалогообложения = Параметры.ПараметрыРегистрации.КодыСистемыНалогообложения;
	
	ПараметрыККТ = ПараметрыККТ(ИдентификаторУстройстваККТ);
	Организация = ПараметрыККТ.Организация;
	
	ЭтоПолноправныйПользователь = ПравоДоступа("Изменение", Метаданные.Справочники.ПодключаемоеОборудование);
	
	Отказ = НЕ ПараметрыККТ.ПроверятьСНО;
	
	ЕстьДоступныеСНО = Ложь;
	Если НЕ Отказ Тогда
		СписокРасхожденийСНО = СписокРасхожденийСНО(Организация, ИдентификаторУстройстваККТ, КодыСистемыНалогообложения, ЕстьДоступныеСНО);
		Отказ = (СписокРасхожденийСНО.Количество() = 0);
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ПодготовитьФорму(СписокРасхожденийСНО, ЕстьДоступныеСНО);
	КонецЕсли; 
	
	КлючСохраненияПоложенияОкна = Новый УникальныйИдентификатор;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Оповестить(КассовыеСменыКлиентБП.СобытиеВыполняетсяОперацияКассовойСмены());
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если НЕ ЗавершениеРаботы Тогда
		Оповестить(КассовыеСменыКлиентБП.СобытиеЗавершиласьОперацияКассовойСмены());
	КонецЕсли; 
КонецПроцедуры



#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКНастройками(Команда)
	ПараметрыОперации = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОткрытияЗакрытияСмены();
	ПараметрыОперации.Кассир = КассовыеСменыВызовСервераБП.ПредставлениеКассира(Организация);
	ПараметрыОперации.КассирИНН = КассовыеСменыВызовСервераБП.ИННКассира(Организация);
	
	Если ЭтоПолноправныйПользователь Тогда
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ПерейтиКНастройкамЗавершение", ЭтотОбъект);
	Иначе
		ОповещениеОЗавершении = Новый ОписаниеОповещения("НастройкаОборудованияЗавершение", ЭтотОбъект);
	КонецЕсли; 
	
	ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьЗакрытиеСменыНаФискальномУстройстве(ОповещениеОЗавершении, УникальныйИдентификатор, ИдентификаторУстройстваККТ, ПараметрыОперации);
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьОткрытиеСмены(Команда)
	УстановитьПризнакБольшеНеСпрашивать(ИдентификаторУстройстваККТ);
	Закрыть();
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПерейтиКНастройкамЗавершение(Параметр, ДополнительныеПараметры) Экспорт
	ОповещениеОЗавершении = Новый ОписаниеОповещения("НастройкаОборудованияЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ИдентификаторУстройстваККТ);
	
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаОбъекта", ПараметрыФормы,,,,,ОповещениеОЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаОборудованияЗавершение(Параметр, ДополнительныеПараметры) Экспорт
	Оповестить("ИзменениеСтатусаКассовойСмены");
	
	Закрыть();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПризнакБольшеНеСпрашивать(ИдентификаторУстройстваККТ)
	МенеджерЗаписи = РегистрыСведений.ОборудованиеПоОрганизациям.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Оборудование = ИдентификаторУстройстваККТ;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.НастройкиСистемыНалогообложенияПроверены = Истина;
		
		УстановитьПривилегированныйРежим(Истина);
		МенеджерЗаписи.Записать();
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФорму(СписокРасхождений, ЕстьДоступныеСНО)
	
	ШрифтПолужирный = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста,,,Истина);
	
	СписокФорматированнаяСтрока = Новый Массив;
	СписокФорматированнаяСтрока.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'На этой кассе нельзя пробивать чеки по '"), ШрифтыСтиля.ОбычныйШрифтТекста));
	СписокФорматированнаяСтрока.Добавить(НОвый ФорматированнаяСтрока(СтрСоединить(СписокРасхождений, " и "),                 ШрифтПолужирный));
	СписокФорматированнаяСтрока.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = '.'"),                                       ШрифтыСтиля.ОбычныйШрифтТекста));
	СписокФорматированнаяСтрока.Добавить(Символы.ПС);
	СписокФорматированнаяСтрока.Добавить(Символы.ПС);

	Если ЕстьДоступныеСНО Тогда
		СписокФорматированнаяСтрока.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Возможно, '"),                          ШрифтыСтиля.ОбычныйШрифтТекста));
	Иначе
		СписокФорматированнаяСтрока.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Для продолжения работы '"),             ШрифтыСтиля.ОбычныйШрифтТекста));
	КонецЕсли; 
	
	СписокФорматированнаяСтрока.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'нужно настроить кассу.'"),                  ШрифтыСтиля.ОбычныйШрифтТекста));
	СписокФорматированнаяСтрока.Добавить(Символы.ПС);
	СписокФорматированнаяСтрока.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Как это сделать?'"),                        ШрифтыСтиля.МелкийШрифтТекста,,,"https://its.1c.ru/db/kkt#content:183:buh30"));
	СписокФорматированнаяСтрока.Добавить(Символы.ПС);
	
	Если НЕ ЭтоПолноправныйПользователь Тогда
		СписокФорматированнаяСтрока.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Обратитесь к сотруднику, ответственному за настройку онлайн кассы.'"), ШрифтыСтиля.ОбычныйШрифтТекста));
		Элементы.ФормаПерейтиКНастройкам.Заголовок = НСтр("ru = 'Завершить работу с кассой (закрыть смену)'");
	КонецЕсли;
	
	Элементы.Декорация1.Заголовок = Новый ФорматированнаяСтрока(СписокФорматированнаяСтрока);
	
	Элементы.ФормПробиватьНеТребуется.Видимость = ЕстьДоступныеСНО;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокРасхожденийСНО(Организация, ИдентификаторУстройстваККТ, КодыСНОККТ, ЕстьДоступныеСНО)
	ТекущаяДата = ТекущаяДатаСеанса();
	
	МассивСНОККТ = СтрРазделить(КодыСНОККТ, ",", Ложь);
	СписокРасхождений = Новый Массив;
	
	СистемаНалогообложения = УчетнаяПолитика.СистемаНалогообложения(Организация, ТекущаяДата);
	
	ЕстьДоступныеСНО = Ложь;
	Если СистемаНалогообложения = Перечисления.СистемыНалогообложения.Общая Тогда
		Если МассивСНОККТ.Найти("0") = Неопределено 
			И (МассивСНОККТ.Найти("3") = Неопределено ИЛИ НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИдентификаторУстройстваККТ, "ИспользуетсяФН36")) Тогда
			
			СписокРасхождений.Добавить("общей системе налогообложения");
		Иначе
			ЕстьДоступныеСНО = Истина;
		КонецЕсли; 
	ИначеЕсли СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная Тогда
		Если УчетнаяПолитика.ПрименяетсяУСНДоходы(Организация, ТекущаяДата) Тогда
			Если МассивСНОККТ.Найти("1") = Неопределено Тогда
				СписокРасхождений.Добавить("упрощенной системе налогообложения (доходы)");
			Иначе
				ЕстьДоступныеСНО = Истина;
			КонецЕсли; 
		ИначеЕсли УчетнаяПолитика.ПрименяетсяУСНДоходыМинусРасходы(Организация, ТекущаяДата) Тогда
			Если МассивСНОККТ.Найти("2") = Неопределено Тогда
				СписокРасхождений.Добавить("упрощенной системе налогообложения (доходы минус расходы)");
			Иначе
				ЕстьДоступныеСНО = Истина;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
	Если УчетнаяПолитика.ПрименяетсяУСНПатент(Организация, ТекущаяДата) Тогда
		Если МассивСНОККТ.Найти("5") = Неопределено Тогда
			СписокРасхождений.Добавить("патенту");
		Иначе
			ЕстьДоступныеСНО = Истина;
		КонецЕсли; 
	КонецЕсли; 
	
	Возврат СписокРасхождений;
КонецФункции
 
&НаСервере
Функция ПараметрыККТ(ОборудованиеСссылка)
	
	Результат = Новый Структура;
	Результат.Вставить("ПроверятьСНО", Ложь);
	Результат.Вставить("Организация", Справочники.Организации.ПустаяСсылка());

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОборудованиеСсылка", ОборудованиеСссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОборудованиеПоОрганизациям.НастройкиСистемыНалогообложенияПроверены = ЛОЖЬ КАК ПроверятьСНО,
	|	ОборудованиеПоОрганизациям.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.ОборудованиеПоОрганизациям КАК ОборудованиеПоОрганизациям
	|ГДЕ
	|	ОборудованиеПоОрганизациям.Оборудование = &ОборудованиеСсылка";
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	Если РезультатЗапроса.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, РезультатЗапроса);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции 

#КонецОбласти 


 
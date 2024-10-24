﻿#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ВыполнитьМетодВФоне(ИнтеграцияАУСНКлиентСервер.ИменаМетодовВзаимодействия().СписокБанков);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьМетодВФоне(Метод)
	
	ПараметрыМетода = ИнтеграцияАУСНКлиентСервер.НовыеПараметрыМетодаВзаимодействия(Метод);
	
	ДлительнаяОперация = ВыполнитьМетодВФонеНаСервере(ПараметрыМетода, УникальныйИдентификатор);
	
	Если ДлительнаяОперация <> Неопределено Тогда
		Обработчик = Новый ОписаниеОповещения("ОбработкаВыполненияМетода", ЭтотОбъект);
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыполнитьМетодВФонеНаСервере(Знач ПараметрыМетода, Знач ИдентификаторФормы)
	
	Возврат ИнтеграцияАУСН.ВыполнитьВФоне(ПараметрыМетода, ИдентификаторФормы);
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыполненияМетода(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = ОтветМетода(Результат);
	
	Если Ответ <> Неопределено Тогда
		ОбработкаОтветаМетода(Ответ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОтветМетода(Результат)
	
	Если Результат = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ЗаписатьОшибкуВЖурналРегистрации(
			Результат.КраткоеПредставлениеОшибки,
			Результат.ПодробноеПредставлениеОшибки);
		Возврат Неопределено;
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда
		Ответ = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		УдалитьИзВременногоХранилища(Результат.АдресРезультата);
	Иначе
		Ответ = Неопределено;
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОтветаМетода(Ответ)
	
	СтатусыЗапросов = ИнтеграцияАУСНКлиентСервер.СтатусыЗапросов();
	
	Если Ответ.Статус = СтатусыЗапросов.Выполнено Тогда
		
		ОбновитьСписокБанков(Ответ.Результат);
		ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.БанкиАУСН"));
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Список банков успешно обновлен'"));
		
	ИначеЕсли Ответ.Статус = СтатусыЗапросов.Ошибка Тогда
		
		Если ЗначениеЗаполнено(Ответ.Сообщение) Тогда
			ПредставлениеОшибки = Ответ.Сообщение;
		Иначе
			ПредставлениеОшибки = СтрШаблон(
				НСтр("ru='Ошибка при вызове метода СписокБанков, код %1.'"),
				Ответ.КодСостояния);
		КонецЕсли;
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ПредставлениеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьСписокБанков(Знач РезультатВыполненияМетода)
	
	ИнтеграцияАУСН.ОбновитьСписокБанков(РезультатВыполненияМетода);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьОшибкуВЖурналРегистрации(Знач КраткоеПредставлениеОшибки, Знач ПодробноеПредставлениеОшибки)
	
	ИнтеграцияАУСН.ЗаписатьОшибкуВЖурналРегистрации(КраткоеПредставлениеОшибки, ПодробноеПредставлениеОшибки);
	
КонецПроцедуры

#КонецОбласти
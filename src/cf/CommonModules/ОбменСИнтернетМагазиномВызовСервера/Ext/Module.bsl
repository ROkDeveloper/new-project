﻿#Область ПрограммныйИнтерфейс

Функция СобытиеЖурналаРегистрации() Экспорт
	Возврат ОбменСИнтернетМагазином.СобытиеЖурналаРегистрации();
КонецФункции

Функция ВыполнитьОбменСИнтернетМагазиномВФоне(УникальныйИдентификатор) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.Вставить("НаименованиеФоновогоЗадания",
		НСтр("ru = 'Загрузка заказов из интернет-магазина'"));
		
	ПараметрыПроцедуры = Новый Структура;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("ОбменСИнтернетМагазином.ЗагрузитьЗаказыИнтернетМагазинаВФоне", 
		ПараметрыПроцедуры, ПараметрыВыполненияВФоне);
	
КонецФункции

Процедура ЗаполнитьСпособыОнлайнОплатыИнтернетМагазина(Знач НастройкиПодключения, Организация) Экспорт
	
	Если НЕ (НастройкиПодключения.CMSИнтернетМагазина = Перечисления.CMSИнтернетМагазина.Bitrix
			ИЛИ НастройкиПодключения.CMSИнтернетМагазина = Перечисления.CMSИнтернетМагазина.UMI) Тогда
		
		ОписаниеОшибки = НСтр("ru = 'Для вашей CMS получение настроек не поддерживается. Необходимо заполнить настройки вручную.'");
		ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки);
		Возврат;
		
	КонецЕсли;
	
	НастройкиСайта = ОбменСИнтернетМагазином.ПолучитьНастройкиСайта(НастройкиПодключения);
	
	Если НЕ ЗначениеЗаполнено(НастройкиСайта.СпособыОнлайнОплаты) Тогда
		
		ТекстСообщения = НСтр("ru = 'В настройках CMS не найдено платежных систем с типом ""Эквайринговая операция"".
			|Необходимо выполнить настройку CMS интернет-магазина'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат;
		
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.СпособыОнлайнОплатыИнтернетМагазина.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Прочитать();
	ТаблицаНастройки = НаборЗаписей.Выгрузить();
	НаборЗаписей.Очистить();
	
	Для Каждого Элемент Из НастройкиСайта.СпособыОнлайнОплаты Цикл
		ТекущаяЗапись = ТаблицаНастройки.Найти(Элемент.Ключ, "ИдентификаторСпособаОплаты");
		НоваяЗапись = НаборЗаписей.Добавить();
		Если ТекущаяЗапись <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(НоваяЗапись, ТекущаяЗапись);
		Иначе
			НоваяЗапись.ИдентификаторСпособаОплаты = Элемент.Ключ;
			НоваяЗапись.НаименованиеСпособаОплаты  = Элемент.Значение;
			НоваяЗапись.Организация                = Организация;
		КонецЕсли;
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ЗаполнитьСпособыДоставкиИнтернетМагазина(Знач НастройкиПодключения, Организация) Экспорт
	
	Если НЕ (НастройкиПодключения.CMSИнтернетМагазина = Перечисления.CMSИнтернетМагазина.Bitrix
			ИЛИ НастройкиПодключения.CMSИнтернетМагазина = Перечисления.CMSИнтернетМагазина.UMI) Тогда
		
		ОписаниеОшибки = НСтр("ru = 'Для вашей CMS получение настроек не поддерживается. Необходимо заполнить настройки вручную.'");
		ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки);
		Возврат;
		
	КонецЕсли;
	
	НастройкиСайта = ОбменСИнтернетМагазином.ПолучитьНастройкиСайта(НастройкиПодключения);
	
	Если НЕ ЗначениеЗаполнено(НастройкиСайта.СлужбыДоставки) Тогда
		
		ТекстСообщения = НСтр("ru = 'В настройках CMS не найдено доступных способов доставки.
			|Необходимо выполнить настройку CMS интернет-магазина'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат;
		
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.СлужбыДоставкиИнтернетМагазина.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Прочитать();
	ТаблицаНастройки = НаборЗаписей.Выгрузить();
	НаборЗаписей.Очистить();
	
	Для Каждого Элемент Из НастройкиСайта.СлужбыДоставки Цикл
		ТекущаяЗапись = ТаблицаНастройки.Найти(Элемент.Ключ, "ИдентификаторСлужбыДоставки");
		НоваяЗапись = НаборЗаписей.Добавить();
		Если ТекущаяЗапись <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(НоваяЗапись, ТекущаяЗапись);
		Иначе
			НоваяЗапись.ИдентификаторСлужбыДоставки = Элемент.Ключ;
			НоваяЗапись.НаименованиеСлужбыДоставки  = Элемент.Значение;
			НоваяЗапись.Организация                 = Организация;
		КонецЕсли;
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция СтатусыЗаказовИнтернетМагазина(Знач НастройкиПодключения) Экспорт
	
	СтатусыЗаказов = Новый Массив;
	Если НЕ (НастройкиПодключения.CMSИнтернетМагазина = Перечисления.CMSИнтернетМагазина.Bitrix
		ИЛИ НастройкиПодключения.CMSИнтернетМагазина = Перечисления.CMSИнтернетМагазина.UMI) Тогда
		
		ТекстСообщения = НСтр("ru = 'Для вашей CMS получение настроек не поддерживается.
			|Необходимо заполнить настройкe вручную'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
	НастройкиСайта = ОбменСИнтернетМагазином.ПолучитьНастройкиСайта(НастройкиПодключения);
	
	Если НЕ ЗначениеЗаполнено(НастройкиСайта.СтатусыЗаказов) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не удалось загрузить настройку ""Статусы заказов""'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
	Для Каждого Элемент Из НастройкиСайта.СтатусыЗаказов Цикл
		СтатусыЗаказов.Добавить(Элемент.Значение);
	КонецЦикла;
	
	Возврат СтатусыЗаказов;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий
//Код процедур и функций
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
//Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//Код процедур и функций
#КонецОбласти
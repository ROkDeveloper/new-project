﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьОбновитьДоговорВладелец();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьОбновитьДоговорВладелец()

	// С помощью средств БСП пользователь может удалить данные файла или пометить его на удаление.
	// Проверяем такую ситуацию, чтобы очистить ссылку на текущий файл в договоре-владельце.

	Если ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ПометкаУдаления
		И НЕ ДополнительныеСвойства.Свойство("УдалениеДанных") Тогда
		// Текущий файл не помечен на удаление, проверка не требуется.
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВладелецФайла) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВладелецФайла, "ФайлДоговора");
	
	Если РеквизитыДоговора.ФайлДоговора <> Ссылка Тогда
		// В договоре выбран другой присоединенный файл.
		Возврат;
	КонецЕсли;
	
	ДоговорОбъект = ВладелецФайла.ПолучитьОбъект();
	Если ДоговорОбъект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Очищаем ссылку на файл в договоре.
	Попытка
		ДоговорОбъект.Заблокировать();
		ДоговорОбъект.ФайлДоговора = Неопределено;   
		ДоговорОбъект.ЭлектронныйФормат = Ложь;
		ДоговорОбъект.Записать();
		ДоговорОбъект.Разблокировать();   
	Исключение
		// Регистрируем в журнал предупреждение, а не ошибку, так как, возможно, что пользователь сейчас редактирует этот договор
		// и он заблокирован формой. Тогда форма сама поймает оповещение от БСП и очистит ссылку на файл договора.
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'При обновлении договора-владельца файла произошла ошибка: %1'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление договора-владельца файла'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.Справочники.ДоговорыКонтрагентов,
			ВладелецФайла,
			ТекстСообщения);
			
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
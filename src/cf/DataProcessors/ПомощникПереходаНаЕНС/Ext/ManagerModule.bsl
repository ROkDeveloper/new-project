﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПереносРасчетовПоНалогамВзносам(СтруктураПараметров, АдресХранилища) Экспорт
	
	Отказ = Ложь;
	
	ДатаДокумента = НачалоДня(СтруктураПараметров.ДатаПерехода);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДокументыОперацийПереходаНаЕНС.ДокументОперации
	|ИЗ
	|	РегистрСведений.ДокументыОперацийПереходаНаЕНС КАК ДокументыОперацийПереходаНаЕНС
	|ГДЕ
	|	ДокументыОперацийПереходаНаЕНС.Организация = &Организация
	|	И ДокументыОперацийПереходаНаЕНС.ДатаПерехода = &ДатаПерехода
	|	И ДокументыОперацийПереходаНаЕНС.ВидОперации = &ВидОперации"
	;
	
	Запрос.УстановитьПараметр("Организация",  СтруктураПараметров.Организация);
	Запрос.УстановитьПараметр("ДатаПерехода", СтруктураПараметров.ДатаПерехода);
	Запрос.УстановитьПараметр("ВидОперации",  СтруктураПараметров.ВидОперации);
	
	ДокОбъект = Неопределено;
	
	ЕстьАктивнаяТранзакция = ТранзакцияАктивна();
	
	РезультатПоДокументам = Запрос.Выполнить();
	
	Если НЕ РезультатПоДокументам.Пустой() Тогда
		
		Выборка = РезультатПоДокументам.Выбрать();
		
		Если ЕстьАктивнаяТранзакция Тогда
			БлокировкаДанных = Новый БлокировкаДанных;
			
			Пока Выборка.Следующий() Цикл
				ЭлементБлокировки = БлокировкаДанных.Добавить("Документ.ОперацияПоЕдиномуНалоговомуСчету");
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.ДокументОперации);
			КонецЦикла;
			
			БлокировкаДанных.Заблокировать();
			
			Выборка.Сбросить();
		КонецЕсли;
		
		Ном = 0;
		МассивЛишнихДокументов = Новый Массив;
		
		Пока Выборка.Следующий() Цикл
			Ном = Ном + 1;
			Если Ном = 1 Тогда
				ДокОбъект = Выборка.ДокументОперации.ПолучитьОбъект();
				Если ДокОбъект.ПометкаУдаления Тогда
					ДокОбъект.УстановитьПометкуУдаления(Ложь);
				ИначеЕсли ДокОбъект.Проведен Тогда
					ДокОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				КонецЕсли;
			Иначе
				МассивЛишнихДокументов.Добавить(Выборка.ДокументОперации);
			КонецЕсли;
		КонецЦикла;
		
		// лишние документы помечаем на удаление
		Для каждого ЛишнийДокумент Из МассивЛишнихДокументов Цикл
			ЛишнийОбъект = ЛишнийДокумент.ПолучитьОбъект();
			ЛишнийДокумент.УстановитьПометкуУдаления(Истина);
		КонецЦикла;
		
	Иначе
		ДокОбъект = Документы.ОперацияПоЕдиномуНалоговомуСчету.СоздатьДокумент();
		ДокОбъект.ВидОперации         = СтруктураПараметров.ВидОперации;
		ДокОбъект.ВводНачальныхДанных = Истина;
		ДокОбъект.Дата                = ДатаДокумента;
		ДокОбъект.Организация         = СтруктураПараметров.Организация;
		ДокОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;
	
	ДокОбъект.Дата                = ДатаДокумента;
	ДокОбъект.Организация         = СтруктураПараметров.Организация;
	ДокОбъект.Ответственный       = Пользователи.ТекущийПользователь();
	ДокОбъект.ВидОперации         = СтруктураПараметров.ВидОперации;
	ДокОбъект.ВводНачальныхДанных = Истина;
	
	ВводитсяЗадолженностьПрошлыхЛет = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		СтруктураПараметров, "ВводитсяЗадолженностьПрошлыхЛет", Ложь);
	
	Если ВводитсяЗадолженностьПрошлыхЛет Тогда
		Комментарий = СтрШаблон(
			НСтр("ru = '#Документ создан автоматически при переносе задолженности прошлых лет на ЕНС, операция - ""%1""'"),
			СтруктураПараметров.ВидОперации);
	Иначе
		Комментарий = СтрШаблон(НСтр("ru = '#Документ создан автоматически при переходе на ЕНС, операция - ""%1""'"),
			СтруктураПараметров.ВидОперации);
	КонецЕсли;
	
	ДокОбъект.Комментарий = Комментарий;
	
	СписокНалогов = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтруктураПараметров, "СписокНалогов");
	
	ПараметрыДокумента = ЕдиныйНалоговыйСчет.ПараметрыПолученияОстатковРасчетов();
	ПараметрыДокумента.Организация                     = ДокОбъект.Организация;
	ПараметрыДокумента.Дата                            = ДокОбъект.Дата;
	ПараметрыДокумента.ВидОперации                     = СтруктураПараметров.ВидОперации;
	ПараметрыДокумента.СписокНалогов                   = СписокНалогов;
	ПараметрыДокумента.ВводНачальныхДанных             = Истина;
	ПараметрыДокумента.ВводитсяЗадолженностьПрошлыхЛет = ВводитсяЗадолженностьПрошлыхЛет;
	
	// получаем данные для заполнения документа
	Исключения = Новый Массив;
	Если СтруктураПараметров.ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов Тогда
		Исключения.Добавить(ПланыСчетов.Хозрасчетный.НДС);
		Исключения.Добавить(ПланыСчетов.Хозрасчетный.НДСпоЭкспортуКВозмещению);
		Исключения.Добавить(ПланыСчетов.Хозрасчетный.НДСНалоговогоАгента);
		Исключения.Добавить(ПланыСчетов.Хозрасчетный.НДСТаможенныйСоюзКУплате);
		Исключения.Добавить(ПланыСчетов.Хозрасчетный.НДСНалоговогоАгентаПоОтдельнымВидамТоваров);
	КонецЕсли;
	
	ТаблицыОстатков = ПолучитьОстаткиРасчетов(ПараметрыДокумента, Исключения);
	
	Если ТипЗнч(ТаблицыОстатков) = Тип("Структура") Тогда
		Для Каждого ДанныеТаблицы Из ТаблицыОстатков Цикл
			ИмяТаблицы = СтрЗаменить(ДанныеТаблицы.Ключ, "Таблица", "");
			Если СписокНалогов <> Неопределено Тогда
				// Удалим только строки по счетам учета списка налогов
				УдалитьСтрокиТЧОперацииПереходаНаЕНСПоСпискуНалогов(ДокОбъект, ИмяТаблицы, СписокНалогов);
			Иначе
				ДокОбъект[ИмяТаблицы].Очистить();
			КонецЕсли;
			Для Каждого СтрокаТаблицы Из ДанныеТаблицы.Значение Цикл
				НоваяСтрока = ДокОбъект[ИмяТаблицы].Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	ТребуетсяКонтроль = Не ДокОбъект.ПроверитьЗаполнение();
	Если ТребуетсяКонтроль Тогда
		Если ДокОбъект.Проведен Тогда
			ДокОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		Иначе
			ДокОбъект.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
	Иначе
		Попытка
			ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Если Не ЕстьАктивнаяТранзакция Тогда
				Если ДокОбъект.Проведен Тогда
					ДокОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				Иначе
					ДокОбъект.Записать(РежимЗаписиДокумента.Запись);
				КонецЕсли;
			КонецЕсли;
			ТребуетсяКонтроль = Истина;
			
			ШаблонСообщения = НСтр("ru = 'Не удалось провести документ %1
									|%2'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ДокОбъект.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				ИмяСобытияЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Документы.ОперацияПоЕдиномуНалоговомуСчету,, 
				ТекстСообщения);
			
		КонецПопытки;
	КонецЕсли;
	
	// отразим выполнение операции в регистрах сведений
	СозданныеДокументы = Новый Массив;
	СозданныеДокументы.Добавить(ДокОбъект.Ссылка);
	
	Результат = Новый Структура;
	Результат.Вставить("ВыполняемаяОперация", СтруктураПараметров.ВидОперации);
	Результат.Вставить("ДокументыОперации",   СозданныеДокументы);
	Результат.Вставить("УспешноВыполнено",    НЕ Отказ);
	Результат.Вставить("ТребуетсяКонтроль",   ТребуетсяКонтроль);
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

Процедура ЗачетАвансов(СтруктураПараметров, АдресХранилища) Экспорт
	
	Отказ = Ложь;
	
	УдалитьСозданныеРанееОперации(СтруктураПараметров);
	
	ДатаДокумента = КонецДня(СтруктураПараметров.ДатаПерехода);
	
	СтруктураПараметров.Вставить("ДокументыОперации", Новый Массив);
	
	ДокументОперация = Документы.ОперацияБух.СоздатьДокумент();
	ДокументОперация.Организация   = СтруктураПараметров.Организация;
	ДокументОперация.Дата          = ДатаДокумента;
	ДокументОперация.Ответственный = Пользователи.ТекущийПользователь();
	ДокументОперация.Комментарий   = НСтр("ru = '#Документ создан автоматически при переходе на ЕНС, операция - ""Зачет авансов по ЕНС""'");
	ДокументОперация.Содержание    = НСтр("ru = '#Зачет переплаты ЕНП в счет задолженности по налогам и взносам'");
	ДокументОперация.Записать();
	Если СтруктураПараметров.Свойство("ДокументыОперации") Тогда
		СтруктураПараметров.ДокументыОперации.Добавить(ДокументОперация.Ссылка);
	КонецЕсли;
	
	ТаблицаРеквизиты = Новый ТаблицаЗначений;
	ТаблицаРеквизиты.Колонки.Добавить("Организация",       Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаРеквизиты.Колонки.Добавить("Период",            Новый ОписаниеТипов("Дата", Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	ТаблицаРеквизиты.Колонки.Добавить("Регистратор",       Новый ОписаниеТипов("ДокументСсылка.ОперацияБух"));
	ТаблицаРеквизиты.Колонки.Добавить("ВидОперации",       Новый ОписаниеТипов("ПеречислениеСсылка.ВидыРегламентныхОпераций"));
	ТаблицаРеквизиты.Колонки.Добавить("ВыдаватьСообщения", Новый ОписаниеТипов("Булево"));
	
	НоваяСтрока = ТаблицаРеквизиты.Добавить();
	НоваяСтрока.Организация       = СтруктураПараметров.Организация;
	НоваяСтрока.Период            = ДатаДокумента;
	НоваяСтрока.Регистратор       = ДокументОперация.Ссылка;
	НоваяСтрока.ВидОперации       = Перечисления.ВидыРегламентныхОпераций.ЗачетАвансаПоЕдиномуНалоговомуСчету;
	НоваяСтрока.ВыдаватьСообщения = Ложь;
	
	ПараметрыПроведения = Новый Структура();
	ПараметрыПроведения.Вставить("ТаблицаРеквизиты", ТаблицаРеквизиты);
	
	ЕдиныйНалоговыйСчет.ЗачетАвансаПоЕдиномуНалоговомуСчету(ПараметрыПроведения, ДокументОперация.Движения, Отказ);
	ЗачетПереплатПрочихРасчетов(ПараметрыПроведения, ДокументОперация.Движения, Отказ);
	
	Для Каждого Движение Из ДокументОперация.Движения Цикл
		Если Движение.Количество() <> 0 Тогда
			ИмяРегистра = Движение.Метаданные().Имя;
			Если Метаданные.РегистрыНакопления.Найти(ИмяРегистра) <> Неопределено Тогда
				НоваяСтрока = ДокументОперация.ТаблицаРегистровНакопления.Добавить();
				НоваяСтрока.Имя = ИмяРегистра;
			ИначеЕсли Метаданные.РегистрыСведений.Найти(ИмяРегистра) <> Неопределено Тогда
				НоваяСтрока = ДокументОперация.ТаблицаРегистровСведений.Добавить();
				НоваяСтрока.Имя = ИмяРегистра;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		ДокументОперация.Движения.Записать();
	Исключение
		
		ШаблонСообщения = НСтр("ru = 'Не удалось записать документ %1
								|%2'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ДокументОперация.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(
			ИмяСобытияЖурналаРегистрации(), 
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Документы.ОперацияПоЕдиномуНалоговомуСчету,, 
			ТекстСообщения);
		
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки;
	
	ЗафиксироватьВыполнениеОперацииПерехода(СтруктураПараметров, СтруктураПараметров.ДокументыОперации);
	
	Результат = Новый Структура;
	Результат.Вставить("ВыполняемаяОперация", СтруктураПараметров.ВидОперации);
	Результат.Вставить("УспешноВыполнено", Истина);
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтразитьВыполнениеОперацииПереходаНаЕНС(СтруктураПараметров, ФиксироватьУстаревшие = Ложь, Отказ = Ложь) Экспорт

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Набор = РегистрыСведений.ВыполнениеОперацийПереходаНаЕНС.СоздатьНаборЗаписей();
	
	Набор.Отбор.ВидОперации.Установить(СтруктураПараметров.ВидОперации);
	Набор.Отбор.Организация.Установить(СтруктураПараметров.Организация);
	
	Запись = Набор.Добавить();
	Запись.Активность          = Истина;
	Запись.ВидОперации         = СтруктураПараметров.ВидОперации;
	Запись.Организация         = СтруктураПараметров.Организация;
	Запись.ДатаПерехода        = СтруктураПараметров.ДатаПерехода;
	Запись.Состояние           = СтруктураПараметров.Состояние;
	Запись.Ответственный       = Ответственный;
	Запись.Актуальность        = Истина;
	
	Набор.Записать();
	
	// сохраняем ссылки на документы операции
	Если СтруктураПараметров.Свойство("ДокументыОперации") Тогда
		ДокументыОперации = СтруктураПараметров.ДокументыОперации;
		Если ДокументыОперации.Количество() > 0 Тогда					
			
			НаборДокументы = РегистрыСведений.ДокументыОперацийПереходаНаЕНС.СоздатьНаборЗаписей();
			НаборДокументы.Отбор.Организация.Установить(СтруктураПараметров.Организация);
			НаборДокументы.Отбор.ВидОперации.Установить(СтруктураПараметров.ВидОперации); 
			
			Для каждого ДокументОперации Из ДокументыОперации Цикл								
				Запись = НаборДокументы.Добавить();
				Запись.Активность = Истина;
				ЗаполнитьЗначенияСвойств(Запись, СтруктураПараметров);
				Запись.ДокументОперации = ДокументОперации;
			КонецЦикла; 
			
			НаборДокументы.Записать();
			
		КонецЕсли; 
	КонецЕсли;
	
	Если ФиксироватьУстаревшие Тогда
		ЗафиксироватьУстаревшиеОперацииПереходаНаЕНС(СтруктураПараметров, Отказ); 		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОтменитьВыполнениеОперацииПереходаНаЕНС(СтруктураПараметров, ФиксироватьУстаревшие = Ложь, Отказ = Ложь) Экспорт

	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Набор = РегистрыСведений.ВыполнениеОперацийПереходаНаЕНС.СоздатьНаборЗаписей();
	
	Набор.Отбор.ВидОперации.Установить(СтруктураПараметров.ВидОперации);
	Набор.Отбор.Организация.Установить(СтруктураПараметров.Организация);
	
	Запись = Набор.Добавить();
	Запись.Активность          = Истина;
	Запись.ВидОперации         = СтруктураПараметров.ВидОперации;
	Запись.Организация         = СтруктураПараметров.Организация;
	Запись.ДатаПерехода        = СтруктураПараметров.ДатаПерехода;
	Запись.Состояние           = СтруктураПараметров.Состояние;
	Запись.Ответственный       = Ответственный;
	Запись.Актуальность        = Ложь;
	
	Набор.Записать();
	
	// обработаем ссылки на документы операции и сами документы в зависимости от переданных параметров:
	// Если СтруктураПараметров.СпособОбработкиДокументовОперации = "ПометитьНаУдаление" - помечаем на удаление
	// Если СтруктураПараметров.СпособОбработкиДокументовОперации = "ОтменитьПроведение" - делаем не проведенными
	ОбрабатыватьДокументыОперации = Ложь;
	СтруктураПараметров.Свойство("ОбрабатыватьДокументыОперации", ОбрабатыватьДокументыОперации);
	ОчиститьСсылкиНаДокументы = Ложь;
	СтруктураПараметров.Свойство("ОчиститьСсылкиНаДокументы", ОчиститьСсылкиНаДокументы);
	
	Если ОбрабатыватьДокументыОперации Тогда
		
		НаборДокументы = РегистрыСведений.ДокументыОперацийПереходаНаЕНС.СоздатьНаборЗаписей();
		НаборДокументы.Отбор.Организация.Установить(СтруктураПараметров.Организация);
		НаборДокументы.Отбор.ВидОперации.Установить(СтруктураПараметров.ВидОперации);
		
		НаборДокументы.Прочитать(); 
		
		Если НаборДокументы.Количество() > 0 Тогда
			
			Для каждого ЗаписьПоДокументу Из НаборДокументы Цикл
				
				ДокументОперации = ЗаписьПоДокументу.ДокументОперации.ПолучитьОбъект();
				
				Если СтруктураПараметров.СпособОбработкиДокументовОперации = "ПометитьНаУдаление" Тогда
					
					ДокументОперации.УстановитьПометкуУдаления(Истина);
					
				ИначеЕсли СтруктураПараметров.СпособОбработкиДокументовОперации = "ОтменитьПроведение" Тогда
					
					Если ДокументОперации.Проведен Тогда
						ДокументОперации.Записать(РежимЗаписиДокумента.ОтменаПроведения);
					Иначе // Операция (БУ и НУ), требуется очистить движения
						ДвиженияДокумента = ДокументОперации.Движения;
						Для каждого НаборДвижений Из ДвиженияДокумента Цикл
							НаборДвижений.Записать(Истина); 
						КонецЦикла; 
					КонецЕсли; 
				КонецЕсли; 
				
			КонецЦикла; 
			
			// Если требуется - очистим ссылки на документы операции
			Если ОчиститьСсылкиНаДокументы Тогда
				НаборДокументы.Очистить();
				НаборДокументы.Записать();
			КонецЕсли; 
			
		КонецЕсли; 		
		
	КонецЕсли;
	
	Если ФиксироватьУстаревшие Тогда
		ЗафиксироватьУстаревшиеОперацииПереходаНаЕНС(СтруктураПараметров, Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ЗафиксироватьУстаревшиеОперацииПереходаНаЕНС(СтруктураПараметров, Отказ = Ложь) Экспорт
	
	МассивДоступныхОпераций = Новый Массив;
	МассивДоступныхОпераций.Добавить(Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов);
	МассивДоступныхОпераций.Добавить(Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеПенейШтрафов);
	МассивДоступныхОпераций.Добавить(Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.КорректировкаСчета);
	МассивДоступныхОпераций.Добавить("ЗачетАвансов");
	
	ИндексТекущейОперации = МассивДоступныхОпераций.Найти(СтруктураПараметров.ВидОперации);
	СледующиеВидыОпераций = Новый Массив;
	
	Для Инд = ИндексТекущейОперации + 1 По МассивДоступныхОпераций.Количество() - 1 Цикл			
		СледующиеВидыОпераций.Добавить(МассивДоступныхОпераций.Получить(Инд));
	КонецЦикла; 
	
	Если СледующиеВидыОпераций.Количество() > 0 Тогда			
		
		Ответственный = Пользователи.ТекущийПользователь();
		
		Набор = РегистрыСведений.ВыполнениеОперацийПереходаНаЕНС.СоздатьНаборЗаписей();
		
		Набор.Отбор.Организация.Установить(СтруктураПараметров.Организация);
		
		Для каждого СледующийВидОперации Из СледующиеВидыОпераций Цикл
			
			Набор.Отбор.ВидОперации.Установить(СледующийВидОперации);
			Набор.Прочитать();
			
			Если Набор.Количество() = 0 Тогда					
				Продолжить;
			КонецЕсли; 
			
			// если есть записи о выполненных следующих операциях, пометим их как неактуальные
			Если Набор.Количество() = 1 Тогда // есть запись про следующую операцию
				
				Запись = Набор[0];
				Запись.Ответственный = Ответственный;
				Запись.Актуальность  = Ложь;
				
			Иначе
				
				Если Набор.Количество() > 1 Тогда
					
					Набор.Очистить();
					Запись = Набор.Добавить();
					Запись.ВидОперации         = СледующийВидОперации;
					Запись.Организация         = СтруктураПараметров.Организация;
					Запись.ДатаПерехода        = СтруктураПараметров.ДатаПерехода;
					Запись.Состояние           = Перечисления.ВидыСостоянийРегламентныхОпераций.НеВыполнено;
					Запись.Ответственный       = Ответственный;
					Запись.Актуальность        = Ложь;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Набор.Записать();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗафиксироватьВыполнениеОперацииПерехода(СтруктураПараметров, ДокументыОперации = Неопределено,  ФиксироватьУстаревшие = Ложь, Отказ = Ложь)

	ПараметрыОперации = Новый Структура;
	
	ПараметрыОперации.Вставить("ВидОперации",         СтруктураПараметров.ВидОперации);
	ПараметрыОперации.Вставить("Организация",         СтруктураПараметров.Организация);
	ПараметрыОперации.Вставить("ДатаПерехода",        СтруктураПараметров.ДатаПерехода);
	ПараметрыОперации.Вставить("Состояние",           Перечисления.ВидыСостоянийРегламентныхОпераций.Выполнено);
	
	ПараметрыОперации.Вставить("ДокументыОперации", ДокументыОперации);
	
	ОтразитьВыполнениеОперацииПереходаНаЕНС(ПараметрыОперации, ФиксироватьУстаревшие, Отказ);

КонецПроцедуры

Процедура УдалитьСозданныеРанееОперации(Параметры)
	
	НачатьТранзакцию();
	
	Попытка
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("ДатаПерехода", НачалоДня(Параметры.ДатаПерехода));
		Запрос.УстановитьПараметр("Организация",  Параметры.Организация);
		Запрос.УстановитьПараметр("ВидОперации",  Параметры.ВидОперации);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ДокументыОперацийПереходаНаЕНС.ДокументОперации КАК ДокументОперации
		|ИЗ
		|	РегистрСведений.ДокументыОперацийПереходаНаЕНС КАК ДокументыОперацийПереходаНаЕНС
		|ГДЕ
		|	ДокументыОперацийПереходаНаЕНС.Организация = &Организация
		|	И ДокументыОперацийПереходаНаЕНС.ДатаПерехода = &ДатаПерехода
		|	И ДокументыОперацийПереходаНаЕНС.ВидОперации = &ВидОперации"
		;
		
		ТаблицаСозданныхДокументов = Запрос.Выполнить().Выгрузить();
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("Документ.ОперацияБух");
		ЭлементБлокировки.ИсточникДанных = ТаблицаСозданныхДокументов;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "ДокументОперации");
		
			Блокировка.Заблокировать();
			Для каждого СтрокаТаблицы Из ТаблицаСозданныхДокументов Цикл
				ДокументОбъект = СтрокаТаблицы.ДокументОперации.ПолучитьОбъект();
				ДокументОбъект.УстановитьПометкуУдаления(Истина);
			КонецЦикла;
			ЗафиксироватьТранзакцию();
			
	Исключение
		
		ШаблонСообщения = НСтр("ru = 'Не удалось удалить документ %1
								|%2'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ДокументОбъект.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(
			ИмяСобытияЖурналаРегистрации(), 
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Документы.ОперацияБух,, 
			ТекстСообщения);
		
		ОтменитьТранзакцию();
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьОстаткиРасчетов(ПараметрыДокумента, Исключения = Неопределено) Экспорт
	
	Организация = ПараметрыДокумента.Организация;
	Период      = ПараметрыДокумента.Дата;
	ВидОперации = ПараметрыДокумента.ВидОперации;
	
	ВводитсяЗадолженностьПрошлыхЛет = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		ПараметрыДокумента, "ВводитсяЗадолженностьПрошлыхЛет", Ложь);
	
	Если ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов
		И Не ВводитсяЗадолженностьПрошлыхЛет Тогда
		ТаблицаНалогов = ПолучитьОстаткиРасчетовПоНалогам(ПараметрыДокумента, Исключения);
	Иначе
		ТаблицаНалогов = ЕдиныйНалоговыйСчет.ПолучитьОстаткиРасчетовПоНалогам(ПараметрыДокумента, Исключения);
	КонецЕсли;
	
	Возврат ТаблицаНалогов;
	
КонецФункции

Функция ПолучитьОстаткиРасчетовПоНалогам(ПараметрыДокумента, Исключения = Неопределено) Экспорт
	
	Организация         = ПараметрыДокумента.Организация;
	Период              = НачалоДня(ПараметрыДокумента.Дата);
	ВидОперации         = ПараметрыДокумента.ВидОперации;
	ВводНачальныхДанных = ПараметрыДокумента.ВводНачальныхДанных;
	СписокНалогов       = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыДокумента, "СписокНалогов");
	Если СписокНалогов <> Неопределено Тогда
		МассивСчетовУчета = Новый Массив;
		Для Каждого СтрокаСписка Из СписокНалогов Цикл
			СчетУчета = Справочники.ВидыНалоговИПлатежейВБюджет.СчетУчета(СтрокаСписка.Значение);
			Если ЗначениеЗаполнено(СчетУчета) Тогда
				МассивСчетовУчета.Добавить(СчетУчета);
			КонецЕсли;
		КонецЦикла;
	Иначе
		МассивСчетовУчета = ЕдиныйНалоговыйСчетПовтИсп.ОбслуживаемыеСчетаУчета(Период-1);
	КонецЕсли;
	
	СчетаИсключения = Новый Массив;
	СчетаИсключения.Добавить(ПланыСчетов.Хозрасчетный.ЕдиныйНалоговыйСчет);
	СчетаИсключения.Добавить(ПланыСчетов.Хозрасчетный.ПФР_ДОБР_орг);
	СчетаИсключения.Добавить(ПланыСчетов.Хозрасчетный.ПФР_ДОБР_сотр);
	Если Исключения <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СчетаИсключения, Исключения);
	КонецЕсли;
	
	ТаблицаНалогов = ЕдиныйНалоговыйСчет.ОписаниеТаблицНалогов();
	
	ТекущаяТаблица = ТаблицаНалогов.ТаблицаНалоги;
	
	ПредыдущийПериод = Период - 1;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода",     Новый Граница(НачалоДня(ПредыдущийПериод), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("КонецПериода",      Новый Граница(КонецДня(ПредыдущийПериод), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация",       Организация);
	Запрос.УстановитьПараметр("МассивСчетовУчета", МассивСчетовУчета);
	Запрос.УстановитьПараметр("СчетаИсключения",   СчетаИсключения);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХозрасчетныйОстаткиИОбороты.Счет КАК СчетУчета,
	|	ХозрасчетныйОстаткиИОбороты.Счет.Код КАК СчетКод,
	|	ХозрасчетныйОстаткиИОбороты.Субконто1 КАК Субконто1,
	|	ХозрасчетныйОстаткиИОбороты.Субконто2 КАК Субконто2,
	|	ХозрасчетныйОстаткиИОбороты.Субконто3 КАК Субконто3,
	|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокКт КАК ТекущаяЗадолженность,
	|	ХозрасчетныйОстаткиИОбороты.СуммаНачальныйОстатокКт - ХозрасчетныйОстаткиИОбороты.СуммаОборотДт КАК ПросроченнаяЗадолженность
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Период,
	|			,
	|			Счет В (&МассивСчетовУчета)
	|				И НЕ Счет В (&СчетаИсключения),
	|			,
	|			Организация = &Организация) КАК ХозрасчетныйОстаткиИОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	СчетКод";
	
	ТаблицаОстатки = Запрос.Выполнить().Выгрузить();
	
	ВидыНалоговыхПлатежей = Перечисления.ВидыПлатежейВГосБюджет.ВидыНалоговыхПлатежей();
	СчетФиксированныхВзносов = ПланыСчетов.Хозрасчетный.ПФР_ОПС_ИП;
	
	Для Каждого СтрокаТаблицы Из ТаблицаОстатки Цикл
		СуммаОстатка  = СтрокаТаблицы.ТекущаяЗадолженность;
		
		СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.СчетУчета);
		НомерСубконто = НомерВидаСубконтоНаСчете(СвойстваСчета, "ВидыПлатежейВГосБюджет");
		Если НомерСубконто > 0 Тогда
			ВидПлатежа = СтрокаТаблицы["Субконто" + НомерСубконто];
			Если ВидыНалоговыхПлатежей.Найти(ВидПлатежа) <> Неопределено Тогда
				Если ВидПлатежа = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
					// Задолженность прошлого периода не уплачена
					СуммаОстатка = Макс(0, СтрокаТаблицы.ПросроченнаяЗадолженность);
				ИначеЕсли ВидПлатежа = Перечисления.ВидыПлатежейВГосБюджет.ВзносыСвышеПредела И СтрокаТаблицы.СчетУчета = СчетФиксированныхВзносов Тогда
					// Вероятно это начисленные взносы ИП со сроком уплаты 1 июля
					СуммаОстатка = 0;
				ИначеЕсли ВидПлатежа = Перечисления.ВидыПлатежейВГосБюджет.ГосрегистрацияОрганизацийЧерезМФЦ Тогда
					// Госпошлина
					СуммаОстатка = 0;
				КонецЕсли; // Иначе - Все что доначислено - по прошлым периодам
			КонецЕсли;
		КонецЕсли;
		
		Если СуммаОстатка = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТекущаяТаблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		Если ТекущаяТаблица.Колонки.Найти("СчетЗатрат") <> Неопределено Тогда
			НоваяСтрока.СчетЗатрат = СтрокаТаблицы.СчетУчета;
		КонецЕсли;
		НоваяСтрока.Сумма = СуммаОстатка;
	КонецЦикла;
	ТекущаяТаблица.Колонки.Добавить("ВидНалоговогоОбязательства", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыПлатежейВГосБюджет"));
	ЕдиныйНалоговыйСчет.ЗаполнитьВидыНалогов(ТекущаяТаблица, Организация, Период);
	
	МассивСтрокКУдалению = Новый Массив;
	Для Каждого СтрокаТаблицы Из ТекущаяТаблица Цикл
		Если ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов Тогда
			Если ВидыНалоговыхПлатежей.Найти(СтрокаТаблицы.ВидНалоговогоОбязательства) = Неопределено Тогда
				МассивСтрокКУдалению.Добавить(СтрокаТаблицы);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаМассива Из МассивСтрокКУдалению Цикл
		ТекущаяТаблица.Удалить(СтрокаМассива);
	КонецЦикла;
	
	ЕдиныйНалоговыйСчет.ДозаполнитьТаблицуНалогов(ТекущаяТаблица, Организация, Период, ВводНачальныхДанных);
	
	Возврат ТаблицаНалогов;
	
КонецФункции

Процедура ЗачетПереплатПрочихРасчетов(Параметры, Движения, Отказ)
	
	Реквизиты = Параметры.ТаблицаРеквизиты[0];
	
	ГоловнаяОрганизация = БухгалтерскийУчетПереопределяемый.ГоловнаяОрганизация(Реквизиты.Организация);
	Организации         = БухгалтерскийУчетПереопределяемый.ВсяОрганизация(ГоловнаяОрганизация);
	
	Период = НачалоДня(Реквизиты.Период) - 1;
	
	ПрименяетсяУСН = УчетнаяПолитика.ПрименяетсяУСН(ГоловнаяОрганизация, Период);
	
	СчетаУчета = Новый Массив;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СчетаУчета, БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.РасчетыПоНалогам));
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СчетаУчета, БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.РасчетыПоСоциальномуСтрахованию));
	ИндексЭлемента = СчетаУчета.Найти(ПланыСчетов.Хозрасчетный.ФСС_НСиПЗ);
	СчетаУчета.Удалить(ИндексЭлемента);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организации",    Организации);
	Запрос.УстановитьПараметр("ПериодОстатков", Новый Граница(КонецДня(Период), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("СчетаУчета",     СчетаУчета);
	Запрос.УстановитьПараметр("ПрименяетсяУСН", ПрименяетсяУСН);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПрочиеРасчетыОстатки.Организация КАК Организация,
	|	ПрочиеРасчетыОстатки.СчетУчета КАК СчетУчета,
	|	ПрочиеРасчетыОстатки.Контрагент КАК Контрагент,
	|	ПрочиеРасчетыОстатки.РасчетныйДокумент КАК РасчетныйДокумент,
	|	ПрочиеРасчетыОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ВЫБОР
	|		КОГДА &ПрименяетсяУСН
	|			ТОГДА -1
	|		ИНАЧЕ 1
	|	КОНЕЦ * ПрочиеРасчетыОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.ПрочиеРасчеты.Остатки(
	|			&ПериодОстатков,
	|			Организация В (&Организации)
	|				И СчетУчета В (&СчетаУчета)) КАК ПрочиеРасчетыОстатки
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ПрименяетсяУСН
	|				ТОГДА ПрочиеРасчетыОстатки.СуммаОстаток > 0
	|			ИНАЧЕ ПрочиеРасчетыОстатки.СуммаОстаток < 0
	|		КОНЕЦ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборДвижений = Движения.ПрочиеРасчеты;
	НаборДвижений.Очистить();
	
	Если ПрименяетсяУСН Тогда
		ВидДвижения = ВидДвиженияНакопления.Приход;
	Иначе
		ВидДвижения = ВидДвиженияНакопления.Расход;
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = НаборДвижений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Реквизиты);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.ВидДвижения = ВидДвижения;
		НоваяСтрока.Активность  = Истина;
	КонецЦикла;
	
	НаборДвижений.Записывать = Истина;
	
КонецПроцедуры

Функция НомерВидаСубконтоНаСчете(СвойстваСчета, ИмяВидаСубконто)
	
	ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные[ИмяВидаСубконто];
	Если СвойстваСчета.ВидСубконто1 = ВидСубконто Тогда
		Возврат 1;
	ИначеЕсли СвойстваСчета.ВидСубконто2 = ВидСубконто Тогда
		Возврат 2;
	ИначеЕсли СвойстваСчета.ВидСубконто3 = ВидСубконто Тогда
		Возврат 3;
	Иначе
		Возврат 0;
	КонецЕсли;

КонецФункции

Функция ИмяСобытияЖурналаРегистрации() Экспорт

	Возврат НСтр("ru = 'Переход на Единый налоговый счет'", ОбщегоНазначения.КодОсновногоЯзыка());

КонецФункции // ИмяСобытияЖурналаРегистрации()

Процедура УдалитьСтрокиТЧОперацииПереходаНаЕНСПоСпискуНалогов(ОперацияЕНСОбъект, ИмяТаблицы, СписокНалогов)
	
	ТаблицаДокумента = ОперацияЕНСОбъект[ИмяТаблицы];
	
	Если ТаблицаДокумента.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивСчетовУчета = Новый Массив;
	Для Каждого СтрокаСписка Из СписокНалогов Цикл
		СчетУчета = Справочники.ВидыНалоговИПлатежейВБюджет.СчетУчета(СтрокаСписка.Значение);
		Если ЗначениеЗаполнено(СчетУчета) Тогда
			МассивСчетовУчета.Добавить(СчетУчета);
		КонецЕсли;
	КонецЦикла;
	
	ИндексСтроки = 0;
	Пока ИндексСтроки < ТаблицаДокумента.Количество() Цикл
		СтрокаТЧ = ТаблицаДокумента[ИндексСтроки];
		СчетУчета = Неопределено;
		Если ИмяТаблицы = "Налоги" Тогда
			СчетУчета = СтрокаТЧ.СчетУчета;
		ИначеЕсли ИмяТаблицы = "Санкции" Тогда
			СчетУчета = СтрокаТЧ.СчетЗатрат;
		КонецЕсли;
		Если МассивСчетовУчета.Найти(СчетУчета) <> Неопределено Тогда
			ТаблицаДокумента.Удалить(СтрокаТЧ);
		Иначе
			ИндексСтроки = ИндексСтроки + 1;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

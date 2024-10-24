﻿
#Область СлужебныйПрограммныйИнтерфейс

Функция ОписаниеПодсказокРаздела(Раздел) Экспорт
	
	Результат = Новый Структура("ДополнительнаяФункциональность");
	МаксимальноеКоличествоСоветовВПанели = УправлениеПанельюПодсказкиКлиентСервер.МаксимальноеКоличествоСоветовВПанели();
	ШаблонИмениЭлементаСоветы = "СоветПоРаботе%1";
	Для Индекс = 1 По МаксимальноеКоличествоСоветовВПанели Цикл
		Результат.Вставить(СтрШаблон(ШаблонИмениЭлементаСоветы, Индекс), "");
	КонецЦикла;
	
	МаксимальноеКоличествоВидеороликов = УправлениеПанельюПодсказкиКлиентСервер.МаксимальноеКоличествоВидеороликовВПанели();
	ШаблонИмениЭлементаВидео = "Видеоинструкция%1";
	Для ИндексВидео = 1 По МаксимальноеКоличествоВидеороликов Цикл
		Результат.Вставить(СтрШаблон(ШаблонИмениЭлементаВидео, ИндексВидео), "");
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(Раздел) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ЭтоРазделСписка = УправлениеПанельюПодсказкиКлиентСервер.ЭтоРазделСписка(Раздел);
	
	Если ЭтоРазделСписка Тогда
		Результат.ДополнительнаяФункциональность = ОписаниеДополнительнойФункциональности(Раздел);
	КонецЕсли;
	
	СписокСоветов = СоветыПоРаботеСПрограммой(Раздел);
	КоличествоСоветов = 0;
	
	Для Каждого ТекущийСовет Из СписокСоветов Цикл
		
		Если КоличествоСоветов >= МаксимальноеКоличествоСоветовВПанели Тогда
			Прервать;
		КонецЕсли;
		
		Если ТекущийСовет.Пометка Тогда
			
			КоличествоСоветов = КоличествоСоветов + 1;
			Результат[СтрШаблон(ШаблонИмениЭлементаСоветы, КоличествоСоветов)] = ТекущийСовет.Значение;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СписокВидеороликов = СсылкиНаВидеороликиРаздела(Раздел);
	КоличествоВидеороликов = 0;
	
	Для Каждого ТекущийВидеоролик Из СписокВидеороликов Цикл
		
		Если КоличествоВидеороликов >= МаксимальноеКоличествоВидеороликов Тогда
			Прервать;
		КонецЕсли;
		
		Если ТекущийВидеоролик.Пометка Тогда
			КоличествоВидеороликов = КоличествоВидеороликов + 1;
			Результат[СтрШаблон(ШаблонИмениЭлементаВидео, КоличествоВидеороликов)] = ТекущийВидеоролик.Значение;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита) Экспорт
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает функциональность, которая доступна в простом интерфейсе и не включена.
// Функциональность по умолчанию располагается в порядке часто используемой:
//  - учет по договорам
//  - оплата платежной картой
//  - путевые листы
//  - выпуск продукции
//  - и т.п.
//
// Возвращаемое значение:
//   ТаблицаЗначений - см. ФункциональностьДоступнаяДляВключения()
//
Функция ФункциональностьДоступнаяДляВключения(ИмяСписка)
	
	ОписаниеФункциональности = Обработки.ФункциональностьПрограммы.ОписаниеФункциональности();
	
	Отбор = Новый Структура("ДоступнаВПростомИнтерфейсе, Доступна", Истина, Истина);
	
	НастройкиПростогоИнтерфейса = ОписаниеФункциональности.НайтиСтроки(Отбор);
	
	ТаблицаФункциональности = НовыйФункциональностьДоступнаяДляВключения();
	ФункциональностьРаздела = ФункциональностьРаздела(ИмяСписка);
	
	Для Каждого ТекущаяНастройка Из НастройкиПростогоИнтерфейса Цикл
		
		Если Не Константы[ТекущаяНастройка.Имя].Получить()
			И ФункциональностьРаздела.Найти(ТекущаяНастройка.Раздел) <> Неопределено Тогда
			
			НоваяСтрока = ТаблицаФункциональности.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяНастройка);
			НоваяСтрока.Синоним = ПредставлениеФункциональности(ТекущаяНастройка.Имя);
			НоваяСтрока.Порядок = ПриоритетФункциональности(ТекущаяНастройка.Имя);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаФункциональности.Сортировать("Порядок");
	
	Результат = Новый Структура("Представление, Ссылка");
	
	Если ТаблицаФункциональности.Количество() > 0 Тогда
		Результат.Представление = ТаблицаФункциональности[0].Синоним;
		Результат.Ссылка = ТаблицаФункциональности[0].Раздел;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НовыйФункциональностьДоступнаяДляВключения()
	
	ТаблицаФункциональности = Новый ТаблицаЗначений;
	ТаблицаФункциональности.Колонки.Добавить("Имя", ОбщегоНазначения.ОписаниеТипаСтрока(255));
	ТаблицаФункциональности.Колонки.Добавить("Раздел", ОбщегоНазначения.ОписаниеТипаСтрока(50));
	ТаблицаФункциональности.Колонки.Добавить("Синоним", ОбщегоНазначения.ОписаниеТипаСтрока(255));
	ТаблицаФункциональности.Колонки.Добавить("Порядок", ОбщегоНазначения.ОписаниеТипаЧисло(1));
	
	Возврат ТаблицаФункциональности;
	
КонецФункции

Функция ПредставлениеФункциональности(ИмяФункциональности)
	
	Представление = НРег(Метаданные.Константы[ИмяФункциональности].Синоним);
	Представление = СтрЗаменить(Представление, НСтр("ru = 'ведется'"), "");
	Представление = СтрЗаменить(Представление, НСтр("ru = 'вести'"), "");
	Представление = СтрЗаменить(Представление, НСтр("ru = 'использовать'"), "");
	
	Возврат СокрЛП(Представление);
	
КонецФункции

Функция ПриоритетФункциональности(ИмяФункциональности)
	
	ПриоритетыФункций = Новый Соответствие;
	ПриоритетыФункций.Вставить("ВестиУчетРасчетовСКонтрагентами", 0);
	ПриоритетыФункций.Вставить("ВестиУчетПоДоговорам", 2);
	ПриоритетыФункций.Вставить("ИспользоватьОплатуПоПлатежнымКартам", 3);
	ПриоритетыФункций.Вставить("ИспользоватьКадровыйУчет", 4);
	ПриоритетыФункций.Вставить("ВедетсяУчетПоПутевымЛистам", 5);
	
	Приоритет = ПриоритетыФункций.Получить(ИмяФункциональности);
	Если Приоритет = Неопределено Тогда
		Возврат 9;
	КонецЕсли;
	
	Возврат Приоритет;
	
КонецФункции

Функция ФункциональностьРаздела(Раздел)
	
	Результат = Новый Массив;
	
	Если Раздел = УправлениеПанельюПодсказкиКлиентСервер.РазделДокументы() Тогда
		
		Результат.Добавить("УчетПоДоговорам");
		Результат.Добавить("Запасы");
		Результат.Добавить("Документы");
		Результат.Добавить("Расчеты");
		Результат.Добавить("ПланированиеПлатежей");
		Результат.Добавить("Торговля");
		Результат.Добавить("РозничнаяТорговля");
		Результат.Добавить("ВнешняяТорговля");
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.РазделТовары() Тогда
		
		Результат = Новый Массив;
		Результат.Добавить("ОбязательнаяМаркировка");
		Результат.Добавить("Производство");
		Результат.Добавить("Торговля");
		Результат.Добавить("РозничнаяТорговля");
		Результат.Добавить("ВнешняяТорговля");
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.РазделДеньги() Тогда
		
		Результат.Добавить("БанкКасса");
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.РазделКонтрагенты() Тогда
		
		Результат.Добавить("УчетПоДоговорам");
		Результат.Добавить("Расчеты");
		
	ИначеЕсли Раздел = "Сотрудники" Тогда
		
		Результат.Добавить("ЗарплатаКадры");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОписаниеДополнительнойФункциональности(Раздел)
	
	ЕстьПравоПросмотраФункциональности = ПравоДоступа("Просмотр", Метаданные.Обработки.ФункциональностьПрограммы);
	
	Если Не ЕстьПравоПросмотраФункциональности Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДопФункции = Новый Массив;
	
	ДоступнаяФункциональность = ФункциональностьДоступнаяДляВключения(Раздел);
	
	Если ЗначениеЗаполнено(ДоступнаяФункциональность.Представление) Тогда
		ДопФункции.Добавить(СтрШаблон(НСтр("ru = 'Вы можете добавить нужные вам функции, например, %1, в разделе: '"),
			ДоступнаяФункциональность.Представление));
	Иначе
		ДопФункции.Добавить(НСтр("ru = 'Вы можете добавить нужные вам функции, в разделе: '"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДоступнаяФункциональность.Ссылка) Тогда
		СсылкаНаФункциональность = СтрШаблон("Группа%1", ДоступнаяФункциональность.Ссылка);
	Иначе
		СсылкаНаФункциональность = "Главное";
	КонецЕсли;
	
	ДопФункции.Добавить(Новый ФорматированнаяСтрока(
		НСтр("ru = 'Настройки - Функциональность'"), , , ,
		СсылкаНаФункциональность));
	
	Возврат Новый ФорматированнаяСтрока(ДопФункции);
	
КонецФункции

Функция СсылкиНаВидеороликиРаздела(Раздел)
	
	СсылкиНаВидео = Новый СписокЗначений;
	ВестиУчетРасчетовСКонтрагентами = ПолучитьФункциональнуюОпцию("ВестиУчетРасчетовСКонтрагентами");
	
	Если Раздел = УправлениеПанельюПодсказкиКлиентСервер.РазделДеньги() Тогда
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/depositingip"">Взнос денег на счет ИП</a>'")),
			, Истина);
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/bank"">Как заплатить поставщику</a>'")), 
			, ВестиУчетРасчетовСКонтрагентами);
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/cash"">Как принять оплату наличными</a>'")), 
			, ВестиУчетРасчетовСКонтрагентами);
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.РазделДокументы() Тогда
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/bill"">Как подготовить счет</a>'")), 
			, Истина);
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/selling/"">Как оформить накладную или акт</a>'")), 
			, Истина);
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.РазделТовары() Тогда
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/goods"">Как принять товар</a>'")), 
			, ВестиУчетРасчетовСКонтрагентами);
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.РазделКонтрагенты() Тогда
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/partners"">Узнайте всё о своих покупателях и поставщиках</a>'")), 
			, Истина);
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументСчетНаОплатуПокупателю() Тогда
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/bill"">Как подготовить счет</a>'")), 
			, Истина);
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/regularbilling"">Регулярное выставление счетов</a>'")), 
			, Истина);
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументСчетНаОплатуПоставщика() Тогда
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/goodsvsmaterials"">Чем отличаются товары от материалов</a>'")), 
			, Истина);
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/identicalgoods"">Что делать, если появилось два одинаковых товара</a>'")), 
			, Истина);
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументПоступлениеТоваровУслугПокупкаКомиссия()
		Или Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументПоступлениеТоваровУслугТовары() Тогда
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/goods"">Как принять товар</a>'")), 
			, Истина);
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/goodsvsmaterials"">Чем отличаются товары от материалов</a>'")), 
			, Истина);
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументРеализацияТоваровУслугПродажаКомиссия()
		Или Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументРеализацияТоваровУслугТовары()
		Или Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументРеализацияТоваровУслугУслуги() Тогда
		
		СсылкиНаВидео.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = '<a href=""http://its.1c.ru/bmk/youtube/bs/selling/"">Как оформить накладную или акт</a>'")), 
			, Истина);
		
	КонецЕсли;
	
	Возврат СсылкиНаВидео;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой(Раздел)
	
	Если Раздел = УправлениеПанельюПодсказкиКлиентСервер.РазделДеньги() Тогда
		
		Возврат СоветыПоРаботеСПрограммой_Деньги();
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.РазделДокументы() Тогда
		
		Возврат СоветыПоРаботеСПрограммой_Документы();
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.РазделТовары() Тогда
		
		Возврат СоветыПоРаботеСПрограммой_Товары();
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.РазделКонтрагенты() Тогда
		
		Возврат СоветыПоРаботеСПрограммой_Контрагенты();
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументСчетНаОплатуПокупателю() Тогда
		
		Возврат СоветыПоРаботеСПрограммой_СчетНаОплатуПокупателю();
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументСчетНаОплатуПоставщика() Тогда
		
		Возврат СоветыПоРаботеСПрограммой_СчетНаОплатуПоставщика();
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументПоступлениеТоваровУслугПокупкаКомиссия() Тогда
		
		Возврат СоветыПоРаботеСПрограммой_ПоступлениеТоваровУслугПокупкаКомиссия();
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументПоступлениеТоваровУслугТовары() Тогда
		
		Возврат СоветыПоРаботеСПрограммой_ПоступлениеТоваровУслугТовары();
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументПоступлениеТоваровУслугУслуги() Тогда
		
		Возврат СоветыПоРаботеСПрограммой_ПоступлениеТоваровУслугУслуги();
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументРеализацияТоваровУслугПродажаКомиссия() Тогда
		
		Возврат СоветыПоРаботеСПрограммой_РеализацияТоваровУслугПродажаКомиссия();
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументРеализацияТоваровУслугТовары() Тогда
		
		Возврат СоветыПоРаботеСПрограммой_РеализацияТоваровУслугТовары();
		
	ИначеЕсли Раздел = УправлениеПанельюПодсказкиКлиентСервер.ДокументРеализацияТоваровУслугУслуги() Тогда
		
		Возврат СоветыПоРаботеСПрограммой_РеализацияТоваровУслугУслуги();
		
	КонецЕсли;
	
	Возврат Новый СписокЗначений;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой_Деньги()
	
	ОсновнаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	ОрганизацияЗаполнена = ЗначениеЗаполнено(ОсновнаяОрганизация);
	
	Советы = Новый СписокЗначений;
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Заполните данные о своём расчётном счёте в разделе <a href=""e1cib/command/Обработка.ПанелиПростойИнтерфейс.Команда.Настройки"">Настройки</a>.'")),
		, Не ОрганизацияЗаполнена Или Не ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОсновнаяОрганизация, "ОсновнойБанковскийСчет")));
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Для прямого взаимодействия с банком воспользуйтесь сервисом <a href=""ДиректБанк"">1С:ДиректБанк</a>. Условия подключения устанавливает банк, в котором открыт счёт.'")),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Для выгрузки реестра бансковских документов откройте список <a href=""БанковскиеВыписки"">Банковские выписки</a> и нажмите команду ""Реестр документов"".'")),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Нажмите кнопку <img src=""НовоеОкно""> (Открыть новое окно), чтобы открыть текущее окно в новой вкладке.'")),
		, Истина);
	
	Возврат Советы;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой_Документы()
	
	ОсновнаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	ОрганизацияЗаполнена = ЗначениеЗаполнено(ОсновнаяОрганизация);
	
	Советы = Новый СписокЗначений;
	
	ВестиУчетРасчетовСКонтрагентами = ПолучитьФункциональнуюОпцию("ВестиУчетРасчетовСКонтрагентами");
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Заполните данные о своём расчётном счёте в разделе <a href=""e1cib/command/Обработка.ПанелиПростойИнтерфейс.Команда.Настройки"">Настройки</a>.'")),
		, Не ОрганизацияЗаполнена Или Не ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОсновнаяОрганизация, "ОсновнойБанковскийСчет")));
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Для выставления клиенту счёта на оплату, нажмите: <a href=""СчетПокупателю"">Документы - Счет покупателю</a>.'")),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'При продаже товаров покупателю, создайте <a href=""РеализацияТоваров"">Накладную</a>, а в случае оказания услуги клиенту - отразите <a href=""РеализацияУслуг"">Акт</a>.'")),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Нажмите кнопку <img src=""НовоеОкно""> (Открыть новое окно), чтобы открыть текущее окно в новой вкладке.'")),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Для отражения счета от поставщика, нажмите: <a href=""СчетПоставщику"">Документы - Счет от поставщика</a>.'")),
		, ВестиУчетРасчетовСКонтрагентами);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'При покупке товаров у поставщика, создайте <a href=""ПоступлениеТоваров"">Накладную</a>, а при оказании услуги поставщиком - отразите <a href=""ПоступлениеУслуг"">Акт</a>.'")),
		, ВестиУчетРасчетовСКонтрагентами);
	
	Возврат Советы;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой_Товары()
	
	Советы = Новый СписокЗначений;
	
	ВестиУчетРасчетовСКонтрагентами = ПолучитьФункциональнуюОпцию("ВестиУчетРасчетовСКонтрагентами");
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Вы можете загрузить товары и актуальные цены из файла с помощью команды: <a href=""ЗагрузитьТовары"">Файл - Загрузить</a>'")),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Посмотреть остатки товаров можно, нажав: <a href=""e1cib/app/Отчет.ОстаткиТоваров"">Отчеты - Остатки товаров</a>.'")),
		, ВестиУчетРасчетовСКонтрагентами);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Если вам необходимо выгрузить список товаров с ценами, нажмите: <a href=""e1cib/command/Обработка.ВыгрузкаНоменклатурыИЦенВФайл.Команда.ВыгрузитьВФайл"">Выгрузить</a> и установите необходимые отборы.'")),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Нажмите кнопку <img src=""НовоеОкно""> (Открыть новое окно), чтобы открыть текущее окно в новой вкладке.'")),
		, Истина);
	
	Возврат Советы;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой_Контрагенты()
	
	Советы = Новый СписокЗначений;
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Вы можете загрузить список контрагентов из файла с помощью команды: <a href=""ЗагрузитьКонтрагенты"">Загрузить</a>'")),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Проверьте контрагента по данным ЕГРЮЛ/ЕГРИП, выбрав его в списке и нажав кнопку: <a href=""e1cib/command/Отчет.ДосьеКонтрагента.Команда.Досье"">Досье</a>.'")),
		, Истина);
	
	Советы.Добавить(НСтр("ru = 'Вы можете вывести список контрагентов и сохранить в файл: меню Ещё - Вывести список.'"),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Нажмите кнопку <img src=""НовоеОкно""> (Открыть новое окно), чтобы открыть текущее окно в новой вкладке.'")),
		, Истина);
	
	Возврат Советы;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой_СчетНаОплатуПокупателю()
	
	Советы = Новый СписокЗначений;
	
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ВестиУчетПоДоговорам) Тогда
		ДополнениеКОписаниюСовета1 = "включите функциональность: <a href=""НастроитьУчетПоДоговорам"">Настройки - Функциональность - Учет по договорам</a>";
	Иначе
		ДополнениеКОписаниюСовета1 = "попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Учет по договорам</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Почему в счете нет поля Договор?</span>
		|Чтобы появилось поле <span style=""font: ШрифтЭлементаПодсказки"">Договор</span>, %1'"), ДополнениеКОписаниюСовета1)),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как загрузить товары из Excel?</span>
		|Чтобы загрузить товары из Excel, нажмите на кнопку <a href=""ДействиеЗагрузитьИзФайла"">Загрузить</a> и выберите файл'")),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как установить наценку на товары?</span>
		|Чтобы изменить цену товарам, нажмите на кнопку <a href=""ДействиеИзменитьТовары"">Изменить</a>'")),
		, Истина);
	
	Возврат Советы;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой_СчетНаОплатуПоставщика()
	
	Советы = Новый СписокЗначений;
	
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ВестиУчетПоДоговорам) Тогда
		ДополнениеКОписаниюСовета1 = "включите функциональность: <a href=""НастроитьУчетПоДоговорам"">Настройки - Функциональность - Учет по договорам</a>";
	Иначе
		ДополнениеКОписаниюСовета1 = "попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Учет по договорам</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Почему в счете нет поля Договор?</span>
		|Чтобы появилось поле <span style=""font: ШрифтЭлементаПодсказки"">Договор</span>, %1'"), ДополнениеКОписаниюСовета1)),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как загрузить счет из файла?</span>
		|Чтобы загрузить счет из файла, отправленного поставщиком по электронной почте из программы 1С, перейдите в список <a href=""e1cib/list/Документ.СчетНаОплатуПоставщика"">Счета от поставщиков</a> и нажмите на кнопку <span style=""font: ШрифтЭлементаПодсказки"">Загрузить - Из файла</span>. <a href=""https://buh.ru/articles/faq/45736/"">Подробнее</a>'")),
		, Истина);
	
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ИспользоватьПланированиеПлатежейПоставщикам) Тогда
		ДополнениеКОписаниюСовета3 = "Включите функциональность: <a href=""НастроитьПланированиеПлатежей"">Настройки - Функциональность - Планирование платежей - Планирование платежей поставщикам</a>";
	Иначе
		ДополнениеКОписаниюСовета3 = "Попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Планирование платежей - Планирование платежей поставщикам</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как сформировать платежки по неоплаченным счетам?</span>
		|%1. Перейдите в список <a href=""e1cib/list/Документ.ПлатежноеПоручение"">Платежные поручения</a> и нажмите на кнопку <span style=""font: ШрифтЭлементаПодсказки"">Оплатить - Товары и услуги</span>'"), ДополнениеКОписаниюСовета3)),
		, Истина);
	
	Возврат Советы;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой_ПоступлениеТоваровУслугПокупкаКомиссия()
	
	Советы = Новый СписокЗначений;
	
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ВестиУчетПоДоговорам) Тогда
		ДополнениеКОписаниюСовета1 = "включите функциональность: <a href=""НастроитьУчетПоДоговорам"">Настройки - Функциональность - Учет по договорам</a>";
	Иначе
		ДополнениеКОписаниюСовета1 = "попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Учет по договорам</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Почему в поступлении нет поля Договор?</span>
		|Чтобы появилось поле <span style=""font: ШрифтЭлементаПодсказки"">Договор</span>, %1'"), ДополнениеКОписаниюСовета1)),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как скопировать строки с товарами из одного документа в другой?</span>
		|Сначала в одном документе выделите строки с товарами и нажмите на кнопку <a href=""ДействиеТоварыСкопироватьСтроки"">Скопировать строки</a>. Затем в другом документе нажмите на кнопку <a href=""ДействиеТоварыВставитьСтроки"">Вставить строки</a>'")),
		, Истина);
	
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ВедетсяУчетВозвратнойТары) Тогда
		ДополнениеКОписаниюСовета3 = "включите функциональность: <a href=""НастроитьЗапасы"">Настройки - Функциональность - Запасы - Возвратная тара</a>";
	Иначе
		ДополнениеКОписаниюСовета3 = "попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Запасы - Возвратная тара</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как вернуть поставщику возвратную тару?</span>
		|Возврат поставщику многооборотной тары отразите, нажав в меню <span style=""font: ШрифтЭлементаПодсказки"">Еще - Создать на основании - Возврат товаров поставщику</span>. Для работы с возвратной тарой %1'"), ДополнениеКОписаниюСовета3)),
		, Истина);
	
	Возврат Советы;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой_ПоступлениеТоваровУслугТовары()
	
	Советы = Новый СписокЗначений;
	
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ВестиУчетПоДоговорам) Тогда
		ДополнениеКОписаниюСовета1 = "включите функциональность: <a href=""НастроитьУчетПоДоговорам"">Настройки - Функциональность - Учет по договорам</a>";
	Иначе
		ДополнениеКОписаниюСовета1 = "попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Учет по договорам</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Почему в поступлении нет поля Договор?</span>
		|Чтобы появилось поле <span style=""font: ШрифтЭлементаПодсказки"">Договор</span>, %1'"), ДополнениеКОписаниюСовета1)),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как загрузить накладную, УПД из файла?</span>
		|Чтобы загрузить накладную или УПД из файла, отправленного поставщиком по электронной почте из программы 1С, перейдите в список <a href=""e1cib/list/Документ.ПоступлениеТоваровУслуг"">Поступление (акты, накладные, УПД)</a> и нажмите на кнопку <span style=""font: ШрифтЭлементаПодсказки"">Загрузить - Из файла</span>. <a href=""https://buh.ru/articles/faq/45736/"">Подробнее</a>'")),
		, Истина);
		
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ВедетсяУчетИмпортныхТоваров) Тогда
		ДополнениеКОписаниюСовета3 = "включите функциональность: <a href=""НастроитьВнешняяТорговля"">Настройки - Функциональность - Внешняя торговля - Приобретение и реализация импортных товаров</a>";
	Иначе
		ДополнениеКОписаниюСовета3 = "попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Внешняя торговля - Приобретение и реализация импортных товаров</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Где вносить ГТД и страну происхождения товара?</span>
		|Чтобы в таблице товаров появились колонки <span style=""font: ШрифтЭлементаПодсказки"">Таможенная декларация</span> и <span style=""font: ШрифтЭлементаПодсказки"">Страна происхождения</span>, %1'"), ДополнениеКОписаниюСовета3)),
		, Истина);
	
	Возврат Советы;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой_ПоступлениеТоваровУслугУслуги()
	
	Советы = Новый СписокЗначений;
	
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ВестиУчетПоДоговорам) Тогда
		ДополнениеКОписаниюСовета1 = "включите функциональность: <a href=""НастроитьУчетПоДоговорам"">Настройки - Функциональность - Учет по договорам</a>";
	Иначе
		ДополнениеКОписаниюСовета1 = "попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Учет по договорам</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Почему в акте нет поля Договор?</span>
		|Чтобы появилось поле <span style=""font: ШрифтЭлементаПодсказки"">Договор</span>, %1'"), ДополнениеКОписаниюСовета1)),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как загрузить акт из файла?</span>
		|Чтобы загрузить акт из файла, отправленного поставщиком по электронной почте из программы 1С, перейдите в список <a href=""e1cib/list/Документ.ПоступлениеТоваровУслуг"">Поступление (акты, накладные, УПД)</a> и нажмите на кнопку <span style=""font: ШрифтЭлементаПодсказки"">Загрузить - Из файла</span>. <a href=""https://buh.ru/articles/faq/45736/"">Подробнее</a>'")),
		, Истина);
	
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.УправлениеЗачетомАвансовПогашениемЗадолженности) Тогда
		ДополнениеКОписаниюСовета3 = "включите функциональность: <a href=""НастроитьРасчеты"">Настройки - Функциональность - Расчеты - Управление зачетом авансов и погашением задолженности</a>";
	Иначе
		ДополнениеКОписаниюСовета3 = "попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Расчеты - Управление зачетом авансов и погашением задолженности</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как перенести задолженность на другой договор?</span>
		|Используйте документ <a href=""e1cib/list/Документ.КорректировкаДолга"">Контрагенты - Корректировка долга</a>. Для этого %1'"), ДополнениеКОписаниюСовета3)),
		, Истина);
	
	Возврат Советы;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой_РеализацияТоваровУслугПродажаКомиссия()
	
	Советы = Новый СписокЗначений;
	
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ВестиУчетПоДоговорам) Тогда
		ДополнениеКОписаниюСовета1 = "включите функциональность: <a href=""НастроитьУчетПоДоговорам"">Настройки - Функциональность - Учет по договорам</a>";
	Иначе
		ДополнениеКОписаниюСовета1 = "попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Учет по договорам</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Почему в реализации нет поля Договор?</span>
		|Чтобы появилось поле <span style=""font: ШрифтЭлементаПодсказки"">Договор</span>, %1'"), ДополнениеКОписаниюСовета1)),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как выбрать имеющиеся в наличии товары?</span>
		|Чтобы выбрать оставшиеся на складе товары, нажмите на кнопку <a href=""ДействиеПодборТовары"">Подбор</a>, станьте на нужную позицию и нажмите на кнопку <span style=""font: ШрифтЭлементаПодсказки"">Выбрать остаток</span>'")),
		, Истина);
		
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ОтключитьКонтрольОтрицательныхОстатков) Тогда
		ДополнениеКОписаниюСовета3 = "отключите настройку: <a href=""НастроитьПроведениеДокументов"">Настройки - Еще - Другие настройки - Проведение документов - Разрешить списание запасов при отсутствии остатков по данным учета</a>";
	Иначе
		ДополнениеКОписаниюСовета3 = "попросите администратора отключить настройку: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Еще - Другие настройки - Проведение документов - Разрешить списание запасов при отсутствии остатков по данным учета</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как запретить продажу товара в минус?</span>
		|Чтобы запретить продавать товары, которых нет в остатках, %1'"), ДополнениеКОписаниюСовета3)),
		, Истина);
	
	Возврат Советы;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой_РеализацияТоваровУслугТовары()
	
	Советы = Новый СписокЗначений;
	
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ВестиУчетПоДоговорам) Тогда
		ДополнениеКОписаниюСовета1 = "включите функциональность: <a href=""НастроитьУчетПоДоговорам"">Настройки - Функциональность - Учет по договорам</a>";
	Иначе
		ДополнениеКОписаниюСовета1 = "попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Учет по договорам</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Почему в реализации нет поля Договор?</span>
		|Чтобы появилось поле <span style=""font: ШрифтЭлементаПодсказки"">Договор</span>, %1'"), ДополнениеКОписаниюСовета1)),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как составить накладную из двух счетов?</span>
		|Чтобы заполнить документ на основании нескольких счетов, нажмите на кнопку <a href=""ДействиеДобавитьИзСчета"">Добавить</a>'")),
		, Истина);
	
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ИспользоватьДоставкуАвтотранспортом) Тогда
		ДополнениеКОписаниюСовета3 = "включите функциональность: <a href=""НастроитьТорговля"">Настройки - Функциональность - Торговля - Доставка товара автотранспортом</a>";
	Иначе
		ДополнениеКОписаниюСовета3 = "попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Торговля - Доставка товара автотранспортом</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как сформировать транспортную накладную?</span>
		|Чтобы печатать транспортную накладную из реализации, %1'"), ДополнениеКОписаниюСовета3)),
		, Истина);
	
	Возврат Советы;
	
КонецФункции

Функция СоветыПоРаботеСПрограммой_РеализацияТоваровУслугУслуги()
	
	Советы = Новый СписокЗначений;
	
	Если УправлениеПанельюПодсказки.ПравоИзмененияНастройки(Метаданные.Константы.ВестиУчетПоДоговорам) Тогда
		ДополнениеКОписаниюСовета1 = "включите функциональность: <a href=""НастроитьУчетПоДоговорам"">Настройки - Функциональность - Учет по договорам</a>";
	Иначе
		ДополнениеКОписаниюСовета1 = "попросите администратора включить функциональность: <span style=""font: ШрифтЭлементаПодсказки"">Настройки - Функциональность - Учет по договорам</span>";
	КонецЕсли;
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Почему в акте нет поля Договор?</span>
		|Чтобы появилось поле <span style=""font: ШрифтЭлементаПодсказки"">Договор</span>, %1'"), ДополнениеКОписаниюСовета1)),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как составить акт из двух счетов?</span>
		|Чтобы заполнить документ на основании нескольких счетов, нажмите на кнопку <a href=""ДействиеДобавитьИзСчета"">Добавить</a>'")),
		, Истина);
	
	Советы.Добавить(СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = '<span style=""font: ШрифтЗаголовкаПодсказки"">Как проконтролировать возврат покупателем подписанного акта?</span>
		|Для контроля за возвратом подписанного контрагентом экземпляра документа, используйте флажок <a href=""ПолеСтатусДокумента"">Документ подписан</a>. Смотрите за колонкой <span style=""font: ШрифтЭлементаПодсказки"">Подписан</span> в списке <a href=""e1cib/list/Документ.РеализацияТоваровУслуг"">Реализация (акты, накладные, УПД)</a>'")),
		, Истина);
	
	Возврат Советы;
	
КонецФункции

#КонецОбласти
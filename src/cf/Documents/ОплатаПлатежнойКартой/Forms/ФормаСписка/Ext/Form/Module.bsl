﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.ОплатаПлатежнойКартой);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Документ.ОплатаПлатежнойКартой",
		"ФормаСписка",
		НСтр("ru='Новости: Оплаты платежными картами'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
	АдресХранилищаНастройкиДинСпискаДляРеестра = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ИспользоватьОнлайнОплаты = ПолучитьФункциональнуюОпцию("ИспользоватьОнлайнОплаты");
	
	ДоступнаИнтеграцияССБП = СистемаБыстрыхПлатежей.НастройкаПодключенияДоступна();
	
	ИспользуетсяНПД = ПолучитьФункциональнуюОпцию("ДоступнаИнтеграцияСПлатформойСамозанятые");
	
	УстановитьУсловноеОформление();
	
	ПомеченныеНаУдалениеСервер.СкрытьПомеченныеНаУдаление(ЭтотОбъект);
	
	// РекламныйСервис
	РекламныйСервис.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РекламныйСервис
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
	Если ИспользоватьОнлайнОплаты Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗагрузитьОперацииОнлайнОплат", 1, Истина);
	КонецЕсли;
	
	Если ИспользуетсяНПД Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьСтатусОфлайнЧековНПД", 1, Истина);
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ЗагрузитьОперацииПоСБП", 1, Истина);
	
	// РекламныйСервис
	РекламныйСервисКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец РекламныйСервис
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список,, Параметр);
	ИначеЕсли ИмяСобытия = "ИзмененСтатусДокументов" Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = ЧекиНПДКлиент.ИмяСобытияИзменениеСтатусаОфлайнЧека() Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
	ОнлайнОплатыБПКлиент.ОбработкаОповещения_ФормаСписка(Элементы.Список, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	ЧекиНПД.УстановитьВДинамическомСпискеПредставленияАннулированныхЧеков(Строки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьОплаты(Команда)
	
	Если ИспользоватьОнлайнОплаты Тогда
		ОнлайнОплатыБПКлиент.НачатьЗагрузкуОперацийОнлайнОплат(Истина);
	КонецЕсли;
	
	ЗагрузитьОперацииПоСБП(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийРеквизитовШапки

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтаФорма,
		Команда
	);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ПомеченныеНаУдалениеКлиент.ПриИзмененииСписка(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
	ОтборыСписков.СброситьИспользованиеПользовательскихОтборовВНастройке(Настройки);
	
	ПомеченныеНаУдалениеСервер.УдалитьОтборПометкаУдаления(Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	БанкИКассаФормы.УстановитьУсловноеОформлениеНПД(ЭтотОбъект);
	
КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

#Область ИнтеграцияССБП

&НаКлиенте
Процедура ЗагрузитьОперацииПоСБП(ВыводитьОкноОжидания = Ложь)
	
	Если Не ДоступнаИнтеграцияССБП Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Загрузка статусов операций.'");
	ПараметрыОжидания.ВыводитьОкноОжидания = ВыводитьОкноОжидания;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = ВыводитьОкноОжидания;
	
	РезультатВыполнения = ЗагрузитьСтатусыОплатыЗапускЗадания(УникальныйИдентификатор);
	Если РезультатВыполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("ВыводитьОкноОжидания", ВыводитьОкноОжидания);
		Если РезультатВыполнения.Статус = "Выполнено" Или РезультатВыполнения.Статус = "Ошибка" Тогда
		ЗагрузитьСтатусыОплатыЗавершение(РезультатВыполнения, ДополнительныеПараметры);
		Возврат;
	КонецЕсли;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ЗагрузитьСтатусыОплатыЗавершение",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗагрузитьОперацииПоСБП()
	
	ЗагрузитьОперацииПоСБП();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗагрузитьСтатусыОплатыЗапускЗадания(ИдентификаторЗадания)
	
	// Возможно, что фоновое задание было запущено раньше,
	// пользователь дал команду его отменить, однако задание не отменено.
	// В таком случае не следует запускать задание повторно - следует дождаться его выполнения.
	// Мы можем отследить ситуацию только, если все это происходит в одной форме.
	// Потому что подсистема ДлительныеОперации не умеет устанавливать ключ фонового задания.
	Если ЗакрытиеМесяца.ЗаданиеЕщеВыполняется(ИдентификаторЗадания) Тогда
		// Надо ждать
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторЗадания);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка статусов операций.'");
	ПараметрыВыполнения.КлючФоновогоЗадания = "ПолучитьСтатусыОперацияC2B";
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ИнтеграцияССБПБП.ПолучитьСтатусыОперацияC2B",
		,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьСтатусыОплатыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыводитьОкноОжидания = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		ДополнительныеПараметры, "ВыводитьОкноОжидания", Ложь);
	
	Если Результат.Статус = "Выполнено" Тогда
		Если ВыводитьОкноОжидания Тогда
			ВыполнененыеОплаты = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
			КоличествоОплат = ?(ЗначениеЗаполнено(ВыполнененыеОплаты), ВыполнененыеОплаты.Количество(), 0);
			Если КоличествоОплат > 0 Тогда
				КоличествоОплатСтр = СтрокаСЧислом(НСтр("ru = '; %1 оплата;; %1 оплаты; %1 оплат; %1 оплат'"),
					КоличествоОплат, ВидЧисловогоЗначения.Количественное, "L=ru");
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Загружено из СБП: %1'"), КоличествоОплатСтр);
				ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка завершена'"),
					"e1cib/list/Документ.ОплатаПлатежнойКартой",
					ТекстСообщения,, СтатусОповещенияПользователя.Важное, "СБП");
			Иначе
				ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка завершена'"),
					"e1cib/list/Документ.ОплатаПлатежнойКартой",
					НСтр("ru = 'Новых операций по СБП нет'"),, СтатусОповещенияПользователя.Важное, "СБП");
			КонецЕсли;
		КонецЕсли;
		
		Элементы.Список.Обновить();
		ОповеститьОбИзменении(Тип("ДокументСсылка.СчетНаОплатуПокупателю"));
	ИначеЕсли Результат.Статус = "Ошибка" И ВыводитьОкноОжидания Тогда
		ПоказатьОповещениеПользователя(
			Результат.КраткоеПредставлениеОшибки,
			,
			,
			БиблиотекаКартинок.Ошибка32);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОнлайнОплаты

&НаКлиенте
Процедура Подключаемый_ЗагрузитьОперацииОнлайнОплат()
	
	ОнлайнОплатыБПКлиент.НачатьЗагрузкуОперацийОнлайнОплат(Ложь);
	
	ПодключитьОбработчикОжидания("Подключаемый_ЗагрузитьОперацииОнлайнОплат", 300, Истина); // Каждые 5 минут.
	
КонецПроцедуры

#КонецОбласти

#Область ЧекиНПД

&НаКлиенте
Процедура Подключаемый_ОбновитьСтатусОфлайнЧековНПД()
	
	ЧекиНПДКлиент.ОбновитьСтатусыОфлайнЧековНПД();
	
КонецПроцедуры

#КонецОбласти

#Область РекламныйСервис

&НаКлиенте
Процедура Подключаемый_ЗаполнитьРекламныйНоситель()
	РекламныйСервисКлиент.ЗаполнитьРекламныйНоситель(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПоказатьКнопкуЗакрытьРекламу()
	РекламныйСервисКлиент.ПоказатьКнопкуЗакрытьРекламу(ЭтотОбъект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_МакетРекламныйСервисПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РекламныйСервисКлиент.МакетРекламныйСервисНажатие(ЭтотОбъект, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_КомандаЗакрытьРекламу()
	РекламныйСервисКлиент.КомандаЗакрытьРекламу(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если УправлениеПечатьюБПКлиентСервер.ЭтоИмяКомандыРеестрДокументов(Команда.Имя) Тогда
		НастройкиДинамическогоСписка(Команда.Имя);
	КонецЕсли;
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура НастройкиДинамическогоСписка(ИмяВФорме)
	
	Отчеты.РеестрДокументов.НастройкиДинамическогоСписка(ЭтотОбъект,, ИмяВФорме);
	
КонецПроцедуры

#КонецОбласти

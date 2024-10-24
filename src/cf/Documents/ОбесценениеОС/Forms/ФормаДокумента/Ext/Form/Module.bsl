﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборОсновныхСредств.Форма.Форма" Тогда
		ДлительнаяОперация = Неопределено;
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ДлительнаяОперация);
		ЗапуститьПроверкуФоновогоЗаданияУчетныеДанныеОС(ДлительнаяОперация);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтотОбъект, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПроведениеСервер.УстановитьПризнакПроверкиРеквизитов(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзмененаИнформацияОС", Объект.Ссылка);
	ДлительнаяОперация = ЗаполнитьУчетныеДанныеОС();
	ЗапуститьПроверкуФоновогоЗаданияУчетныеДанныеОС(ДлительнаяОперация);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	ОпределитьМежотчетныйПериодДляРетроспективногоОбесценения();
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);
	
	// Проверим наличие строк в табличной части.
	Если Объект.ОС.Количество() > 0 Тогда
		ТребуетсяВызовСервера = Истина;
	КонецЕсли;
	
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то перечитаем предыдущие значения.
	Если ТребуетсяВызовСервера Тогда
		ДлительнаяОперация = ЗаполнитьУчетныеДанныеОС();
		ЗапуститьПроверкуФоновогоЗаданияУчетныеДанныеОС(ДлительнаяОперация);
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОпределитьМежотчетныйПериодДляРетроспективногоОбесценения();
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ДлительнаяОперация = ЗаполнитьУчетныеДанныеОС();
		ЗапуститьПроверкуФоновогоЗаданияУчетныеДанныеОС(ДлительнаяОперация);
	КонецЕсли;
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОС

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		// Очистим колонки, при очистке основного средства
		Для Каждого ИмяКолонки Из Объект.ОС.Выгрузить().Колонки Цикл
			СтрокаТЧ[ИмяКолонки] = Неопределено;
		КонецЦикла;
	Иначе
		ОСОсновноеСредствоПриИзмененииНаСервере(ОсновноеСредство);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОС.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ЗаполнитьДобавленныеКолонкиСтроки(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОСВозмещаемаяСтоимостьПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	
	//Убыток от обесценения
	Если СтрокаТЧ.ВозмещаемаяСтоимость <= СтрокаТЧ.БалансоваяСтоимость Тогда
		
		СтрокаТЧ.СуммаУбыткаПризнаваемая = СтрокаТЧ.БалансоваяСтоимость - СтрокаТЧ.ВозмещаемаяСтоимость;
		СтрокаТЧ.СуммаУбыткаВосстанавливаемая = 0;
		
	//Восстановление убытка от обесценения
	ИначеЕсли СтрокаТЧ.ВозмещаемаяСтоимость > СтрокаТЧ.БалансоваяСтоимость 
		И СтрокаТЧ.СуммаОбесценения > 0 Тогда
		
		СтрокаТЧ.СуммаУбыткаПризнаваемая = 0;
		СтрокаТЧ.СуммаУбыткаВосстанавливаемая = Мин(СтрокаТЧ.СуммаОбесценения, СтрокаТЧ.ВозмещаемаяСтоимость - СтрокаТЧ.БалансоваяСтоимость);
		
	КонецЕсли;
	
	СтрокаТЧ.ИзменениеОбесценения = СтрокаТЧ.СуммаУбыткаПризнаваемая - СтрокаТЧ.СуммаУбыткаВосстанавливаемая;
	
КонецПроцедуры

&НаКлиенте
Процедура ОССуммаУбыткаПризнаваемаяПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	СтрокаТЧ.СуммаУбыткаВосстанавливаемая = 0;
	СтрокаТЧ.ИзменениеОбесценения = СтрокаТЧ.СуммаУбыткаПризнаваемая - СтрокаТЧ.СуммаУбыткаВосстанавливаемая;
	
КонецПроцедуры

&НаКлиенте
Процедура ОССуммаУбыткаВосстанавливаемаяПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	СтрокаТЧ.СуммаУбыткаВосстанавливаемая = Мин(СтрокаТЧ.СуммаУбыткаВосстанавливаемая, СтрокаТЧ.СуммаОбесценения);
	СтрокаТЧ.СуммаУбыткаПризнаваемая = 0;
	СтрокаТЧ.ИзменениеОбесценения = СтрокаТЧ.СуммаУбыткаПризнаваемая - СтрокаТЧ.СуммаУбыткаВосстанавливаемая;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказатьОстатки", Истина);
	ПараметрыФормы.Вставить("ДатаОстатков", Объект.Дата);
	ПараметрыФормы.Вставить("Организация",  Объект.Организация);
	
	Если Объект.ОС.Количество() > 0 Тогда
		ПараметрыФормы.Вставить("АдресОСВХранилище", ПоместитьОСВХранилище());
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ПодборОсновныхСредств.Форма.Форма", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьСостояниеДокумента();
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	ЗаполнитьИнвентарныеНомераОС();
	
	ЗаполнитьДобавленныеКолонки();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	УстановитьУсловноеОформлениеОС();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеОС()

	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОССуммаУбыткаВосстанавливаемая");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ОС.СуммаОбесценения", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОСОсновноеСредствоПриИзмененииНаСервере(ОсновноеСредство)
	
	МассивОсновныеСредства = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОсновноеСредство);
	ЗаполнитьУчетныеДанныеОС(МассивОсновныеСредства);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	Элементы.ОСЗаголовокСуммаВосстановления.Видимость = НЕ Объект.МежотчетныйПериод;
	Элементы.ОССуммаУбыткаВосстанавливаемая.Видимость = НЕ Объект.МежотчетныйПериод;
	Элементы.ОСЗаголовокОбесценение.Видимость = НЕ Объект.МежотчетныйПериод;
	Элементы.ОССуммаОбесценения.Видимость = НЕ Объект.МежотчетныйПериод;
	Элементы.СтатьяПрочихДоходовРасходов.Видимость = НЕ Объект.МежотчетныйПериод;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ФСБУ6ПрименяетсяДосрочно(Организация)
	Возврат ПолучитьФункциональнуюОпцию("ПрименятьФСБУ6Досрочно", Новый Структура("Организация", Организация));
КонецФункции

&НаКлиенте
Процедура ОпределитьМежотчетныйПериодДляРетроспективногоОбесценения()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) ИЛИ НЕ ЗначениеЗаполнено(Объект.Дата) Тогда
		Объект.МежотчетныйПериод = Ложь;
		Возврат;
	КонецЕсли;
	
	Если НЕ ФСБУ6ПрименяетсяДосрочно(Объект.Организация) Тогда
		МежотчетныйПериод = ?(КонецДня(Объект.Дата) = КонецГода(Объект.Дата), Истина, Ложь) И Год(Объект.Дата) = 2021;
		Объект.МежотчетныйПериод = МежотчетныйПериод;
		Если МежотчетныйПериод Тогда
			Объект.Дата = КонецДня(Объект.Дата);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#Область Подбор

&НаСервере
Функция ПоместитьОСВХранилище()
	
	ТаблицаОС = Объект.ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство");
	Возврат ПоместитьВоВременноеХранилище(ТаблицаОС);
	
КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(Знач ВыбранноеЗначение, ДлительнаяОперация = Неопределено)
	
	ДобавленныеСтроки = УчетОС.ОбработатьПодборОсновныхСредств(Объект.ОС, ВыбранноеЗначение);
	
	// Обработаем добавленные строки
	МассивОсновныхСредств = ОбщегоНазначения.ВыгрузитьКолонку(ДобавленныеСтроки, "ОсновноеСредство");
	ДлительнаяОперация = ЗаполнитьУчетныеДанныеОС(МассивОсновныхСредств);
	ЗаполнитьНовыеЗначения(ДобавленныеСтроки);
	ЗаполнитьДобавленныеКолонки();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнвентарныеНомераОС()
	
	ТаблицаОС = Объект.ОС.Выгрузить();
	
	ТаблицаНомеров = УчетОС.ПолучитьТаблицуИнвентарныхНомеровОС(ТаблицаОС,
		Объект.Организация, Объект.Дата);
	
	Объект.ОС.Загрузить(ТаблицаНомеров);
	
КонецПроцедуры

#КонецОбласти

#Область Заполнение

&НаКлиенте
Процедура Подключаемый_ЗаполнитьПредыдущиеЗначения()
	
	ДлительнаяОперация = ЗаполнитьУчетныеДанныеОС();
	ЗапуститьПроверкуФоновогоЗаданияУчетныеДанныеОС(ДлительнаяОперация);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьУчетныеДанныеОС(ОсновныеСредства = Неопределено)
	
	Если Объект.ОС.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение данных основных средств'");
	
	Если ОсновныеСредства = Неопределено Тогда
		ОсновныеСредства = ОбщегоНазначения.ВыгрузитьКолонку(Объект.ОС, "ОсновноеСредство");
	КонецЕсли;
	
	МаксимальноеКоличествоОСБезФона = 10;
	Если ОсновныеСредства.Количество() < МаксимальноеКоличествоОСБезФона Тогда
		// Если заполняем по небольшому количеству строк, то запускаем получение информации не в фоне
		ПараметрыЗапуска.ЗапуститьНеВФоне = Истина;
	КонецЕсли;
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("Организация",           Объект.Организация);
	ПараметрыВыполнения.Вставить("Дата",                  Объект.Дата);
	ПараметрыВыполнения.Вставить("МежотчетныйПериод",     Объект.МежотчетныйПериод);
	ПараметрыВыполнения.Вставить("Ссылка",                Объект.Ссылка);
	ПараметрыВыполнения.Вставить("МассивОсновныхСредств", ОсновныеСредства);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыВыполнения.Дата = КонецДня(ПараметрыВыполнения.Дата);
	КонецЕсли;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		"Документы.ОбесценениеОС.УчетныеДанныеОС",
		ПараметрыВыполнения,
		ПараметрыЗапуска);
	
	Если ДлительнаяОперация <> Неопределено И ДлительнаяОперация.Статус = "Выполнено" Тогда
		ЗаполнитьУчетныеДанныеОСПослеПолученияВФоне(ДлительнаяОперация);
		
		Возврат Неопределено;
	Иначе
		Элементы.ГруппаОжиданиеЗаполненияПредыдущихЗначений.Видимость = Истина;
		Элементы.ОС.ТолькоПросмотр = Истина;
		Возврат ДлительнаяОперация;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьУчетныеДанныеОСПослеПолученияВФоне(Результат)
	
	Элементы.ГруппаОжиданиеЗаполненияПредыдущихЗначений.Видимость = Ложь;
	Элементы.ОС.ТолькоПросмотр = Ложь;
	
	Если Результат = Неопределено Тогда // задание было отменено
		Возврат;
	КонецЕсли;
	
	УчетныеДанныеОС = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Для Каждого СтрокаТаблицы Из Объект.ОС Цикл
		ДанныеОС = УчетныеДанныеОС.Найти(СтрокаТаблицы.ОсновноеСредство, "ОсновноеСредство");
		Если ДанныеОС = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ДанныеОС);
		
	КонецЦикла;
КонецПроцедуры
 
&НаКлиенте
Процедура ЗапуститьПроверкуФоновогоЗаданияУчетныеДанныеОС(ДлительнаяОперация)
	
	Если ДлительнаяОперация <> Неопределено Тогда
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗаполнитьУчетныеДанныеОСЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьУчетныеДанныеОСЗавершение(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда // задание было отменено
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Ошибка" Тогда
		СообщитьОбОшибкеДлительнойОперации(ДлительнаяОперация);
	Иначе
		ЗаполнитьУчетныеДанныеОСПослеПолученияВФоне(ДлительнаяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНовыеЗначения(ДобавленныеСтроки = Неопределено)
	
	Если ДобавленныеСтроки = Неопределено Тогда
		ДобавленныеСтроки = Объект.ОС;
	КонецЕсли;
			
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонки()

	Для Каждого СтрокаТаблицы Из Объект.ОС Цикл
		ЗаполнитьДобавленныеКолонкиСтроки(СтрокаТаблицы);
	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеКолонкиСтроки(СтрокаТаблицы)
	
	СтрокаТаблицы.ЗаголовокБалансоваяСтоимость   = НСтр("ru='балансовая стоимость'");
	СтрокаТаблицы.ЗаголовокВозмещаемаяСтоимость  = НСтр("ru='возмещаемая сумма'");
	
	СтрокаТаблицы.ЗаголовокОбесценение           = НСтр("ru='накопленное обесценение'");
	СтрокаТаблицы.ЗаголовокСуммаОбесценения      = НСтр("ru='признать убыток'");
	СтрокаТаблицы.ЗаголовокСуммаВосстановления   = НСтр("ru='восстановить убыток'");
	
	ЗаполнитьКолонкиИзменениеОбесценения(СтрокаТаблицы);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьКолонкиИзменениеОбесценения(СтрокаТаблицы)
	
	Если СтрокаТаблицы.ИзменениеОбесценения > 0 Тогда
		
		СтрокаТаблицы.СуммаУбыткаПризнаваемая = СтрокаТаблицы.ИзменениеОбесценения;
		СтрокаТаблицы.СуммаУбыткаВосстанавливаемая = 0;
		
		//Восстановление убытка от обесценения
	ИначеЕсли СтрокаТаблицы.ИзменениеОбесценения < 0 Тогда
		
		СтрокаТаблицы.СуммаУбыткаПризнаваемая = 0;
		СтрокаТаблицы.СуммаУбыткаВосстанавливаемая = - СтрокаТаблицы.ИзменениеОбесценения;;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РегламентныеЗаданияИДлительныеОперации

&НаКлиенте
Процедура СообщитьОбОшибкеДлительнойОперации(ДлительнаяОперация)
	
	ШаблонСообщения = НСтр("ru = 'При выполнении операции произошла ошибка:
							|%1
							|Подробности в журнале регистрации.'");
	Если ЗначениеЗаполнено(ДлительнаяОперация.КраткоеПредставлениеОшибки) Тогда
		СообщениеОбОшибке = СтрШаблон(ШаблонСообщения, ДлительнаяОперация.КраткоеПредставлениеОшибки);
	Иначе
		СообщениеОбОшибке = СтрШаблон(ШаблонСообщения, ДлительнаяОперация.ПодробноеПредставлениеОшибки);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти
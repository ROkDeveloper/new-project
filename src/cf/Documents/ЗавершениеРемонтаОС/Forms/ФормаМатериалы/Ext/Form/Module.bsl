﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Организация,ПодразделениеОрганизации,Склад,Дата,ОсновноеСредство");
	
	Если ЗначениеЗаполнено(Параметры.АдресХранилищаЦенностей)
		И ЭтоАдресВременногоХранилища(Параметры.АдресХранилищаЦенностей) Тогда
		
		ТаблицыПараметров = ПолучитьИзВременногоХранилища(Параметры.АдресХранилищаЦенностей);
		УдалитьИзВременногоХранилища(Параметры.АдресХранилищаЦенностей);
		
		Если ЗначениеЗаполнено(ТаблицыПараметров.ТаблицаМатериалы) Тогда
			Материалы.Загрузить(ТаблицыПараметров.ТаблицаМатериалы);
		КонецЕсли;
		
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
	УстановитьВидимостьСчетовУчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ДанныеСкопированыВБуферОбмена" Тогда
		УстановитьДоступностьКомандыВставки(ЭтотОбъект, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	РеквизитыТабличнойЧасти = Метаданные.Документы.ЗавершениеРемонтаОС.ТабличныеЧасти.Материалы.Реквизиты;
	
	ЭлементыИМетаданные = Новый Структура;
	ЭлементыИМетаданные.Вставить("Номенклатура", РеквизитыТабличнойЧасти.Номенклатура);
	ЭлементыИМетаданные.Вставить("Количество", РеквизитыТабличнойЧасти.Количество);
	ЭлементыИМетаданные.Вставить("Цена", РеквизитыТабличнойЧасти.Цена);
	ЭлементыИМетаданные.Вставить("Сумма", РеквизитыТабличнойЧасти.Сумма);
	Если СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета() Тогда
		ЭлементыИМетаданные.Вставить("СчетУчета", РеквизитыТабличнойЧасти.СчетУчета);
	КонецЕсли;
	ЭлементыИМетаданные.Вставить("СтатьяЗатрат", РеквизитыТабличнойЧасти.СтатьяЗатрат);
	
	ПроверяемыйСписок = РедактированиеВПодчиненныхФормах.НовыйПроверяемыйСписок();
	ПроверяемыйСписок.Таблица = Материалы;
	ПроверяемыйСписок.Имя = "Материалы";
	ПроверяемыйСписок.Синоним = СинонимТабличнойЧасти();
	
	РедактированиеВПодчиненныхФормах.ВыполнитьПроверкуЗаполненияТаблицыПоРеквизитамМетаданных(
		ПроверяемыйСписок, ЭлементыИМетаданные, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемФормыЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
	Если НЕ Отказ И Модифицированность Тогда
		Отказ = Не ПроверитьЗаполнение();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыМатериалы

&НаКлиенте
Процедура МатериалыПриИзменении(Элемент)
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура,Количество,Цена,Сумма,СтатьяЗатрат");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
	ДанныеОбъекта.Вставить("СпособЗаполненияЦены", ПредопределенноеЗначение("Перечисление.СпособыЗаполненияЦен.ПоПродажнымЦенам"));
	ДанныеОбъекта.Вставить("СуммаВключаетНДС", Ложь);
	
	ПараметрыЗаполненияСчетовУчета = НачатьЗаполнениеСчетовУчета(
		"Материалы.Номенклатура",
		Неопределено,
		ТекущиеДанные,
		ДанныеОбъекта,
		ДанныеСтрокиТаблицы);
		
	МатериалыНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта, ПараметрыЗаполненияСчетовУчета.КЗаполнению);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиентБП.НоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыНоменклатураАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ПараметрыПолученияДанных.Вставить("ВидыНоменклатуры", "Материалы,Товары");
	
	РаботаСНоменклатуройКлиентБП.НоменклатураАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыНоменклатураОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ПараметрыПолученияДанных.Вставить("ВидыНоменклатуры", "Материалы,Товары");
	
	РаботаСНоменклатуройКлиентБП.НоменклатураОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(ТекущиеДанные);
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыЦенаПриИзменении(Элемент)
	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(Элементы.Материалы.ТекущиеДанные);
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	Если ТекущиеДанные.Количество = 0 Тогда
		ТекущиеДанные.Цена = ТекущиеДанные.Сумма;
	Иначе
		ТекущиеДанные.Цена = Окр(ТекущиеДанные.Сумма / ТекущиеДанные.Количество, 2);
	КонецЕсли;
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ЗакрытьФормуИВернутьРезультат(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	ЗакрытьФормуИВернутьРезультат(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПодбораМатериалы(Команда)
	
	ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма",
		ПолучитьПараметрыПодбора(),
		ЭтотОбъект,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	КоличествоСтрок = Элементы.Материалы.ВыделенныеСтроки.Количество();
	Если КоличествоСтрок = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СкопироватьСтрокиНаСервере();
	ОбработкаТабличныхЧастейКлиент.ОповеститьОКопированииСтрокВБуферОбмена(ЭтотОбъект, КоличествоСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	КоличествоСтрок = ВставитьСтрокиНаСервере();
	ОбработкаТабличныхЧастейКлиент.ОповеститьОВставкеСтрокИзБуфераОбмена(ЭтотОбъект, КоличествоСтрок);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Заголовок = СтрШаблон(НСтр("ru = '%1: %2'"), СинонимТабличнойЧасти(), ОсновноеСредство);
	
	ВалютаДокумента = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	УстановитьОграниченияЭлементовФормыИзМетаданных();
	
	ОбновитьИтоги(ЭтотОбъект);
	
	// Проверка буфера обмена на наличие скопированных строк
	УстановитьДоступностьКомандыВставки(ЭтотОбъект, Не ОбщегоНазначения.ПустойБуферОбмена());
	
КонецПроцедуры

&НаСервере
Функция СинонимТабличнойЧасти()
	
	Возврат НСтр("ru = 'Материалы, полученные в ходе ремонта'");
	
КонецФункции

&НаСервере
Процедура УстановитьОграниченияЭлементовФормыИзМетаданных()
	
	ЭлементыИМетаданные = Новый Соответствие;
	
	ЭлементыИМетаданные.Вставить(Элементы.МатериалыНоменклатура,
		Метаданные.Документы.ЗавершениеРемонтаОС.ТабличныеЧасти.Материалы.Реквизиты.Номенклатура);
	
	ЭлементыИМетаданные.Вставить(Элементы.МатериалыКоличество,
		Метаданные.Документы.ЗавершениеРемонтаОС.ТабличныеЧасти.Материалы.Реквизиты.Количество);
	
	ЭлементыИМетаданные.Вставить(Элементы.МатериалыЦена,
		Метаданные.Документы.ЗавершениеРемонтаОС.ТабличныеЧасти.Материалы.Реквизиты.Цена);
	
	ЭлементыИМетаданные.Вставить(Элементы.МатериалыСумма,
		Метаданные.Документы.ЗавершениеРемонтаОС.ТабличныеЧасти.Материалы.Реквизиты.Сумма);
	
	ЭлементыИМетаданные.Вставить(Элементы.МатериалыСчетУчета,
		Метаданные.Документы.ЗавершениеРемонтаОС.ТабличныеЧасти.Материалы.Реквизиты.СчетУчета);
	
	ЭлементыИМетаданные.Вставить(Элементы.МатериалыСтатьяЗатрат,
		Метаданные.Документы.ЗавершениеРемонтаОС.ТабличныеЧасти.Материалы.Реквизиты.СтатьяЗатрат);
	
	РедактированиеВПодчиненныхФормах.УстановитьСвойстваЭлементовПоРеквизитамМетаданных(ЭлементыИМетаданные);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗакрытьФормуИВернутьРезультат(Истина);
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		ЗакрытьФормуИВернутьРезультат(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуИВернутьРезультат(ПередатьВладельцуРезультат)
	
	РезультатЗаполнения = Неопределено;
	
	Если ПередатьВладельцуРезультат Тогда
		
		Если НЕ ПроверитьЗаполнение() Тогда
			Возврат;
		КонецЕсли;
		
		РезультатЗаполнения = Новый Структура;
		РезультатЗаполнения.Вставить("Материалы", Материалы);
		
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть(РезультатЗаполнения);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)
	
	Форма.ИтогиВсего = Форма.Материалы.Итог("Сумма");
	
КонецПроцедуры

#Область ПодборКопированиеИВставка

&НаКлиенте
Функция ПолучитьПараметрыПодбора()
	
	ПараметрыФормы = Новый Структура;
	
	ДатаРасчетов = ?(НачалоДня(Дата) = НачалоДня(ТекущаяДата()), Неопределено, Дата);
	
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Подбор номенклатуры в ""%1""'"), СинонимТабличнойЧасти());
	
	ПараметрыФормы.Вставить("ДатаРасчетов",          ДатаРасчетов);
	ПараметрыФормы.Вставить("Склад",                 Склад);
	ПараметрыФормы.Вставить("Организация",           Организация);
	ПараметрыФормы.Вставить("Подразделение",         ПодразделениеОрганизации);
	ПараметрыФормы.Вставить("Валюта",                ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	ПараметрыФормы.Вставить("ЕстьЦена",              Ложь);
	ПараметрыФормы.Вставить("ЕстьКоличество",        Истина);
	ПараметрыФормы.Вставить("Заголовок",             ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ИмяТаблицы",            "Материалы");
	ПараметрыФормы.Вставить("Услуги",                Ложь);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервере
Процедура СкопироватьСтрокиНаСервере()
	
	ОбщегоНазначения.СкопироватьСтрокиВБуферОбмена(Материалы, 
		Элементы.Материалы.ВыделенныеСтроки);
	
КонецПроцедуры

&НаСервере
Функция ВставитьСтрокиНаСервере()
	
	ПараметрыВставки = ОбработкаТабличныхЧастей.ПолучитьПараметрыВставкиДанныхИзБуфераОбмена(
		Документы.ЗавершениеРемонтаОС.ПустаяСсылка(), "Материалы");
	ОпределитьСписокСвойствДляВставкиИзБуфера(ПараметрыВставки);
	ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ПараметрыВставки);
	
	Возврат ПараметрыВставки.КоличествоДобавленныхСтрок;
	
КонецФункции

&НаСервере
Процедура ОпределитьСписокСвойствДляВставкиИзБуфера(ПараметрыВставки)
	
	СписокСвойств = Новый Массив;
	
	СписокСвойств.Добавить("Номенклатура");
	СписокСвойств.Добавить("Количество");
	СписокСвойств.Добавить("Цена");
	СписокСвойств.Добавить("Сумма");
	СписокСвойств.Добавить("СтатьяЗатрат");
	
	Если ПараметрыВставки.ПоказыватьСчетаУчетаВДокументах Тогда
		СписокСвойств.Добавить("СчетУчета");
	КонецЕсли;
	
	ПараметрыВставки.СписокСвойств = ОбработкаТабличныхЧастей.ПолучитьСписокСвойствИмеющихсяВТаблицеДанных(
		ПараметрыВставки.Данные, СписокСвойств);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение)
	
	ЭтоВставкаИзБуфера = ВыбранноеЗначение.Свойство("ЭтоВставкаИзБуфера");
	СписокСвойств = Неопределено;
	Если ЭтоВставкаИзБуфера Тогда
		ТаблицаЦенностей = ВыбранноеЗначение.Данные;
		СписокСвойств = ВыбранноеЗначение.СписокСвойств;
	Иначе
		ТаблицаЦенностей = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
	КонецЕсли;
	
	КоличествоДобавленныхСтрок = 0;
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
	ДанныеОбъекта.Вставить("СпособЗаполненияЦены", ПредопределенноеЗначение("Перечисление.СпособыЗаполненияЦен.ПоПродажнымЦенам"));
	ДанныеОбъекта.Вставить("СуммаВключаетНДС", Ложь);
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаЦенностей, "Номенклатура", Истина),
		ДанныеОбъекта, Ложь);
	
	Для Каждого СтрокаТовара Из ТаблицаЦенностей Цикл
		
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТовара.Номенклатура);
		
		// Пропускаем строки с неправильным типом номенклатуры
		Если ЭтоВставкаИзБуфера 
			И СведенияОНоменклатуре <> Неопределено
			И ЗначениеЗаполнено(СведенияОНоменклатуре.Услуга)
			И СведенияОНоменклатуре.Услуга Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		СтрокаТабличнойЧасти = Материалы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовара, СписокСвойств);
		
		КоличествоДобавленныхСтрок = КоличествоДобавленныхСтрок + 1;
		
		Если СтрокаТабличнойЧасти.Сумма = 0 Тогда
			
			Если ЗначениеЗаполнено(СведенияОНоменклатуре) Тогда
				Если СтрокаТабличнойЧасти.Цена = 0 Тогда
					СтрокаТабличнойЧасти.Цена = СведенияОНоменклатуре.Цена;
				КонецЕсли;
			КонецЕсли;
			
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
			
		ИначеЕсли СтрокаТабличнойЧасти.Количество <> 0 Тогда
			
			СтрокаТабличнойЧасти.Цена =  Окр(СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество, 2);
			
		КонецЕсли;
		
		ДанныеСтрокиТаблицы = Новый Структура(
			"Номенклатура,Количество,Цена,Сумма,СтатьяЗатрат");
		ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТабличнойЧасти);
		
		ПараметрыЗаполненияСчетовУчета = НачатьЗаполнениеСчетовУчета(
			"Материалы.Номенклатура",
			Неопределено,
			СтрокаТабличнойЧасти,
			ДанныеОбъекта,
			ДанныеСтрокиТаблицы);
		
		ЗаполненныеСчетаУчета = СчетаУчетаВДокументах.ЗаполнитьРеквизитыПриИзменении(
			Документы.СписаниеОС,
			ПараметрыЗаполненияСчетовУчета.КЗаполнению,
			ДанныеОбъекта,
			"Материалы",
			СтрокаТабличнойЧасти);
		
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ЗаполненныеСчетаУчета);
		
	КонецЦикла;
	
	Если ЭтоВставкаИзБуфера Тогда
		ВыбранноеЗначение.КоличествоДобавленныхСтрок = КоличествоДобавленныхСтрок;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СчетаУчета

&НаСервере
Процедура УстановитьВидимостьСчетовУчета()
	
	ЭлементыСчетов = Новый Массив();
	ЭлементыСчетов.Добавить("МатериалыСчетУчета");
	
	СчетаУчетаВДокументах.УстановитьВидимостьСчетовУчета(Элементы, ЭлементыСчетов);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НачатьЗаполнениеСчетовУчета(ПричиныИзменения, Объект = Неопределено, СтрокаСписка = Неопределено, КонтейнерОбъект = Неопределено, КонтейнерСтрокаСписка = Неопределено) Экспорт

	// Код этой функции сформирован автоматически с помощью СчетаУчетаВДокументах.КодФункцииНачатьЗаполнениеСчетовУчета()
	
	ПараметрыЗаполнения = СчетаУчетаВДокументахКлиентСервер.НовыйПараметрыЗаполнения(
		"СписаниеОС",
		ПричиныИзменения,
		Объект,
		СтрокаСписка,
		КонтейнерОбъект,
		КонтейнерСтрокаСписка);

	// 1. Заполняемые реквизиты
	// Организация
	Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Организация") <> Неопределено Тогда
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "Материалы.СчетУчета");
	КонецЕсли;

	// Дата
	Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Дата") <> Неопределено Тогда
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "Материалы.СчетУчета");
	КонецЕсли;

	// Склад
	Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Склад") <> Неопределено Тогда
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "Материалы.СчетУчета");
	КонецЕсли;
	
	// Материалы.Номенклатура
	Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Материалы.Номенклатура") <> Неопределено Тогда
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "Материалы.СчетУчета");
	КонецЕсли;
	
	// 2. (если требуется) Передадим на сервер данные, необходимые для заполнения
	Если ПараметрыЗаполнения.Свойство("Контейнер") Тогда
		// Организация
		Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Организация") <> Неопределено Тогда
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Организация");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Дата");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "Номенклатура");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "СчетУчета");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Склад");
		КонецЕсли;

		// Дата
		Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Дата") <> Неопределено Тогда
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Дата");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Организация");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "Номенклатура");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "СчетУчета");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Склад");
		КонецЕсли;

		// Материалы.Номенклатура
		Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Материалы.Номенклатура") <> Неопределено Тогда
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "Номенклатура");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "СчетУчета");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Организация");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Склад");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Дата");
		КонецЕсли;

		// Склад
		Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Склад") <> Неопределено Тогда
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Склад");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Организация");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Дата");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "Номенклатура");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "СчетУчета");
		КонецЕсли;

	КонецЕсли; // Нужно передавать на сервер данные заполнения
	
	Возврат ПараметрыЗаполнения;

КонецФункции

#КонецОбласти

&НаСервере
Процедура МатериалыНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта, Знач СчетаУчетаКЗаполнению)
	
	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта, Ложь, Истина);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СведенияОНоменклатуре.Цена <> 0 Тогда
		СтрокаТабличнойЧасти.Цена = СведенияОНоменклатуре.Цена;
	КонецЕсли;
	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
	
	Если ЗначениеЗаполнено(СведенияОНоменклатуре.СтатьяЗатрат) Тогда
		СтрокаТабличнойЧасти.СтатьяЗатрат = СведенияОНоменклатуре.СтатьяЗатрат;
	Иначе
		СтрокаТабличнойЧасти.СтатьяЗатрат = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(
			"Справочник.СтатьиЗатрат.СписаниеМатериалов");
	КонецЕсли;
	
	ЗаполненныеСчетаУчета = СчетаУчетаВДокументах.ЗаполнитьРеквизитыПриИзменении(
		Документы.ЗавершениеРемонтаОС,
		СчетаУчетаКЗаполнению,
		ДанныеОбъекта,
		"Материалы",
		СтрокаТабличнойЧасти);
	
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ЗаполненныеСчетаУчета);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКомандыВставки(Форма, Доступность)
	
	Доступность = Не Форма.ТолькоПросмотр И Доступность;
	Элементы = Форма.Элементы;
	Элементы.МатериалыВставитьСтроки.Доступность = Доступность;
	
КонецПроцедуры

#КонецОбласти


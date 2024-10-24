﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагрузитьПараметрыВРеквизитыФормы();
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы
		И (Модифицированность ИЛИ ПеренестиВДокумент) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И НЕ ПеренестиВДокумент Тогда
		
		Отказ = Истина;
		
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена,, КодВозвратаДиалога.Да);
		
	ИначеЕсли ПеренестиВДокумент Тогда
		
		Отказ = НЕ ПроверитьЗаполнение();
		
		Если Отказ Тогда
			Модифицированность = Истина;
			ПеренестиВДокумент = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПеренестиВДокумент Тогда
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("СуммаДокумента", Объект.СуммаДокумента);
		СтруктураВозврата.Вставить("АдресХранилищаВыплатаДепонентов", АдресХранилищаВыплатаДепонентов);
		
		Если ВыплатаДепонентов.Количество() > 0 Тогда
			СтруктураВозврата.Вставить("ВыплатаДепонентовВедомость", ВыплатаДепонентов[0].Ведомость);
			СтруктураВозврата.Вставить("ВыплатаДепонентовСуммаКВыплате", ВыплатаДепонентов.Итог("СуммаКВыплате"));
		КонецЕсли;
		
		ОповеститьОВыборе(СтруктураВозврата);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Документы.РасходныйКассовыйОрдер.ОбработкаПроверкиЗаполненияВыплатаДепонентов(
		Объект, ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	// Чтобы дважды не вызывать сервер, сразу поместим во временное хранилище 
	// таблицу ВыплатаДепонентов.
	Если НЕ Отказ Тогда
		АдресХранилищаВыплатаДепонентов = ПоместитьВыплатаДепонентовВоВременноеХранилище();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть(КодВозвратаДиалога.OK);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыплатаДепонентов

&НаКлиенте
Процедура ВыплатаДепонентовПередУдалением(Элемент, Отказ)
	
	Отказ = ВыплатаДепонентов.Количество() = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаДепонентовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	РасходныйКассовыйОрдерФормыКлиент.ВыплатаДепонентовПриНачалеРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, Копирование);
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элементы.ВыплатаДепонентов.ТекущиеДанные;
		ТекущиеДанные.НомерСтроки = ВыплатаДепонентов.Количество();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаДепонентовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РасходныйКассовыйОрдерФормыКлиент.ВыплатаДепонентовПриОкончанииРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаДепонентовПослеУдаления(Элемент)
	
	ОбновитьИтоги(ЭтотОбъект);
	
	ПеренумероватьСтроки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаДепонентовВедомостьПриИзменении(Элемент)
	
	РасходныйКассовыйОрдерФормыКлиент.ВыплатаДепонентовВедомостьПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаДепонентовВедомостьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РасходныйКассовыйОрдерФормыКлиент.ВыплатаДепонентовВедомостьНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаДепонентовВедомостьОчистка(Элемент, СтандартнаяОбработка)
	
	РасходныйКассовыйОрдерФормыКлиент.ВыплатаДепонентовВедомостьОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаДепонентовВедомостьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РасходныйКассовыйОрдерФормыКлиент.ВыплатаДепонентовВедомостьОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаДепонентовПриИзменении(Элемент)
	
	РасходныйКассовыйОрдерФормыКлиент.ВыплатаДепонентовПриИзменении(ЭтотОбъект, Элемент);
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьПараметрыВРеквизитыФормы()
	
	Объект = Новый Структура;
	Для каждого ПараметрЗаполнения Из Параметры.ПараметрыФормы.Шапка Цикл
		Объект.Вставить(ПараметрЗаполнения.Ключ, ПараметрЗаполнения.Значение);
	КонецЦикла;
	
	Объект.Вставить("ДополнительныеСвойства", Новый Структура()); // Используется при проверке заполнения.

	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПараметрыФормы.Шапка);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПараметрыФормы);
	
	Если ЗначениеЗаполнено(Параметры.ПараметрыФормы.АдресХранилищаВыплатаДепонентов) Тогда
		ВыплатаДепонентов.Загрузить(ПолучитьИзВременногоХранилища(Параметры.ПараметрыФормы.АдресХранилищаВыплатаДепонентов));
	КонецЕсли;
	
	Ссылка = Параметры.Ключ;
	
	Если ВыплатаДепонентов.Количество() = 0 Тогда
		ВыплатаДепонентов.Добавить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	ОбновитьИтоги(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)
	
	Элементы = Форма.Элементы;
	
	ИтогоСуммаКВыплате = Форма.ВыплатаДепонентов.Итог("СуммаКВыплате");
	
	Элементы.ВыплатаДепонентовСуммаКВыплате.ТекстПодвала = Формат(ИтогоСуммаКВыплате, "ЧЦ=15; ЧДЦ=2");
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ПеренумероватьСтроки(ЭтотОбъект);
	
	// Управление внешним видом формы
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПеренумероватьСтроки(Форма)
	
	Для Сч = 0 По Форма.ВыплатаДепонентов.Количество() - 1 Цикл
		СтрокаПлатеж = Форма.ВыплатаДепонентов[Сч];
		СтрокаПлатеж.НомерСтроки = Сч + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВыплатаДепонентовВоВременноеХранилище()
	
	ТаблицаВыплатаДепонентов = ВыплатаДепонентов.Выгрузить();
	
	АдресХранилища = ПоместитьВоВременноеХранилище(ТаблицаВыплатаДепонентов, УникальныйИдентификатор);
	
	Возврат АдресХранилища;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ЗАВЕРШЕНИЕ НЕМОДАЛЬНЫХ ВЫЗОВОВ

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СчетПокупателю" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСписка

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВвестиДокументПоШаблону(ТекущиеДанные.Правило, ТекущиеДанные.Шаблон);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьСчета(Команда)
	
	Правила = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		
		Правила.Добавить(ДанныеСтроки.Правило);
		
	КонецЦикла;
	
	Если Правила.Количество() = 1 Тогда
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		
		ВвестиДокументПоШаблону(ТекущиеДанные.Правило, ТекущиеДанные.Шаблон);
		
	Иначе
		
		СозданныеДокументы = СоздатьДокументыНаСервере(Правила);
		
		Элементы.Список.Обновить();
		
		ОткрытьСозданныеДокументы(СозданныеДокументы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Пропустить(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Правила = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		
		Правила.Добавить(ДанныеСтроки.Правило);
		
	КонецЦикла;
	
	ПропуститьВыбранныеПравилаНаСервере(Правила);
	
	Элементы.Список.Обновить();
	Оповестить("Запись_РегулярныеСчетаПокупателям");
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 1 Тогда
		
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыделенныеСтроки[0]);
		
		ТекстОповещения = НСтр("ru = 'Пропущен счет:'");
		
		ТекстПояснения = СтрШаблон(НСтр("ru = '%1 %2 руб перенесен на %3'"),
			Строка(ДанныеСтроки.Контрагент),
			Формат(ДанныеСтроки.Сумма, "ЧДЦ=2"),
			Формат(ДанныеСтроки.ДатаСледующего, "ДЛФ=DD"));
		
		Ссылка = ПолучитьНавигационнуюСсылку(ДанныеСтроки.Шаблон);
		
	Иначе
		
		ТекстОповещения = "";
		
		ТекстПояснения = СтрШаблон(НСтр("ru = 'Пропущено %1'"),
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
			ВыделенныеСтроки.Количество(), НСтр("ru = 'счет, счета, счетов'")));
		
		Ссылка = "";
		
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстОповещения, Ссылка, ТекстПояснения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДатуСледующего(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСледующего = '00010101';
	ДатаШаблона    = '00010101';
	
	Правила = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		
		ДатаСледующего = Макс(ДанныеСтроки.ДатаСледующего, ДатаСледующего);
		ДатаШаблона    = Макс(ДанныеСтроки.ДатаШаблона, ДатаШаблона);
		
		Правила.Добавить(ДанныеСтроки.Правило);
		
	КонецЦикла;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Правила",     Правила);
	ДополнительныеПараметры.Вставить("ДатаШаблона", ДатаШаблона);
	
	ОповещениеВводДаты = Новый ОписаниеОповещения("ВводДатыСледующего", ЭтаФорма, ДополнительныеПараметры);
	
	ПоказатьВводДаты(ОповещениеВводДаты, ДатаСледующего, "Изменить дату следующего", ЧастиДаты.Дата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрекратитьПовторять(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 1 Тогда
		
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыделенныеСтроки[0]);
		
		ТекстОповещения = НСтр("ru = 'Отмена повторения счета:'");
		
		ТекстПояснения = СтрШаблон(НСтр("ru = '%1 %2 руб'"),
			Строка(ДанныеСтроки.Контрагент),
			Формат(ДанныеСтроки.Сумма, "ЧДЦ=2"));
		
		Ссылка = ПолучитьНавигационнуюСсылку(ДанныеСтроки.Шаблон);
		
	Иначе
		
		ТекстОповещения = "";
		
		ТекстПояснения = СтрШаблон(НСтр("ru = 'Отмена повторения: %1'"),
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
			ВыделенныеСтроки.Количество(), НСтр("ru = 'счет, счета, счетов'")));
		
		Ссылка = "";
		
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстОповещения, Ссылка, ТекстПояснения);
	
	ПрекратитьПовторятьВыбранныеПравилаНаСервере();
	
	Элементы.Список.Обновить();
	Оповестить("Запись_ПравилаРегулярныхСчетовПокупателям");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	
	ЭлементУО = Список.УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СписокДатаСледующего");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ДатаСледующего", ВидСравненияКомпоновкиДанных.Меньше, НачалоДня(ТекущаяДатаСеанса()));
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
	Формат = СтрШаблон("ДЛФ=D %1", НСтр("(просрочен)"));
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Формат", Формат);
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиДокументПоШаблону(Правило, Шаблон)
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("ПравилоПовторения",   Правило);
	ПараметрыФормы.Вставить("ЗначениеКопирования", Шаблон);
	
	ОткрытьФорму("Документ.СчетНаОплатуПокупателю.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Функция СоздатьДокументыНаСервере(Правила)
	
	Возврат Справочники.ПравилаРегулярныхСчетовПокупателям.СоздатьДокументыПоПравилам(Правила);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьСозданныеДокументы(СозданныеДокументы)
	
	Если СозданныеДокументы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СписокДокументов = Новый СписокЗначений;
	СписокДокументов.ЗагрузитьЗначения(СозданныеДокументы);
	СписокВыделения = Новый Структура("Ссылка", СписокДокументов);
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("ТекущаяСтрока",   СозданныеДокументы[0]);
	ПараметрыФормы.Вставить("СписокВыделения", СписокВыделения);
	
	ОткрытьФорму("Документ.СчетНаОплатуПокупателю.ФормаСписка", ПараметрыФормы, ЭтотОбъект, Ложь);
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПропуститьВыбранныеПравилаНаСервере(Правила)
	
	Справочники.ПравилаРегулярныхСчетовПокупателям.ПропуститьПовторение(Правила);
	
КонецПроцедуры

&НаСервере
Процедура ПрекратитьПовторятьВыбранныеПравилаНаСервере()
	
	Для Каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		
		ПравилоОбъект = ВыделеннаяСтрока.ПолучитьОбъект();
		
		ПравилоОбъект.Выполняется = Ложь;
		
		ПравилоОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВводДатыСледующего(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДатаШаблона = ДополнительныеПараметры.ДатаШаблона;
	
	Если Результат < ДатаШаблона Тогда
		
		ТекстШаблона   = НСтр("ru = 'Следующий счет не может быть ранее предыдущего от %1'");
		ТекстСообщения = СтрШаблон(ТекстШаблона, Формат(ДатаШаблона, "ДФ=dd.MM.yyyy"));
		
	Иначе
		
		ИзменитьДатуСледующегоНаСервере(Результат, ДополнительныеПараметры.Правила);
		
		Элементы.Список.Обновить();
		Оповестить("Запись_ПравилаРегулярныхСчетовПокупателям");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьДатуСледующегоНаСервере(ДатаСледующего, Правила)
	
	РегистрыСведений.РегулярныеСчетаПокупателям.ИзменитьДатуСледующего(Правила, ДатаСледующего);
	
КонецПроцедуры

#КонецОбласти

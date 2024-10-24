﻿#Область ПрограммныйИнтерфейс

// Возвращает вид документа по коду ФНС
//
// Параметры:
//  КодФНС - Строка - код вида документа, может быть получен функцией КодыФНСВидовДокументов
//
// Возвращаемое значение:
//  СправочникСсылка.ВидыДокументовФизическихЛиц
//
Функция ВидДокументаПоКодуФНС(КодФНС) Экспорт
	
	Если Не ЗначениеЗаполнено(КодФНС) Тогда
		Возврат Справочники.ВидыДокументовФизическихЛиц.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВидыДокументовФизическихЛиц.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыДокументовФизическихЛиц КАК ВидыДокументовФизическихЛиц
		|ГДЕ
		|	ВидыДокументовФизическихЛиц.КодМВД = &КодФНС
		|	И НЕ ВидыДокументовФизическихЛиц.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("КодФНС", КодФНС);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.ВидыДокументовФизическихЛиц.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// Возвращает коды ФНС для видов документов
//
// Возвращаемое значение:
//  Структура - элементы структуры заполняются следующим образом:
//   *Ключ - имя вида документа
//   *Значение - Строка - код ФНС вида документа
//
Функция КодыФНСВидовДокументов() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИностранныйПаспорт", "10");
	Результат.Вставить("ВидНаЖительство", "12");
	Результат.Вставить("РазрешениеНаВременноеПроживание", "15");
	Результат.Вставить("ПаспортГражданинаРФ", "21");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ДанныеДействующегоДокумента(ДанныеДокументов, ПодходящиеВидыДокументов, Серия = "", Номер = "", УдостоверяетЛичность = Ложь) Экспорт
	
	НайденныйДокумент = Неопределено;
	Для Каждого Строка Из ДанныеДокументов Цикл
		Если ПодходящиеВидыДокументов.Найти(Строка.ВидДокумента) <> Неопределено Тогда
			Если ЗначениеЗаполнено(Серия) Или ЗначениеЗаполнено(Номер) Тогда
				Если Строка.Серия = Серия И Строка.Номер = Номер Тогда
					НайденныйДокумент = Строка;
					Прервать;
				КонецЕсли;
			ИначеЕсли ЭтоАктуальныйДокумент(НайденныйДокумент, Строка) И
				?(УдостоверяетЛичность, Строка.ЯвляетсяДокументомУдостоверяющимЛичность, Истина) Тогда
				НайденныйДокумент = Строка;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат НайденныйДокумент;
	
КонецФункции

Функция СерияНомерДокументаРаздельно(Знач СерияНомер) Экспорт
	
	СерияНомер = СокрЛП(СерияНомер);
	СтруктураНомера = Новый Структура;
	ПоложениеПробела = СтрНайти(СерияНомер, " ", НаправлениеПоиска.СКонца);
	Если ПоложениеПробела = 0 Тогда
		СтруктураНомера.Вставить("Номер", СерияНомер);
		СтруктураНомера.Вставить("Серия", "");
	Иначе
		СтруктураНомера.Вставить("Номер", Сред(СерияНомер, ПоложениеПробела + 1));
		СтруктураНомера.Вставить("Серия", Лев(СерияНомер, ПоложениеПробела - 1));
	КонецЕсли;
	
	Возврат СтруктураНомера;
	
КонецФункции

Процедура ДобавитьСведенияОДокументеФизЛица(ВидДокумента, ФизЛицо, ДанныеЗаполнения, УдостоверяетЛичность, Страна = Неопределено) Экспорт
	
	НачатьТранзакцию();
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДокументыФизическихЛиц.Период КАК Период,
		|	ДокументыФизическихЛиц.Физлицо КАК Физлицо,
		|	ДокументыФизическихЛиц.ВидДокумента КАК ВидДокумента
		|ИЗ
		|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
		|ГДЕ
		|	ДокументыФизическихЛиц.Физлицо = &Физлицо
		|	И ДокументыФизическихЛиц.Серия = &Серия
		|	И ДокументыФизическихЛиц.Номер = &Номер";
	
	Запрос.УстановитьПараметр("Физлицо", ФизЛицо);
	Запрос.УстановитьПараметр("Серия", ДанныеЗаполнения.Серия);
	Запрос.УстановитьПараметр("Номер", ДанныеЗаполнения.Номер);
	Выборка = Запрос.Выполнить().Выбрать();
	ЗаписьДокументыФизЛиц = РегистрыСведений.ДокументыФизическихЛиц.СоздатьМенеджерЗаписи();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЗаписьДокументыФизЛиц, Выборка);
		ЗаписьДокументыФизЛиц.Прочитать();
		ЗаписьДокументыФизЛиц.Удалить();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЗаписьДокументыФизЛиц, ДанныеЗаполнения);
	ЗаписьДокументыФизЛиц.Период = ДанныеЗаполнения.ДатаВыдачи;
	ЗаписьДокументыФизЛиц.Физлицо = ФизЛицо;
	ЗаписьДокументыФизЛиц.ВидДокумента = ВидДокумента;
	ЗаписьДокументыФизЛиц.ЯвляетсяДокументомУдостоверяющимЛичность = УдостоверяетЛичность;
	Если ЗначениеЗаполнено(Страна) Тогда
		ЗаписьДокументыФизЛиц.СтранаВыдачи = Страна;
	КонецЕсли;
	
	Если УдостоверяетЛичность Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ДокументыФизическихЛиц.ВидДокумента КАК ВидДокумента,
			|	ДокументыФизическихЛиц.Период КАК Период
			|ИЗ
			|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
			|ГДЕ
			|	ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность
			|	И ДокументыФизическихЛиц.Физлицо = &Физлицо";
		Запрос.УстановитьПараметр("Физлицо", ФизЛицо);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаписьСуществующегоУдостоверенияЛичности = РегистрыСведений.ДокументыФизическихЛиц.СоздатьМенеджерЗаписи();
			ЗаписьСуществующегоУдостоверенияЛичности.Физлицо = ФизЛицо;
			ЗаписьСуществующегоУдостоверенияЛичности.ВидДокумента = Выборка.ВидДокумента;
			ЗаписьСуществующегоУдостоверенияЛичности.Период = Выборка.Период;
			ЗаписьСуществующегоУдостоверенияЛичности.Прочитать();
			ЗаписьСуществующегоУдостоверенияЛичности.ЯвляетсяДокументомУдостоверяющимЛичность = Ложь;
			ЗаписьСуществующегоУдостоверенияЛичности.Записать();
		КонецЦикла;
	КонецЕсли;
	
	ЗаписьДокументыФизЛиц.Записать();
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоАктуальныйДокумент(ПредыдущийДокумент, НовыйДокумент)
	
	ДействующийДокумент = Не ЗначениеЗаполнено(НовыйДокумент.СрокДействия)
		Или НовыйДокумент.СрокДействия > ТекущаяДатаСеанса();
	АктуальныйДокумент = (ПредыдущийДокумент = Неопределено)
		Или НовыйДокумент.Период > ПредыдущийДокумент.Период;
	Возврат ДействующийДокумент И АктуальныйДокумент;
	
КонецФункции

#КонецОбласти
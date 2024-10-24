﻿////////////////////////////////////////////////////////////////////////////////
// Работа с последовательностями
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Отменяет регистрацию в последовательности и регистре отложенного проведения для ситуации,
// когда пометка на удаление документа ставится при обмене.
//
// Параметры:
// 	Источник - ДокументОбъект - Текущий документ.
//	Отказ - Булево - Признак отказа от выполнения отмены.
//
Процедура ОтменитьРегистрациюПриОбменеПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Не Источник.ОбменДанными.Загрузка Тогда
		// Отмена будет штатным образом в ОбработкаУдаленияПроведения.
		Возврат;
	КонецЕсли;
	
	УзелОтправитель = Источник.ОбменДанными.Отправитель;
	Если УзелОтправитель <> Неопределено
	   И ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(УзелОтправитель) Тогда
		// Изменения из узла распределённой информационной базы приходят по всем регистрам и последовательностям.
		Возврат;
	КонецЕсли;
	
	Если Источник.ЭтоНовый()
	 Или Источник.Проведен Тогда
	 	// Обрабатываем только случаи, когда ранее записанный документ сейчас записывается непроведённым.
		Возврат;
	КонецЕсли;
	
	СостояниеРанее = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Источник.Ссылка, "Проведен, ПометкаУдаления");
	Если СостояниеРанее.Проведен <> Истина
	   И (СостояниеРанее.ПометкаУдаления = Истина Или Не Источник.ПометкаУдаления) Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(Источник, Отказ);

КонецПроцедуры

// Процедура при проведении документа сбрасывает в последовательности 
// "Документы организаций" состояние в значение 
// "Проведен с нарушением последовательности".
//
Процедура ЗарегистрироватьВПоследовательностиПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		// Регистрация в последовательности будет при проведении.
		Возврат;
	КонецЕсли;
	
	РаботаСПоследовательностями.ЗарегистрироватьВПоследовательности(Источник, Отказ, Ложь);

КонецПроцедуры

// В обработчике перед физическим удалением документа из базы устанавливается 
// состояние нарушения последовательности для следующего документа за удаляемым.
//
Процедура ЗарегистрироватьВПоследовательностиПередУдалением(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Источник.Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПоследовательности.Организация КАК Организация,
	|	ТаблицаПоследовательности.Период КАК Период
	|ИЗ
	|	Последовательность.ДокументыОрганизаций КАК ТаблицаПоследовательности
	|ГДЕ
	|	ТаблицаПоследовательности.Регистратор = &Регистратор";
	
	ТаблицаОрганизаций = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаОрганизаций.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоНарушенийПоследовательностиДоДокумента = 0;
	
	Для Каждого СтрокаТаблицы Из ТаблицаОрганизаций Цикл
		МоментНарушения = РаботаСПоследовательностями.МоментНарушенияПоследовательности(
			СтрокаТаблицы.Организация, СтрокаТаблицы.Период);
		
		Если МоментНарушения <> Неопределено Тогда
			Если МоментНарушения.Сравнить(Источник.МоментВремени()) < 0 Тогда
				КоличествоНарушенийПоследовательностиДоДокумента = КоличествоНарушенийПоследовательностиДоДокумента + 1;
			КонецЕсли;
		КонецЕсли;
	
	КонецЦикла;
	
	Если ТаблицаОрганизаций.Количество() = КоличествоНарушенийПоследовательностиДоДокумента Тогда
		// По всем организациям, в которых был когда-либо зарегистрирован документ, 
		// момент нарушения последовательности раньше самого документа, 
		// поэтому удаление документа ни на что не повлияет.
		Возврат;
	КонецЕсли;
	
	// Заблокируем последовательность по тем организациям, которые встречаются 
	// в наборе	текущего документа.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Последовательность.ДокументыОрганизаций");
	ЭлементБлокировки.ИсточникДанных = ТаблицаОрганизаций;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
	Блокировка.Заблокировать();
	
	ДатаДокумента = Источник.Дата;
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.УстановкаЦенНоменклатуры") Тогда
		ДатаДокумента = НачалоДня(ДатаДокумента); // Цены региструются с точностью до дня
	КонецЕсли;
	
	Запрос.УстановитьПараметр("МоментДокумента", 	Новый МоментВремени(ДатаДокумента, Источник.Ссылка));
	Запрос.УстановитьПараметр("Организации", 		ТаблицаОрганизаций.ВыгрузитьКолонку("Организация"));
	
	// Находим следующий за удаляемым документ. Если у него состояние "Проведен в последовательности",
	// то заменяем его на "Проведен с нарушением последовательности".
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаПоследовательности.Организация КАК Организация,
	|	МИНИМУМ(ТаблицаПоследовательности.Период) КАК Период
	|ПОМЕСТИТЬ ВТ_БлижайшиеДаты
	|ИЗ
	|	Последовательность.ДокументыОрганизаций КАК ТаблицаПоследовательности
	|ГДЕ
	|	ТаблицаПоследовательности.Организация В(&Организации)
	|	И ТаблицаПоследовательности.МоментВремени > &МоментДокумента
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаПоследовательности.Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_БлижайшиеДаты.Организация КАК Организация,
	|	ВТ_БлижайшиеДаты.Период КАК Период,
	|	МИНИМУМ(ТаблицаПоследовательности.Регистратор) КАК Регистратор
	|ИЗ
	|	ВТ_БлижайшиеДаты КАК ВТ_БлижайшиеДаты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Последовательность.ДокументыОрганизаций КАК ТаблицаПоследовательности
	|		ПО ВТ_БлижайшиеДаты.Организация = ТаблицаПоследовательности.Организация
	|			И ВТ_БлижайшиеДаты.Период = ТаблицаПоследовательности.Период
	|			И (ТаблицаПоследовательности.СостояниеПроведения В (ЗНАЧЕНИЕ(Перечисление.СостоянияПроведенияВПоследовательности.ПроведенВПоследовательности), ЗНАЧЕНИЕ(Перечисление.СостоянияПроведенияВПоследовательности.ПерепроведениеПропущено)))
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_БлижайшиеДаты.Организация,
	|	ВТ_БлижайшиеДаты.Период";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		РаботаСПоследовательностями.СброситьСостояниеПоследовательностиДокумента(
			Выборка.Регистратор,
			Выборка.Период,
			Выборка.Организация);
	
	КонецЦикла;

КонецПроцедуры

// Выполняет фильтрацию по организации в записей последовательности при отправке данных по РИБ
//
Процедура ПроверитьОрганизациюВПоследовательностиПриОтправкеДанныхПодчиненному(Источник, ЭлементДанных, ОтправкаЭлемента, СозданиеНачальногоОбраза) Экспорт
	
	Если ТипЗнч(ЭлементДанных) <> Тип("ПоследовательностьНаборЗаписей.ДокументыОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	
	// Признак отправки мог быть изменен в более ранних обработчиках подписок на события,
	// если это так, то не меняем его.
	Если ОтправкаЭлемента <> ОтправкаЭлементаДанных.Авто Тогда
		Возврат;
	КонецЕсли;
	
	// Если организация не входит в список организаций, 
	// перечисленных в табличной части Организации текущего узла,
	// то удаляем такую запись из набора последовательности.
	ВГраница = ЭлементДанных.Количество() - 1;
	Для Сч = 0 По ВГраница Цикл
		
		Движение = ЭлементДанных[ВГраница - Сч];
		Если Источник.Организации.Найти(Движение.Организация) = Неопределено Тогда
			ЭлементДанных.Удалить(Движение);
		КонецЕсли;
	
	КонецЦикла;
	
	Если ЭлементДанных.Количество() = 0 Тогда
		// Нет данных для передачи.
		ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

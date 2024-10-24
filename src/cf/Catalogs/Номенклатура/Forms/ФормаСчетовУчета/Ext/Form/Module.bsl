﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуСчетов()
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСчетаУчета(Команда)
	
	ЗаполнитьТаблицуСчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетаУчетаСкрытьНеИспользуемые(Команда)
	
	Элементы.КнопкаСчетаУчетаСкрытьНеИспользуемые.Пометка = НЕ Элементы.КнопкаСчетаУчетаСкрытьНеИспользуемые.Пометка;
	
	ЗаполнитьТаблицуСчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетаУчетаСправкаРегистра(Команда)
	
	ОткрытьСправку("РегистрСведений.СчетаУчетаНоменклатуры");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуСчетов()
	
	Результат = СформироватьТаблицуСчетовУчета(Параметры.НоменклатураСчетов,Элементы.КнопкаСчетаУчетаСкрытьНеИспользуемые.Пометка); 
	ЗначениеВРеквизитФормы(Результат,"СчетаУчета");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьТаблицуСчетовУчета(Номенклатура, СчетаУчетаСкрытьНеИспользуемые)

	МассивНоменклатура	 = Новый Массив();
	МассивНоменклатура.Добавить(Справочники.Номенклатура.ПустаяСсылка());
	МассивНоменклатура.Добавить(Номенклатура);
	
	МассивВидНоменклатуры	 = Новый Массив();
	МассивВидНоменклатуры.Добавить(Справочники.ВидыНоменклатуры.ПустаяСсылка());
	МассивВидНоменклатуры.Добавить(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ВидНоменклатуры"));
	
	СписокГрупп = ОбщегоНазначенияБПВызовСервера.ПолучитьСписокВышеСтоящихГрупп(Номенклатура);
	Для каждого Элемент Из СписокГрупп Цикл
		МассивНоменклатура.Добавить(Элемент);
	КонецЦикла;
	
	ТестЗапрос = Новый Запрос();
	
	ТестЗапрос.УстановитьПараметр("Номенклатура",       МассивНоменклатура);
	ТестЗапрос.УстановитьПараметр("ВидНоменклатуры",    МассивВидНоменклатуры);
	
	ТестЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА СчетаУчетаНоменклатуры.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА ""< Для всех >""
	|		ИНАЧЕ СчетаУчетаНоменклатуры.Организация
	|	КОНЕЦ КАК Организация,
	|	СчетаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	СчетаУчетаНоменклатуры.Номенклатура.ЭтоГруппа КАК ЭтоГруппа,
	|	ВЫБОР
	|		КОГДА СчетаУчетаНоменклатуры.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ТОГДА ""< Для всех >""
	|		ИНАЧЕ СчетаУчетаНоменклатуры.Склад
	|	КОНЕЦ КАК Склад,
	|	ВЫБОР
	|		КОГДА СчетаУчетаНоменклатуры.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.ПустаяСсылка)
	|			ТОГДА ""< Для всех >""
	|		ИНАЧЕ СчетаУчетаНоменклатуры.ТипСклада
	|	КОНЕЦ КАК ТипСклада,
	|	СчетаУчетаНоменклатуры.СчетУчета КАК СчетУчета,
	|	СчетаУчетаНоменклатуры.СчетУчетаПередачи КАК СчетУчетаПередачи,
	|	СчетаУчетаНоменклатуры.СчетДоходовОтРеализации КАК СчетДоходовОтРеализации,
	|	СчетаУчетаНоменклатуры.СчетРасходовОтРеализации КАК СчетРасходовОтРеализации,
	|	СчетаУчетаНоменклатуры.СчетУчетаНДСПоПриобретеннымЦенностям КАК СчетУчетаНДСПоПриобретеннымЦенностям,
	|	СчетаУчетаНоменклатуры.СчетУчетаНДСПоРеализации КАК СчетУчетаНДСПоРеализации,
	|	СчетаУчетаНоменклатуры.СчетУчетаНДСУплаченногоНаТаможне КАК СчетУчетаНДСУплаченногоНаТаможне,
	|	СчетаУчетаНоменклатуры.Субконто1 КАК Субконто1,
	|	СчетаУчетаНоменклатуры.Субконто2 КАК Субконто2,
	|	СчетаУчетаНоменклатуры.Субконто3 КАК Субконто3,
	|	СчетаУчетаНоменклатуры.ВидНоменклатуры
	|ИЗ
	|	РегистрСведений.СчетаУчетаНоменклатуры КАК СчетаУчетаНоменклатуры
	|ГДЕ
	|	СчетаУчетаНоменклатуры.Номенклатура В(&Номенклатура)
	|	И СчетаУчетаНоменклатуры.ВидНоменклатуры В(&ВидНоменклатуры)";

	ТаблицаЗапроса = ТестЗапрос.Выполнить().Выгрузить();
	ТаблицаЗапроса.Колонки.Добавить("Глубина");
	ТаблицаЗапроса.Колонки.Добавить("Описание");
	ТаблицаЗапроса.Колонки.Добавить("Приоритет");
	ТаблицаЗапроса.Колонки.Добавить("АктивностьПравила");
	ТаблицаЗапроса.Колонки.Добавить("Общее");
	
	Для Каждого Строка Из ТаблицаЗапроса Цикл
		Описание = "";
		Если Строка.Номенклатура = Справочники.Номенклатура.ПустаяСсылка() Тогда
			Строка.Глубина = 0;
			Описание = "Для всех номенклатурных единиц %1% (при отсутствии других правил)";
		ИначеЕсли Строка.Номенклатура = Номенклатура Тогда
			Строка.Глубина = СтрДлина(Строка.Номенклатура.ПолныйКод());
			Описание = "Для номенклатурной единицы " + Строка(Строка.Номенклатура);
		Иначе
			Строка.Глубина = СтрДлина(Строка.Номенклатура.ПолныйКод());
			Описание = "Для всех номенклатурных единиц %1%, входящих в группу " + Строка(Строка.Номенклатура);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.ВидНоменклатуры) Тогда
			Описание = СтрЗаменить(Описание, " %1%", " с видом номенклатуры " + Строка(Строка.ВидНоменклатуры));
			Описание = СтрЗаменить(Описание, " (при отсутствии других правил)", "");
		Иначе
			Описание = СтрЗаменить(Описание, " %1%", "");
		КонецЕсли;
		
		Если Строка.Организация <> "< Для всех >" Тогда
			Описание = Описание + "; по организации " + Строка(Строка.Организация);
		КонецЕсли;
		Если Строка.Склад <> "< Для всех >"  Тогда
			Описание = Описание + "; на складе " + Строка(Строка.Склад);
		ИначеЕсли Строка.ТипСклада <> "< Для всех >" Тогда
			Описание = Описание + "; на складах типа " + Строка(Строка.ТипСклада);
		КонецЕсли;
		
		Строка.Общее = ?(Строка.Номенклатура = Номенклатура, 1, 0);
		Строка.Описание = Описание;
		
	КонецЦикла;
	
	ТаблицаЗапроса.Сортировать("Глубина Убыв, Склад Убыв, ТипСклада Убыв, Организация Убыв, ВидНоменклатуры Убыв", Новый СравнениеЗначений);
	
	Если ТаблицаЗапроса.Количество() > 0 Тогда
	
		ОтборАктивностьПравила = Новый Структура("АктивностьПравила", Истина);
		
		АктивностьОпт = Истина;
		АктивностьРозница = Истина;
		
		ТекПриоритет = 1;
		ТекКлючПриоритета = (ТаблицаЗапроса[0].Глубина*1000) + (Число(ЗначениеЗаполнено(ТаблицаЗапроса[0].Организация))*100) 
		+ (Число(ЗначениеЗаполнено(ТаблицаЗапроса[0].Склад))*10) + (Число(ЗначениеЗаполнено(ТаблицаЗапроса[0].ТипСклада)));
		
		Для Каждого Строка Из ТаблицаЗапроса Цикл
			КлючПриоритета = (Строка.Глубина*1000) + (Число(ЗначениеЗаполнено(Строка.Организация))*100) 
			+ (Число(ЗначениеЗаполнено(Строка.Склад))*10) + (Число(ЗначениеЗаполнено(Строка.ТипСклада)));
			
			Если КлючПриоритета <> ТекКлючПриоритета Тогда
				ТекКлючПриоритета = КлючПриоритета;
				ТекПриоритет = ТекПриоритет + 1;
			КонецЕсли;
			Строка.Приоритет = ТекПриоритет;
			
			НайденныеСтроки = ТаблицаЗапроса.НайтиСтроки(ОтборАктивностьПравила);
			Для Каждого СтрокаАктивногоПравила Из НайденныеСтроки Цикл
				Если (СтрокаАктивногоПравила.Организация =  "< Для всех >" ИЛИ СтрокаАктивногоПравила.Организация = Строка.Организация) 
					И ((СтрокаАктивногоПравила.Склад = Строка.Склад И СтрокаАктивногоПравила.Склад <>  "< Для всех >")
						ИЛИ 
					  (СтрокаАктивногоПравила.Склад =  "< Для всех >"   
					   	И (СтрокаАктивногоПравила.ТипСклада =  "< Для всех >" ИЛИ СтрокаАктивногоПравила.ТипСклада = Строка.ТипСклада))) Тогда
				
					Строка.АктивностьПравила = Ложь;
					Прервать;
				
				КонецЕсли; 
			КонецЦикла;
			
			Если ЗначениеЗаполнено(Строка.АктивностьПравила) Тогда
				Продолжить;
			ИначеЕсли Строка.ТипСклада = "< Для всех >" Тогда
				Строка.АктивностьПравила = (АктивностьОпт ИЛИ АктивностьРозница);
			ИначеЕсли Строка.ТипСклада = Перечисления.ТипыСкладов.ОптовыйСклад Тогда
				Строка.АктивностьПравила = (АктивностьОпт);
			Иначе
				Строка.АктивностьПравила = (АктивностьРозница);
			КонецЕсли;
			
			Если Строка.Организация = "< Для всех >" И Строка.Склад = "< Для всех >" Тогда
				Если НЕ ЗначениеЗаполнено(Строка.ТипСклада) Тогда
					АктивностьОпт = Ложь;
					АктивностьРозница = Ложь;
				ИначеЕсли Строка.ТипСклада = Перечисления.ТипыСкладов.ОптовыйСклад Тогда
					АктивностьОпт = Ложь;
				Иначе
					АктивностьРозница = Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если СчетаУчетаСкрытьНеИспользуемые Тогда
			НайденныеСтроки = ТаблицаЗапроса.НайтиСтроки(Новый Структура("АктивностьПравила", Ложь));
			Для Каждого Строка Из НайденныеСтроки Цикл
				ТаблицаЗапроса.Удалить(Строка);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаЗапроса;

КонецФункции

#КонецОбласти
﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ИспользоватьПодборМаркируемойПродукции       = Параметры.ИспользоватьПодборМаркируемойПродукции;
	ИспользуетсяРегистрацияРозничныхПродажВЕГАИС = Параметры.ИспользуетсяРегистрацияРозничныхПродажВЕГАИС;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ШтрихкодАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Если ПустаяСтрока(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = ДанныеВыбораАвтоподборНаСервере(Текст, ИспользоватьПодборМаркируемойПродукции);
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодПриИзменении(Элемент)
	Если ПустаяСтрока(Штрихкод) Тогда
	
		Возврат;
	КонецЕсли; 
	
	Результат = ДанныеНоменклатурыПоШтрихкодуНаСервере(Штрихкод, 
		ИспользоватьПодборМаркируемойПродукции, ИспользуетсяРегистрацияРозничныхПродажВЕГАИС);
		
	Если НЕ Результат.Номенклатура.Пустая() Тогда
		Закрыть(Результат);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьЗначение(Команда)
	ДанныеВыбора = ДанныеНоменклатурыПоШтрихкодуНаСервере(Штрихкод, ИспользоватьПодборМаркируемойПродукции, ИспользуетсяРегистрацияРозничныхПродажВЕГАИС);
	
	Результат = Неопределено;
	Если НЕ ДанныеВыбора.Номенклатура.Пустая() Тогда
		ДанныеЗакрытия = Результат;
	КонецЕсли;
	
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыбор(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ДанныеВыбораАвтоподборНаСервере(Текст, ИспользоватьПодборМаркируемойПродукции)
	ДанныеВыбора = Новый СписокЗначений;
	
	НоменклатураПоШтрихкоду = РегистрыСведений.ШтрихкодыНоменклатуры.НоменклатураПоШтрихкоду(Текст, Ложь);
	Для каждого СтрокаНоменклатуры Из НоменклатураПоШтрихкоду Цикл
		ДанныеВыбора.Добавить(СтрокаНоменклатуры.Штрихкод, СтрокаНоменклатуры.Представление);
	КонецЦикла;
	
	Если ИспользоватьПодборМаркируемойПродукции Тогда
		НомераКиз = Справочники.КонтрольныеЗнакиГИСМ.ПодобратьКИЗ_ГИСМПоШтрихкоду(Текст);
		Для каждого НомерКиз Из НомераКиз Цикл
			ДанныеВыбора.Добавить(НомерКиз.Штрихкод, НомерКиз.Представление);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ДанныеВыбора;
КонецФункции 

&НаСервереБезКонтекста
Функция НовыйРезультатВыбора(Штрихкод)
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("Штрихкод",                Штрихкод);
	РезультатВыбора.Вставить("Номенклатура",            Справочники.Номенклатура.ПустаяСсылка());
	РезультатВыбора.Вставить("Количество",              1);
	РезультатВыбора.Вставить("ЭтоАлкогольнаяПродукция", Ложь);
	РезультатВыбора.Вставить("КИЗ_ГИСМ",                Неопределено);
	
	Возврат РезультатВыбора;

КонецФункции 

&НаСервере
Функция ДанныеНоменклатурыПоШтрихкодуНаСервере(Штрихкод, ИспользоватьПодборМаркируемойПродукции, ИспользуетсяРегистрацияРозничныхПродажВЕГАИС)
	РезультатВыбора = НовыйРезультатВыбора(Штрихкод);
	
	Если ИспользоватьПодборМаркируемойПродукции
		И ИнтеграцияГИСМКлиентСервер.ЭтоНомерКиЗ(Штрихкод) Тогда
		
		ДанныеКиЗ = Справочники.КонтрольныеЗнакиГИСМ.ДанныеКИЗ_ГИСМПоНомеру(Штрихкод);
		//Если соответствия нет -вводи вручную, выбрав номенклатуру
		Если ДанныеКиЗ <> Неопределено Тогда
			РезультатВыбора.Вставить("Номенклатура", ДанныеКиЗ.Владелец);
			РезультатВыбора.Вставить("КИЗ_ГИСМ",     ДанныеКиЗ.КИЗ_ГИСМ);
		КонецЕсли;
	Иначе
		РезультатПоискаПоШтрихкодуЕГАИС = Неопределено;
		Если ИспользуетсяРегистрацияРозничныхПродажВЕГАИС Тогда
			ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.НайтиПоШтрихкоду(РезультатПоискаПоШтрихкодуЕГАИС, Штрихкод)
		КонецЕсли; 
				
		Если РезультатПоискаПоШтрихкодуЕГАИС <> Неопределено
			И РезультатПоискаПоШтрихкодуЕГАИС.МаркируемаяПродукция Тогда
			
			РезультатВыбора.Вставить("Номенклатура",            РезультатПоискаПоШтрихкодуЕГАИС.Номенклатура);
			РезультатВыбора.Вставить("ЭтоАлкогольнаяПродукция", Истина);
		Иначе
			ТаблицаНоменклатуры = РегистрыСведений.ШтрихкодыНоменклатуры.НоменклатураПоШтрихкоду(Штрихкод);
			
			Если ТаблицаНоменклатуры.Количество() = 1 Тогда
				РезультатВыбора.Вставить("Номенклатура", ТаблицаНоменклатуры[0].Номенклатура);
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
	Возврат РезультатВыбора;
КонецФункции

#КонецОбласти 




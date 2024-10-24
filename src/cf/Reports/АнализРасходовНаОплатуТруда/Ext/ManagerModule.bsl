﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализРасходовНаОплатуТруда");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сведения об отражении в учете расходов на оплату труда.
		|Обороты счетов учета расчетов по зарплате и страховым взносам (70 и 69) в корреспонденции 
		|со счетами учета затрат (20, 26, 44 и т.д.).'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета",          Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",           Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",           Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",               Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);
							
	Возврат Результат;
							
КонецФункции
	
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Анализ расходов на оплату труда" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", Дата(1, 1, 1));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", Дата(3999, 11, 1));
	КонецЕсли;
	
	МассивСчетов = Новый Массив;
	Если ПараметрыОтчета.РасходыНаОплатуТруда Тогда
		МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда);
	КонецЕсли;
	Если ПараметрыОтчета.СтраховыеВзносы Тогда
		МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоСоциальномуСтрахованию);
	КонецЕсли;
		
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "МассивСчетов", МассивСчетов);
		
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);	
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = 2;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + 2;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	
	Возврат НаборПоказателей;
	
КонецФункции

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
		
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ПользовательскиеОтборы = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ПользовательскиеОтборы.ИдентификаторПользовательскойНастройки = "Отбор";
	
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
		
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(Адрес);
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровки = ДанныеОбъекта.ДанныеРасшифровки;
	
	ДополнительныеСвойства.Вставить("РежимРасшифровки", Истина);
	ДополнительныеСвойства.Вставить("Организация"     , ОтчетОбъект.Организация);

	Период        = Неопределено;
		
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ДанныеРасшифровки.Настройки);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ДанныеОбъекта.Объект.СхемаКомпоновкиДанных));
	
	МассивПолей = БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки(Расшифровка, ДанныеРасшифровки, КомпоновщикНастроек, Истина);

 	Для Каждого Отбор Из МассивПолей Цикл
		Если ТипЗнч(Отбор) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") тогда
			Если Отбор.Значение = NULL тогда
				Продолжить;
			КонецЕсли;
			
			Если Отбор.Поле = "Подразделение" Тогда
				Если ЗначениеЗаполнено(Отбор.Значение) Тогда
					ДополнительныеСвойства.Вставить("Подразделение", Отбор.Значение);
				Иначе
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение);
				КонецЕсли;
			ИначеЕсли Отбор.Поле = "Организация" Тогда
				ДополнительныеСвойства.Вставить("Организация", Отбор.Значение);
			ИначеЕсли Отбор.Поле = "Период" Тогда
				Период = Отбор.Значение;
			Иначе
				Если Отбор.Поле <> "СчетДт" И Отбор.Поле <> "СчетКт" 
					И Отбор.Поле <> "КорСубконто1" И Отбор.Поле <> "КорСубконто2" И Отбор.Поле <> "КорСубконто3" 
					И Отбор.Поле <> "ПодразделениеКор" Тогда
					Продолжить;
				Иначе
					Если Найти(Отбор.Поле,"КорСубконто") <> 0 Тогда
						Отбор.Поле = СтрЗаменить(Отбор.Поле,"КорСубконто","СубконтоДт");
					ИначеЕсли Найти(Отбор.Поле,"Счет") <> 0 Тогда
						Если Отбор.Значение.ЗапретитьИспользоватьВПроводках Тогда
							Отбор.Иерархия = Истина;
						КонецЕсли;						
					ИначеЕсли Найти(Отбор.Поле,"ПодразделениеКор") <> 0 Тогда
						Отбор.Поле = СтрЗаменить(Отбор.Поле,"ПодразделениеКор","ПодразделениеДт");
					КонецЕсли;
					
					Если Отбор.Иерархия Тогда
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение, ВидСравненияКомпоновкиДанных.ВИерархии);
					Иначе
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение);
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;	
		ИначеЕсли ТипЗнч(Отбор) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если Отбор.Представление = "###ОтборПоОрганизации###" Тогда
				ДополнительныеСвойства.Вставить("Организация"                      , Отбор.ПравоеЗначение);
				ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения", Ложь);
			ИначеЕсли Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение") 
				И Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
				ДополнительныеСвойства.Вставить("Подразделение", Отбор.ПравоеЗначение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	ДополнительныеСвойства.Вставить("НачалоПериода", ОтчетОбъект.НачалоПериода);
	ДополнительныеСвойства.Вставить("КонецПериода" , ОтчетОбъект.КонецПериода);
		
	ДополнительныеСвойства.Вставить("ПоказательБУ"     , Истина);
		
	СписокПунктовМеню = Новый СписокЗначений;
	СписокПунктовМеню.Добавить("ОтчетПоПроводкам", "Отчет по проводкам");
	
	НастройкиРасшифровки = Новый Структура;
	НастройкиРасшифровки.Вставить("ОтчетПоПроводкам", ПользовательскиеНастройки);
		
	ДанныеОбъекта.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	Адрес = ПоместитьВоВременноеХранилище(ДанныеОбъекта, Адрес);
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
﻿#Область СлужебныеПроцедурыИФункции

Функция ПараметрыНормализации(ВидПродукции, ВидУпаковки) Экспорт
	
	Если ИнтеграцияИСПовтИсп.ЭтоПродукцияМОТП(ВидПродукции) Тогда
		
		Если ВидУпаковки = Перечисления.ВидыУпаковокИС.Логистическая Тогда
			ПараметрыНормализации = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПараметрыНормализацииКодаМаркировки();
			ПараметрыНормализации.ИмяСвойстваКодМаркировки = "Штрихкод";
			ПараметрыНормализации.НачинаетсяСоСкобки       = Ложь;
		Иначе
			ПараметрыНормализации = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПараметрыНормализацииКодаМаркировки();
			ПараметрыНормализации.ИмяСвойстваКодМаркировки = "Штрихкод";
			ПараметрыНормализации.НачинаетсяСоСкобки       = Ложь;
			ПараметрыНормализации.ВключатьМРЦ              = Истина;
		КонецЕсли;
		
	ИначеЕсли ИнтеграцияИСПовтИсп.ЭтоПродукцияИСМП(ВидПродукции) Тогда
		
		ПараметрыНормализации = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПараметрыНормализацииКодаМаркировки();
		ПараметрыНормализации.ИмяСвойстваКодМаркировки = "Штрихкод";
		ПараметрыНормализации.НачинаетсяСоСкобки       = Ложь;
		
	КонецЕсли;
	
	Возврат ПараметрыНормализации;
	
КонецФункции

Функция ПараметрыРазбора() Экспорт
	
	ПользовательскиеПараметрыРазбораКодаМаркировки = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПользовательскиеПараметрыРазбораКодаМаркировки();
	ПользовательскиеПараметрыРазбораКодаМаркировки.ПроверятьАлфавитЭлементов = Ложь;
	
	Возврат ПользовательскиеПараметрыРазбораКодаМаркировки;
	
КонецФункции

#КонецОбласти

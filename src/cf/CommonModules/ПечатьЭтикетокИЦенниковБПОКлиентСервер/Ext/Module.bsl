﻿#Область ПрограммныйИнтерфейс

// Возвращает структуру товара для заполнения табличной части формы обработки ПечатьЭтикетокИЦенниковБПО.
// 
// Возвращаемое значение:
//  Структура.
Функция ТоварДляПечати() Экспорт
	
	СтруктураТовара = Новый Структура();
	
	СтруктураТовара.Вставить("НоменклатураБПО");
	СтруктураТовара.Вставить("ХарактеристикаБПО");
	СтруктураТовара.Вставить("УпаковкаБПО");
	СтруктураТовара.Вставить("ОрганизацияБПО");
	СтруктураТовара.Вставить("Штрихкод");
	СтруктураТовара.Вставить("Цена");
	СтруктураТовара.Вставить("Количество");
	
	Возврат СтруктураТовара;
	
КонецФункции

// Возвращает список предопределенных полей в виде соответствия, которые необходимо учесть при заполнении таблицы товаров
// для возможности работы с предопределенными шаблонами.
// 
// Возвращаемое значение:
//  Соответствие Из УникальныйИдентификатор - Список предопределенных полей.
Функция СписокПредопределенныхПолей() Экспорт
	
	СоответствиеПредопределенныхПолей = Новый Соответствие;
	
	СоответствиеПредопределенныхПолей.Вставить("Организация", "e5b5c498-eafe-4c7b-87cd-0818bb6d41a4");
	СоответствиеПредопределенныхПолей.Вставить("Номенклатура", "0a750c7e-cd83-4a96-b03a-db046e65e2da");
	СоответствиеПредопределенныхПолей.Вставить("Характеристика", "87fc9c5d-ae15-48a4-bf69-3d56050b80ec");
	СоответствиеПредопределенныхПолей.Вставить("Штрихкод", "87fc9c5d-ae15-48a4-bf69-3d56050b80ec");
	СоответствиеПредопределенныхПолей.Вставить("Цена", "6897bd06-07c0-41aa-b0c9-ac8cc2825a16");
	СоответствиеПредопределенныхПолей.Вставить("СтараяЦена", "4ae76b8d-97f5-418d-89a1-87b46d9e846f");
	СоответствиеПредопределенныхПолей.Вставить("ЕдиницаИзмерения", "c750502d-3013-4ecd-a71e-fd6f05787786");
	
	Возврат СоответствиеПредопределенныхПолей;
	
КонецФункции

#КонецОбласти
﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Первоначальная инициализация контекста настройки.
	КонтекстНастройки = НовыйКонтекстНастройки();
	ЗаполнитьЗначенияСвойств(КонтекстНастройки, Параметры.ПараметрыНастройки);
	
	ЗаполнитьКонтекст(Параметры.ПараметрыНастройки, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	КлючНастройки = КлючНастройки();
	
	Если БольшеНеПоказыватьПодсказку() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Очистить(); // стандартное сохранение не подходит
	
	КлючНастроек = КлючНастройки + "_БольшеНеПоказывать";
	
	ОписаниеПодсказкаОНастройке = Новый ОписаниеНастроек();
	ОписаниеПодсказкаОНастройке.КлючОбъекта   = "ПодсказкаОНастройке/Форма";
	ОписаниеПодсказкаОНастройке.КлючНастроек  = КлючНастроек;
	ОписаниеПодсказкаОНастройке.Пользователь  = ИмяПользователя();
	ОписаниеПодсказкаОНастройке.Представление = "Подсказка о настройке. " + ПредставлениеНастройки();
	Если БольшеНеПоказывать Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			ОписаниеПодсказкаОНастройке.КлючОбъекта,
			ОписаниеПодсказкаОНастройке.КлючНастроек,
			БольшеНеПоказывать,
			ОписаниеПодсказкаОНастройке);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Установить(Команда)
	
	Если ЭтоНастройкаЭквайринга(КонтекстНастройки.Настройка) Тогда
		Закрыть();
		ПараметрыНастройки = Новый Структура("Ключ", КонтекстНастройки.ВидОплаты);
		ОткрытьФорму("Справочник.ВидыОплатОрганизаций.ФормаОбъекта", ПараметрыНастройки);
	Иначе
		Закрыть(ВозращаемоеЗначение());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеУстанавливать(Команда)
	
	БольшеНеПоказывать = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура БольшеНеПоказыватьНикогда(Команда)
	
	БольшеНеПоказывать = Истина;
	КлючНастройки = КлючНастройкиДоговорБольшеНеПоказывать(КонтекстНастройки);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстВопросаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если ЭтоНастройкаЭквайринга(КонтекстНастройки.Настройка) Тогда
		Элементы.ТекстВопросаОбычныйТекст.Видимость = Ложь;
		Элементы.ТекстВопросаФорматированныйТекст.Видимость = Истина;
		Элементы.ТекстВопросаФорматированныйТекст.Заголовок = СформироватьТекстВопроса();
		Элементы.ФормаУстановить.Заголовок = НСтр("ru = 'Настроить'");
		Элементы.ФормаБольшеНеПоказывать.Заголовок = НСтр("ru = 'Больше не показывать'");
	Иначе
		Элементы.ТекстВопросаФорматированныйТекст.Видимость = Ложь;
		Элементы.ТекстВопросаОбычныйТекст.Видимость = Истина;
		Элементы.ТекстВопросаОбычныйТекст.Заголовок = СформироватьТекстВопроса();
		Элементы.ФормаУстановить.Заголовок = НСтр("ru = 'Установить'");
		Элементы.ФормаБольшеНеПоказывать.Заголовок = НСтр("ru = 'Не устанавливать'");
	КонецЕсли;
	
	Элементы.ФормаБольшеНеПоказыватьНикогда.Видимость = ЭтоНастройкаДоговора(КонтекстНастройки.Настройка);
	
	КлючСохраненияПоложенияОкна = КлючОкна() + Формат(КоличествоВидовОпераций, "ЧГ=");
	
КонецПроцедуры

#Область Настройки

Функция НовыйКонтекстНастройки()
	
	Возврат Новый Структура("ВидОперации, Настройка");
	
КонецФункции

&НаСервере
Функция ВозращаемоеЗначение()
	
	Структура = Новый Структура;
	
	Если ЭтоНастройкаСтатьиДДС(КонтекстНастройки.Настройка) Тогда
		Структура.Вставить("СтатьяДДС", КонтекстНастройки.СтатьяДДС);
		Структура.Вставить("ИмяПредопределенныхДанных",  КонтекстНастройки.ПредопределеннаяСтатьяДДС);
		Структура.Вставить("ВидДвиженияДенежныхСредств", КонтекстНастройки.ВидДДС);
	ИначеЕсли ЭтоНастройкаДоговора(КонтекстНастройки.Настройка) Тогда
		Структура.Вставить("Договор", КонтекстНастройки.Договор);
	ИначеЕсли ЭтоНастройкаЭквайринга(КонтекстНастройки.Настройка) Тогда
		Структура.Вставить("ВидОплаты", КонтекстНастройки.ВидОплаты);
	ИначеЕсли ЭтоНастройкаОсновнаяСтавкаНДС(КонтекстНастройки.Настройка) Тогда
		Структура.Вставить("ВидСтавкиНДС", КонтекстНастройки.ВидСтавкиНДС);
	КонецЕсли;
	
	Возврат Структура;
	
КонецФункции

&НаСервере
Функция БольшеНеПоказыватьПодсказку()
	
	Результат = Ложь;
	
	КлючНастройкиДоговор = КлючНастройкиДоговорБольшеНеПоказывать(КонтекстНастройки);
	Если Не ПустаяСтрока(КлючНастройкиДоговор) Тогда
		Результат = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ПодсказкаОНастройке/Форма", КлючНастройкиДоговор + "_БольшеНеПоказывать", Ложь);
	КонецЕсли;
	
	Если Не Результат Тогда
		Результат = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ПодсказкаОНастройке/Форма", КлючНастройки + "_БольшеНеПоказывать", Ложь);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция КлючНастройки()
	
	Результат = "";
	
	Если ЭтоНастройкаСтатьиДДС(КонтекстНастройки.Настройка) Тогда
		Результат = КонтекстНастройки.ПредопределеннаяСтатьяДДС;
	ИначеЕсли ЭтоНастройкаДоговора(КонтекстНастройки.Настройка) Тогда
		Результат = "" + КонтекстНастройки.ВидДоговора
			+ "/" + КонтекстНастройки.Владелец
			+ "/" + КонтекстНастройки.Организация;
	ИначеЕсли ЭтоНастройкаЭквайринга(КонтекстНастройки.Настройка) Тогда
		Результат = "Эквайринг"
			+ "/" + КонтекстНастройки.Договор
			+ "/" + КонтекстНастройки.Владелец
			+ "/" + КонтекстНастройки.Организация;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция КлючНастройкиДоговорБольшеНеПоказывать(КонтекстНастройки)
	
	Результат = "";
	
	Если ЭтоНастройкаДоговора(КонтекстНастройки.Настройка) Тогда
		Результат = КонтекстНастройки.Настройка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПредставлениеНастройки()
	
	Результат = "";
	
	Если ЭтоНастройкаСтатьиДДС(КонтекстНастройки.Настройка) Тогда
		Результат = КонтекстНастройки.СтатьяДДС;
	ИначеЕсли КонтекстНастройки.Настройка = КлючНастройки Тогда // должна быть выше проверки настройки договора
		Возврат КонтекстНастройки.Настройка;
	ИначеЕсли ЭтоНастройкаДоговора(КонтекстНастройки.Настройка) Тогда
		Результат = КонтекстНастройки.Договор;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция КлючОкна()
	
	Результат = "";
	
	Если ЭтоНастройкаСтатьиДДС(КонтекстНастройки.Настройка) Тогда
		Результат = КонтекстНастройки.ПредопределеннаяСтатьяДДС;
	ИначеЕсли ЭтоНастройкаДоговора(КонтекстНастройки.Настройка) Тогда
		Результат = "" + КонтекстНастройки.ВидДоговора;
	ИначеЕсли ЭтоНастройкаЭквайринга(КонтекстНастройки.Настройка) Тогда
		Результат = КонтекстНастройки.Настройка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПредставлениеОпераций()
	
	Если ЭтоНастройкаСтатьиДДС(КонтекстНастройки.Настройка) Тогда
		
		СоответствиеСтатьейДДСОперациям = Справочники.СтатьиДвиженияДенежныхСредств.СоответствиеСтатьейДДСОперациям(
			КонтекстНастройки.ВидОперации);
		
		ТаблицаПредопределенныхЗначений = Справочники.СтатьиДвиженияДенежныхСредств.ТаблицаПредопределенныхЗначений();
		ЭлементДДС = ТаблицаПредопределенныхЗначений.Найти(
			КонтекстНастройки.ПредопределеннаяСтатьяДДС, "ИмяПредопределенныхДанных");
		КонтекстНастройки.ВидДДС = ЭлементДДС.ВидДвиженияДенежныхСредств;
		
		ВидыОпераций = ВидыОперацийСтатьяДДС(
			СоответствиеСтатьейДДСОперациям, КонтекстНастройки.ПредопределеннаяСтатьяДДС);
		
		Если КоличествоВидовОпераций = 0 Тогда
			СтатьяПоВидуОперации = УчетДенежныхСредствПовтИсп.ПредопределеннаяСтатьяДДСПоКонтексту(КонтекстНастройки.ВидОперации);
			ВидыОпераций = ВидыОперацийСтатьяДДС(
				СоответствиеСтатьейДДСОперациям, СтатьяПоВидуОперации, ЭлементДДС.ПредставлениеОперации);
		КонецЕсли;
		
	ИначеЕсли ЭтоНастройкаДоговора(КонтекстНастройки.Настройка) Тогда
		
		ВидыОпераций = ВидыОперацийДоговор();
		
	КонецЕсли;
	
	Возврат СтрСоединить(ВидыОпераций, Символы.ПС);
	
КонецФункции

&НаСервере
Функция СформироватьТекстВопроса()
	
	ТекстВопроса = "";
	
	Если ЭтоНастройкаСтатьиДДС(КонтекстНастройки.Настройка) Тогда
		ТекстВопроса = СформироватьТекстВопросаСтатьяДДС();
	ИначеЕсли ЭтоНастройкаДоговора(КонтекстНастройки.Настройка) Тогда
		ТекстВопроса = СформироватьТекстВопросаДоговор();
	ИначеЕсли ЭтоНастройкаЭквайринга(КонтекстНастройки.Настройка) Тогда
		ТекстВопроса = СформироватьТекстВопросаПроцентКомиссииЭквайринга();
	ИначеЕсли ЭтоНастройкаОсновнаяСтавкаНДС(КонтекстНастройки.Настройка) Тогда
		ТекстВопроса = СформироватьТекстВопросаОсновнаяСтавкаНДС();
	КонецЕсли;
	
	Возврат ТекстВопроса;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКонтекст(ПараметрыНастройки, Отказ)
	
	Если ЭтоНастройкаСтатьиДДС(КонтекстНастройки.Настройка) Тогда
		ЗаполнитьКонтекстСтатьяДДС(ПараметрыНастройки, Отказ);
	ИначеЕсли ЭтоНастройкаДоговора(КонтекстНастройки.Настройка) Тогда
		ЗаполнитьКонтекстДоговор(ПараметрыНастройки);
	ИначеЕсли ЭтоНастройкаЭквайринга(КонтекстНастройки.Настройка) Тогда
		ЗаполнитьКонтекстПроцентКомиссииЭквайринга(ПараметрыНастройки);
	ИначеЕсли ЭтоНастройкаОсновнаяСтавкаНДС(КонтекстНастройки.Настройка) Тогда
		ЗаполнитьКонтекстОсновнаяСтавкаНДС(ПараметрыНастройки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоНастройкаСтатьиДДС(Настройка)
	
	Возврат Настройка = "СтатьяДДС";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоНастройкаДоговора(Настройка)
	
	Возврат Настройка = "Договор";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоНастройкаЭквайринга(Настройка)
	
	Возврат Настройка = "ПроцентКомиссииЭквайринга";
	
КонецФункции

#Область НастройкиСтатьяДДС

&НаСервере
Функция СформироватьТекстВопросаСтатьяДДС()
	
	ВставляемыеЗначения = Новый Структура;
	ВставляемыеЗначения.Вставить("СтатьяДДС", КонтекстНастройки.СтатьяДДС);
	ВставляемыеЗначения.Вставить("ПредставлениеСтатьяДДС", КонтекстНастройки.ПредставлениеСтатьяДДС);
	Если КоличествоВидовОпераций = 1 Тогда
		ВставляемыеЗначения.Вставить("Операциях", НСтр("ru = 'операции'"));
		ВставляемыеЗначения.Вставить("ПредставлениеОпераций", " """ + ПредставлениеОпераций() + """");
	Иначе
		ВставляемыеЗначения.Вставить("Операциях", НСтр("ru = 'операциях:'"));
		ВставляемыеЗначения.Вставить("ПредставлениеОпераций", Символы.ПС + ПредставлениеОпераций());
	КонецЕсли;
	
	// Сформируем строку текста подсказки
	ШаблонСтроки =
		НСтр("ru = '[ПредставлениеСтатьяДДС] в документе программа может заполнять автоматически.
		|
		|В следующий раз статья ""[СтатьяДДС]"" будет использована в [Операциях][ПредставлениеОпераций]
		|
		|В дальнейшем изменить настройку можно в справочнике
		|""Статьи движения денежных средств"".
		|
		|Установить автоматическое заполнение статьи?'");
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонСтроки, ВставляемыеЗначения);
	
	Возврат ТекстВопроса;
	
КонецФункции

&НаСервере
Функция ВидыОперацийСтатьяДДС(СоответствиеСтатьей, КодСтатьиДДС, ПредставлениеОперации = "")
	
	ТаблицаОпераций = Новый ТаблицаЗначений;
	ТаблицаОпераций.Колонки.Добавить("Операция",  ОбщегоНазначения.ОписаниеТипаСтрока(100));
	ТаблицаОпераций.Колонки.Добавить("Приоритет", Новый ОписаниеТипов("Булево"));
	
	ТекстОперации = "";
	Для каждого КлючИЗначение Из СоответствиеСтатьей Цикл
		Если КлючИЗначение.Значение = КодСтатьиДДС Тогда
			ВидОперации = КлючИЗначение.Ключ;
			Если ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.РасчетыПоКредитамИЗаймам
				Или ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.РасчетыПоКредитамИЗаймам Тогда
				// Этот вид операции больше не используется.
				Продолжить;
			КонецЕсли;
			
			ПредставлениеПеречисления = ВидОперации.Метаданные().ЗначенияПеречисления.Получить(
				Перечисления[ВидОперации.Метаданные().Имя].Индекс(ВидОперации)).Синоним;
			
			ТекстОперации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1%2'"),
				ПредставлениеПеречисления,
				?(ПустаяСтрока(ПредставлениеОперации), "", " (" + НРег(ПредставлениеОперации) + ")"));
			
			НоваяСтрока = ТаблицаОпераций.Добавить();
			НоваяСтрока.Операция  = "  - " + ТекстОперации;
			НоваяСтрока.Приоритет = ВидОперации = КонтекстНастройки.ВидОперации;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоВидовОпераций = ТаблицаОпераций.Количество();
	Если КоличествоВидовОпераций = 1 Тогда
		ВидыОпераций = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекстОперации);
	Иначе
		// Позаботимся о том, чтобы вид операции из документа шел в описании первой строкой.
		ТаблицаОпераций.Сортировать("Приоритет Убыв, Операция");
		ВидыОпераций = ТаблицаОпераций.ВыгрузитьКолонку("Операция");
	КонецЕсли;
	
	Возврат ВидыОпераций;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКонтекстСтатьяДДС(ПараметрыНастройки, Отказ)
	
	ПредопределеннаяСтатьяДДС = УчетДенежныхСредствПовтИсп.ПредопределеннаяСтатьяДДСПоКонтексту(ПараметрыНастройки.КонтекстОперации);
	Отказ = ПустаяСтрока(ПредопределеннаяСтатьяДДС);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстНастройки.Вставить("ВидДДС"); // будет заполнена позже
	КонтекстНастройки.Вставить("СтатьяДДС",                 ПараметрыНастройки.СтатьяДДС);
	КонтекстНастройки.Вставить("ПредставлениеСтатьяДДС",    ПараметрыНастройки.ПредставлениеСтатьяДДС);
	КонтекстНастройки.Вставить("ПредопределеннаяСтатьяДДС", ПредопределеннаяСтатьяДДС);
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиДоговор

&НаСервере
Процедура ЗаполнитьКонтекстДоговор(ПараметрыНастройки)
	
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПараметрыНастройки.Договор,
		"ВидДоговора, Владелец, Организация");
	
	КонтекстНастройки.Вставить("ТипДокумента", ПараметрыНастройки.ТипДокумента);
	КонтекстНастройки.Вставить("Договор",      ПараметрыНастройки.Договор);
	КонтекстНастройки.Вставить("ВидДоговора",  РеквизитыДоговора.ВидДоговора);
	КонтекстНастройки.Вставить("Организация",  РеквизитыДоговора.Организация);
	КонтекстНастройки.Вставить("Владелец",     РеквизитыДоговора.Владелец);
	
КонецПроцедуры

&НаСервере
Функция СформироватьТекстВопросаДоговор()
	
	ВставляемыеЗначения = Новый Структура;
	ВставляемыеЗначения.Вставить("Договор", КонтекстНастройки.Договор);
	
	Если КоличествоВидовОпераций = 1 Тогда
		ВставляемыеЗначения.Вставить("Операциях", НСтр("ru = 'операции'"));
		ВставляемыеЗначения.Вставить("ПредставлениеОпераций", " """ + ПредставлениеОпераций() + """");
	Иначе
		ВставляемыеЗначения.Вставить("Операциях", НСтр("ru = 'операций:'"));
		ВставляемыеЗначения.Вставить("ПредставлениеОпераций", Символы.ПС + ПредставлениеОпераций());
	КонецЕсли;
	
	// Сформируем строку текста подсказки
	ШаблонСтроки =
		НСтр("ru = 'Договор ""[Договор]"" можно установить основным, тогда в следующий раз он будет автоматически подставлен в поле ""Договор"" для [Операциях][ПредставлениеОпераций].
		|
		|В дальнейшем изменить настройку можно в разделе ""Договоры"" справочника ""Контрагенты"".
		|
		|Установить договор основным?'");
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(
		ШаблонСтроки, ВставляемыеЗначения);
	
	Возврат ТекстВопроса;
	
КонецФункции

&НаСервере
Функция ВидыОперацийДоговор()
	
	ТаблицаОпераций = Новый ТаблицаЗначений;
	ТаблицаОпераций.Колонки.Добавить("Операция",  ОбщегоНазначения.ОписаниеТипаСтрока(100));
	ТаблицаОпераций.Колонки.Добавить("Приоритет", Новый ОписаниеТипов("Булево"));
	
	ПредставлениеПеречисления = "";
	Для каждого ВидОперации Из РаботаСДоговорамиКонтрагентовБПВызовСервера.ВидыОперацийДокумента(
			КонтекстНастройки.ВидДоговора, КонтекстНастройки.ТипДокумента) Цикл
		Если ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.РасчетыПоКредитамИЗаймам
			Или ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.РасчетыПоКредитамИЗаймам Тогда
			// Этот вид операции больше не используется.
			Продолжить;
		КонецЕсли;
		
		ПредставлениеПеречисления = ВидОперации.Метаданные().ЗначенияПеречисления.Получить(
			Перечисления[ВидОперации.Метаданные().Имя].Индекс(ВидОперации)).Синоним;
		
		НоваяСтрока = ТаблицаОпераций.Добавить();
		НоваяСтрока.Операция  = "  - " + ПредставлениеПеречисления;
		НоваяСтрока.Приоритет = ВидОперации = КонтекстНастройки.ВидОперации;
	КонецЦикла;
	
	КоличествоВидовОпераций = ТаблицаОпераций.Количество();
	Если КоличествоВидовОпераций = 1 Тогда
		ВидыОпераций = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПредставлениеПеречисления);
	Иначе
		// Позаботимся о том, чтобы вид операции из документа шел в описании первой строкой.
		ТаблицаОпераций.Сортировать("Приоритет Убыв, Операция");
		ВидыОпераций = ТаблицаОпераций.ВыгрузитьКолонку("Операция");
	КонецЕсли;
	
	Возврат ВидыОпераций;
	
КонецФункции

#КонецОбласти

#Область НастройкиПроцентКомиссииЭквайринга

&НаСервере
Процедура ЗаполнитьКонтекстПроцентКомиссииЭквайринга(ПараметрыНастройки)
	
	РеквизитыВидаОплаты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПараметрыНастройки.ВидОплаты,
		"Контрагент, ДоговорКонтрагента, Организация");
	
	КонтекстНастройки.Вставить("Договор",     РеквизитыВидаОплаты.ДоговорКонтрагента);
	КонтекстНастройки.Вставить("Организация", РеквизитыВидаОплаты.Организация);
	КонтекстНастройки.Вставить("Владелец",    РеквизитыВидаОплаты.Контрагент);
	КонтекстНастройки.Вставить("ВидОплаты",   ПараметрыНастройки.ВидОплаты);
	
КонецПроцедуры

&НаСервере
Функция СформироватьТекстВопросаПроцентКомиссииЭквайринга()
	
	ФорматированныеСтроки = Новый Массив;
	
	ФорматированныеСтроки.Добавить(НСтр("ru = 'Комиссия банка в документе может заполняться автоматически.'"));
	ФорматированныеСтроки.Добавить(Символы.ПС);
	
	ФорматированныеСтроки.Добавить(НСтр("ru = 'Для этого задайте процент комиссии банка в виде оплаты'"));
	ФорматированныеСтроки.Добавить(Символы.ПС);
	
	НаименованиеВидОплаты = Строка(КонтекстНастройки.ВидОплаты);
	НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(КонтекстНастройки.ВидОплаты);
	Гиперссылка = Новый ФорматированнаяСтрока(НаименованиеВидОплаты,,,, НавигационнаяСсылка);
	ФорматированныеСтроки.Добавить(Гиперссылка);
	
	// Сформируем форматированную строку текста подсказки
	ФорматированнаяСтрока = Новый ФорматированнаяСтрока(ФорматированныеСтроки);
	
	Возврат ФорматированнаяСтрока;
	
КонецФункции

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоНастройкаОсновнаяСтавкаНДС(Настройка)
	
	Возврат Настройка = "ОсновнаяСтавкаНДС";
	
КонецФункции

#Область НастройкиОсновнаяСтавкаНДС

&НаСервере
Процедура ЗаполнитьКонтекстОсновнаяСтавкаНДС(ПараметрыНастройки)
	
	КонтекстНастройки.Вставить("ВидСтавкиНДС", ПараметрыНастройки.ВидСтавкиНДС);
	КонтекстНастройки.Вставить("Дата",         ПараметрыНастройки.Дата);
		
КонецПроцедуры

&НаСервере
Функция СформироватьТекстВопросаОсновнаяСтавкаНДС()
	
	ВставляемыеЗначения = Новый Структура;
	ВставляемыеЗначения.Вставить("СтавкаНДС", Перечисления.СтавкиНДС.СтавкаНДС(КонтекстНастройки.ВидСтавкиНДС, КонтекстНастройки.Дата));
	ПростойИнтерфейс = ПолучитьФункциональнуюОпцию("ИнтерфейсТаксиПростой");
	Если ПростойИнтерфейс Тогда
		ПутьКРазделу = НСтр("ru = '""Настройки"" - ""Другие настройки"" - ""Персональные настройки""'");
	Иначе
		ПутьКРазделу = НСтр("ru = '""Главное"" - ""Персональные настройки""'");
	КонецЕсли;
	ВставляемыеЗначения.Вставить("ПутьКРазделу", ПутьКРазделу);

	// Сформируем строку текста подсказки
	ШаблонСтроки =
		НСтр("ru = 'Ставку НДС ""[СтавкаНДС]"" можно установить основной, тогда в следующий раз она будет автоматически подставлена в поле ""% НДС"" при создании новой номенклатуры.
		|
		|В дальнейшем изменить настройку можно в разделе [ПутьКРазделу].
		|
		|Установить ставку НДС ""[СтавкаНДС]"" как основную?'");
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(
		ШаблонСтроки, ВставляемыеЗначения);
	
	Возврат ТекстВопроса;
	
КонецФункции


#КонецОбласти

#КонецОбласти

#КонецОбласти

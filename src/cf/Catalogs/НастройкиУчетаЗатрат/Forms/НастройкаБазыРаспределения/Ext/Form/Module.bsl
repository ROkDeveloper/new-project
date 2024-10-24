﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,
		"ПредметНастройки,
		|АдресНастройкаАналитики,
		|НаименованиеБазы,
		|ЕдиницаИзмеренияПоказателя,
		|УникальныйИдентификаторСчетаСтрокой");
	
	ДобавленныеРеквизиты = Новый Структура;
	
	Если ПредметНастройки = "Счет" Тогда
		
		НастроитьФормуВыбораСчетовУчета();

	ИначеЕсли ПредметНастройки = "ВидАналитики" Тогда
		
		НастроитьФормуВыбораВидовАналитики();
		
	ИначеЕсли ПредметНастройки = "Наименование" Тогда
		
		НастроитьФормуВводаНаименования();
		
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = ПредметНастройки + XMLСтрока(ДобавленныеРеквизиты.Количество());
	
	Если ТолькоПросмотр Тогда
		Элементы.Отмена.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ПредметНастройки = "Наименование" И Не ЗначениеЗаполнено(НаименованиеБазы) Тогда
		
		ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Заполнение", "НаименованиеБазы");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "НаименованиеБазы", , Отказ);
	
	ИначеЕсли ПредметНастройки = "Счет" Тогда
		
		Если Не ЕстьОтмеченныйСчетУчета() Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Укажите хотя бы один счет учета'"), , , , Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не Модифицированность Тогда
		Закрыть(Неопределено);
		Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда

		СтруктураВозврата = Новый Структура;
		Если ПредметНастройки = "Счет" Тогда
			ОбновитьТаблицуНастройкиВыбраннымиСчетами();
			СтруктураВозврата.Вставить("АдресАналитикаРаспределения", АдресНастройкаАналитики);
		ИначеЕсли ПредметНастройки = "ВидАналитики" Тогда
			ОбновитьТаблицуНастройкиВыбраннымиВидамиАналитики();
			СтруктураВозврата.Вставить("АдресАналитикаРаспределения", АдресНастройкаАналитики);
		ИначеЕсли ПредметНастройки = "Наименование" Тогда
			СтруктураВозврата.Вставить("НаименованиеБазы", НаименованиеБазы);
			СтруктураВозврата.Вставить("ЕдиницаИзмеренияПоказателя", ЕдиницаИзмеренияПоказателя);
		КонецЕсли;

		Закрыть(СтруктураВозврата);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьТаблицуНастройкиВыбраннымиВидамиАналитики()

	НастройкаАналитикиБазы = ПолучитьИзВременногоХранилища(АдресНастройкаАналитики);
	
	Для Каждого ДобавленныйРеквизит Из ДобавленныеРеквизиты Цикл

		ВидАналитики = ДобавленныйРеквизит.Значение;

		СтруктураПоиска = Новый Структура("Счет, ВидАналитики", НастраиваемыйСчетУчета, ВидАналитики);
		СтрокиТаблицы = НастройкаАналитикиБазы.НайтиСтроки(СтруктураПоиска);

		УстановитьСтатусИспользования(СтрокиТаблицы, ДобавленныйРеквизит);
		
	КонецЦикла;

	ПоместитьВоВременноеХранилище(НастройкаАналитикиБазы, АдресНастройкаАналитики);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуНастройкиВыбраннымиСчетами()
	
	НастройкаАналитикиБазы = ПолучитьИзВременногоХранилища(АдресНастройкаАналитики);

	Для Каждого ДобавленныйРеквизит Из ДобавленныеРеквизиты Цикл

		СчетУчета = ДобавленныйРеквизит.Значение;
		СтрокиТаблицы = НастройкаАналитикиБазы.НайтиСтроки(Новый Структура("Счет", СчетУчета));

		УстановитьСтатусИспользования(СтрокиТаблицы, ДобавленныйРеквизит);
		
	КонецЦикла;

	ПоместитьВоВременноеХранилище(НастройкаАналитикиБазы, АдресНастройкаАналитики);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтатусИспользования(СтрокиТаблицы, ДобавленныйРеквизит)

	Для Каждого СтрокаТаблицы Из СтрокиТаблицы Цикл

		СтрокаТаблицы[ПредметНастройки + "Статус"] = ЭтотОбъект[ДобавленныйРеквизит.Ключ];

	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуВыбораСчетовУчета()

	Заголовок = НСтр("ru = 'Счета учета'");
	
	Элементы.СчетаУчета.Видимость = Истина;
	
	ДанныеЗаполненияФормы = ДанныеЗаполненияСчетовУчета();
	ДобавитьРеквизитыФормы(ДанныеЗаполненияФормы);
	ДобавитьЭлементыФормы(ДанныеЗаполненияФормы, Элементы.СчетаУчетаГруппаФлагов);
	
КонецПроцедуры

&НаСервере
Функция ДанныеЗаполненияСчетовУчета()

	НастройкаАналитики = ПолучитьИзВременногоХранилища(АдресНастройкаАналитики);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НастройкаАналитики", НастройкаАналитики);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкаАналитики.Счет КАК Счет,
	|	НастройкаАналитики.СчетСтатус КАК СчетСтатус
	|ПОМЕСТИТЬ НастройкаАналитики
	|ИЗ
	|	&НастройкаАналитики КАК НастройкаАналитики
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкаАналитики.Счет КАК Счет,
	|	МАКСИМУМ(НастройкаАналитики.СчетСтатус) КАК СчетСтатус,
	|	Хозрасчетный.Код КАК Код,
	|	Хозрасчетный.Наименование КАК Наименование,
	|	Хозрасчетный.Порядок КАК Порядок
	|ИЗ
	|	НастройкаАналитики КАК НастройкаАналитики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|		ПО НастройкаАналитики.Счет = Хозрасчетный.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	НастройкаАналитики.Счет,
	|	Хозрасчетный.Код,
	|	Хозрасчетный.Наименование,
	|	Хозрасчетный.Порядок
	|
	|УПОРЯДОЧИТЬ ПО
	|	Хозрасчетный.Порядок";
	
	АналитикаСчетаУчета = Запрос.Выполнить().Выбрать();
	
	ДанныеЗаполненияФормы = Новый Массив;
	
	Пока АналитикаСчетаУчета.Следующий() Цикл

		ЗаголовокСчета = ПланыСчетов.Хозрасчетный.ПолноеПредставлениеСчета(
			АналитикаСчетаУчета.Счет, АналитикаСчетаУчета.Код, АналитикаСчетаУчета.Наименование);

		ИмяРеквизитаСчетУчета = "Счет_" + Справочники.НастройкиУчетаЗатрат.СтрокаУникальногоИдентификатораИзСсылки(АналитикаСчетаУчета.Счет);

		// Заполним вспомогательные данные: 
		// Имя - имя реквизита формы,
		// Заголовок - заголовок элемента формы,
		// Значение - признак использования счета.
		ДанныеНастройкиСчета = Новый Структура;
		ДанныеНастройкиСчета.Вставить("Имя",       ИмяРеквизитаСчетУчета);
		ДанныеНастройкиСчета.Вставить("Заголовок", ЗаголовокСчета);
		ДанныеНастройкиСчета.Вставить("Значение",  АналитикаСчетаУчета.СчетСтатус = 1);
		
		ДанныеЗаполненияФормы.Добавить(ДанныеНастройкиСчета);
		
		// ДобавленныеРеквизиты - реквизит формы, используется для сопоставления элементов формы со счетами учета.
		ДобавленныеРеквизиты.Вставить(ИмяРеквизитаСчетУчета, АналитикаСчетаУчета.Счет);
		
	КонецЦикла;

	Возврат ДанныеЗаполненияФормы;
	
КонецФункции

&НаСервере
Функция ДанныеЗаполненияВидовАналитики()

	НастройкаАналитики = ПолучитьИзВременногоХранилища(АдресНастройкаАналитики);
	НастраиваемыйСчетУчета = ПланыСчетов.Хозрасчетный.ПолучитьСсылку(
		Новый УникальныйИдентификатор(УникальныйИдентификаторСчетаСтрокой));
	
	// Виды аналитик будем отображать на форме в том порядке, в котором они определены в видах субконто на счете, при этом
	// разрез "Подразделения" должен отображаться первым в списке.
	Запрос = Новый Запрос;
		
	Запрос.УстановитьПараметр("НастройкаАналитики", НастройкаАналитики);
	Запрос.УстановитьПараметр("Счет", НастраиваемыйСчетУчета);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкаАналитики.ВидАналитики КАК ВидАналитики,
	|	НастройкаАналитики.ВидАналитикиСтатус КАК ВидАналитикиСтатус,
	|	НастройкаАналитики.Счет КАК Счет,
	|	НастройкаАналитики.ВидАналитикиПредставление КАК ВидАналитикиПредставление
	|ПОМЕСТИТЬ НастройкаАналитики
	|ИЗ
	|	&НастройкаАналитики КАК НастройкаАналитики
	|ГДЕ
	|	НастройкаАналитики.Счет = &Счет
	|	И НастройкаАналитики.ВидАналитикиСтатус >= 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкаАналитики.ВидАналитики КАК ВидАналитики,
	|	НастройкаАналитики.ВидАналитикиСтатус КАК ВидАналитикиСтатус,
	|	ВЫБОР
	|		КОГДА ХозрасчетныйВидыСубконто.Ссылка ЕСТЬ NULL
	|			ТОГДА 0
	|		ИНАЧЕ ХозрасчетныйВидыСубконто.НомерСтроки
	|	КОНЕЦ КАК ПорядокСубконто,
	|	НастройкаАналитики.ВидАналитикиПредставление
	|ИЗ
	|	НастройкаАналитики КАК НастройкаАналитики
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|		ПО НастройкаАналитики.ВидАналитики = ХозрасчетныйВидыСубконто.ВидСубконто
	|		И (ХозрасчетныйВидыСубконто.Ссылка = &Счет)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПорядокСубконто,
	|	ВидАналитики";
	
	ВыборкаВидовАналитик = Запрос.Выполнить().Выбрать();
	
	ДанныеЗаполненияФормы = Новый Массив;
	
	Пока ВыборкаВидовАналитик.Следующий() Цикл

		ИмяАналитики =
			"ВидАналитики_" + Справочники.НастройкиУчетаЗатрат.СтрокаУникальногоИдентификатораИзСсылки(ВыборкаВидовАналитик.ВидАналитики);
		
		// Заполним вспомогательные данные: 
		// Имя - имя реквизита формы,
		// Заголовок - заголовок элемента формы,
		// Значение - признак использования вида аналитики.
		ДанныеНастройкиВидаАналитики = Новый Структура;
		ДанныеНастройкиВидаАналитики.Вставить("Имя", ИмяАналитики);
		ДанныеНастройкиВидаАналитики.Вставить("Заголовок", ВыборкаВидовАналитик.ВидАналитикиПредставление);
		ДанныеНастройкиВидаАналитики.Вставить("Значение", ВыборкаВидовАналитик.ВидАналитикиСтатус = 1);
		
		ДанныеЗаполненияФормы.Добавить(ДанныеНастройкиВидаАналитики);
		
		// ДобавленныеРеквизиты - реквизит формы, для сопоставления элементов формы с видами аналитик.
		ДобавленныеРеквизиты.Вставить(ИмяАналитики, ВыборкаВидовАналитик.ВидАналитики);
		
	КонецЦикла;

	Возврат ДанныеЗаполненияФормы;
	
КонецФункции

&НаСервере
Процедура НастроитьФормуВыбораВидовАналитики()

	Заголовок = НСтр("ru = 'Объекты учета'");
	
	Элементы.ВидыАналитики.Видимость = Истина;
	
	ДанныеЗаполненияФормы = ДанныеЗаполненияВидовАналитики();
	ДобавитьРеквизитыФормы(ДанныеЗаполненияФормы);
	ДобавитьЭлементыФормы(ДанныеЗаполненияФормы, Элементы.ВидыАналитикиГруппаФлагов);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуВводаНаименования()
	Заголовок = НСтр("ru = 'Наименование базы распределения'");
	Элементы.НаименованиеБазыРаспределения.Видимость = Истина;
КонецПроцедуры

&НаСервере
Процедура ДобавитьРеквизитыФормы(ДанныеЗаполненияФормы)
	
	МассивРеквизитов = Новый Массив;
	
	Для Каждого ДанныеНастройки Из ДанныеЗаполненияФормы Цикл
		
		ДобавитьРеквизитФормы(МассивРеквизитов, ДанныеНастройки.Имя, ДанныеНастройки.Заголовок);
		
	КонецЦикла;
	
	ИзменитьРеквизиты(МассивРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРеквизитФормы(МассивРеквизитов, ИмяРеквизита, ЗаголовокРеквизита)
	
	РеквизитВидАналитики = Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("Булево"), , ЗаголовокРеквизита);
	РеквизитВидАналитики.СохраняемыеДанные = Истина;
	
	МассивРеквизитов.Добавить(РеквизитВидАналитики);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементыФормы(ДанныеЗаполненияФормы, ГруппаФормы)

	Для Каждого СтрокаДанных Из ДанныеЗаполненияФормы Цикл

		ЭлементСчет = Элементы.Добавить(СтрокаДанных.Имя, Тип("ПолеФормы"), ГруппаФормы);
		ЭлементСчет.Вид = ВидПоляФормы.ПолеФлажка;
		ЭлементСчет.ПутьКДанным = СтрокаДанных.Имя;
		ЭлементСчет.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;

		ЭтотОбъект[СтрокаДанных.Имя] = СтрокаДанных.Значение;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ЕстьОтмеченныйСчетУчета()
	
	Для Каждого ДобавленныйРеквизит Из ДобавленныеРеквизиты Цикл

		Если ЭтотОбъект[ДобавленныйРеквизит.Ключ] = Истина Тогда
			// Нашелся заполненный счет учета.
			Возврат Истина;
		КонецЕсли;

	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
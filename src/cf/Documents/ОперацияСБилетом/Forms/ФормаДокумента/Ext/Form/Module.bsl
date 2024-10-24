﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьСостояниеДокумента();
	КонецЕсли; 
		
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ВыборПорядкаУчетаРасчетов" Тогда
		
		ОбработкаВыбораПорядокУчетаРасчетовНаСервере(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтотОбъект, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПроведениеСервер.УстановитьПризнакПроверкиРеквизитов(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	УстановитьСостояниеДокумента();
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПолейФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьФункциональныеОпцииФормы();
		
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ПричиныИзмененияСчетовУчета = Новый Массив;
	КонтрагентПриИзмененииНаСервере(ПричиныИзмененияСчетовУчета);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентСоздание(Элемент, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентСоздание(Элемент, Элемент.ТекстРедактирования, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ПредлагатьНовыйДоговор = Ложь;
	КонецЕсли;	
	
	ПричиныИзмененияСчетовУчета = Новый Массив;
	ДоговорПриИзмененииНаСервере(ПричиныИзмененияСчетовУчета);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаСоздание(Элемент, СтандартнаяОбработка)
	
	ВведенноеЗначение = ?(Элемент.ТекстРедактирования = Строка(Объект.ДоговорКонтрагента),
		"", Элемент.ТекстРедактирования);
	ПараметрыДоговора = ПараметрыСозданияНовогоДоговора();
	
	РаботаСДоговорамиКонтрагентовБПКлиент.ДоговорСоздание(
		Элемент, ВведенноеЗначение, ПараметрыДоговора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПараметрыДоговора = ПараметрыСозданияНовогоДоговора();
	
	РаботаСДоговорамиКонтрагентовБПКлиент.ДоговорОбработкаВыбора(
		Элемент, ВыбранноеЗначение, ПараметрыДоговора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РаботаСДоговорамиКонтрагентовБПКлиент.ЗаполнитьСписокВыбора(
		Элемент, Текст, ПредлагатьНовыйДоговор, СтандартнаяОбработка);
	
	РаботаСДоговорамиКонтрагентовБПКлиент.ДоговорАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСДоговорамиКонтрагентовБПКлиент.ДоговорОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура БилетПриИзменении(Элемент)
	
	БилетПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура БилетСоздание(Элемент, СтандартнаяОбработка)
	
	ПараметрыСозданияБилета = Новый Массив;
	ПараметрыСозданияБилета.Добавить(Новый ПараметрВыбора("Дополнительно.ДатаПокупки", Объект.Дата));
	
	Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыСозданияБилета);
	
КонецПроцедуры

&НаКлиенте
Процедура БилетЗаменаСоздание(Элемент, СтандартнаяОбработка)
	
	Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыСозданияБилетаНаЗамену());
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокУчетаРасчетовНажатие(Элемент, СтандартнаяОбработка) Экспорт

	Если НЕ ТолькоПросмотр Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	
	ТипыДокументов        = "Метаданные.Документы.ОперацияСБилетом.ТабличныеЧасти.ЗачетАвансов.Реквизиты.ДокументАванса.Тип";
	РежимОтбораДокументов = ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоОстаткам");
	АдресХранилищаЗачетАвансов = ПоместитьЗачетАвансовВоВременноеХранилищеНаСервере();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТолькоПросмотр",                 ТолькоПросмотр);
	ПараметрыФормы.Вставить("Дата",                           Объект.Дата);
	ПараметрыФормы.Вставить("ДоговорКонтрагента",             Объект.ДоговорКонтрагента);
	ПараметрыФормы.Вставить("Контрагент",                     Объект.Контрагент);
	ПараметрыФормы.Вставить("Организация",                    Объект.Организация);
	ПараметрыФормы.Вставить("ОстаткиОбороты",                 "Дт");
	ПараметрыФормы.Вставить("ТипыДокументов",                 ТипыДокументов);
	ПараметрыФормы.Вставить("РежимОтбораДокументов",          РежимОтбораДокументов);
	ПараметрыФормы.Вставить("АдресХранилищаЗачетАвансов",     АдресХранилищаЗачетАвансов);
	ПараметрыФормы.Вставить("СпособЗачетаАвансов",            Объект.СпособЗачетаАвансов);
	ПараметрыФормы.Вставить("СчетУчетаРасчетовСКонтрагентом", Объект.СчетУчетаРасчетовСКонтрагентом);
	ПараметрыФормы.Вставить("СчетУчетаРасчетовПоАвансам",     Объект.СчетУчетаРасчетовПоАвансам);
	ПараметрыФормы.Вставить("ДоступенЗачетАвансов",           Истина);
	ПараметрыФормы.Вставить("ИспользуетсяСрокОплаты",         Ложь);
	
	ОткрытьФорму("ОбщаяФорма.ВыборПорядкаУчетаРасчетов", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	РассчитатьСуммыНДС(Объект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)
	РассчитатьСуммыНДС(Объект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СуммаНДСПриИзменении(Элемент)
	ОбработатьИзменениеСуммыНДС(Объект);
КонецПроцедуры

&НаКлиенте
Процедура СуммаНеОблагаемаяНДСПриИзменении(Элемент)
	РассчитатьСуммыНДС(Объект, Элемент.Имя);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкаФормы

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	// Операции ЗаменаВозврат и ЗаменаПокупка используются только при обмене с внешними системами.
	// При ручном вводе используется операция Обмен.
	Если Объект.ВидОперации = Перечисления.ВидыОперацийСБилетами.ЗаменаВозврат 
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСБилетами.Обмен Тогда
		Элементы.БилетЗамена.Видимость = Истина;
		Элементы.БилетЗамена.Заголовок = НСтр("ru='Новый билет'");
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийСБилетами.ЗаменаПокупка Тогда
		Элементы.БилетЗамена.Видимость = Истина;
		Элементы.БилетЗамена.Заголовок = НСтр("ru='Прежний билет'");
	Иначе 
		Элементы.БилетЗамена.Видимость = Ложь;
	КонецЕсли;	
	
	УстановитьФункциональныеОпцииФормы();
	
	ПредлагатьНовыйДоговор = ВестиУчетПоДоговорам И НЕ ЗначениеЗаполнено(Объект.ДоговорКонтрагента)
		И РаботаСДоговорамиКонтрагентовБП.ПредлагатьНовыйДоговор(Объект.Организация, Объект.Контрагент);
	
	// Штраф имеет смысл только при возврате
	Элементы.Штраф.Видимость = (Объект.ВидОперации = Перечисления.ВидыОперацийСБилетами.Возврат);
		
	УстановитьЗаголовок();
	УстановитьПорядокУчетаРасчетов();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрОрганизацияФункциональныхОпцийФормы(ЭтотОбъект, Объект.Организация, Объект.Дата);
	ВестиУчетПоДоговорам = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	// Доступность взаимосвязанных полей
	Элементы.ДоговорКонтрагента.Доступность       = ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Контрагент);
	Элементы.ПодразделениеОрганизации.Доступность = ЗначениеЗаполнено(Объект.Организация);
		
	ДоступностьПорядокУчетаРасчетов = (НЕ Форма.ВестиУчетПоДоговорам И ЗначениеЗаполнено(Объект.Контрагент)) ИЛИ ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	Элементы.ПорядокУчетаРасчетов.Доступность = ДоступностьПорядокУчетаРасчетов;
	Элементы.ПорядокУчетаРасчетов.Гиперссылка = ДоступностьПорядокУчетаРасчетов;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок()
	
	ЧастиЗаголовка = Новый Массив;
	// Общий заголовок
	ЧастьЗаголовка = НСтр("ru='Поступление билетов:'");
	ЧастиЗаголовка.Добавить(ЧастьЗаголовка);
	
	// Вид операции
	ИндексЗначения = Перечисления.ВидыОперацийСБилетами.Индекс(Объект.ВидОперации);
	ЧастиЗаголовка.Добавить(Метаданные.Перечисления.ВидыОперацийСБилетами.ЗначенияПеречисления[ИндексЗначения].Синоним);	
		
	// Номер и Дата документа 
	Если ЗначениеЗаполнено(Объект.Номер) И ЗначениеЗаполнено(Объект.Дата) Тогда
		ЧастьЗаголовка = СтрШаблон(НСтр("ru='%1 от %2'"), СокрЛП(Объект.Номер), Формат(Объект.Дата, "ДЛФ=D"));
		ЧастиЗаголовка.Добавить(ЧастьЗаголовка);
	КонецЕсли;	
	
	// Новый документ 
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЧастьЗаголовка = НСтр("ru='(создание)'");
		ЧастиЗаголовка.Добавить(ЧастьЗаголовка);
	КонецЕсли;	
	
	Заголовок = СтрСоединить(ЧастиЗаголовка, " ");
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьДоговор(ПричиныИзмененияСчетовУчета)
	
	ДоговорДоИзменения = Объект.ДоговорКонтрагента;
	
	Объект.ДоговорКонтрагента = Неопределено;
	ВидыДоговоровАгента = Справочники.Билеты.ВидыДоговоровАгента();
	РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(Объект.ДоговорКонтрагента,
		Объект.Контрагент, Объект.Организация, ВидыДоговоровАгента);
		
	ПредлагатьНовыйДоговор = ВестиУчетПоДоговорам И НЕ ЗначениеЗаполнено(Объект.ДоговорКонтрагента)
		И РаботаСДоговорамиКонтрагентовБП.ПредлагатьНовыйДоговор(Объект.Организация, Объект.Контрагент);
		
	Если ДоговорДоИзменения	<> Объект.ДоговорКонтрагента Тогда
		ДоговорПриИзмененииНаСервере(ПричиныИзмененияСчетовУчета);	
	КонецЕсли;		
		
КонецПроцедуры
	
&НаСервере
Процедура УстановитьПорядокУчетаРасчетов()

	ОсобенностиДокумента = УчетВзаиморасчетовФормы.НовыйОсобенностиУчетаРасчетовДокумента();
	УчетВзаиморасчетовФормы.УстановитьПорядокУчетаРасчетов(ЭтотОбъект, ОсобенностиДокумента);

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеОбработчикиСобытий

&НаКлиентеНаСервереБезКонтекста
Функция НачатьЗаполнениеСчетовУчета(ПричиныИзменения, Объект = Неопределено, СтрокаСписка = Неопределено, КонтейнерОбъект = Неопределено, КонтейнерСтрокаСписка = Неопределено)

	// Код этой функции сформирован автоматически с помощью СчетаУчетаВДокументах.КодФункцииНачатьЗаполнениеСчетовУчета()

	ПараметрыЗаполнения = СчетаУчетаВДокументахКлиентСервер.НовыйПараметрыЗаполнения(
		"ОперацияСБилетом",
		ПричиныИзменения,
		Объект,
		СтрокаСписка,
		КонтейнерОбъект,
		КонтейнерСтрокаСписка);

	// 1. Заполняемые реквизиты
	// Организация
	Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Организация") <> Неопределено Тогда
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "СчетУчетаРасчетовСКонтрагентом");
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "СчетУчетаРасчетовПоАвансам");
	КонецЕсли;

	// Контрагент
	Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Контрагент") <> Неопределено Тогда
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "СчетУчетаРасчетовСКонтрагентом");
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "СчетУчетаРасчетовПоАвансам");
	КонецЕсли;

	// ДоговорКонтрагента
	Если ПараметрыЗаполнения.ПричиныИзменения.Найти("ДоговорКонтрагента") <> Неопределено Тогда
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "СчетУчетаРасчетовСКонтрагентом");
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "СчетУчетаРасчетовПоАвансам");
	КонецЕсли;

	// СчетУчетаРасчетовСКонтрагентом
	Если ПараметрыЗаполнения.ПричиныИзменения.Найти("СчетУчетаРасчетовСКонтрагентом") <> Неопределено Тогда
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "СчетУчетаРасчетовПоАвансам");
	КонецЕсли;

	// 2. (если требуется) Передадим на сервер данные, необходимые для заполнения
	Если ПараметрыЗаполнения.Свойство("Контейнер") Тогда
		// Организация
		Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Организация") <> Неопределено Тогда
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Организация");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "СчетУчетаРасчетовСКонтрагентом");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Контрагент");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "ДоговорКонтрагента");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "СчетУчетаРасчетовПоАвансам");
		КонецЕсли;

		// Контрагент
		Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Контрагент") <> Неопределено Тогда
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Контрагент");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "СчетУчетаРасчетовСКонтрагентом");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Организация");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "ДоговорКонтрагента");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "СчетУчетаРасчетовПоАвансам");
		КонецЕсли;

		// ДоговорКонтрагента
		Если ПараметрыЗаполнения.ПричиныИзменения.Найти("ДоговорКонтрагента") <> Неопределено Тогда
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "ДоговорКонтрагента");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "СчетУчетаРасчетовСКонтрагентом");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Организация");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Контрагент");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "СчетУчетаРасчетовПоАвансам");
		КонецЕсли;

		// СчетУчетаРасчетовСКонтрагентом
		Если ПараметрыЗаполнения.ПричиныИзменения.Найти("СчетУчетаРасчетовСКонтрагентом") <> Неопределено Тогда
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "СчетУчетаРасчетовСКонтрагентом");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "СчетУчетаРасчетовПоАвансам");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Организация");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Контрагент");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "ДоговорКонтрагента");
		КонецЕсли;

	КонецЕсли; // Нужно передавать на сервер данные заполнения
	
	Возврат ПараметрыЗаполнения;

КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
		
	УстановитьФункциональныеОпцииФормы();
		
	ПодразделениеПоУмолчанию = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновноеПодразделениеОрганизации");
	Если БухгалтерскийУчетПереопределяемый.ПодразделениеПринадлежитОрганизации(ПодразделениеПоУмолчанию, Объект.Организация) Тогда
		Объект.ПодразделениеОрганизации = ПодразделениеПоУмолчанию;
	КонецЕсли;
	
	ПричиныИзмененияСчетовУчета = Новый Массив;
	ПричиныИзмененияСчетовУчета.Добавить("Организация");
	
	КонтрагентПриИзмененииНаСервере(ПричиныИзмененияСчетовУчета);
	
	ЗаполнитьСчетаУчета(ПричиныИзмененияСчетовУчета, "Организация");
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере(ПричиныИзмененияСчетовУчета)
	
	ПричиныИзмененияСчетовУчета.Добавить("Контрагент");
	УстановитьДоговор(ПричиныИзмененияСчетовУчета);
	ЗаполнитьСчетаУчета(ПричиныИзмененияСчетовУчета, "Контрагент");
			
КонецПроцедуры

&НаСервере
Процедура ДоговорПриИзмененииНаСервере(ПричиныИзмененияСчетовУчета)
	
	ПричиныИзмененияСчетовУчета.Добавить("Договор");
	ЗаполнитьСчетаУчета(ПричиныИзмененияСчетовУчета, "Договор");
			
КонецПроцедуры

&НаСервере
Процедура БилетПриИзмененииНаСервере()
		
	Если Не ЗначениеЗаполнено(Объект.Билет) Тогда
		Возврат;
	КонецЕсли;	
		
	Документы.ОперацияСБилетом.ЗаполнитьНаОснованииПокупки(Объект);
		
	Если Объект.ВидОперации = Перечисления.ВидыОперацийСБилетами.Возврат Тогда
		// Заполним сумму возврата - это вся стоимость билета
		СуммыБилета = Справочники.Билеты.СуммыБилетов(
			Объект.Организация, 
			, 
			, 
			Объект.Билет,
			,
			Объект.Ссылка);
			
		Если СуммыБилета.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(Объект, СуммыБилета[0], "Сумма, СтавкаНДС, СуммаНДС");
		КонецЕсли;	
			
	КонецЕсли;	
	
	УстановитьПорядокУчетаРасчетов();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПорядокУчетаРасчетовНаСервере(ВыбранноеЗначение)

	УчетВзаиморасчетов.ОбработкаВыбораПорядокУчетаРасчетов(ЭтотОбъект, ВыбранноеЗначение);
	УчетВзаиморасчетов.УстановитьПорядокУчетаРасчетов(ЭтотОбъект);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьСуммыНДС(ДанныеФормы, ИмяЭлемента)
	
	Если НЕ ЗначениеЗаполнено(ДанныеФормы.СтавкаНДС) Тогда
		Возврат;
	КонецЕсли;	
	
	ОблагаемаяСуммаСНДС = ДанныеФормы.Сумма - ДанныеФормы.СуммаНеОблагаемаяНДС;
	
	Если ОблагаемаяСуммаСНДС = 0 Тогда
		ДанныеФормы.СуммаНДС = 0;
		Возврат;
	КонецЕсли;	
	
	Если ОблагаемаяСуммаСНДС < 0 Тогда
		
		Если Найти(ИмяЭлемента, "СуммаНеОблагаемаяНДС") = 0 Тогда
			ДанныеФормы.СуммаНеОблагаемаяНДС = ДанныеФормы.Сумма;
		Иначе
			ДанныеФормы.Сумма = ДанныеФормы.СуммаНеОблагаемаяНДС;
		КонецЕсли;
		
		ДанныеФормы.СуммаНДС = 0;
		Возврат;
		
	КонецЕсли;	
		
	ДанныеФормы.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
		ОблагаемаяСуммаСНДС,
		Истина,
		УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(ДанныеФормы.СтавкаНДС, Ложь));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьИзменениеСуммыНДС(ДанныеФормы)
	
	Если ДанныеФормы.СуммаНДС > ДанныеФормы.Сумма Тогда
		ДанныеФормы.Сумма = ДанныеФормы.СуммаНДС; 	
		ДанныеФормы.СуммаНеОблагаемаяНДС = 0; 	
		Возврат;
	КонецЕсли;	
	
	СтавкаНДСВПроцентах = УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(ДанныеФормы.СтавкаНДС, Ложь);
	
	Если СтавкаНДСВПроцентах = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	ОблагаемаяСумма = ДанныеФормы.СуммаНДС / СтавкаНДСВПроцентах * 100;
	
	ДанныеФормы.СуммаНеОблагаемаяНДС = ДанныеФормы.Сумма - ОблагаемаяСумма - ДанныеФормы.СуммаНДС; 	
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ПараметрыСозданияБилетаНаЗамену()
	
	ПараметрыСозданияБилета = Новый Массив;
	
	РеквизитыБилета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Билет, "Перевозчик, Маршрут, Сотрудник, ДатаОтправления");
	
	Для Каждого Реквизит Из РеквизитыБилета Цикл 
		ПараметрыСозданияБилета.Добавить(Новый ПараметрВыбора("Дополнительно."+Реквизит.Ключ, Реквизит.Значение));
	КонецЦикла;
	
	ПараметрыСозданияБилета.Добавить(Новый ПараметрВыбора("Дополнительно.ДатаПокупки", Объект.Дата));
	
	Возврат ПараметрыСозданияБилета;
	
КонецФункции	

&НаСервере
Процедура ЗаполнитьСчетаУчета(ПричиныИзмененияСчетовУчета, ИмяРеквизита)
	
	Если Не СчетаУчетаВДокументахКлиентСервер.МожноНачатьЗаполнениеСчетовУчета(ИмяРеквизита, ПричиныИзмененияСчетовУчета) Тогда
		Возврат;
	КонецЕсли;
		
	ПараметрыЗаполнения = НачатьЗаполнениеСчетовУчета(ПричиныИзмененияСчетовУчета, Объект);
	СчетаУчетаВДокументах.ЗаполнитьОбъектПриИзменении(ПараметрыЗаполнения);
	УстановитьПорядокУчетаРасчетов();
	
КонецПроцедуры

&НаСервере
Функция ПоместитьЗачетАвансовВоВременноеХранилищеНаСервере()

	Возврат ПоместитьВоВременноеХранилище(Объект.ЗачетАвансов.Выгрузить(), УникальныйИдентификатор);

КонецФункции

&НаСервере
Функция ПараметрыСозданияНовогоДоговора()
	
	Возврат РаботаСДоговорамиКонтрагентовБП.ПараметрыСозданияНовогоДоговора(ЭтотОбъект);
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

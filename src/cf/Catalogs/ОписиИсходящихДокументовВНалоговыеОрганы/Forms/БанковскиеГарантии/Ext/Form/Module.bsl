﻿
&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РазобратьВходныеПараметры(Параметры);
	УправлениеФормой(ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПередЗакрытием_Завершение", 
		ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
		ОписаниеОповещения, 
		Отказ, 
		ЗавершениеРаботы);
		
КонецПроцедуры

#КонецОбласти
 
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОчиститьСканНажатие(Элемент)
	
	ИнициализироватьДокументы(ЭтотОбъект);
	КонтекстЭДОКлиент.ОчиститьСканНажатие(ЭтотОбъект, Элемент);
	
	ЭтоXmlФайл = ЭтоXmlФайлПоИмениЭлемента(Элемент.Имя);
	
	Если ЭтоXmlФайл Тогда
		XMLФайл = ПустоеОписание();
	Иначе
		Подпись = ПустоеОписание();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЭтоXmlФайл = ЭтоXmlФайлПоИмениЭлемента(Элемент.Имя);
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "выберите" Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"БанковскиеГарантии_ПослеВыбора", 
			ЭтотОбъект,
			Элемент.Имя);
			
		ДокументооборотСКОКлиент.ВыбратьXMLФайлВОтветНаТребование(ОписаниеОповещения, ЭтоXmlФайл, НЕ ЭтоXmlФайл);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "Файл" Тогда
		
		Если ЭтоXmlФайл Тогда
			ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(XMLФайл.Адрес, XMLФайл.Имя);
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Открытие файла подписи не предусмотрено'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЭтоXmlФайлПоИмениЭлемента(ИмяЭлемента)
	
	ЭтоXmlФайл = СтрНайти(ВРег(ИмяЭлемента), "XML");
	Возврат ЭтоXmlФайл;

КонецФункции 

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если XMLФайл.Адрес = "" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбран файл банковской гарантии'"));
		Возврат;
	КонецЕсли;
	
	Если Подпись.Адрес = "" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбран файл подписи'"));
		Возврат;
	КонецЕсли;
	
	ОбработкаЗаявленийАбонентаКлиентСервер.СнятьМодифицированность(ЭтотОбъект);
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("XMLФайл", Новый Структура(XMLФайл));
	ДополнительныеПараметры.Вставить("Подпись", Новый Структура(Подпись));
	
	Закрыть(ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытием_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	СохранитьИзменения(Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура РазобратьВходныеПараметры(Параметры)
	
	Опись           	= Параметры.Опись;
	ЗапретитьИзменение 	= Параметры.ЗапретитьИзменение;
	ИмяФайлаДанных      = Параметры.ИмяФайлаДанных;
	ИмяФайлаПодписи     = Параметры.ИмяФайлаПодписи;
	
	XMLФайл = ОписаниеФайла(ИмяФайлаДанных);
	Подпись = ОписаниеФайла(ИмяФайлаПодписи);
	
	Если ИмяФайлаДанных = "" И ИмяФайлаПодписи = "" Тогда
		Заголовок = НСтр("ru = 'Выберите файлы'");
	КонецЕсли;
	
	СинийЦвет 	= Новый Цвет(28, 85, 174);
	КрасныйЦвет = ЦветаСтиля.ЦветОшибкиПроверкиБРО;
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаСервере
Функция ОписаниеФайла(Имя)
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	СписокИменФайлов = Новый СписокЗначений;
	СписокИменФайлов.Добавить(Имя);
	
	СоответствиеИмяИАдреса = КонтекстЭДОСервер.ПолучитьФайлыПринадлежащиеОписи(
		Опись, 
		УникальныйИдентификатор, 
		СписокИменФайлов);
	
	Если СоответствиеИмяИАдреса.Количество() = 0 Тогда
		Возврат ПустоеОписание();
	КонецЕсли;
	
	Описание = ОписаниеФайлаПоСоответсвию(
		Имя, 
		СоответствиеИмяИАдреса);
		
	Возврат Описание;
		
КонецФункции

&НаСервере
Функция ОписаниеФайлаПоСоответсвию(Имя, Соответствие)
	
	Адрес = Соответствие[Имя];
	Возврат ОписаниеФайлаПоИмениИАдресу(Имя, Адрес);
	
КонецФункции

&НаСервере
Функция ОписаниеФайлаПоИмениИАдресу(Имя, Адрес)
	
	ДвДанные = ПолучитьИзВременногоХранилища(Адрес);
	Размер   = ДвДанные.Размер();
	
	Результат = Новый Структура();
	Результат.Вставить("Имя", 		Имя);
	Результат.Вставить("Адрес", 	Адрес);
	Результат.Вставить("Размер", 	Размер);
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

&НаКлиенте
Процедура БанковскиеГарантии_ПослеВыбора(Результат, ИмяЭлемента) Экспорт
	
	Если НЕ Результат.Выполнено ИЛИ Результат.ОписанияФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаЗаявленийАбонентаКлиентСервер.УстановитьМодифицированность(ЭтотОбъект);
	
	Файл = Результат.ОписанияФайлов[0];
	
	ЭтоXmlФайл = ЭтоXmlФайлПоИмениЭлемента(ИмяЭлемента);
	
	Если ЭтоXmlФайл Тогда
		
		Если НЕ СтрНайти(Врег(Файл.Имя), "ON_SVBANKGAR") Тогда
			ТекстОшибки = НСтр("ru = 'Имя файла банковской гарантии должно начинаться на ON_SVBANKGAR'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		КНД = ДокументооборотСКОВызовСервера.КНДФайлаПоАдресу(Файл.Адрес, "windows-1251");
		Если КНД <> "1114319" Тогда
			ТекстОшибки = НСтр("ru = 'Выбран файл не банковской гарантии (КНД банковской гарантии должен быть равен 1114319)'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ОписаниеФайла = Результат.ОписанияФайлов[0];
	
	Если ЭтоXmlФайл Тогда
		XMLФайл = Новый ФиксированнаяСтруктура(ОписаниеФайла);
	Иначе
		Подпись = Новый ФиксированнаяСтруктура(ОписаниеФайла);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	ИнициализироватьДокументы(Форма);
	ОбработкаЗаявленийАбонентаКлиентСервер.ИзменитьОформлениеДокументов(Форма);
	
	Если Элементы.ОчиститьСсылкаXML.Видимость Тогда
		Элементы.ОчиститьСсылкаXML.Видимость = НЕ Форма.ЗапретитьИзменение;
	КонецЕсли;
	
	Если Элементы.ОчиститьСсылкаПодпись.Видимость Тогда
		Элементы.ОчиститьСсылкаПодпись.Видимость = НЕ Форма.ЗапретитьИзменение;
	КонецЕсли;
	
	Элементы.ФормаСохранитьИзменения.Доступность = НЕ Форма.ЗапретитьИзменение;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИнициализироватьДокументы(Форма)
	
	Форма.ФайлыДокументов.Очистить();
	ДобавитьФайл(Форма, Форма.XMLФайл, "XML");
	ДобавитьФайл(Форма, Форма.Подпись, "Подпись");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьФайл(Форма, Описание, Документ)
	
	Если ЗначениеЗаполнено(Описание.Адрес) Тогда
		Файлы = ОбработкаЗаявленийАбонентаКлиентСервер.ОписаниеФайла(Описание.Имя, Описание.Адрес);
		ОбработкаЗаявленийАбонентаКлиентСервер.ДополнитьФайлыВидомДокумента(Файлы, Документ, Форма);
	КонецЕсли;
	
КонецПроцедуры

Функция ПустоеОписание()
	
	Описание = Новый Структура;
	Описание.Вставить("Имя", 	"");
	Описание.Вставить("Адрес", "");
	Описание.Вставить("Размер", "");
	
	Описание = Новый ФиксированнаяСтруктура(Описание);
	
	Возврат Описание;
	
КонецФункции

#КонецОбласти



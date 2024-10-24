﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустой() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НастройкиСистемыНалогообложения" Тогда
		
		ОрганизацияОповещения = Неопределено;
		Если Параметр.Свойство("Организация", ОрганизацияОповещения) И ОрганизацияОповещения = НастройкиУчетаНДФЛ.Организация Тогда
			УправлениеФормой(ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Очистку регистра ПроверенныеДокументы должны сделать в любом случае. Она продолжится, даже если форма закроется.
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеЗаписиЗавершение", ЭтотОбъект);
	ПроведениеКлиент.НачатьОчисткуРегистраПроверенныхДокументов(
		ОповещениеОЗавершении, НастройкиУчетаНДФЛ.Период, НастройкиУчетаНДФЛ.Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыОповещения = Новый Структура("Организация, Период", НастройкиУчетаНДФЛ.Организация, НастройкиУчетаНДФЛ.Период);
	Оповестить("Запись_НастройкиУчетаНДФЛ", ПараметрыОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СообщениеОбОшибкеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СистемаНалогообложения" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		НастройкиУчетаКлиент.ОбработкаНавигационнойСсылкиСистемаНалогообложения(
			ЭтотОбъект, НастройкиУчетаНДФЛ.Организация, НастройкиУчетаНДФЛ.Период);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименяетсяСПриИзменении(Элемент)
	
	НастройкиУчетаНДФЛ.Период = Дата(ПрименяетсяС, 1, 1);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВестиУчетПоВидамДеятельностиПриИзменении(Элемент)
	
	НастройкиУчетаНДФЛФормыКлиент.ВестиУчетПоВидамДеятельностиПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыВключаютсяВДоходыВПериодеПолученияПриИзменении(Элемент)
	
	НастройкиУчетаНДФЛФормыКлиент.АвансыВключаютсяВДоходыВПериодеПолученияПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДляПризнанияРасходовТребуетсяПолучениеДоходаПриИзменении(Элемент)
	
	НастройкиУчетаНДФЛФормыКлиент.ДляПризнанияРасходовТребуетсяПолучениеДоходаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПризнаватьРасходыПоОперациямПрошлогоГодаПриИзменении(Элемент)
	
	НастройкиУчетаНДФЛФормыКлиент.ПризнаватьРасходыПоОперациямПрошлогоГода(ЭтотОбъект, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВсеВидыДеятельности(Команда)
	
	НастройкиУчетаНДФЛФормыКлиент.ВсеВидыДеятельности(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ПрименяетсяС = Год(НастройкиУчетаНДФЛ.Период);
	
	НастройкиУчетаНДФЛФормы.ПодготовитьФормуНаСервере(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Запись   = Форма.НастройкиУчетаНДФЛ;
	
	Элементы.ПроверьтеНастройкиСистемыНалогообложения.Видимость = Не ПлательщикНДФЛ(Запись.Организация, Запись.Период);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПлательщикНДФЛ(Знач Организация, Знач Период)
	
	Возврат УчетнаяПолитика.ПлательщикНДФЛ(Организация, Период);
	
КонецФункции

#КонецОбласти
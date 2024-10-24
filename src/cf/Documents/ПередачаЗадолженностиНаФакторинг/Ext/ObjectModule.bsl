﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено Тогда
		
		Если ТипДанныхЗаполнения <> Тип("Структура")
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
			ДокументОснование = ДанныеЗаполнения;
		ИначеЕсли ТипДанныхЗаполнения = Тип("Структура")
			И ДанныеЗаполнения.Свойство("Основание")
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Основание.Метаданные()) Тогда
			ДокументОснование = ДанныеЗаполнения.Основание;
		КонецЕсли;
		
		Если ДокументОснование <> Неопределено Тогда
			ЗаполнитьПоДокументуОснованию(ДокументОснование);
		Иначе
			СуммаВключаетНДС = Истина;
		КонецЕсли;
			
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(Основание)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание, Истина);
		
		// Заполним табличную часть Уступки права требования
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "СуммаДокумента, СчетУчетаРасчетовСКонтрагентом");
		НоваяСтрока = ДебиторскаяЗадолженность.Добавить();
		НоваяСтрока.Сделка = Основание;
		НоваяСтрока.Сумма = РеквизитыОснования.СуммаДокумента;
		НоваяСтрока.СчетУчетаРасчетов = РеквизитыОснования.СчетУчетаРасчетовСКонтрагентом;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = ДебиторскаяЗадолженность.Итог("Сумма");
	
	ЗаполнитьДоговорПередЗаписью();

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ПередачаЗадолженностиНаФакторинг.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаПрочихРасчетовИП = Документы.ПередачаЗадолженностиНаФакторинг.ПодготовитьТаблицуПрочиеРасчетыИП(
		ПараметрыПроведения.Реквизиты,
		ПараметрыПроведения.ДебиторскаяЗадолженность,
		Отказ);
		
	Документы.ПередачаЗадолженностиНаФакторинг.СформироватьДвиженияПередачаЗадолженностиНаФакторинг(
		ПараметрыПроведения.ДебиторскаяЗадолженность,
		ПараметрыПроведения.Реквизиты,
		Движения, Отказ);
		
	УчетВзаиморасчетов.СформироватьДвиженияПоПрочимРасчетам(
		ТаблицаПрочихРасчетовИП,
		Движения,
		Отказ);
		
	// Регистрация в последовательности.
	РаботаСПоследовательностями.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		ЭтотОбъект,
		Отказ,
		ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет договор в объекте, в случае если не ведется учет по договорам
//
Процедура ЗаполнитьДоговорПередЗаписью()

	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		Возврат;
	КонецЕсли;
	
	// Договор с покупателем.
	ЗаполнитьДоговорКонтрагента(
		ДоговорКонтрагента,
		Контрагент,
		Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	
	// Договор с факторинговой компанией.
	ЗаполнитьДоговорКонтрагента(
		ДоговорФакторинга,
		ФакторинговаяКомпания,
		Перечисления.ВидыДоговоровКонтрагентов.СФакторинговойКомпанией);
	
КонецПроцедуры

Процедура ЗаполнитьДоговорКонтрагента(Договор, Владелец, ВидДоговора)

	ПараметрыДоговора = Новый Структура;
	ПараметрыДоговора.Вставить("ВидДоговора", ВидДоговора);
	ПараметрыДоговора.Вставить("Организация", Организация);
	ПараметрыДоговора.Вставить("Владелец",    Владелец);
	
	Если НЕ (ЗначениеЗаполнено(ПараметрыДоговора.Владелец) И
		ЗначениеЗаполнено(ПараметрыДоговора.Организация) И 
		ТипЗнч(ПараметрыДоговора.Владелец) = Тип("СправочникСсылка.Контрагенты")) Тогда
		Возврат;
	КонецЕсли;
	
	Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	
	Если НЕ РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
			Договор, 
			ПараметрыДоговора.Владелец, 
			ПараметрыДоговора.Организация, 
			ПараметрыДоговора.ВидДоговора) Тогда
			
		ПараметрыСоздания = Новый Структура("ЗначенияЗаполнения", ПараметрыДоговора);
		Договор = РаботаСДоговорамиКонтрагентовБПВызовСервера.СоздатьОсновнойДоговорКонтрагента(ПараметрыСоздания);
		
	КонецЕсли;
	

КонецПроцедуры

#КонецОбласти

#КонецЕсли
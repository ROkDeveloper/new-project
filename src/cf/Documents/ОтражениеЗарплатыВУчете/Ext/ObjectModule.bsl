﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ
//

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ОтражениеЗарплатыВУчете.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Алгоритмы формирования проводок этого документа рассчитывают суммы проводок налогового учета
	Движения.Хозрасчетный.ДополнительныеСвойства.Вставить("СуммыНалоговогоУчетаЗаполнены", Истина);
	
	УчетЗарплаты.СформироватьДвиженияОтраженияЗарплаты(ПараметрыПроведения.ТаблицаОтраженияВУчете,
		ПараметрыПроведения.ТаблицаРеквизиты, Движения, Отказ);

	УчетЗарплаты.СформироватьДвиженияОтраженияЗарплатыУСН(ПараметрыПроведения.ТаблицаОтраженияВУчетеУСН,
		ПараметрыПроведения.ТаблицаРеквизиты, Движения, Отказ);
		
	УчетЗарплаты.СформироватьДвиженияОтраженияЗарплатыИП(ПараметрыПроведения.ТаблицаОтраженияВУчетеИП,
		ПараметрыПроведения.ТаблицаРеквизиты, Движения, Отказ);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
		
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	СтруктураОбязательныхРеквизитов = Новый Структура("ФизическоеЛицо, ОписаниеУдержанияДляЧека", "Сотрудник", "Описание удержания для чека");
	
	Для Каждого ТекущаяСтрока Из ОтражениеВУчете Цикл
		Для Каждого ОбязательныйРеквизит ИЗ СтруктураОбязательныхРеквизитов Цикл
			ИмяРеквизита			= ОбязательныйРеквизит.Ключ;
			ПредставлениеРеквизита	= ОбязательныйРеквизит.Значение;
			ЗначениеРеквизита		= ТекущаяСтрока[ИмяРеквизита];
			Если ТекущаяСтрока.ЯвляетсяОснованиемОформленияКассовогоЧека Тогда
				Если НЕ ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Отражение в учете""'"),
					ПредставлениеРеквизита,
					ТекущаяСтрока.НомерСтроки);
					Префикс	= "" + "ОтражениеВУчете" + "[" + Формат(ТекущаяСтрока.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Префикс + ИмяРеквизита, , Отказ);
					Отказ	= Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("ОтражениеВУчете.ФизическоеЛицо");
	МассивНепроверяемыхРеквизитов.Добавить("ОтражениеВУчете.ОписаниеУдержанияДляЧека");
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецЕсли

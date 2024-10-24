﻿#Область СлужебныйПрограммныйИнтерфейс

#Область Печать

Функция ВыполнитьКомандуПечати(ОписаниеКоманды) Экспорт
	
	УведомленияДляПечати = ЕдиныйНалоговыйСчетВызовСервера.ПолучитьНастройкиПечатиУведомлений(ОписаниеКоманды.ОбъектыПечати);
	ЗаголовкиФормыПечати = ЕдиныйНалоговыйСчетВызовСервера.ЗаголовкиФормыПечати(УведомленияДляПечати);
	
	Для Каждого УведомлениеДляПечати Из УведомленияДляПечати Цикл
		
		СписокПечатаемыхЛистов = УведомлениеОСпецрежимахНалогообложенияВызовСервера.ПечатьУведомленияБРО(УведомлениеДляПечати);
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ОписаниеКоманды.Форма, , Ложь, 
			СписокПечатаемыхЛистов, ЗаголовкиФормыПечати[УведомлениеДляПечати]);
	КонецЦикла;
	
КонецФункции

Функция ВыполнитьКомандуПечатиPDF417(ОписаниеКоманды) Экспорт
	
	// Команда для формы документа, в котором есть экспортный метод
	ОписаниеКоманды.Форма.ПоказатьСДвухмернымШтрихкодомPDF417();
	
КонецФункции

#КонецОбласти

Процедура ПередОткрытиемФормыУведомления(Организация, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура ПриВыбореВидаУведомления(Форма, ПараметрыУведомления) Экспорт
	
	ЗначенияЗаполнения = Новый Структура("Организация", ПараметрыУведомления.Организация);
	ПараметрыУведомления.Вставить("ЗначенияЗаполнения",
		ЗначенияЗаполнения);
	ПараметрыУведомления.Вставить("ВидУведомления",
		ПараметрыУведомления.ВидУведомления);
		
	ИмяОбъекта = "";
	Если ПараметрыУведомления.ВидУведомления = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ИсчисленныеСуммыНалогов") Тогда
		ИмяОбъекта = "УведомлениеОбИсчисленныхСуммахНалогов";
	ИначеЕсли ПараметрыУведомления.ВидУведомления = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОЗачетеНалога") Тогда
		ИмяОбъекта = "ЗаявлениеОЗачетеВСчетПредстоящейОбязанности";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяОбъекта) Тогда
		ОткрытьФорму("Документ." + ИмяОбъекта + ".Форма.ФормаСозданияУведомления",
			ПараметрыУведомления,
			Форма);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

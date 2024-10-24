﻿
#Область ПрограммныйИнтерфейс

Функция ПараметрыОткрытияДолжности(Организация, ФизическоеЛицо) Экспорт
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("СпособОткрытия", Неопределено);
	ПараметрыОткрытия.Вставить("Сотрудник", Неопределено);
	
	// Если физическое лицо является руководителем или главным бухгалтером,
	// то нужно открыть форму организации или форму ответственных лиц.
	// В противном случае нужно открыть форму сотрудника.
	// Для руководителя и гл.бухгалтера сведения о должности определяются с помощью 
	// РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОбОрганизации (поля ДолжностьРук, ДолжностьБух).
	// БРО определяет, что это руководитель или гл.бухгалтер с помощью переопределяемых методов
	// ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.ГлБухгалтер() и .Руководитель().
	// Поэтому в этом случае нужно открывать организацию,т.к. данные для должности хранятся именно там.
	// Если физ.лицо не является гл.бухгалтером или руководителем, то его должноть определяется с помощью
	// ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.ПолучитьДанныеИсполнителя().
	// В этом случае нужно открывать сотрудника, т.к. должность в ПолучитьДанныеИсполнителя() определяется из сотрудника.
	
	ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(Организация, ТекущаяДатаСеанса());
	Если ФизическоеЛицо = ОтветственныеЛица.Руководитель Тогда
		ПараметрыОткрытия.СпособОткрытия = "ОткрытьРуководителя";
	ИначеЕсли ФизическоеЛицо = ОтветственныеЛица.ГлавныйБухгалтер Тогда
		ПараметрыОткрытия.СпособОткрытия = "ОткрытьГлавногоБухгалтера";
	Иначе
		Сотрудник = СотрудникПоФизическомуЛицу(Организация, ФизическоеЛицо);
		Если ЗначениеЗаполнено(Сотрудник) Тогда
			ПараметрыОткрытия.СпособОткрытия = "ОткрытьСотрудника";
			ПараметрыОткрытия.Сотрудник = Сотрудник;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СотрудникПоФизическомуЛицу(Организация, ФизическоеЛицо)
	
	ДанныеФизическогоЛица = УчетЗарплаты.ДанныеФизическихЛиц(Организация, ФизическоеЛицо, КонецДня(ТекущаяДата()), Ложь, Ложь);
	Возврат ДанныеФизическогоЛица.Сотрудник;
	
КонецФункции

#КонецОбласти

﻿
#Область ПрограммныйИнтерфейс
	
Функция СчетНаОплатуПокупателюПредставление(СчетНаОплатуПокупателю) Экспорт
	Если НЕ ЗначениеЗаполнено(СчетНаОплатуПокупателю) Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	РеквизитыСчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		СчетНаОплатуПокупателю, 
		"Дата, Номер");

	Возврат РеализацияТоваровУслугФормы.ПредставлениеСчетаНаОплату(РеквизитыСчета);
КонецФункции

Функция ОстатокТовараПоСчету(Номенклатура, СчетНаОплатуПокупателю, Регистратор) Экспорт
	МассивСчетов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СчетНаОплатуПокупателю);
	
	РеализацииПоСчету = Документы.СчетНаОплатуПокупателю.РеализацииПоСчетам(МассивСчетов);
	
	СтрокиКУдалению = РеализацииПоСчету.НайтиСтроки(Новый Структура("Реализация", Регистратор));
	Для каждого Строка Из СтрокиКУдалению Цикл
		РеализацииПоСчету.Удалить(Строка);
	КонецЦикла;
	
	// Товары и услуги
	ТоварыУслугиКРеализации = Документы.СчетНаОплатуПокупателю.ТоварыУслугиКРеализацииПоСчету(
		СчетНаОплатуПокупателю, РеализацииПоСчету);
		
	СтрокаНоменклатура = ТоварыУслугиКРеализации.Найти(Номенклатура, "Номенклатура");
	Если СтрокаНоменклатура <> Неопределено Тогда
		Возврат СтрокаНОменклатура.Количество;
	Иначе
		Возврат 0;
	КонецЕсли; 
КонецФункции

#Область РаботасЭТрН

Функция РеквизитыЭТрН(Основание) Экспорт
	Возврат ОбменСКонтрагентамиБП.РеквизитыЭТрН(Основание);
КонецФункции

Функция НастроенОбменЭПД(Организация, Грузополучатель, Перевозчик) Экспорт
	Возврат ОбменСГИСЭПДБП.ДокументооборотНастроен(Организация, Грузополучатель) 
		  И ОбменСГИСЭПДБП.ДокументооборотНастроен(Организация, Перевозчик);
КонецФункции

#КонецОбласти 

#КонецОбласти 

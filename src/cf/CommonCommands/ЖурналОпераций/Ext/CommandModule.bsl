﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = ОбщегоНазначенияБПКлиентСервер.ПараметрыОткрытияФормыСОжиданием(ПараметрыВыполненияКоманды);
	Если ПараметрыОткрытия.Окно <> Неопределено Тогда
		ПараметрыОткрытия.Владелец     = Неопределено;
		ПараметрыОткрытия.Уникальность = Истина;
	КонецЕсли;
	ПараметрыОткрытия.ИмяФормы = "ЖурналДокументов.ЖурналОпераций.ФормаСписка";
	ПараметрыОткрытия.ЗамерПроизводительности = Истина;
	
	ОбщегоНазначенияБПКлиент.ОткрытьФормуСОжиданием(ПараметрыОткрытия);
	
КонецПроцедуры

﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Объект = ПараметрыВыполненияКоманды.Источник.Объект;
	Организация = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Объект, "Организация");
	Банк = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Объект, "Банк");
	
	ПараметрыОткрываемойФормы = Новый Структура;
	ПараметрыОткрываемойФормы.Вставить("Организация", Организация);
	ПараметрыОткрываемойФормы.Вставить("Банк", Банк);
	
	ОткрытьФорму("РегистрСведений.ДокументыАУСН.Форма.ЖурналОбмена",
		ПараметрыОткрываемойФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

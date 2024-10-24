﻿#Область СлужебныйПрограммныйИнтерфейс

// См. КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамОбъекта
Процедура ОткрытьОтчетПоПроблемамОбъекта(Форма, ПроблемныйОбъект, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		Возврат;
	КонецЕсли;
	
	МодульКонтрольВеденияУчетаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("КонтрольВеденияУчетаКлиент");
	МодульКонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамОбъекта(Форма, ПроблемныйОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

// См. КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамИзСписка
Процедура ОткрытьОтчетПоПроблемамИзСписка(Форма, ИмяСписка, Поле, СтандартнаяОбработка, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства = Форма[ИмяСписка].КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	Если Поле.Имя = ДополнительныеСвойства.КолонкаИндикатора Тогда
		
		ТаблицаФормы = Форма.Элементы.Найти(ДополнительныеСвойства.ИмяСписка);
		Если ТаблицаФормы <> Неопределено И ТаблицаФормы.ТекущиеДанные[Поле.Имя] > 0 Тогда
			
			МодульКонтрольВеденияУчетаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("КонтрольВеденияУчетаКлиент");
			МодульКонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамИзСписка(Форма, ИмяСписка, Поле, СтандартнаяОбработка, ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

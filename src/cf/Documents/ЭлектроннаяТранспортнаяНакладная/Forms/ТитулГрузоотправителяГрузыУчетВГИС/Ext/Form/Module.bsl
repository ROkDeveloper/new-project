﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	ОбменСГИСЭПД.СоздатьЭлементыВводаЗначенийСписка(ЭтотОбъект, "ИдентификационныеНомераУчетныхЕдиниц", "ИдентификационныйНомерУчетнойЕдиницы");
	
КонецПроцедуры

&НаКлиенте
Процедура ИмеетУчетВГИСПриИзменении(Элемент)
	
	ОбменСГИСЭПДКлиентСервер.ИзменитьОформлениеФормы(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
		
	ОбменСГИСЭПДКлиент.СохранитьПараметрыПодчиненнойФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбменСГИСЭПДКлиент.ПриОткрытииПодчиненнойФормы(ЭтотОбъект);
																		
КонецПроцедуры
			
&НаКлиенте
Функция ОписаниеРеквизитовФормы() Экспорт
	
	Возврат ОписаниеРеквизитовФормыСервер();
	
КонецФункции

&НаСервере
Функция ОписаниеРеквизитовФормыСервер()
	
	Возврат ОбменСГИСЭПД.ОписаниеРеквизитовФормы(ЭтаФорма);
		
КонецФункции

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ДобавлениеПоляВвода(Команда)
	
	ИмяТаблицыИПоля = СтрЗаменить(Команда.Имя, "ДобавлениеПоляВвода", "");
	МассивЧастей = ОбменСГИСЭПДКлиентСервер.РазделитьСтрокуСоСложнымРазделителем(ИмяТаблицыИПоля, "__");
	
	ДобавлениеПоляВводаСервер(МассивЧастей[0], МассивЧастей[1]);
	
КонецПроцедуры


&НаСервере
Процедура ДобавлениеПоляВводаСервер(ИмяТаблицы, ИмяПоля)
	
	ОбменСГИСЭПД.СоздатьЭлементыВводаЗначенийСписка(ЭтотОбъект, ИмяТаблицы, ИмяПоля, Истина);
	
КонецПроцедуры


&НаКлиенте
Процедура ТитулГрузоотправителяИдентификационныеНомераУчетныхЕдиницПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОбменСГИСЭПДКлиент.ОчиститьПодчиненныеТаблицы(ЭтотОбъект, Элемент.Имя, ТекущиеДанные.ИдентификаторСтроки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТитулГрузоотправителяИдентификационныеНомераУчетныхЕдиницПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ОбменСГИСЭПДКлиент.ТаблицаПриНачалеРедактирования(Элемент, ЭтотОбъект, НоваяСтрока, Копирование);


КонецПроцедуры

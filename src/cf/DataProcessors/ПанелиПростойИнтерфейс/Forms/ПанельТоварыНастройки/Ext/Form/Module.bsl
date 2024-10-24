﻿
#Область КомандыФормы

&НаКлиенте
Процедура Склады(Команда)
	
	ОткрытьФормуВОкнеФормы("Справочник.Склады.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ТипыЦенНоменклатуры(Команда)
	
	ОткрытьФормуВОкнеФормы("Справочник.ТипыЦенНоменклатуры.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаЦенНоменклатуры(Команда)
	
	ОткрытьФормуВОкнеФормы("Документ.УстановкаЦенНоменклатуры.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыНоменклатуры(Команда)
	
	ОткрытьФормуВОкнеФормы("Справочник.ВидыНоменклатуры.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФормуВОкнеФормы(ИмяФормы)
	
	ОткрытьФорму(ИмяФормы, , ЭтотОбъект, ИмяФормы, Окно);
	
КонецПроцедуры

#КонецОбласти
﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ГодУбытка = Год(Объект.ГодУбытка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.ГодУбытка = Дата(ГодУбытка, 1, 1);
	
КонецПроцедуры

#КонецОбласти

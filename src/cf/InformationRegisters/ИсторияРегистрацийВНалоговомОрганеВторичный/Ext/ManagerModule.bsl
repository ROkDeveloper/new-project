﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(СтруктурнаяЕдиница)
	|	ИЛИ ЗначениеРазрешено(СтруктурнаяЕдиница.Владелец)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьВторичныеДанные(СтруктурныеЕдиницы = Неопределено) Экспорт
	
	Набор = РегистрыСведений.ИсторияРегистрацийВНалоговомОрганеВторичный.СоздатьНаборЗаписей();
	Набор.ОбменДанными.Загрузка = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	|	ИсторияРегистрацийВНалоговомОргане.Период КАК Период
	|ИЗ
	|	РегистрСведений.ИсторияРегистрацийВНалоговомОргане КАК ИсторияРегистрацийВНалоговомОргане
	|ГДЕ
	|	&УсловиеПоСтруктурнойЕдинице
	|
	|УПОРЯДОЧИТЬ ПО
	|	СтруктурнаяЕдиница,
	|	Период";
	
	Если СтруктурныеЕдиницы = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоСтруктурнойЕдинице", "ИСТИНА");
		Набор.Записать();
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоСтруктурнойЕдинице",
			"ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница В (&СтруктурныеЕдиницы)");
		Запрос.УстановитьПараметр("СтруктурныеЕдиницы", СтруктурныеЕдиницы);
	КонецЕсли;
	
	// АПК:1328-выкл Заполнение вторичных данных вызывается из записи набора первичных данных.
	Результат = Запрос.Выполнить();
	// АПК:1328-вкл

	Если Результат.Пустой() И СтруктурныеЕдиницы <> Неопределено Тогда
		Для Каждого СтруктурнаяЕдиница Из СтруктурныеЕдиницы Цикл
			Набор.Отбор.СтруктурнаяЕдиница.Установить(СтруктурнаяЕдиница);
			Набор.Записать();
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("СтруктурнаяЕдиница") Цикл
		
		Набор.Отбор.СтруктурнаяЕдиница.Установить(Выборка.СтруктурнаяЕдиница);
		
		Пока Выборка.Следующий() Цикл
			Если Набор.Количество() > 0 Тогда
				Набор[Набор.Количество() - 1].ДатаОкончания = Выборка.Период - 1;
			КонецЕсли;
			
			Запись = Набор.Добавить();
			Запись.ДатаНачала = Выборка.Период;
			Запись.СтруктурнаяЕдиница = Выборка.СтруктурнаяЕдиница;
			Запись.РегистрацияВНалоговомОргане = Выборка.РегистрацияВНалоговомОргане;
		КонецЦикла;
		
		Набор[Набор.Количество() - 1].ДатаОкончания = ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата();
		Набор.Записать();
		Набор.Очистить();
		
	КонецЦикла;
	
КонецПроцедуры

// Пересчитывает зависимые данные после загрузки сообщения обмена
//
// Параметры:
//		ЗависимыеДанные - ТаблицаЗначений:
//			* ВедущиеМетаданные - ОбъектМетаданных - Метаданные ведущих данных
//			* ЗависимыеМетаданные - ОбъектМетаданных - Метаданные текущего объекта
//			* ВедущиеДанные - Массив объектов, заполненный при загрузке сообщения обмена
//				по этим объектам требуется обновить зависимые данные
//
Процедура ОбновитьЗависимыеДанныеПослеЗагрузкиОбменаДанными(ЗависимыеДанные) Экспорт
	
	Если ЗависимыеДанные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтруктурныеЕдиницы = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из ЗависимыеДанные Цикл
		Для Каждого НаборЗаписей Из СтрокаТаблицы.ВедущиеДанные Цикл
			СтруктурнаяЕдиницаНабораЗаписей = НаборЗаписей.Отбор.СтруктурнаяЕдиница.Значение;
			Если Не ЗначениеЗаполнено(СтруктурнаяЕдиницаНабораЗаписей) Тогда
				ЗаполнитьВторичныеДанные();
				Возврат; // При пустой структурной единице, хотя бы в одном наборе записей 
				         // будут заполнены вторичные данные по всем структурным единицам.
			КонецЕсли;
			СтруктурныеЕдиницы.Добавить(СтруктурнаяЕдиницаНабораЗаписей);
		КонецЦикла
	КонецЦикла;
	
	ЗаполнитьВторичныеДанные(СтруктурныеЕдиницы);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
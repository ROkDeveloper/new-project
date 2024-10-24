﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

Процедура ЗаполнитьСпособОтраженияРасходов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПервоначальныеСведенияОСНалоговыйУчет.Регистратор КАК Регистратор,
	|	ВЫРАЗИТЬ(ПервоначальныеСведенияОСНалоговыйУчет.Регистратор КАК Документ.ПринятиеКУчетуОС).СпособОтраженияРасходовПриВключенииВСтоимость КАК СпособОтраженияРасходовПриВключенииВСтоимость,
	|	ВЫРАЗИТЬ(ПервоначальныеСведенияОСНалоговыйУчет.Регистратор КАК Документ.ПринятиеКУчетуОС).СпособыОтраженияРасходовПоАмортизации КАК СпособыОтраженияРасходовПоАмортизации
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСНалоговыйУчет КАК ПервоначальныеСведенияОСНалоговыйУчет
	|ГДЕ
	|	ПервоначальныеСведенияОСНалоговыйУчет.Регистратор ССЫЛКА Документ.ПринятиеКУчетуОС
	|	И ПервоначальныеСведенияОСНалоговыйУчет.ПорядокВключенияСтоимостиВСоставРасходов = ЗНАЧЕНИЕ(Перечисление.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ВключениеВРасходыПриПринятииКУчету)
	|	И ПервоначальныеСведенияОСНалоговыйУчет.СпособОтраженияРасходовПриВключенииВСтоимость = ЗНАЧЕНИЕ(Справочник.СпособыОтраженияРасходовПоАмортизации.ПустаяССылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПервоначальныеСведенияОСНалоговыйУчет.Регистратор,
	|	ЗНАЧЕНИЕ(Справочник.СпособыОтраженияРасходовПоАмортизации.ПустаяССылка),
	|	ВЫРАЗИТЬ(ПервоначальныеСведенияОСНалоговыйУчет.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СпособОтраженияРасходовПоАмортизации
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСНалоговыйУчет КАК ПервоначальныеСведенияОСНалоговыйУчет
	|ГДЕ
	|	ПервоначальныеСведенияОСНалоговыйУчет.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
	|	И ПервоначальныеСведенияОСНалоговыйУчет.ПорядокВключенияСтоимостиВСоставРасходов = ЗНАЧЕНИЕ(Перечисление.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ВключениеВРасходыПриПринятииКУчету)
	|	И ПервоначальныеСведенияОСНалоговыйУчет.СпособОтраженияРасходовПриВключенииВСтоимость = ЗНАЧЕНИЕ(Справочник.СпособыОтраженияРасходовПоАмортизации.ПустаяССылка)";
	
	ВыборкаЗаписи = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаЗаписи.Следующий() Цикл
	
		НаборЗаписей = РегистрыСведений.ПервоначальныеСведенияОСНалоговыйУчет.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаЗаписи.Регистратор);
		НаборЗаписей.Прочитать();
		
		Для каждого СтрокаНабора Из НаборЗаписей Цикл
			Если СтрокаНабора.ПорядокВключенияСтоимостиВСоставРасходов = 
				Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ВключениеВРасходыПриПринятииКУчету
				И НЕ ЗначениеЗаполнено(СтрокаНабора.СпособОтраженияРасходовПриВключенииВСтоимость) Тогда
				
				Если ЗначениеЗаполнено(ВыборкаЗаписи.СпособОтраженияРасходовПриВключенииВСтоимость) Тогда
					СтрокаНабора.СпособОтраженияРасходовПриВключенииВСтоимость = 
						ВыборкаЗаписи.СпособОтраженияРасходовПриВключенииВСтоимость;
					СтрокаНабора.СпособОтраженияРасходовАналогичноАмортизации = Ложь;
				Иначе
					СтрокаНабора.СпособОтраженияРасходовПриВключенииВСтоимость = 
						ВыборкаЗаписи.СпособыОтраженияРасходовПоАмортизации;
					СтрокаНабора.СпособОтраженияРасходовАналогичноАмортизации = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

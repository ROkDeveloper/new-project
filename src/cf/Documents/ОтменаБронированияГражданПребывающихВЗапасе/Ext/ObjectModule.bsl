﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	СформироватьДвиженияПоБронированию(Движения, ДанныеДляПроведения.ДвиженияПоБронированию);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОтменаБронированияГражданСотрудники.Ссылка.Дата КАК Период,
	               |	ОтменаБронированияГражданСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) КАК Организация
	               |ИЗ
	               |	Документ.ОтменаБронированияГражданПребывающихВЗапасе.Сотрудники КАК ОтменаБронированияГражданСотрудники
	               |ГДЕ
	               |	ОтменаБронированияГражданСотрудники.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПроведения = Новый Структура;
	
	ДвиженияПоБронированию = РезультатЗапроса.Выгрузить();
	ДанныеДляПроведения.Вставить("ДвиженияПоБронированию", ДвиженияПоБронированию);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура СформироватьДвиженияПоБронированию(Движения, ДвиженияПоБронированию) Экспорт 
	
	Если ДвиженияПоБронированию.Количество() > 0 Тогда
		Движения.БронированиеСотрудников.Записывать = Истина;
	КонецЕсли; 
	
	Движения.БронированиеСотрудников.Загрузить(ДвиженияПоБронированию);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
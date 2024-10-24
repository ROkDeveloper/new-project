﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РедактированиеНастроек = Справочники.НастройкиУчетаЗатрат.ПрименитьПараметрыФормыНастроек(ЭтотОбъект, Счет);
	
	ЗаполнитьСодержимоеФормы(РедактированиеНастроек);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаOK(Команда)
	
	РезультатФормы = Неопределено;
	
	Если Модифицированность Тогда
		РезультатФормы = УстановитьВыполненныеНастройки(АдресРедактированиеНастроек, Счет, Роль);
	КонецЕсли;
	
	Закрыть(РезультатФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСодержимоеФормы(РедактированиеНастроек)
	
	УстановитьЗаголовокНазначенияСчета(Элементы.НазначениеСчетаЗаголовок, Счет);
	
	Настройки = РедактированиеНастроек.Настройки;
	ЗакрытиеСчета = Настройки.Закрытие[Счет];
	Роль = ЗакрытиеСчета.Роль;
	
	НаличиеКалькуляционныхСчетов = НаличиеКалькуляционныхСчетов(Настройки.СчетаУчета);
	НезавершенноеПроизводство = УчетНезавершенногоПроизводства(Настройки.СчетаУчета, Настройки.Закрытие);
	
	ЭлементыКлючаСохраненияОкна = Новый Массив;
	ЭлементыКлючаСохраненияОкна.Добавить(XMLСтрока(НаличиеКалькуляционныхСчетов));
	ЭлементыКлючаСохраненияОкна.Добавить(XMLСтрока(НезавершенноеПроизводство));
	ЭлементыКлючаСохраненияОкна.Добавить(XMLСтрока(Настройки.ВыпускПродукции));
	КлючСохраненияПоложенияОкна = СтрСоединить(ЭлементыКлючаСохраненияОкна, ";");
	
	УстановитьВидимостьРолей(НаличиеКалькуляционныхСчетов);
	УстановитьПодсказки(НаличиеКалькуляционныхСчетов, Настройки.ВыпускПродукции, НезавершенноеПроизводство);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УстановитьВыполненныеНастройки(Знач АдресРедактированиеНастроек, Знач Счет, Знач Роль)
	
	РедактированиеНастроек = Справочники.НастройкиУчетаЗатрат.НачатьУстановкуВыполненныхНастроек(АдресРедактированиеНастроек);
	
	РедактированиеНастроек.Настройки.Закрытие[Счет].Роль = Роль;
	
	Возврат Справочники.НастройкиУчетаЗатрат.ЗавершитьУстановкуВыполненныхНастроек(
		АдресРедактированиеНастроек,
		РедактированиеНастроек);
	
КонецФункции

&НаСервереБезКонтекста
Функция УчетНезавершенногоПроизводства(СчетаУчета, НастройкиЗакрытия)
	
	Для Каждого Счет Из СчетаУчета Цикл
		
		Если ЗначениеЗаполнено(НастройкиЗакрытия[Счет].НезавершенноеПроизводство) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьЗаголовокНазначенияСчета(НастраиваемоеПоле, Счет)
	
	НастраиваемоеПоле.Заголовок = СтрШаблон(
		НСтр("ru = 'На счете %1 учитываются:'"),
		ПланыСчетов.Хозрасчетный.ПолноеПредставлениеСчета(Счет));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НаличиеКалькуляционныхСчетов(СчетаУчетаЗатрат)
	
	СчетаПрямыхРасходов = УчетЗатрат.ПредопределенныеСчетаПрямыхРасходов();
	
	Для Каждого СчетУчета Из СчетаУчетаЗатрат Цикл
		
		Если СчетаПрямыхРасходов.Найти(СчетУчета) = Неопределено
			И СчетаПрямыхРасходов.Найти(СчетУчета.Родитель) = Неопределено Тогда
			
			Продолжить;
		КонецЕсли;
		
		Возврат Истина;
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

&НаСервере
Процедура УстановитьВидимостьРолей(НаличиеКалькуляционныхСчетов)
	
	Элементы.ВедениеОсновнойДеятельностиОформление.Видимость = Не НаличиеКалькуляционныхСчетов;
	Элементы.КосвенныеЗатратыОформление.Видимость = НаличиеКалькуляционныхСчетов;
	Элементы.ИныеРасходыОформление.Видимость = НаличиеКалькуляционныхСчетов;
	
	Если Не НаличиеКалькуляционныхСчетов Тогда
		Элементы.УправленческиеРасходы.РасширеннаяПодсказка.Заголовок = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПодсказки(НаличиеКалькуляционныхСчетов, ВыпускПродукции, НезавершенноеПроизводство)
	
	ТекстВыпущеннаяПродукция = "";
	ТекстПродукция = "";
	ТекстГотоваяПродукция = "";
	ТекстПроизводствоПродукции = "";
	ТекстНезавершенноеПроизводство = "";
	
	Если ВыпускПродукции Тогда
		ТекстВыпущеннаяПродукция = НСтр("ru = 'выпущенной продукции, '");
		ТекстГотоваяПродукция = НСтр("ru = 'готовой продукции, '");
		ТекстПроизводствоПродукции = НСтр("ru = 'производства продукции, '");
		ТекстПродукция = НСтр("ru = 'продукции, '");
	КонецЕсли;
	
	Если НезавершенноеПроизводство Тогда
		ТекстНезавершенноеПроизводство = НСтр("ru = ' и незавершенного производства'");
	КонецЕсли;

	Если НаличиеКалькуляционныхСчетов Тогда
		
		// Косвенные затраты.
		
		ШаблонТекста = НСтр(
		"ru = 'Косвенные затраты включаются в себестоимость %1работ, услуг%3,
		 |но не могут быть прямо отнесены к производству конкретного вида %2работ, услуг.
		 |Они распределяются между конкретными видами %2работ, услуг обоснованным способом, установленным организацией.'");
		
		Элементы.КосвенныеЗатратыПодсказка.Заголовок = СтрШаблон(
			ШаблонТекста, ТекстВыпущеннаяПродукция, ТекстПродукция, ТекстНезавершенноеПроизводство);
			
		// Управленческие расходы.
		
		ШаблонТекста = НСтр(
		"ru = 'Управленческие расходы не включаются в себестоимость %1работ, услуг%3.
		 |В отчете о финансовых результатах они отражаются отдельной строкой, обособленно от себестоимости проданных товаров, %2работ, услуг.'");
		
		Элементы.УправленческиеРасходыПодсказка.Заголовок = СтрШаблон(
			ШаблонТекста, ТекстВыпущеннаяПродукция, ТекстПродукция, ТекстНезавершенноеПроизводство);
			
		// Иные расходы.
		
		ШаблонТекста = НСтр(
		"ru = 'К этой категории относятся расходы, не включаемые в себестоимость %1работ, услуг%2, кроме управленческих расходов.
         |Например, расходы
         |- на хранение
         |- на подготовку производства, которое еще не началось либо не дало результата
         |- связанные с ненадлежащей организацией производственного процесса
         |- иные, необязательные для %3выполнения работ, оказания услуг.
         |В отчете о финансовых результатах они отражаются в составе себестоимости проданных товаров, продукции, работ, услуг.'");
		
		Элементы.ИныеРасходыПодсказка.Заголовок = СтрШаблон(
			ШаблонТекста, ТекстГотоваяПродукция, ТекстНезавершенноеПроизводство, ТекстПроизводствоПродукции);
			
		Возврат;
	КонецЕсли;
	
	// Расходы на ведение основной деятельности.
	
	ШаблонТекста = НСтр(
	"ru = 'В отчете о финансовых результатах они отражаются в составе себестоимости проданных товаров, %1работ, услуг.
	 |Такой порядок учета используют организации, деятельность которых не связана с производственным процессом.'");
	
	Элементы.ВедениеОсновнойДеятельностиПодсказка.Заголовок = СтрШаблон(ШаблонТекста, ТекстПродукция);
	
	// Управленческие расходы.
	
	ШаблонТекста = НСтр(
	"ru = 'В отчете о финансовых результатах они отражаются отдельной строкой, обособленно от себестоимости проданных товаров, %1работ, услуг.'");
	
	Элементы.УправленческиеРасходыПодсказка.Заголовок = СтрШаблон(ШаблонТекста, ТекстПродукция);
	
КонецПроцедуры

#КонецОбласти


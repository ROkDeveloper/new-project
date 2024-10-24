﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РасширениеРаботыСФайламиПодключено = Истина;
	
	ПутьКФайлу          = Параметры.ПутьКФайлу;
	АдресИсходныхДанных = Параметры.АдресИсходныхДанных;
	
	Если Параметры.Кодировка = "DOS" Тогда
		Кодировка = "cp866";        // КодировкаТекста.OEM;
	Иначе
		Кодировка = "windows-1251"; // КодировкаТекста.ANSI;
	КонецЕсли;
	
	УстановитьГруппуПроверки("ГруппаПроверкаПоКнопке");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПодключитьРасширениеРаботыСФайлами", 0.1, Истина);
	Иначе
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьФайлВыгрузки", 2, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ТекущаяГруппаПроверки = ТекущаяГруппаПроверки(ЭтотОбъект);
	Если ТекущаяГруппаПроверки = "ГруппаФайлИзменен"
		ИЛИ ТекущаяГруппаПроверки = "ГруппаФайлУдален" Тогда
		
		Если ЗагруженнаяВыпискаПроверена Тогда
			
			Если Не ЗавершениеРаботы
				И ЗначениеЗаполнено(ПутьКФайлу) Тогда
				
				Отказ = Истина;
				УдалитьФайлПередЗакрытием();
				
			КонецЕсли;
			
		Иначе
			
			Отказ = Истина;
			
			ТекстПредупрежденияОбУгрозе = НСтр("ru = 'Подтвердите, что Клиент банка проверен и в нем все платежи корректны'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстПредупрежденияОбУгрозе, , , "ЗагруженнаяВыпискаПроверена");
			
		КонецЕсли;
		
	ИначеЕсли Не ЗавершениеРаботы
		И ЗначениеЗаполнено(ПутьКФайлу) Тогда
		
		Отказ = Истина;
		ПроверитьИУдалитьФайлПередЗакрытием();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Проверить(Команда)
	
	Если РасширениеРаботыСФайламиПодключено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПоказатьРезультатОднократно", ЭтотОбъект);
		ПроверитьФайлНаКлиенте(ОписаниеОповещения);
	Иначе
		ОповещениеПомещениеФайла = Новый ОписаниеОповещения("ПомещениеФайлаЗавершение", ЭтотОбъект);
		НачатьПомещениеФайла(ОповещениеПомещениеФайла, , , Истина, ЭтотОбъект.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Пропустить(Команда)
	
	Если ТекущаяГруппаПроверки(ЭтотОбъект) = "ГруппаПроверкаПоКнопке" Тогда
		Комментарий = НСтр("ru = 'Пользователь отказался от проверки файла выгрузки платежей в Клиенте банка'");
		ЗаписатьВЖурналРегистрации("ОтказОтПроверкиВыписки", Комментарий);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ЗагруженнаяВыпискаПроверенаПриИзменении(Элемент)
	
	Комментарий = НСтр("ru = 'Пользователь подтвердил, что реквизиты в Клиенте банка проверены и не подменены'");
	
	ЗаписатьВЖурналРегистрации("УстановленФлагПроверкиКлиентБанка", Комментарий);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнструкцияФайлИзмененТекстСообщения7ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьИзмененныйФайл" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если АдресИзмененногоФайла = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Текст = ТекстовыйДокументИзВременногоХранилищаФайла(АдресИзмененногоФайла, Кодировка);
		Текст.Показать(НСтр("ru = 'Текст удаленного файла'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнструкцияПроверкаНажатие(Элемент)
	
	АдресСсылки = "http://its.1c.ru/bmk/safebank";
	ПерейтиПоНавигационнойСсылке(АдресСсылки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьГруппуПроверки(ИмяГруппыПроверки)
	
	Для Каждого ГруппаПроверки Из ГруппыПроверки() Цикл
		
		Элементы[ГруппаПроверки].Видимость = ГруппаПроверки = ИмяГруппыПроверки;
		
	КонецЦикла;
	КлючСохраненияПоложенияОкна = ИмяГруппыПроверки + Строка(ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент());
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекущаяГруппаПроверки(Форма)
	
	Для Каждого ГруппаПроверки Из ГруппыПроверки() Цикл
		
		Если Форма.Элементы[ГруппаПроверки].Видимость Тогда
			Возврат ГруппаПроверки;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ГруппыПроверки()
	
	ГруппыПроверки = Новый Массив;
	ГруппыПроверки.Добавить("ГруппаПроверкаПоКнопке");
	ГруппыПроверки.Добавить("ГруппаПроверкаУспешна");
	ГруппыПроверки.Добавить("ГруппаФайлИзменен");
	ГруппыПроверки.Добавить("ГруппаФайлУдален");
	
	Возврат ГруппыПроверки;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПодключитьРасширениеРаботыСФайлами() Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьРасширениеРаботыСФайламиЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьРасширениеРаботыСФайламиЗавершение(ПодключеноРасширениеРаботыСФайлами, ДополнительныеПараметры) Экспорт
	
	РасширениеРаботыСФайламиПодключено = ПодключеноРасширениеРаботыСФайлами;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеФайлаЗавершение(Результат, АдресФайлаПомещенный, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат = Ложь ИЛИ АдресФайлаПомещенный = "" Тогда
		Возврат;
	КонецЕсли;
	
	Результат = СравнитьПолученныйФайл(АдресФайлаПомещенный, АдресИсходныхДанных, Кодировка);
	ПоказатьРезультатОднократно(Результат, Новый Структура);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СравнитьПолученныйФайл(АдресФайлаПомещенный, АдресИсходныхДанных, Кодировка)
	
	ТекстВыгрузкиФайлаСтрокой          = ТекстВыгрузкиСтрокой(АдресФайлаПомещенный, Кодировка);
	
	ТекстВыгрузкиИсходногоФайлаСтрокой = ТекстВыгрузкиСтрокой(АдресИсходныхДанных, Кодировка);
	
	Результат = ?(ТекстВыгрузкиФайлаСтрокой = ТекстВыгрузкиИсходногоФайлаСтрокой, "ПроверкаВыполненаУспешно", "ФайлИзменен");
	
	Если Результат = "ПроверкаВыполненаУспешно" Тогда
		УдалитьИзВременногоХранилища(АдресФайлаПомещенный);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекстВыгрузкиСтрокой(Знач АдресИсходныхДанных, Знач Кодировка)
	
	ДвоичныеДанныеИсходногоФайла = ПолучитьИзВременногоХранилища(АдресИсходныхДанных);
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ДвоичныеДанныеИсходногоФайла.Записать(ИмяВременногоФайла);
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяВременногоФайла, Кодировка);
	ТекстСтрокой = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	УдалитьФайлы(ИмяВременногоФайла);
	
	Возврат ТекстСтрокой;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьРезультатПроверки(РезультатПроверки)
	
	Элементы.Проверить.Видимость = Ложь;
	Если РезультатПроверки = "ПроверкаВыполненаУспешно" Тогда
		// Проверка выполнена успешно
		
		Элементы.Проверить.Видимость = ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
		
		УстановитьГруппуПроверки("ГруппаПроверкаУспешна");
		Комментарий = СтрШаблон(НСтр("ru = 'Файл выгрузки платежей ""%1"" не изменен.'"),
			ПутьКФайлу);
		
	ИначеЕсли РезультатПроверки = "ФайлИзменен" Тогда
		// Файл изменен
		
		Элементы.ГруппаФайл.Видимость = НЕ ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
		УстановитьГруппуПроверки("ГруппаФайлИзменен");
		Комментарий = СтрШаблон(НСтр("ru = 'Файл выгрузки платежей ""%1"" изменен другой программой.'"),
			ПутьКФайлу);
		
	ИначеЕсли РезультатПроверки = "ФайлУдален" Тогда
		// Файл удален
		
		УстановитьГруппуПроверки("ГруппаФайлУдален");
		Комментарий = СтрШаблон(НСтр("ru = 'Файл выгрузки платежей ""%1"" удален другой программой.'"),
			ПутьКФайлу);
		
	КонецЕсли;
	
	ЗаписатьВЖурналРегистрации(РезультатПроверки, Комментарий);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьФайлВыгрузки()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗапуститьПроверкуПовторно", ЭтотОбъект);
	ПроверитьФайлНаКлиенте(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьПроверкуПовторно(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "ПроверкаВыполненаУспешно" Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьФайлВыгрузки", 5, Истина);
	Иначе
		ПоказатьРезультатПроверки(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРезультатОднократно(Результат, ДополнительныеПараметры) Экспорт
	
	ПоказатьРезультатПроверки(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьФайлНаКлиенте(ОповещениеПослеПроверки)
	
	ДополнительныеПараметры = Новый Структура("ОповещениеПослеПроверки", ОповещениеПослеПроверки);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьФайлНаКлиентеСозданиеФайла", ЭтотОбъект, ДополнительныеПараметры);
	
	Файл = Новый Файл();
	Файл.НачатьИнициализацию(ОписаниеОповещения, ПутьКФайлу);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьФайлНаКлиентеСозданиеФайла(Файл, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьФайлНаКлиентеПроверкаСуществования", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПроверкуСуществования(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьФайлНаКлиентеПроверкаСуществования(Существует, ДополнительныеПараметры) Экспорт
	
	Если Существует Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьФайлНаКлиентеПослеЧтенияФайла", ЭтотОбъект, ДополнительныеПараметры);
		
		ПомещаемыеФайлы = Новый Массив;
		ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ПутьКФайлу));
		
		НачатьПомещениеФайлов(ОписаниеОповещения, ПомещаемыеФайлы, Ложь, УникальныйИдентификатор);
		
	Иначе
		
		ОписаниеОповещения = ДополнительныеПараметры.ОповещениеПослеПроверки;
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, "ФайлУдален");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьФайлНаКлиентеПослеЧтенияФайла(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы <> Неопределено И ПомещенныеФайлы.Количество() > 0 Тогда
		
		ОписаниеФайла        = ПомещенныеФайлы.Получить(0);
		АдресФайлаПомещенный = ОписаниеФайла.Хранение;
		
		Результат = СравнитьПолученныйФайл(АдресФайлаПомещенный, АдресИсходныхДанных, Кодировка);
		
		Если Результат = "ФайлИзменен"
			И НЕ ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
			
			АдресИзмененногоФайла = АдресФайлаПомещенный;
			
			ПараметрыПослеУдаления = Новый Структура();
			ПараметрыПослеУдаления.Вставить("Результат", Результат);
			ПараметрыПослеУдаления.Вставить("ОповещениеПослеУдаления", ДополнительныеПараметры.ОповещениеПослеПроверки);
			ОписаниеОповещения = Новый ОписаниеОповещения("ПослеУдаленияИзмененногоФайла", ЭтотОбъект, ПараметрыПослеУдаления);
			НачатьУдалениеФайлов(ОписаниеОповещения, ПутьКФайлу);
		
		Иначе
			ОписаниеОповещения = ДополнительныеПараметры.ОповещениеПослеПроверки;
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, Результат);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУдаленияИзмененногоФайла(ДополнительныеПараметры) Экспорт
	
	ПутьКФайлу = "";
	ЗагруженнаяВыпискаПроверена = "";
	
	ОписаниеОповещения = ДополнительныеПараметры.ОповещениеПослеУдаления;
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеУдаления, ДополнительныеПараметры.Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИУдалитьФайлПередЗакрытием()
	
	// Для веб-клиента проверка файла выполняется по кнопке.
	// Поэтому дополнительную проверку при закрытии не выполняем.
	Если НЕ ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьИУдалитьФайлПередЗакрытиемЗавершение", ЭтотОбъект);
		ПроверитьФайлНаКлиенте(ОписаниеОповещения);
	Иначе
		УдалитьФайлПередЗакрытием();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИУдалитьФайлПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "ПроверкаВыполненаУспешно" Тогда
		
		УдалитьФайлПередЗакрытием();
		
	Иначе
		
		ПоказатьРезультатОднократно(Результат, Новый Структура);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайлПередЗакрытием()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьФайлПередЗакрытиемЗавершение", ЭтотОбъект);
	НачатьУдалениеФайлов(ОписаниеОповещения, ПутьКФайлу);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайлПередЗакрытиемЗавершение(ДополнительныеПараметры) Экспорт
	
	ПутьКФайлу = "";
	Закрыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекстовыйДокументИзВременногоХранилищаФайла(АдресФайла, Кодировка)
	
	ИмяВременногоФайла  = ПолучитьИмяВременногоФайла("txt");
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресФайла);
	ДвоичныеДанныеФайла.Записать(ИмяВременногоФайла);
	
	Текст = Новый ТекстовыйДокумент();
	Текст.Прочитать(ИмяВременногоФайла, Кодировка);
	УдалитьФайлы(ИмяВременногоФайла); // Удалим временный файл, после его обработки.
	
	Возврат Текст;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписатьВЖурналРегистрации(РезультатПроверки, Комментарий)
	
	Если РезультатПроверки = "ПроверкаВыполненаУспешно" Тогда
		Уровень = УровеньЖурналаРегистрации.Информация;
	Иначе
		Уровень = УровеньЖурналаРегистрации.Ошибка;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации("Проверка выгрузки платежей", Уровень, Метаданные.Обработки.КлиентБанк, , Комментарий);
	
КонецПроцедуры

#КонецОбласти

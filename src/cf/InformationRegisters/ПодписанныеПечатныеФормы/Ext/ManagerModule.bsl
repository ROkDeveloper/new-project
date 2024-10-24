﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьПечатнуюФорму(ДанныеПечатнойФормы, ПечатнаяФорма, ДатаВыпуска) Экспорт
	
	Запись = РегистрыСведений.ПодписанныеПечатныеФормы.СоздатьМенеджерЗаписи();
	
	Запись.ПрисоединенныйФайл         = ДанныеПечатнойФормы.ФайлОбъекта;
	Запись.ИдентификаторПечатнойФормы = ДанныеПечатнойФормы.ИдентификаторПечатнойФормы;
	Запись.ДатаВыпуска                = ДатаВыпуска;
	Запись.Название                   = ДанныеПечатнойФормы.Название;
	Запись.Организация                = ДанныеПечатнойФормы.Организация;
	Запись.Сотрудник                  = ДанныеПечатнойФормы.Сотрудник;
	Запись.ФизическоеЛицо             = ДанныеПечатнойФормы.ФизическоеЛицо;
	Запись.Номер                      = ДанныеПечатнойФормы.Номер;
	Запись.Дата                       = ДанныеПечатнойФормы.Дата;
	Запись.Оригинал                   = Новый ХранилищеЗначения(ПечатнаяФорма, Новый СжатиеДанных(9));
	
	Запись.Записать();
	
КонецПроцедуры

Функция УдалитьПечатныеФормыОбъекта(СсылкаНаОбъект) Экспорт
	
	Результат = 0;
	
	ОбработатьВТранзакции = Не ТранзакцияАктивна();
	Если ОбработатьВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	
	Попытка
		
		ФайлыПоОбъектам = КадровыйЭДО.ФайлыПечатныхФормПоОбъектам(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СсылкаНаОбъект), , Истина, Истина);
		
		ФайлыПечатныхФорм = Новый Массив;
		Для Каждого ОписаниеФайловОбъекта Из ФайлыПоОбъектам Цикл
			
			Для Каждого ОписаниеФайловИдентификатора Из ОписаниеФайловОбъекта.Значение Цикл
				
				Для Каждого ФайлИдентификатора Из ОписаниеФайловИдентификатора.Значение Цикл
					
					ФайлыПечатныхФорм.Добавить(ФайлИдентификатора);
					
					Результат = Результат + 1;
					Запись = РегистрыСведений.ПодписанныеПечатныеФормы.СоздатьМенеджерЗаписи();
					Запись.ПрисоединенныйФайл = ФайлИдентификатора;
					Запись.ИдентификаторПечатнойФормы = ОписаниеФайловИдентификатора.Ключ;
					Запись.Прочитать();
					
					Если Запись.Выбран() Тогда
						
						Запись.Удалить();
						
						Блокировка = Новый БлокировкаДанных;
						ЭлементБлокировки = Блокировка.Добавить("Справочник."
							+ РаботаСФайламиСлужебный.ИмяСправочникаХраненияФайлов(СсылкаНаОбъект));
						ЭлементБлокировки.УстановитьЗначение("Ссылка", ФайлИдентификатора);
						Блокировка.Заблокировать();
						
						ОбъектФайла = ФайлИдентификатора.ПолучитьОбъект();
						ОбъектФайла.ДополнительныеСвойства.Вставить("УдалениеПечатныхФорм", Истина);
						ОбъектФайла.УстановитьПометкуУдаления(Истина);
						
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
		РегистрыСведений.ЗапланированныеДействияСФайламиДокументовКЭДО.УдалитьФайлыИзОбработки(ФайлыПечатныхФорм);
		
		Если ОбработатьВТранзакции Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;
		
	Исключение
		
		Если ОбработатьВТранзакции Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		
		Ошибка = ИнформацияОбОшибке();
		ВызватьИсключение ПодробноеПредставлениеОшибки(Ошибка);
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ДанныеФайлаПечатнойФормы(ФайлаПечатнойФормы) Экспорт
	
	Возврат ДанныеФайловПечатныхФорм(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
			ФайлаПечатнойФормы))[ФайлаПечатнойФормы];
	
КонецФункции

Функция ДанныеФайловПечатныхФормНаПодпись(КоллекцияФайлов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПрисоединенныеФайлы", КоллекцияФайлов);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПодписанныеФормы.ПрисоединенныйФайл КАК ФайлОбъекта,
		|	ПодписанныеФормы.ИдентификаторПечатнойФормы КАК ИдентификаторПечатнойФормы,
		|	ПодписанныеФормы.ПрисоединенныйФайл.ВладелецФайла КАК Владелец,
		|	ПодписанныеФормы.Оригинал КАК Оригинал,
		|	ПодписанныеФормы.Название КАК Название,
		|	ПодписанныеФормы.Организация КАК Организация,
		|	ПодписанныеФормы.Сотрудник КАК Сотрудник,
		|	ПодписанныеФормы.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПодписанныеФормы.Номер КАК Номер,
		|	ПодписанныеФормы.Дата КАК Дата
		|ИЗ
		|	РегистрСведений.ПодписанныеПечатныеФормы КАК ПодписанныеФормы
		|ГДЕ
		|	ПодписанныеФормы.ПрисоединенныйФайл В(&ПрисоединенныеФайлы)";
	
	УстановитьПривилегированныйРежим(Истина);
	ФайлыНаПодпись = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ФайлыНаПодпись;
	
КонецФункции

Функция ДанныеФайловПечатныхФорм(КоллекцияФайлов) Экспорт
	
	ДанныхФайлов = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПрисоединенныеФайлы", КоллекцияФайлов);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПодписанныеФормы.ПрисоединенныйФайл КАК ПрисоединенныйФайл,
		|	ПодписанныеФормы.ИдентификаторПечатнойФормы КАК ИдентификаторПечатнойФормы,
		|	ПодписанныеФормы.Оригинал КАК Оригинал,
		|	ПодписанныеФормы.ДатаВыпуска КАК ДатаВыпуска,
		|	ПодписанныеФормы.Название КАК Название,
		|	ПодписанныеФормы.Организация КАК Организация,
		|	ПодписанныеФормы.Сотрудник КАК Сотрудник,
		|	ПодписанныеФормы.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПодписанныеФормы.Номер КАК Номер,
		|	ПодписанныеФормы.Дата КАК Дата
		|ИЗ
		|	РегистрСведений.ПодписанныеПечатныеФормы КАК ПодписанныеФормы
		|ГДЕ
		|	ПодписанныеФормы.ПрисоединенныйФайл В(&ПрисоединенныеФайлы)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеФайла = ПоляДанныхФайла();
		ЗаполнитьЗначенияСвойств(ДанныеФайла, Выборка);
		ДанныхФайлов.Вставить(Выборка.ПрисоединенныйФайл, ДанныеФайла);
	КонецЦикла;
	
	Возврат ДанныхФайлов;
	
КонецФункции

Функция ОтобратьФайлыПечатныхФорм(ПрисоединенныеФайлы) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПрисоединенныеФайлы", ПрисоединенныеФайлы);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПодписанныеПечатныеФормы.ПрисоединенныйФайл КАК ПрисоединенныйФайл
		|ИЗ
		|	РегистрСведений.ПодписанныеПечатныеФормы КАК ПодписанныеПечатныеФормы
		|ГДЕ
		|	ПодписанныеПечатныеФормы.ПрисоединенныйФайл В(&ПрисоединенныеФайлы)";
	
	УстановитьПривилегированныйРежим(Истина);
	ФайлыПечатныхФорм = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ПрисоединенныйФайл");
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ФайлыПечатныхФорм;
	
КонецФункции

Процедура ЗарегистрироватьПечатнуюФорму(ОригиналВMXL, Владелец, ПрисоединенныйФайл, Организация, ФизическоеЛицо, ИдентификаторПечатнойФормы, Название) Экспорт
	
	Если ОригиналВMXL <> Неопределено Тогда
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Прочитать(ОригиналВMXL.ОткрытьПотокДляЧтения());
		ДанныеПечатнойФормы = КадровыйЭДО.ДанныеПечатнойФормы();
		ДанныеПечатнойФормы.Владелец                   = Владелец;
		ДанныеПечатнойФормы.ФайлОбъекта                = ПрисоединенныйФайл;
		ДанныеПечатнойФормы.Организация                = Организация;
		ДанныеПечатнойФормы.ФизическоеЛицо             = ФизическоеЛицо;
		ДанныеПечатнойФормы.ИдентификаторПечатнойФормы = ИдентификаторПечатнойФормы;
		ДанныеПечатнойФормы.Название                   = Название;
		ДанныеПечатнойФормы.ИмяФайла                   = Название;
		ДобавитьПечатнуюФорму(ДанныеПечатнойФормы, ТабличныйДокумент, ТекущаяДатаСеанса());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПоляДанныхФайла()
	
	Возврат Новый Структура(
		"ПрисоединенныйФайл,
		|ИдентификаторПечатнойФормы,
		|Оригинал,
		|ДатаВыпуска,
		|Название,
		|Организация,
		|Сотрудник,
		|ФизическоеЛицо,
		|Номер,
		|Дата");
	
КонецФункции

Процедура ЗаполнитьНомераДокументов(ПараметрыОбновления = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Если ПараметрыОбновления = Неопределено Тогда
		МассивОбновленных = Новый Массив;
	Иначе
		
		Если ПараметрыОбновления.Свойство("МассивОбновленных") Тогда
			МассивОбновленных = ПараметрыОбновления.МассивОбновленных;
		Иначе
			МассивОбновленных = Новый Массив;
			ПараметрыОбновления.Вставить("МассивОбновленных", МассивОбновленных);
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("МассивОбновленных", МассивОбновленных);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	ПодписанныеПечатныеФормы.ПрисоединенныйФайл КАК ПрисоединенныйФайл
		|ИЗ
		|	РегистрСведений.ПодписанныеПечатныеФормы КАК ПодписанныеПечатныеФормы
		|ГДЕ
		|	НЕ ПодписанныеПечатныеФормы.ПрисоединенныйФайл В (&МассивОбновленных)
		|	И ПодписанныеПечатныеФормы.Номер = """"";
	
	Если ПараметрыОбновления = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000","");
	КонецЕсли;
	
	ПрисоединенныеФайлы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ПрисоединенныйФайл");
	Если ПрисоединенныеФайлы.Количество() = 0 Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	ВладельцыФайлов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ПрисоединенныеФайлы, "ВладелецФайла");
	ВладельцыСНомером = Новый Массив;
	Для Каждого ДанныеВладельцаФайла Из ВладельцыФайлов Цикл
		Если ОбщегоНазначения.ЭтоДокумент(
				ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(
					ДанныеВладельцаФайла.Значение.Метаданные().ПолноеИмя())) Тогда
			ВладельцыСНомером.Добавить(ДанныеВладельцаФайла.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если ВладельцыСНомером.Количество() = 0 Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
	РеквизитыВладельцев = Новый Соответствие;
	
	ТипыВладельцев = ОбщегоНазначенияБЗК.ОбъектыПоТипам(ВладельцыСНомером);
	ТекстыЗапросов = Новый Массив;
	Для Каждого ТипВладельцев Из ТипыВладельцев Цикл
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипВладельцев.Ключ);
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	ТаблицаОбъекта.Ссылка КАК Ссылка,
			|	ТаблицаОбъекта.Номер КАК Номер,
			|	ТаблицаОбъекта.НомерПриказа КАК НомерПриказа,
			|	НЕОПРЕДЕЛЕНО КАК НомерПервичногоДокумента
			|ИЗ
			|	Документ.ПриемНаРаботу КАК ТаблицаОбъекта
			|ГДЕ
			|	ТаблицаОбъекта.Ссылка В(&Ссылка)";
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("НомерПервичногоДокумента", МетаданныеОбъекта) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "НЕОПРЕДЕЛЕНО КАК НомерПервичногоДокумента", "ТаблицаОбъекта.НомерПервичногоДокумента КАК НомерПервичногоДокумента");
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ТаблицаОбъекта.НомерПриказа", "НЕОПРЕДЕЛЕНО");
		ИначеЕсли Не ОбщегоНазначения.ЕстьРеквизитОбъекта("НомерПриказа", МетаданныеОбъекта) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ТаблицаОбъекта.НомерПриказа", "НЕОПРЕДЕЛЕНО");
		КонецЕсли;
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Документ.ПриемНаРаботу", МетаданныеОбъекта.ПолноеИмя());
		
		ИмяПараметра = "ПараметрЗапроса" + Формат(Запрос.Параметры.Количество(), "ЧН=; ЧГ=");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "(&Ссылка)", "(&" + ИмяПараметра + ")");
		ТекстыЗапросов.Добавить(ТекстЗапроса);
		
		Запрос.УстановитьПараметр(ИмяПараметра, ТипВладельцев.Значение);
		
	КонецЦикла;
	
	Запрос.Текст = СтрСоединить(ТекстыЗапросов, " ОБЪЕДИНИТЬ ВСЕ ");
	ВыборкаРеквизитов = Запрос.Выполнить().Выбрать();
	Пока ВыборкаРеквизитов.Следующий() Цикл
		РеквизитыВладельцев.Вставить(ВыборкаРеквизитов.Ссылка,
			Новый Структура("Номер,НомерПриказа,НомерПервичногоДокумента",
				ВыборкаРеквизитов.Номер,
				ВыборкаРеквизитов.НомерПриказа,
				ВыборкаРеквизитов.НомерПервичногоДокумента));
	КонецЦикла;
	
	Для Каждого ПрисоединенныйФайл Из ПрисоединенныеФайлы Цикл
		
		МассивОбновленных.Добавить(ПрисоединенныйФайл);
		ВладелецФайла = ВладельцыФайлов.Получить(ПрисоединенныйФайл);
		Если ВладелецФайла = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НомерНаПечать = "";
		РеквизитыВладельца = РеквизитыВладельцев.Получить(ВладелецФайла);
		Если РеквизитыВладельца <> Неопределено Тогда
			Если ЗначениеЗаполнено(РеквизитыВладельца.НомерПриказа) Тогда
				НомерНаПечать = ЗарплатаКадрыОтчеты.НомерНаПечать(РеквизитыВладельца.Номер, РеквизитыВладельца.НомерНаПечать);
			ИначеЕсли ЗначениеЗаполнено(РеквизитыВладельца.НомерПервичногоДокумента) Тогда
				НомерНаПечать = ЗарплатаКадрыОтчеты.НомерНаПечать(РеквизитыВладельца.Номер, РеквизитыВладельца.НомерПервичногоДокумента);
			Иначе
				НомерНаПечать = ЗарплатаКадрыОтчеты.НомерНаПечать(РеквизитыВладельца.Номер);
			КонецЕсли;
		КонецЕсли;
		
		Если ПустаяСтрока(НомерНаПечать) Тогда
			Продолжить;;
		КонецЕсли;
		
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления,
			"РегистрСведений.ПодписанныеПечатныеФормы", "ПрисоединенныйФайл", ПрисоединенныйФайл) Тогда
			
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.ПодписанныеПечатныеФормы.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПрисоединенныйФайл.Установить(ПрисоединенныйФайл);
		НаборЗаписей.Прочитать();
		
		Для Каждого Запись Из НаборЗаписей Цикл
			Если ПустаяСтрока(Запись.Номер) Тогда
				Запись.Номер = НомерНаПечать;
			КонецЕсли;
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
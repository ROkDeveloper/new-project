﻿
#Область ПрограммныйИнтерфейс

// Возвращает ставку налога по патентной системе налогообложения
//
// Возвращаемое значение:
//  Число - ставка налога в процентах
//
Функция НалоговаяСтавкаПоУмолчанию() Экспорт
	
	Возврат 6;
	
КонецФункции

// Возвращает признак необходимости показа предупреждения о заполнении реквизитов патента.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - Организация, которой принадлежит патент.
//  Патент - СправочникСсылка.Патенты - Патент.
//  ТолькоУСНПатент - Булево - Признак применения организацией УСН на основе патента без совмещения с другими режимами налогообложения.
//  НесколькоПатентов - Булево - Признак наличия нескольких действующих патентов для указанной организации.
//
// Возвращаемое значение:
//  Булево - Признак необходимости показа предупреждения.
//
Функция ПоказатьПредупреждениеНеобходимоЗаполнитьПатент(Организация, Патент, ТолькоУСНПатент, НесколькоПатентов) Экспорт
	
	Если ЗначениеЗаполнено(Организация)
		И ТолькоУСНПатент
		И НЕ ЗначениеЗаполнено(Патент)
		И НЕ НесколькоПатентов Тогда
		
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает границы переходного периода, на который можно получить патент при переходе с ЕНВД
// не дожидаясь регионального закона
//
// Возвращаемое значение:
//  Структура:
//     * Начало - Дата
//     * Конец  - Дата
//
Функция ПереходныйПериод() Экспорт
	
	Период = Новый Структура;
	Период.Вставить("Начало", Дата(2021, 1, 1));
	Период.Вставить("Конец",  Дата(2021, 3, 31));
	
	Возврат Период;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Рассчитывает потенциально возможный доход по патенту
//
// Параметры:
//  ПотенциальноВозможныйГодовойДоход - Число - потенциально возможный к получению годовой доход
//  ДатаНачала - Дата - дата начала действия патента
//  ДатаОкончания - Дата - дата окончания действия патента
//
Функция РассчитатьПотенциальноВозможныйДоход(ПотенциальноВозможныйГодовойДоход, ДатаНачала, ДатаОкончания) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаНачала) Или Не ЗначениеЗаполнено(ДатаОкончания)
		Или Год(ДатаНачала) <> Год(ДатаОкончания) Тогда
		Возврат ПотенциальноВозможныйГодовойДоход;
	КонецЕсли;
	
	Если РассчитыватьСтоимостьПатентаПоКалендарнымДням(ДатаНачала, ДатаОкончания) Тогда
		
		КоличествоДнейСрока = КоличествоДней(ДатаНачала, ДатаОкончания);
		КоличествоДнейВГоду = КоличествоДней(НачалоГода(ДатаОкончания), КонецГода(ДатаОкончания));
		
		ПотенциальноВозможныйДоход = ПотенциальноВозможныйГодовойДоход * КоличествоДнейСрока / КоличествоДнейВГоду;
		
	Иначе
		
		ДействуетСНачалаМесяца = НачалоДня(ДатаНачала) = НачалоМесяца(ДатаНачала);
		КоличествоМесяцевСрока = Месяц(ДатаОкончания) - Месяц(ДатаНачала) + ?(ДействуетСНачалаМесяца, 1, 0);
		
		ПотенциальноВозможныйДоход = ПотенциальноВозможныйГодовойДоход * КоличествоМесяцевСрока / 12;
		
	КонецЕсли;
	
	Возврат Окр(ПотенциальноВозможныйДоход, 2, РежимОкругления.Окр15как20);
	
КонецФункции

// Рассчитывает сумму налога по патенту.
//
// Параметры:
//  ПотенциальныйГодовойДоход - Число(15,2) - сумма потенциально возможного годового дохода, указанная в патенте.
//  НачалоПатента             - Дата - дата начала действия патента.
//  ОкончаниеПатента          - Дата - дата окончания действия патента.
//  СтавкаНалога              - Число(2,0) - ставка налога. Если ставка не передана, то налог будет рассчитан по ставке 6%
//
// Возвращаемое значение:
//   Число - сумма налога.
//
Функция НалогПоПатенту(ПотенциальныйГодовойДоход, НачалоПатента, ОкончаниеПатента, СтавкаНалога = Неопределено) Экспорт
	
	Если СтавкаНалога = Неопределено Тогда
		СтавкаНалога = НалоговаяСтавкаПоУмолчанию();
	КонецЕсли;
	
	НалоговаяБаза = РассчитатьПотенциальноВозможныйДоход(
		ПотенциальныйГодовойДоход,
		НачалоПатента,
		ОкончаниеПатента);
	
	Возврат Окр(НалоговаяБаза * СтавкаНалога / 100, 0);
	
КонецФункции

// Рассчитывает суммы и даты платежей по патенту.
//
// Параметры:
//  СуммаНалогаКУплате - Число - общая сумма налога по патенту.
//  НачалоПатента      - Дата - дата начала действия патента.
//  ОкончаниеПатента   - Дата - дата окончания действия патента.
//
// Возвращаемое значение:
//   Структура - сведения о платежах, состав см. НовыйРасчетПлатежейПоПатенту().
//
Функция РасчетПлатежейПоПатенту(СуммаНалогаКУплате, НачалоПатента, ОкончаниеПатента) Экспорт
	
	Расчет = НовыйРасчетПлатежейПоПатенту();
	
	Если СуммаНалогаКУплате <= 0 Тогда
		Возврат Расчет;
	КонецЕсли;
	
	Если УплачиваетсяОдинПлатеж(НачалоПатента, ОкончаниеПатента) Тогда
		// Налог по патентам сроком действия до 6 месяцев уплачивается в полной сумме не позднее окончания патента.
		Расчет.СуммаПервогоПлатежа = СуммаНалогаКУплате;
		Расчет.ДатаПервогоПлатежа = УчетПСНВызовСервера.УточнитьСрокОплатыПатента(ОкончаниеПатента);
		Расчет.СуммаВторогоПлатежа = 0;
		Расчет.ДатаВторогоПлатежа = '00010101';
	Иначе
		// Налог по патентам сроком действия более 6 месяцев уплачивается двумя платежами:
		//  - первый платеж 1/3 суммы не позднее 90 календарных дней с начала патента;
		//  - второй платеж 2/3 суммы не позднее срока окончания патента;
		Расчет.СуммаПервогоПлатежа = Окр(СуммаНалогаКУплате / 3);
		Расчет.ДатаПервогоПлатежа = УчетПСНВызовСервера.УточнитьСрокОплатыПатента(НачалоПатента + 90 * 86400);
		Расчет.СуммаВторогоПлатежа = СуммаНалогаКУплате - Расчет.СуммаПервогоПлатежа;
		Расчет.ДатаВторогоПлатежа = УчетПСНВызовСервера.УточнитьСрокОплатыПатента(ОкончаниеПатента);
	КонецЕсли;
	
	Возврат Расчет;
	
КонецФункции

// Определяет порядок уплаты налога по патенту в зависимости от его срока - одним платежом или двумя.
//
// Параметры:
//  НачалоПатента      - Дата - дата начала действия патента.
//  ОкончаниеПатента   - Дата - дата окончания действия патента.
//
// Возвращаемое значение:
//   Булево - если Истина, уплачивается единственный платеж на полную сумму налога,
//            если Ложь, два платежа в размере 1/3 и 2/3 суммы налога.
//
Функция УплачиваетсяОдинПлатеж(НачалоПатента, ОкончаниеПатента) Экспорт
	
	ПериодВторогоПлатежа = НачалоДня(ДобавитьМесяц(НачалоПатента, 6) - 1);
	
	Возврат ПериодВторогоПлатежа > НачалоДня(КонецГода(НачалоПатента))
		Или ПериодВторогоПлатежа > ОкончаниеПатента;
	
КонецФункции

// Рассчитывает сумму освобождения от налога по патенту на основании данных патента.
//
// Параметры:
//  ПотенциальныйГодовойДоход - Число(15,2) - сумма потенциально возможного годового дохода, указанная в патенте.
//  НачалоПатента             - Дата - дата начала действия патента.
//  ОкончаниеПатента          - Дата - дата окончания действия патента.
//
// Возвращаемое значение:
//   Число - сумма налога за период, освобождаемый от уплаты налога..
//
Функция СуммаОсвобожденияОтНалога(ПотенциальныйГодовойДоход, НачалоПатента, ОкончаниеПатента) Экспорт
	
	ПериодОсвобождения = ПериодПатентаОсвобожденныйОтНалога(НачалоПатента, ОкончаниеПатента);
	
	Если ПериодОсвобождения = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат НалогПоПатенту(ПотенциальныйГодовойДоход, ПериодОсвобождения.НачалоПериода, ПериодОсвобождения.КонецПериода);
	
КонецФункции

// Рассчитывает сумму освобождения от налога на основании суммы налога и данных патента.
// Используется вместо РасчетОсвобожденияОтНалога() в случаях, когда сумма налога по патенту
// не может быть рассчитана от заданного годового потенциального дохода.
// Например, когда расчетная сумма налога в форме патента отредактирована пользователем вручную.
//
// Параметры:
//  СуммаНалога      - Число(8,0) - сумма налога по патенту.
//  НачалоПатента    - Дата - дата начала действия патента.
//  ОкончаниеПатента - Дата - дата окончания действия патента.
//  Организация      - СправочникСсылка.Организации - организация, которой выдан патент.
//
// Возвращаемое значение:
//   Число(8,0) - сумма налога за период, освобождаемый от уплаты налога.
//
Функция СуммаОсвобожденияОтНалогаПоСуммеНалога(СуммаНалога, НачалоПатента, ОкончаниеПатента) Экспорт
	
	ПериодОсвобождения = ПериодПатентаОсвобожденныйОтНалога(НачалоПатента, ОкончаниеПатента);
	
	Если ПериодОсвобождения = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	ДнейСрокаПатента        = КоличествоДней(НачалоПатента, ОкончаниеПатента);
	ДнейПериодаОсвобождения = КоличествоДней(ПериодОсвобождения.НачалоПериода, ПериодОсвобождения.КонецПериода);
	
	Возврат Окр(СуммаНалога * ДнейПериодаОсвобождения / ДнейСрокаПатента, 0);
	
КонецФункции

// Определяет, захватывает ли срок действия патента период, за который налог по патенту может не уплачиваться
// в рамках антикризисных мер поддержки предпринимателей из наиболее пострадавших от коронавируса сфер деятельности.
//
// Параметры:
//  НачалоПатента - Дата - дата начала действия патента.
//  ОкончаниеПатента - Дата - дата окончания действия патента.
//
// Возвращаемое значение:
//  Булево - если Истина, в течение срока патента могут применяться антикризисные меры.
//
Функция ВозможноОсвобождениеОтНалога(НачалоПатента, ОкончаниеПатента) Экспорт
	
	ПериодОсвобождения = ПериодПатентаОсвобожденныйОтНалога(НачалоПатента, ОкончаниеПатента);
	
	Возврат ПериодОсвобождения <> Неопределено;
	
КонецФункции

// Определяет, что организация в указанный период применяет освобождение от налога по патенту,
// установленное пунктом 4 статьи 2 Федерального закона № 172-ФЗ от 08.06.2020
//
// Параметры:
//  Организация - СправочникСсылка.Организации
//  НачалоПатента - Дата - начало срока действия патента
//  ОкончаниеПатента - Дата - конец срока действия патента
//
// Возвращаемое значение:
//  Булево
//
Функция ПрименяетсяОсвобождениеОтНалога(Организация, НачалоПериода, КонецПериода) Экспорт
	
	Возврат ВозможноОсвобождениеОтНалога(НачалоПериода, КонецПериода)
		И УчетПСНВызовСервера.ДеятельностьОтнесенаКПострадавшимОтКоронавируса(Организация);
	
КонецФункции

// Формирует подсказку для суммы освобождения от налога в связи с антикризисными мерами
// для пострадавших от коронавирусной инфекции.
//
// Параметры:
//  ПрименяетсяОсвобождение           - Булево - если Истина, применяется освобождение от налога.
//  СуммаОсвобождения                 - Число(8,0) - сумма освобождения от налога.
//  ПотенциальноВозможныйГодовойДоход - Число(15,2) - потенциально возможный к получению годовой доход.
//  НачалоПатента                     - Дата - начало срока действия патента.
//  КонецПатента                      - Дата - окончание срока действия патента.
//
// Возвращаемое значение:
//   ФорматированнаяСтрока - подсказка.
//
Функция ТекстПодсказкиОсвобождениеОтНалога(ПрименяетсяОсвобождение, СуммаОсвобождения,
	ПотенциальноВозможныйГодовойДоход, НачалоПатента, ОкончаниеПатента) Экспорт
	
	Если Не ПрименяетсяОсвобождение Тогда
		Возврат "";
	КонецЕсли;
	
	СодержаниеПодсказки = Новый Массив;
	
	СодержаниеПодсказки.Добавить(
		НСтр("ru = 'Рассчитывается по формуле:
					|(Потенциальный годовой доход * Дней во 2 квартале / Дней в году) * 6%'"));
	
	// Если расчетное значение освобождения не корректировалось пользователем, покажем расчет суммы.
	
	РасчетнаяСуммаОсвобождения = СуммаОсвобожденияОтНалога(ПотенциальноВозможныйГодовойДоход, НачалоПатента, ОкончаниеПатента);
	
	Если СуммаОсвобождения = РасчетнаяСуммаОсвобождения Тогда
		
		СодержаниеПодсказки.Добавить(""); // Строка-отступ
		
		ОсвобожденныйПериодПатента = ПериодПатентаОсвобожденныйОтНалога(НачалоПатента, ОкончаниеПатента);
		
		ДнейСрокаОсвобождения = КоличествоДней(ОсвобожденныйПериодПатента.НачалоПериода, ОсвобожденныйПериодПатента.КонецПериода);
		ДнейВГоду             = КоличествоДней(НачалоГода(НачалоПатента), КонецГода(ОкончаниеПатента));
		
		СодержаниеПодсказки.Добавить(СтрШаблон(НСтр("ru = '(%1 * %2 / %3) * 6%% = %4'"),
			Формат(ПотенциальноВозможныйГодовойДоход, "ЧЦ=15; ЧДЦ=2; ЧН=0,00"),
			Формат(ДнейСрокаОсвобождения, "ЧДЦ=0; ЧН=0"),
			Формат(ДнейВГоду, "ЧДЦ=0; ЧН=0"),
			Формат(СуммаОсвобождения, "ЧЦ=8; ЧДЦ=0; ЧН=0")));
		
	КонецЕсли;
	
	Возврат СтрСоединить(СодержаниеПодсказки, Символы.ПС);
	
КонецФункции

// Возвращает количество календарных дней в периоде, включая граничные дни.
//
// Параметры:
//  НачалоПериода - Дата - начало периода.
//  КонецПериода  - Дата - конец периода.
//
// Возвращаемое значение:
//   Число - количество дней в периоде.
//
Функция КоличествоДней(НачалоПериода, КонецПериода) Экспорт
	
	ОдинДень = 24 * 60 * 60; // Секунд в сутках
	
	Возврат (НачалоДня(КонецПериода) - НачалоДня(НачалоПериода)) / ОдинДень + 1;
	
КонецФункции

Функция ОтражениеДоходовСоздатьПатентЗначение() Экспорт
	
	Возврат "НовыйПатент";
	
КонецФункции

Функция ОтражениеДоходовСоздатьПатентПредставление() Экспорт
	
	Возврат НСтр("ru = 'Создать патент ...'");
	
КонецФункции

// Возвращает виды деятельности, которые можно применять при переходе с ЕНВД не дожидаясь регионального закона
//
// Возвращаемое значение:
//   Соответствие
//
Функция КодыВидовДеятельностиПереходногоПериода() Экспорт
	
	КодыФедеральныхВидовДеятельности = Новый Соответствие;
	КодыФедеральныхВидовДеятельности.Вставить("94",
		"Деятельность стоянок для транспортных средств");
	КодыФедеральныхВидовДеятельности.Вставить("95",
		"Розничная торговля, осуществляемая через объекты стационарной торговой сети с площадью торгового зала свыше 50 квадратных метров, но не более 150 квадратных метров по каждому объекту организации торговли");
	КодыФедеральныхВидовДеятельности.Вставить("96",
		"Оказание услуг общественного питания, осуществляемых через объекты организации общественного питания с площадью зала обслуживания посетителей свыше 50 квадратных метров, но не более 150 квадратных метров по каждому объекту организации общественного питания");
	КодыФедеральныхВидовДеятельности.Вставить("97",
		"Ремонт, техническое обслуживание автотранспортных и мототранспортных средств, мотоциклов, машин и оборудования, мойки транспортных средств, полирования и предоставления аналогичных услуг");
	
	Возврат КодыФедеральныхВидовДеятельности;
	
КонецФункции

// Возвращает коды ОКВЭД, соответствующие видам деятельности, которые можно применять при переходе с ЕНВД
// не дожидаясь регионального закона
//
// Возвращаемое значение:
//   Соответствие
//
Функция КодыОКВЭДПереходногоПериода() Экспорт
	
	КодыОКВЭД = Новый Соответствие;
	КодыОКВЭД.Вставить("94", СтрРазделить("52.21.24", ",")); // Стоянки
	КодыОКВЭД.Вставить("95", СтрРазделить("47.1,47.2,47.3,47.4,47.5,47.6,47.7", ",")); // Магазины
	КодыОКВЭД.Вставить("97", СтрРазделить("56.10,56.21,56.29,56.30", ",")); // Рестораны
	КодыОКВЭД.Вставить("98", СтрРазделить("45.20", ",")); // Автосервисы
	
	Возврат КодыОКВЭД;
	
КонецФункции

// Возвращает дату вступления в силу федерального закона №373-ФЗ, согласно которому налог по патенту можно уменьшать
// на сумму оплаченных страховых взносов и больничных пособий
//
// Возвращаемое значение:
//  Дата
//
Функция ДатаНачалаУменьшенияПСННаСтраховыеВзносы() Экспорт
	
	Возврат Дата(2021, 1, 1);
	
КонецФункции

// Возвращает дату начала действия формы книги учета доходов по патенту
// по приказу ФНС от 07.11.2023 г. № ЕА-7-3/816@
//
// Возвращаемое значение:
//   Дата - 1 янаваря 2024 года
//
Функция ДатаНачалаДействияФормыКнигиДоходовПоПриказу_ЕА_7_3_816() Экспорт
	
	Возврат Дата(2024, 1, 1);
	
КонецФункции

// Возвращает код региона с учетом объединения
//
// Параметры:
//   КодРегиона - Строка - Код региона регистрации патента
//
// Возвращаемое значение:
//   Строка
//
Функция КодРегионаСУчетомОбъединенияРегионов(КодРегиона) Экспорт
	
	// Для Ненецкого АО классификатор видов деятельности ведется с учетом кода региона по прежнему формату,
	// но подача заявления осуществляется в налоговую объединенного региона.
	
	Если КодРегиона = "83" Тогда
		Возврат "29";
	КонецЕсли;
	
	Возврат КодРегиона;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РасчетСтоимостиПатента

Функция РассчитыватьСтоимостьПатентаПоКалендарнымДням(ДатаНачала, ДатаОкончания)
	
	// П. 62 ст. 2 Федерального закона от 29.09.2019 N 325-ФЗ изменил расчет налога по патенту (п. 1 ст. 346.51 НК РФ).
	// Ранее налог рассчитывался пропорционально количеству месяцев срока действия,
	// после вступления в силу новой редакции НК налог рассчитывается по календарным дням срока действия патента.
	// Изменения вступили в силу с 29 октября 2019 года.
	ДатаНачалаРасчетаПоКалендарнымДням = '20191029';
	
	Если ДатаНачала >= ДатаНачалаРасчетаПоКалендарнымДням Тогда
		
		Возврат Истина;
		
	ИначеЕсли ПатентПрекращенДосрочно(ДатаНачала, ДатаОкончания) Тогда
		
		// В случае прекращения предпринимательской деятельности до истечения срока патента налог пересчитывается
		// исходя из фактического периода времени осуществления предпринимательской деятельности в календарных днях.
		Возврат Истина;
		
	Иначе
		
		// Патент выдан на срок, кратный месяцу, и рассчитывается по количеству месяцев срока.
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

Функция ПатентПрекращенДосрочно(ДатаНачала, ДатаОкончания)
	
	ОдинДень = 86400; // Секунд в сутках (24*60*60)
	
	ДействуетСНачалаМесяца = НачалоДня(ДатаНачала) = НачалоМесяца(ДатаНачала);
	КоличествоМесяцевСрока = Месяц(ДатаОкончания) - Месяц(ДатаНачала) + ?(ДействуетСНачалаМесяца, 1, 0);
	
	РасчетнаяДатаОкончания = ДобавитьМесяц(ДатаНачала, КоличествоМесяцевСрока) - ОдинДень;
	
	Возврат НачалоДня(ДатаОкончания) <> НачалоДня(РасчетнаяДатаОкончания);
	
КонецФункции

// Возвращает фактический период освобождения от налога в пределах срока патента.
//
// Параметры:
//  НачалоПатента - Дата - начало срока действия патента.
//  КонецПатента  - Дата - окончание срока действия патента.
//
// Возвращаемое значение:
//   Структура - границы периода, освобожденного от налога. Свойства:
//    * НачалоПериода - Дата - начало периода, освобожденного от налога.
//    * КонецПериода - Дата - начало периода, освобожденного от налога.
//
Функция ПериодПатентаОсвобожденныйОтНалога(НачалоПатента, ОкончаниеПатента)
	
	Если НачалоДня(ОкончаниеПатента) < НачалоДня(НачалоПатента) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПериодОсвобождения = ПериодОсвобожденияОтНалогаПострадавшимОтКоронавируса();
	
	Если НачалоПатента > ПериодОсвобождения.КонецПериода Или ОкончаниеПатента < ПериодОсвобождения.НачалоПериода Тогда
		// Срок действия патента не выпадает на период, в котором возможно освобождение от налога.
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура("НачалоПериода, КонецПериода", '00010101', '00010101');
	
	Результат.НачалоПериода = Макс(НачалоПатента, ПериодОсвобождения.НачалоПериода);
	Результат.КонецПериода  = Мин(ОкончаниеПатента, ПериодОсвобождения.КонецПериода);
	
	Возврат Результат;
	
КонецФункции

Функция ПериодОсвобожденияОтНалогаПострадавшимОтКоронавируса()
	
	// Федеральный закон № 172-ФЗ от 08.06.2020
	
	Результат = Новый Структура;
	
	// От налога освобождаются дни, относящиеся ко 2 кварталу 2020 года.
	
	Результат.Вставить("НачалоПериода", НачалоКвартала(Дата(2020, 4, 1)));
	Результат.Вставить("КонецПериода",  КонецКвартала(Дата(2020, 4, 1)));
	
	Возврат Результат;
	
КонецФункции

Функция НовыйРасчетПлатежейПоПатенту()
	
	РасчетПлатежей = Новый Структура;
	
	РасчетПлатежей.Вставить("СуммаПервогоПлатежа", 0);
	РасчетПлатежей.Вставить("ДатаПервогоПлатежа", '00010101');
	РасчетПлатежей.Вставить("СуммаВторогоПлатежа", 0);
	РасчетПлатежей.Вставить("ДатаВторогоПлатежа", '00010101');
	
	Возврат РасчетПлатежей;
	
КонецФункции

#КонецОбласти

#Область РаботаСФормами

// Проверяет настройку формы для помещения элементов, управляющих выбором патента.
// Если состав и свойства реквизитов формы не удовлетворяют требованиям - вызывается исключение.
//
// Параметры:
//  Форма   - ФормаКлиентскогоПриложения - проверяемая форма.
//
Процедура ПроверитьВозможностьВыбораПатента(Форма) Экспорт
	
	ТекстИсключения = "";
	
	Если Не ФормаПоддерживаетВыборПатента(Форма, ТекстИсключения) Тогда
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет настройку формы для помещения элементов, управляющих выбором патента.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - проверяемая форма.
//  СообщениеОбОшибке  - Строка - при несоответствии требованиям будет заполнен информацией об ошибке.
//
// Возвращаемое значение:
//   Булево   - Истина, если состав и свойства реквизитов формы соответствуют требованиям.
//
Функция ФормаПоддерживаетВыборПатента(Форма, СообщениеОбОшибке = "") Экспорт
	
	ИмяРеквизитаСпискаПатентов = ИмяРеквизитаСпискаПатентов();
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, ИмяРеквизитаСпискаПатентов) Тогда
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В форме ""%1"" отсутствует реквизит для списка доступных патентов.'"),
			Форма.ИмяФормы);
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Форма[ИмяРеквизитаСпискаПатентов]) <> Тип("СписокЗначений") Тогда
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В форме ""%1"" назначен неверный тип реквизиту - список доступных патентов.'"),
			Форма.ИмяФормы);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Возвращает значение выбранного патента по его представлению.
//
// Параметры:
//  ПатентПредставление  - Строка - представление патента
//  СписокПатентов  - СписокЗначений - список доступных патентов,
//                    см. УчетПСН.СписокДоступныхПатентов()
//
// Возвращаемое значение:
//   СправочникСсылка.Патенты, Строка  - значение выбранного патента
//                                       в соответствии со списком патентов.
//
Функция ВыбранныйПатентЗначение(ПатентПредставление, СписокПатентов) Экспорт
	
	Патент = Неопределено;
	
	Для Каждого ЗначениеПатента Из СписокПатентов Цикл
		Если СокрЛП(ЗначениеПатента.Представление) = СокрЛП(ПатентПредставление) Тогда
			Патент = ЗначениеПатента.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Патент;
	
КонецФункции

// Возвращает представление патента по его значению
//
// Параметры:
//  Патент  - СправочникСсылка.Патент - выбранный патент
//  СписокПатентов  - СписокЗначений - список доступных патентов,
//                    см. УчетПСН.СписокДоступныхПатентов()
//
// Возвращаемое значение:
//   Строка   - представление выбранного патента в соответствии со списком патентов
//
Функция ВыбранныйПатентПредставление(Патент, СписокПатентов) Экспорт
	
	ЗначениеПатент = СписокПатентов.НайтиПоЗначению(Патент);
	
	Если ЗначениеПатент <> Неопределено Тогда
		Возврат ЗначениеПатент.Представление;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Возвращает список доступных патентов, хранящийся в реквизитах формы.
// Данные списка предварительно должны быть заполнены с помощью УчетПСН.НастроитьВыборПатента.
// Заполнение списка здесь не проверяется.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма,
//          должна удовлетворять требованиям проверки ПроверитьВозможностьВыбораПатента()
//
// Возвращаемое значение:
//   СписокЗначений   - список доступных патентов.
//
Функция СписокПатентов(Форма) Экспорт
	
	Возврат Форма[ИмяРеквизитаСпискаПатентов()];
	
КонецФункции

// Возвращает имя обязательного реквизита форм, предназначенного для хранения доступных патентов
//
// Возвращаемое значение:
//   Строка   - имя обязательного реквизита форм
//
Функция ИмяРеквизитаСпискаПатентов()
	
	Возврат "СписокПатентов";
	
КонецФункции

// Заполняет список выбора поля, предназначенного для указания патента.
// Список заполняется представлениями переданных доступных патентов.
//
// Параметры:
//  СписокВыбора  - СписокЗначений - список выбора поля.
//  СписокПатентов  - СписокЗначений - список доступных патентов.
//
Процедура ОбновитьСписокВыбораПатента(СписокВыбора, СписокПатентов) Экспорт
	
	СписокВыбора.Очистить();
	
	// Строковые представления патентов используются в списке выбора для того,
	// чтобы после выбора и до окончания редактирования строки текст в поле не очищался.
	Для Каждого ЗначениеПатент Из СписокПатентов Цикл
		СписокВыбора.Добавить(ЗначениеПатент.Представление);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

Функция НавигационнаяСсылкаНеобходимоЗаполнитьПатент() Экспорт
	
	Возврат "НеобходимоЗаполнитьПатент";
	
КонецФункции

Функция СсылкаНаСтатьюУменьшениеНалога() Экспорт
	
	Возврат "http://buh.ru/articles/documents/63785/";
	
КонецФункции

// Возвращает шаблон строки ссылки на закон субъекта РФ,
// раздел "Особенности регионального законодательства"
//
// Возвращаемое значение:
//  Строка
//
Функция ШаблонСсылкиНаЗаконРегиона() Экспорт
	
	Возврат "https://www.nalog.ru/rn%1/taxation/taxes/patent/#title22";
	
КонецФункции

// Возвращает шаблон строки ссылки на Классификатор видов предпринимательской деятельности
//
// Возвращаемое значение:
//  Строка
//
Функция ШаблонСсылкиНаКлассификаторВидовДеятельности() Экспорт
	
	Возврат "https://www.nalog.ru/rn%1/taxation/taxes/patent/#title23";
	
КонецФункции

#КонецОбласти

﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ПростойИнтерфейсФинансы");
	
	ОткрытьФорму(
		"Обработка.ПанелиПростойИнтерфейс.Форма.ПанельФинансы",,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.ПанелиПростойИнтерфейс.Форма.ПанельФинансы" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

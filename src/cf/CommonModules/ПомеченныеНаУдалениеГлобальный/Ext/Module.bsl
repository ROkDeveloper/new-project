﻿#Область ПрограммныйИнтерфейс

// Обработчик ожидания при интерактивной установке пометки удаления.
//
Процедура Подключаемый_ОповещениеОПометкеУдаления() Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru='Помеченые на удаление'"),
		"e1cib/command/Обработка.ПанелиПростойИнтерфейс.Команда.ПомеченныеНаУдаление",
		НСтр("ru='Перейти'")
	);
	
КонецПроцедуры

#КонецОбласти
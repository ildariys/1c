////////////////////////////////////////////////////////////////////////////////
// Клиентские процедуры и функции общего назначения:
// - возврат строки для установки заголовка
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Получить строку установки заголовка.
// 
// Возвращаемое значение: 
//  Неопределено, Строка - Получить строку установки заголовка
Функция ПолучитьСтрокуУстановкиЗаголовка() Экспорт 
	
	Если ИмяПользователя() = Неопределено Тогда	
		Возврат Неопределено;	
	КонецЕсли;

	Если ИмяПользователя() = "Администратор" Тогда
		Возврат ИмяПользователя();
	КонецЕсли;
	
	МассивФИО = Новый Массив;
	МассивФИО = СтрРазделить(ИмяПользователя()," ");
	ИмяПользователя = МассивФИО[1];
	СтрокаВозврата = Метаданные.Синоним + "/ " + ИмяПользователя + " /" + ТекущаяДата();
	
	Возврат СтрокаВозврата ;
	
КонецФункции

#КонецОбласти


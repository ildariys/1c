#Область СлужебныеПроцедурыИФункции
  
// Цена блюда.
// 
// Параметры:
//  Период Период
//  Ссылка Ссылка
// Возвращаемое значение:
//  Цена - Цена блюда
Функция ЦенаБлюда(Период, Ссылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦеныБлюдСрезПоследних.Цена КАК Цена
		|ИЗ
		|	РегистрСведений.ЦеныБлюд.СрезПоследних(&Период, Блюдо.Ссылка = &Ссылка) КАК ЦеныБлюдСрезПоследних";
	
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	Возврат ВыборкаДетальныеЗаписи.Цена;
	
КонецФункции

// Значение константы сумма выдачи бонусной карты.
// 
// Возвращаемое значение:
//  Произвольный, Число - Значение константы сумма выдачи бонусной карты
Функция ЗначениеКонстантыСуммаВыдачиБонуснойКарты() Экспорт

	Возврат(Константы.СуммаВыдачиБонуснойКарты.Получить());

КонецФункции 

// Статус заказа.
// 
// Параметры:
//  Статус Статус
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыБлюда - Статус заказа
Функция СтатусЗаказа (Статус) Экспорт
	
	Возврат Перечисления.СтатусыБлюда[Статус];
	
КонецФункции

// Дата выдачи сертификата.
// 
// Параметры:
//  Ссылка Ссылка на спарвочник сертификаты
// 
// Возвращаемое значение: 
// Дата
//  
Функция ДатаВыдачиСертификата(Ссылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Сертификаты.ДатаВыдачи
		|ИЗ
		|	Справочник.Сертификаты КАК Сертификаты
		|ГДЕ
		|	Сертификаты.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.ДатаВыдачи;
	КонецЦикла;
	
КонецФункции

// Сумма сертификата.
// 
// Параметры:
//  Ссылка Ссылка на спарвочник сертификаты
// 
// Возвращаемое значение: 
// Сумма
//  
Функция СуммаСертификата(Ссылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Сертификаты.Сумма КАК Сумма
		|ИЗ
		|	Справочник.Сертификаты КАК Сертификаты
		|ГДЕ
		|	Сертификаты.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Сумма;
	КонецЦикла;
	
КонецФункции
#КонецОбласти

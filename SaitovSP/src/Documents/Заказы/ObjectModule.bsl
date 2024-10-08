#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если Резерв Тогда
		Движения.РезервСтолов.Записывать = ИСТИНА;
		Движение = Движения.РезервСтолов.Добавить();
		Движение.ДатаРезерва = ДатаРезерва;
		Движение.Период = Дата;
		Движение.Стол = НомерСтола;
		Возврат;
	КонецЕсли;
	
	СтруктураЗаказыКлиента = КоличествоЗаказовклиента(Клиент);
	
	Если СтруктураЗаказыКлиента.ТипКарты = ПредопределенноеЗначение("Справочник.ТипыКарт.КаждыйНБесплатно")
		И СтруктураЗаказыКлиента.Размер = (СтруктураЗаказыКлиента.КоличествоСделанныхЗаказаов + 1)
		Или
		(СтруктураЗаказыКлиента.ТипКарты = ПредопределенноеЗначение("Справочник.ТипыКарт.КаждыйНСреднийБесплатно")
		И СтруктураЗаказыКлиента.Итого >= Блюда.Итог("Сумма")
		И СтруктураЗаказыКлиента.Размер = (СтруктураЗаказыКлиента.КоличествоСделанныхЗаказаов + 1))
		Тогда
		
		РазмерСкидки = 0;
		Сообщить("Скидка " + СтруктураЗаказыКлиента.ТипКарты + " " +СтруктураЗаказыКлиента.Размер); 
		// регистр КоличествоЗаказовАкция Расход
		Движения.КоличествоЗаказовАкция.Записывать = Истина;
		Движение = Движения.КоличествоЗаказовАкция.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Клиент = Клиент;
		Движение.Итого = Итого;
		Движение.Количество = (СтруктураЗаказыКлиента.Размер - 1);
		
	Иначе
		
		// регистр СуммаЗаказовКлиенты 
		Движения.СуммаЗаказовКлиенты.Записывать = Истина;
		Движение = Движения.СуммаЗаказовКлиенты.Добавить();
		Движение.Период = Дата;
		Движение.Клиент = Клиент;
		Движение.СуммаЗаказа = Итого;
		Движение.Официант = Официант;
		Движение.Ресторан = Ресторан;
		
		// регистр КоличествоЗаказовАкция Приход
		Движения.КоличествоЗаказовАкция.Записывать = Истина;
		Движение = Движения.КоличествоЗаказовАкция.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Клиент = Клиент;
		Движение.Итого = Итого;
		Движение.Количество = 1;
		
	КонецЕсли;
	
	Для каждого ТекущаяСтрока Из Блюда Цикл
		Если ЗначениеЗаполнено(ТекущаяСтрока.ПричинаОтказа) Тогда
			Движения.ИсторияОтказовОтБлюд.Записывать = Истина;
			Движение 							= Движения.ИсторияОтказовОтБлюд.Добавить();
			Движение.Блюдо 						= ТекущаяСтрока.Блюдо;
			Движение.Повар 						= ТекущаяСтрока.Повар;
			Движение.Официант 					= Официант;
			Движение.Период 					= Дата;
			Движение.Причина 					= ТекущаяСтрока.ПричинаОтказа;
			Движение.ИдентификаторСтроки 		= ТекущаяСтрока.ИдентификаторСтроки;
			Движение.Заказ						= Ссылка;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция КоличествоЗаказовклиента(Ссылка)
	
	СтруктураЗаказыКлиента = Новый Структура;
	
	СтруктураЗаказыКлиента.Вставить("КоличествоСделанныхЗаказаов", 0);
	СтруктураЗаказыКлиента.Вставить("Итого", 0);
	СтруктураЗаказыКлиента.Вставить("ТипКарты", Неопределено);
	СтруктураЗаказыКлиента.Вставить("Размер", Неопределено);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КоличествоЗаказовАкцияОстатки.КоличествоОстаток КАК КоличествоСделанныхЗаказаов,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(КоличествоЗаказовАкцияОстатки.КоличествоОстаток, 0) = 0
	|			ТОГДА 0
	|		ИНАЧЕ КоличествоЗаказовАкцияОстатки.ИтогоОстаток / КоличествоЗаказовАкцияОстатки.КоличествоОстаток
	|	КОНЕЦ КАК Итого
	|ИЗ
	|	РегистрНакопления.КоличествоЗаказовАкция.Остатки КАК КоличествоЗаказовАкцияОстатки
	|ГДЕ
	|	КоличествоЗаказовАкцияОстатки.Клиент.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СкидочныеКарты.Размер КАК Размер,
	|	СкидочныеКарты.ТипКарты.Ссылка КАК ТипКартыСсылка
	|ИЗ
	|	Справочник.СкидочныеКарты КАК СкидочныеКарты
	|ГДЕ
	|	СкидочныеКарты.Клиент.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ВыборкаДетальныеЗаписи = РезультатЗапроса[0].Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		СтруктураЗаказыКлиента.Вставить("КоличествоСделанныхЗаказаов", ВыборкаДетальныеЗаписи.КоличествоСделанныхЗаказаов);
		СтруктураЗаказыКлиента.Вставить("Итого", ВыборкаДетальныеЗаписи.Итого);
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса[1].Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		СтруктураЗаказыКлиента.Вставить("ТипКарты", ВыборкаДетальныеЗаписи.ТипКартыСсылка);
		СтруктураЗаказыКлиента.Вставить("Размер", ВыборкаДетальныеЗаписи.Размер);
	КонецЕсли;
	
	Возврат СтруктураЗаказыКлиента;
	
КонецФункции

Функция УстановитьСуммуСертификата(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сертификаты.Сумма КАК Сумма
	|ИЗ
	|	Справочник.Сертификаты КАК Сертификаты
	|ГДЕ
	|	Сертификаты.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Сумма;
	КонецЦикла;
	
КонецФункции

Функция СертификатОплаты(Код)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Код", Код);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Сертификаты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Сертификаты КАК Сертификаты
	|ГДЕ
	|	Сертификаты.Код = &Код";
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти



#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ЦеныЗакупкиНоменклатур
	Движения.ЦеныЗакупкиНоменклатур.Записывать = Истина;
	Для Каждого ТекСтрокаНоменклатура Из Номенклатура Цикл
		Движение 				= Движения.ЦеныЗакупкиНоменклатур.Добавить();
		Движение.Период 		= Дата;
		Движение.Номенклатура 	= ТекСтрокаНоменклатура.Номенклатура;
		Движение.Поставщик 		= Поставщик;
		Движение.Ресторан 		= Ресторан;
		Движение.Цена 			= ТекСтрокаНоменклатура.Цена;
	КонецЦикла;

	// регистр ПродуктыРесторана Приход
	Движения.ПродуктыРесторана.Записывать = Истина;
	Для Каждого ТекСтрокаНоменклатура Из Номенклатура Цикл
		Движение 					= Движения.ПродуктыРесторана.Добавить();
		Движение.ВидДвижения 		= ВидДвиженияНакопления.Приход;
		Движение.Период 			= Дата;
		Движение.Номенклатура 		= ТекСтрокаНоменклатура.Номенклатура;
		Движение.Ресторан 			= Ресторан;
		Движение.Количество 		= ТекСтрокаНоменклатура.Количество;
		Движение.ЕдиницаИзмерения 	= ТекСтрокаНоменклатура.ЕдИзм;
	КонецЦикла;

	// регистр Взаиморасчеты Расход
	Движения.Взаиморасчеты.Записывать = Истина;
	Для Каждого ТекСтрокаНоменклатура Из Номенклатура Цикл
		Движение 				= Движения.Взаиморасчеты.Добавить();
		Движение.ВидДвижения 	= ВидДвиженияНакопления.Расход;
		Движение.Период 		= Дата;
		Движение.Поставщик 		= Поставщик;
		Движение.Ресторан 		= Ресторан;
		Движение.Сумма 			= ТекСтрокаНоменклатура.Сумма;
	КонецЦикла;

КонецПроцедуры
#КонецОбласти

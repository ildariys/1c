
#Область СлужебныеПроцедурыИФункции
Процедура ОбработкаПроведения(Отказ, Режим) Экспорт

	// регистр ИсторияНачисленияЗароботнойПлаты
	Движения.ИсторияНачисленияЗароботнойПлаты.Записывать = Истина;
	Движение = Движения.ИсторияНачисленияЗароботнойПлаты.Добавить();
	Движение.Период = Дата;
	Движение.Отвественный = Бухгалтер;

	// регистр ЗароботнаяПлата Расход
	Движения.ЗароботнаяПлата.Записывать = Истина;
	Для Каждого ТекСтрокаЗарплаты Из Зарплаты Цикл
		Движение = Движения.ЗароботнаяПлата.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Сотрудник = ТекСтрокаЗарплаты.Сотрудник;
		Движение.Должность = ТекСтрокаЗарплаты.Должность;
		Движение.Зарплата = ТекСтрокаЗарплаты.ЗаработнаяПлата;
	КонецЦикла;

КонецПроцедуры
#КонецОбласти

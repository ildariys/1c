
Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ДенежныеСредстваСети Расход для центрального офиса
	Движения.ДенежныеСредстваСети.Записывать = Истина;
	Движение = Движения.ДенежныеСредстваСети.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Период = Дата;
	Движение.Ресторан = ПараметрыСеанса.ТекущийРесторан;
	Движение.Выручка = СуммаПогашения;

	// регистр ДолгиПоставщикам Приход
	Движения.Взаиморасчеты.Записывать = Истина;
	Движение = Движения.Взаиморасчеты.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Период = Дата;
	Движение.Поставщик = Поставщик;
	Движение.Ресторан = ПараметрыСеанса.ТекущийРесторан;
	Движение.Сумма = СуммаПогашения;

	// регистр ДолгиПоставщикам Расход
	Движения.Взаиморасчеты.Записывать = Истина;
	Движение = Движения.Взаиморасчеты.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Поставщик = Поставщик;
	Движение.Ресторан = ПараметрыСеанса.ТекущийРесторан;
	Движение.Сумма = СуммаПогашения;

	// регистр ДолгиПоставщикам Расход
	Движения.Взаиморасчеты.Записывать = Истина;
	Движение = Движения.Взаиморасчеты.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Поставщик = Поставщик;
	Движение.Ресторан = Ресторан;
	Движение.Сумма = СуммаПогашения;

КонецПроцедуры

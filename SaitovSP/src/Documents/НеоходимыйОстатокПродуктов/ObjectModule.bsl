
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр НеоходимыеОстатки
	Движения.НеоходимыеОстатки.Записывать = Истина;
	Для Каждого ТекСтрокаТабличнаяЧасть1 Из ТабличнаяЧасть1 Цикл
		Движение = Движения.НеоходимыеОстатки.Добавить();
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТабличнаяЧасть1.Номенклатура;
		Движение.Повар = Повар;
		Движение.Ресторан = Ресторан;
		Движение.Количество = ТекСтрокаТабличнаяЧасть1.Количество;
		Движение.УчетнаяЕдиница = ТекСтрокаТабличнаяЧасть1.УчетнаяЕдиница;
	КонецЦикла;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры

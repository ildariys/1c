
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
		Объект.Дата = ТекущаяДата();
		Объект.Ресторан = ПараметрыСеанса.ТекущийРесторан;
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Разряды.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Разряды КАК Разряды";
		РезультатЗапроса = Запрос.Выполнить();
		РезультатВыборка = РезультатЗапроса.Выбрать();
		Пока РезультатВыборка.Следующий() Цикл 
			ТЧ = Объект.НазначениеОклада.Добавить();
			ТЧ.Разряд = РезультатВыборка.Ссылка;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

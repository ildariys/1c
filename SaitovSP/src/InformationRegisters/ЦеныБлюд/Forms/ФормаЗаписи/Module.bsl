
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запись.Время = ТекущаяДатаСеанса();
	Запись.Автор = ПараметрыСеанса.ТекущийПользователь;
КонецПроцедуры

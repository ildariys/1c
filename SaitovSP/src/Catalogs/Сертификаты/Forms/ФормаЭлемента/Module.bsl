
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.ДатаВыдачи = '00010101' Тогда
		Объект.ДатаВыдачи = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриЗакрытииНаСервере()
	//Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ПриЗакрытииНаСервере();
КонецПроцедуры

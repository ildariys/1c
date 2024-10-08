#Область СлужебныеПроцедурыИФункции

// Закрытие документов доставки.
Процедура ЗакрытиеДокументовДоставки() Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(ТекущаяДата()));
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Заказы.Ссылка,
		|	Заказы.ВремяВыдачиЗаказаКурьеру
		|ИЗ
		|	Документ.Заказы КАК Заказы
		|ГДЕ
		|	Заказы.СтатусЗаказа = ЗНАЧЕНИЕ(Перечисление.СтатусЗаказа.ВДоставке)
		|	И Заказы.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания";
	
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если (ТекущаяДата() - ВыборкаДетальныеЗаписи.ВремяВыдачиЗаказаКурьеру) > 
			(Константы.ВремяДоставки.Получить() * 60) Тогда
			
			Документы.Заказы.ЗакрытиеНеДоставленногоЗаказа(ВыборкаДетальныеЗаписи.Ссылка);
			
		КонецЕсли;		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
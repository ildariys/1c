// @strict-types

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриОткрытииНаСервере();
	ТекущийПовар = ПолучениеДанныхТекущегоСеансаСервер.ВернутьЗначениеПараметраСеансаТекущийПользователь();
	
	ПодключитьОбработчикОжидания("Обновить", 10);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готовлю(Команда)
	
	Если ТекущийЭлемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаФорма.ТекущийЭлемент.ТекущиеДанные.Повар = ТекущийПовар;
	ЭтаФорма.ТекущийЭлемент.ТекущиеДанные.Статус = ОбщийСервер.СтатусЗаказа("Готовиться");
	///Создание структуры для Записи в документ изменений
	СтруктураЗаказа = Новый Структура;
	СтруктураЗаказа.Вставить("Ссылка",ТекущийЭлемент.ТекущиеДанные.СсылкаЗаказ);
	СтруктураЗаказа.Вставить("ИдентификаторСтроки",ТекущийЭлемент.ТекущиеДанные.ИдентификаторСтроки);
	СтруктураЗаказа.Вставить("Повар",ТекущийПовар);
	СтруктураЗаказа.Вставить("Статус",ТекущийЭлемент.ТекущиеДанные.Статус);
	//Вызоа процедуры изменения заказа
	ЗаписьИзмененийВдокументе(СтруктураЗаказа);
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	Если ТекущийЭлемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущийЭлемент.ТекущиеДанные.Повар = ТекущийПовар Тогда
		
		ТекущийЭлемент.ТекущиеДанные.Статус = ОбщийСервер.СтатусЗаказа("Готово");
		НомерСтола = ЭтаФорма.ТекущийЭлемент.ТекущиеДанные.НомерСтола;
		СтруктураЗаказа = Новый Структура;
		СтруктураЗаказа.Вставить("Ссылка",ТекущийЭлемент.ТекущиеДанные.СсылкаЗаказ);
		СтруктураЗаказа.Вставить("ИдентификаторСтроки",ТекущийЭлемент.ТекущиеДанные.ИдентификаторСтроки);
		СтруктураЗаказа.Вставить("Повар",ТекущийЭлемент.ТекущиеДанные.Повар);
		СтруктураЗаказа.Вставить("Статус",ТекущийЭлемент.ТекущиеДанные.Статус);
		ЗаписьИзмененийВдокументе(СтруктураЗаказа);
		
		СписаниеПродуктов(ЭтаФорма.ТекущийЭлемент.ТекущиеДанные.Количество, ТекущийЭлемент.ТекущиеДанные.СсылкаЗаказ, ТекущийЭлемент.ТекущиеДанные.ИдентификаторСтроки)
		
		
	ИначеЕсли ЗначениеЗаполнено(ТекущийЭлемент.ТекущиеДанные.Повар) Тогда
		
		Сообщить("Этот заказ готовить повар " + ТекущийЭлемент.ТекущиеДанные.Повар);
		
	Иначе
		
		Сообщить("Необходимо сначала взять в работу!");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&Наклиенте
Процедура Обновить()
	
	ДинамическоеОбновлениеСписка();
	
КонецПроцедуры

&НаСервере
Процедура ДинамическоеОбновлениеСписка()	

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("НачПериода", НачалоДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("КонПериода", КонецДня(ТекущаяДата()));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Заказы.НомерСтола КАК НомерСтола,
	|	ЗаказыБлюда.Блюдо КАК Блюдо,
	|	Заказы.Официант КАК Официант,
	|	ЗаказыБлюда.Статус КАК Статус,
	|	Заказы.Дата КАК Дата,
	|	ЗаказыБлюда.Количество КАК Количество,
	|	Заказы.Ссылка КАК СсылкаЗаказ,
	|	ЗаказыБлюда.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ЗаказыБлюда.Повар КАК Повар
	|ИЗ
	|	Документ.Заказы.Блюда КАК ЗаказыБлюда
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Заказы КАК Заказы
	|		ПО ЗаказыБлюда.Ссылка = Заказы.Ссылка
	|ГДЕ
	|	Заказы.Дата МЕЖДУ &НачПериода И &КонПериода
	|	И НЕ Заказы.ЗаказЗакрыт
	|	И НЕ Заказы.Резерв
	|	И ЗаказыБлюда.Блюдо <> ЗНАЧЕНИЕ(Справочник.Блюда.Сертификат)
	|	И Заказы.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Статус,
	|	НомерСтола";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	СостояниеБлюд.Очистить();	
	
	Пока Выборка.Следующий() Цикл

		СтрокаТЗ = СостояниеБлюд.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЗ,Выборка);
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачПериода", НачалоДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("КонПериода", КонецДня(ТекущаяДата()));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Заказы.НомерСтола КАК НомерСтола,
	|	ЗаказыБлюда.Блюдо КАК Блюдо,
	|	Заказы.Официант КАК Официант,
	|	ЗаказыБлюда.Статус КАК Статус,
	|	Заказы.Дата КАК Дата,
	|	ЗаказыБлюда.Количество КАК Количество,
	|	Заказы.Ссылка КАК СсылкаЗаказ,
	|	ЗаказыБлюда.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ЗаказыБлюда.Повар КАК Повар
	|ИЗ
	|	Документ.Заказы.Блюда КАК ЗаказыБлюда
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Заказы КАК Заказы
	|		ПО ЗаказыБлюда.Ссылка = Заказы.Ссылка
	|ГДЕ
	|	Заказы.Дата МЕЖДУ &НачПериода И &КонПериода
	|	И НЕ Заказы.ЗаказЗакрыт
	|	И НЕ Заказы.Резерв
	|	И ЗаказыБлюда.Блюдо <> ЗНАЧЕНИЕ(Справочник.Блюда.Сертификат)
	|	И Заказы.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Статус,
	|	НомерСтола";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	СостояниеБлюд.Очистить();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаТЗ = СостояниеБлюд.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЗ,Выборка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписаниеПродуктов(Количество, Ссылка, ИдинтификаторСтроки)
	
	Документы.РасходПродуктов.СозданиеДокументаЗаказ(Количество, Ссылка, ИдинтификаторСтроки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписьИзмененийВдокументе(СтруктураЗаказа)
	
	Документы.Заказы.РедактированиеДокументаПоваром(СтруктураЗаказа);
	
КонецПроцедуры

#КонецОбласти


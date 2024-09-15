#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполнитьЗаписьПриПревышенииСуммы;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Проверка, Если новй документ, то подставляем значения
	Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
		Объект.Дата 	= ТекущаяДата();
		Объект.Бухгалтер = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	ВыполнитьЗаписьПриПревышенииСуммы = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Для каждого ТекущаяСтрока Из Объект.Зарплаты Цикл	
		Если ТекущаяСтрока.ЗаработнаяПлата < 0 Тогда
			Сообщить("Начисление меньше нуля! Впишите корректные данные!");
			Отказ = Истина;
			Возврат;
		КонецЕсли;	
	КонецЦикла;
	
	АвансПревышаетНачисление 		= ЛОЖЬ;
	СтруктураПроверкиНачисления 	= Новый Структура;
	СтруктураПроверкиНачисления 	= ПередЗаписьюНаСервере();
	
	Если СтруктураПроверкиНачисления.Количество() > 0 Тогда
		 АвансПревышаетНачисление	= СтруктураПроверкиНачисления.АвансПревышаетНачисление;
		 ТекстСообщения				= СтруктураПроверкиНачисления.ТекстСообщения;
	КонецЕсли;
	Если АвансПревышаетНачисление и Не ВыполнитьЗаписьПриПревышенииСуммы Тогда
		Отказ = Истина;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса",ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет, 0, КодВозвратаДиалога.Да, "Продолжить запись?");
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗарплаты
&НаКлиенте
Процедура ЗарплатыПриИзменении(Элемент)
	
	ВыполнитьЗаписьПриПревышенииСуммы = Ложь;
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.Зарплаты.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПерезаписи",ЭтотОбъект);
		ПоказатьВопрос(Оповещение, "В таблице уже есть данные, перезаписать?", РежимДиалогаВопрос.ДаНет, 0, КодВозвратаДиалога.Да, "Перезаписать?");
	Иначе
		ВыполнитьЗаписьПриПревышенииСуммы = Истина;
		ЗаполнитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПередЗаписьюНаСервере()
	
	СтруктураПроверкиНачисления = Новый Структура;
			 
	АвансПревышаетНачисление = ЛОЖЬ;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗароботнаяПлатаОстатки.Сотрудник КАК Сотрудник,
		|	ЗароботнаяПлатаОстатки.ЗарплатаОстаток КАК ЗарплатаОстаток
		|ИЗ
		|	РегистрНакопления.ЗароботнаяПлата.Остатки КАК ЗароботнаяПлатаОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
	ТекстСообщения = "Сумма выплат превышает начисление для:" + Символы.ПС;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 		
		Для Каждого ТекСтрока Из Объект.Зарплаты Цикл
			Если ВыборкаДетальныеЗаписи.Сотрудник = ТекСтрока.Сотрудник Тогда
				Если ВыборкаДетальныеЗаписи.ЗарплатаОстаток < ТекСтрока.ЗаработнаяПлата Тогда

					ТекстСообщения = ТекстСообщения + ВыборкаДетальныеЗаписи.Сотрудник + Символы.ПС;
					АвансПревышаетНачисление = Истина;

				КонецЕсли;
			КонецЕсли;
		КонецЦикла;		
	КонецЦикла;
	
	СтруктураПроверкиНачисления.Вставить("АвансПревышаетНачисление", АвансПревышаетНачисление);
	СтруктураПроверкиНачисления.Вставить("ТекстСообщения", ТекстСообщения);

	Возврат (СтруктураПроверкиНачисления);

КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ВыполнитьЗаписьПриПревышенииСуммы = Истина;
		Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПерезаписи (Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ВыполнитьЗаписьПриПревышенииСуммы = Истина;
		ЗаполнитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Объект.Зарплаты.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗароботнаяПлатаОстатки.Сотрудник КАК Сотрудник,
		|	ЗароботнаяПлатаОстатки.ЗарплатаОстаток КАК ЗаработнаяПлата
		|ПОМЕСТИТЬ Вт_Начисления
		|ИЗ
		|	РегистрНакопления.ЗароботнаяПлата.Остатки КАК ЗароботнаяПлатаОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Сотрудник,
		|	Сотрудники.Должность КАК Должность,
		|	ЕСТЬNULL(Вт_Начисления.ЗаработнаяПлата, 0) КАК ЗаработнаяПлата
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ Вт_Начисления КАК Вт_Начисления
		|		ПО (Вт_Начисления.Сотрудник = Сотрудники.Ссылка)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл		
		НовСтр = Объект.Зарплаты.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ВыборкаДетальныеЗаписи);		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
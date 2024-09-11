#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Официант") Тогда		
		Объект.Официант = Параметры.Официант;		
	КонецЕсли;
	
	Если Объект.Ресторан.Пустая() Тогда		
		Объект.Ресторан = ПолучениеДанныхТекущегоСеансаСервер.ВернутьЗначениеПараметраСеансаТекущийРесторан();		
	КонецЕсли;
	
	Объект.Дата = Неопределено;
	////////////////////Вызов процедуры создания кнопок
	СозданиеКнопокСтолов();
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = "АРМ Официанта";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("Обновить", 10);
	ИзменениеДоступностиКнопокФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОплатаСертификатомПриИзменении(Элемент)
	
	Если Объект.ОплатаСертификатом Тогда
	
		Элементы.СертификатОплатыПроверяемый.Видимость = Истина;
		Элементы.СуммаСертификата.Видимость = Истина;
		
	Иначе
		
		Элементы.СертификатОплатыПроверяемый.Видимость 	= Ложь;
		Элементы.СуммаСертификата.Видимость 			= Ложь;
		Объект.СертификатОплаты 						= "";
	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаРезерваПриИзменении(Элемент)
	
	Если Объект.ДатаРезерва < НачалоДня(ТекущаяДата()) Тогда
		
		Сообщить("Дата резерва меньше текущей даты!");
		Объект.ДатаРезерва = "01010001";
		
	КонецЕсли;КонецПроцедуры

&НаКлиенте
Процедура ГостьПриИзменении(Элемент)
	
	ПрименениеСкидки();
	Элементы.ПрименитьСкидку.Доступность = Истина;
	
КонецПроцедуры 

&НаКлиенте
Процедура РезервПриИзменении(Элемент)
	
	Если Объект.Резерв Тогда
		
		Элементы.УстановитьРезерв.Доступность = Истина;
		Элементы.ДатаРезерва.Доступность = Истина;
		
	Иначе
		
		Элементы.УстановитьРезерв.Доступность = Ложь;
		Элементы.ДатаРезерва.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыБлюда

&НаКлиенте
Процедура БлюдаКоличествоПриИзменении(Элемент)
	
	ОбновитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура БлюдаПередУдалением(Элемент, Отказ)
	
	Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Статус) Тогда	
		Отказ = Истина;
		Сообщить("Нельзя удалить. Блюдо в работе!");	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БлюдаЦенаПриИзменении(Элемент)
	ОбновитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура БлюдаБлюдаПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Блюда.ТекущиеДанные;
	СТрокаТч.ИдентификаторСтроки = Новый УникальныйИдентификатор;
	СтрокаТЧ.Количество = 1;
	//Проверяем выбранное значение на сертификат
	Если СтрокаТЧ.Блюдо = ПредопределенноеЗначение("Справочник.Блюда.Сертификат") Тогда
		ПоказатьОповещениеОВводеЦеныСертификата();
	КонецЕсли;
	//Установить цену текущего блбюда из регистра
	СтрокаТЧ.Цена = ОбщийСервер.ЦенаБлюда(ТекущаяДата(),СтрокаТЧ.Блюдо);
	//Расчитать сумму в строке
	ОбновитьДанные();
	//СтрокаТЧ.Статус = ОбщийСервер.СтатусЗаказа("ЗаказПринят");

КонецПроцедуры

&НаКлиенте
Процедура БлюдаПриИзменении(Элемент)
	РасчетИтого(РежимЗаписиДокумента.Запись);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Обновить()
	
	ПрисвоениеЦветаНазванияСтолу();
	
КонецПроцедуры

&НаСервереБезконтекста
Функция СуммаВыдачиБонуснойКарты()
	
	Возврат Константы.СуммаВыдачиБонуснойКарты.Получить();
	
КонецФункции 

&НаСервере
Функция СоздатьНовыйСертификат(Сумма)
	
	НовыйОбъект 			= Справочники.Сертификаты.СоздатьЭлемент();
	НовыйОбъект.ДатаВыдачи 	= ТекущаяДата();
	НовыйОбъект.Сумма 		= Сумма;
	НовыйОбъект.Записать();
	ПроведениеНовыхСертификатов(НовыйОбъект.Ссылка, Сумма);
	Возврат НовыйОбъект.Ссылка;
	
КонецФункции 

&НаСервереБезКонтекста
Процедура ПроведениеНовыхСертификатов(СертификатОплаты, Сумма) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.Сертификаты.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Сертификат						= СертификатОплаты;
	МенеджерЗаписи.Период							= ТекущаяДата();
	МенеджерЗаписи.Погашен							= Ложь;
	МенеджерЗаписи.СуммаСертификата					= Сумма;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

////////////////////Печать Сертификатов
&НаСервереБезКонтекста
Процедура ПечатьСертификата(ТабДок, ПараметрКоманды)
	
	Справочники.Сертификаты.Печать(ТабДок, ПараметрКоманды);

КонецПроцедуры

&НаКлиенте
Процедура ДиалогСоздатьНовуюКарту()
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса",ЭтотОбъект);
	ПоказатьВопрос(Оповещение,"Выдать новую карту клиенту?",РежимДиалогаВопрос.ДаНет,0,КодВозвратаДиалога.Да,"Новая скидочная карта");

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
	
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Клиент", Объект.Клиент);		
		ОткрытьФорму("Справочник.СкидочныеКарты.Форма.ФормаЭлемента", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТипИРазмерСкидки(Ссылка)
	
	СтруктураСкидочнойКарты = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СкидочныеКарты.ТипКарты.Ссылка КАК ТипКартыСсылка,
		|	СкидочныеКарты.Размер КАК Размер,
		|	СкидочныеКарты.ТипКарты.ИмяПредопределенныхДанных КАК ТипКартыИмяПредопределенныхДанных
		|ИЗ
		|	Справочник.СкидочныеКарты КАК СкидочныеКарты
		|ГДЕ
		|	СкидочныеКарты.Клиент.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтруктураСкидочнойКарты.Вставить("ТипСкидки", ВыборкаДетальныеЗаписи.ТипКартыИмяПредопределенныхДанных);
		СтруктураСкидочнойКарты.Вставить("РазмерСкидки", ВыборкаДетальныеЗаписи.Размер);
	КонецЦикла;
	
	Возврат СтруктураСкидочнойКарты;
	
КонецФункции

&НаСервереБезКонтекста
Функция КоличествоЗаказовклиентаИРазмерСкидки(Ссылка)
	
	СтруктураЗаказыКлиента = Новый Структура;
	СтруктураЗаказыКлиента.Вставить("КоличествоСделанныхЗаказаов", 0);
	СтруктураЗаказыКлиента.Вставить("Итого", 0);
	СтруктураЗаказыКлиента.Вставить("ТипКарты", Неопределено);
	СтруктураЗаказыКлиента.Вставить("Размер", Неопределено);

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КоличествоЗаказовАкцияОстатки.КоличествоОстаток КАК КоличествоСделанныхЗаказаов,
	|	КоличествоЗаказовАкцияОстатки.ИтогоОстаток / КоличествоЗаказовАкцияОстатки.КоличествоОстаток КАК Итого
	|ИЗ
	|	РегистрНакопления.КоличествоЗаказовАкция.Остатки КАК КоличествоЗаказовАкцияОстатки
	|ГДЕ
	|	КоличествоЗаказовАкцияОстатки.Клиент.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СкидочныеКарты.Размер КАК Размер,
	|	СкидочныеКарты.ТипКарты.Ссылка КАК ТипКартыСсылка
	|ИЗ
	|	Справочник.СкидочныеКарты КАК СкидочныеКарты
	|ГДЕ
	|	СкидочныеКарты.Клиент.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	РезультатЗапроса = Запрос.ВыполнитьПакет();

	ВыборкаДетальныеЗаписи = РезультатЗапроса[0].Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		СтруктураЗаказыКлиента.Вставить("КоличествоСделанныхЗаказаов",
			ВыборкаДетальныеЗаписи.КоличествоСделанныхЗаказаов);
		СтруктураЗаказыКлиента.Вставить("Итого", ВыборкаДетальныеЗаписи.Итого);
	КонецЕсли;

	ВыборкаДетальныеЗаписи = РезультатЗапроса[1].Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		СтруктураЗаказыКлиента.Вставить("ТипКарты", ВыборкаДетальныеЗаписи.ТипКартыСсылка);
		СтруктураЗаказыКлиента.Вставить("Размер", ВыборкаДетальныеЗаписи.Размер);
	КонецЕсли;

	Возврат СтруктураЗаказыКлиента;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьСуммуСертификата(Ссылка)
		
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сертификаты.Сумма КАК Сумма
	|ИЗ
	|	Справочник.Сертификаты КАК Сертификаты
	|ГДЕ
	|	Сертификаты.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СуммаСертификата = ВыборкаДетальныеЗаписи.Сумма;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатПриИзменении(Элемент)
	
	УстановитьСуммуСертификата(Объект.СертификатОплаты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаЧисла(Результат, Параметры) Экспорт
	
	Если Не Результат = Неопределено Тогда
		СтрокаТЧ = Элементы.Блюда.ТекущиеДанные;
		СтрокаТЧ.Цена = Результат;
		ОбновитьДанные();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОповещениеОВводеЦеныСертификата()
	
	Оповещение = Новый ОписаниеОповещения("ПослеВводаЧисла", ЭтотОбъект);	
	ПоказатьВводЧисла( Оповещение,,"Введите номинал сертификата ",5);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапретРедактирования()
	
	Элементы.ГруппаЗаказ.Доступность = Ложь;
	Сообщить ("Заказ закрыт, редактирование недоступно");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанные()

	СтрокаТЧ = ЭтаФорма.Элементы.Блюда.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиент.РассчитатьСуммыВСтрокеТабличнойЧасти(СтрокаТЧ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименениеСкидки()	
	
	//ПОдумать Над Названием процедуры КоличествоЗаказовклиентаИРазмерСкидки
	СтруктураЗаказыКлиента = КоличествоЗаказовклиентаИРазмерСкидки(Объект.Клиент);
	
	Если СтруктураЗаказыКлиента.ТипКарты = ПредопределенноеЗначение("Справочник.ТипыКарт.Скидка") Тогда
		
		РазмерСкидки = 1 - СтруктураЗаказыКлиента.Размер / 100;
			
	ИначеЕсли СтруктураЗаказыКлиента.ТипКарты = ПредопределенноеЗначение("Справочник.ТипыКарт.КаждыйНБесплатно")
		Или (СтруктураЗаказыКлиента.ТипКарты = ПредопределенноеЗначение("Справочник.ТипыКарт.КаждыйНСреднийБесплатно")
		И СтруктураЗаказыКлиента.Итого > Объект.Блюда.Итог("Сумма")) Тогда
		
		Если СтруктураЗаказыКлиента.Размер < СтруктураЗаказыКлиента.КоличествоСделанныхЗаказаов Тогда
			
		//	ОчисткаРегистра(Объект.Клиент);
			РазмерСкидки = 0;
			Сообщить("Каждый Н бесплатно");
			
		КонецЕсли;
		
	Иначе
		РазмерСкидки = 1;
	КонецЕсли;
	
КонецПроцедуры

Функция ЗначениеРеквизита() 
	
		СтруктураСкидочнойКарты = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТипыКарт.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
		|ИЗ
		|	Справочник.ТипыКарт КАК ТипыКарт";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтруктураСкидочнойКарты.Вставить("ВыборкаДетальныеЗаписи.ТипКартыИмяПредопределенныхДанных", ВыборкаДетальныеЗаписи.ТипКартыИмяПредопределенныхДанных);
	КонецЦикла;
	
	Возврат СтруктураСкидочнойКарты;
	
КонецФункции

Функция СуммаЗаказовКлиента(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СуммаЗаказовКлиентыОбороты.СуммаЗаказаОборот КАК СуммаЗаказаОборот
		|ИЗ
		|	РегистрНакопления.СуммаЗаказовКлиенты.Обороты(&НачалоПериода, &КонецПериода, Месяц, ) КАК СуммаЗаказовКлиентыОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СкидочныеКарты КАК СкидочныеКарты
		|		ПО СуммаЗаказовКлиентыОбороты.Клиент.Ссылка = СкидочныеКарты.Клиент.Ссылка
		|ГДЕ
		|	СуммаЗаказовКлиентыОбороты.Клиент.Ссылка = &Ссылка
		|	И СкидочныеКарты.Клиент ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ТекущаяДата()));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ТекущаяДата()));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.СуммаЗаказаОборот;
	КонецЦикла;
	
	Возврат 0;
	
КонецФункции

&НаСервере
Процедура СозданиеКнопокСтолов ()
	
	//ПОлучам все столы ресторана 
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Владелец", ПараметрыСеанса.ТекущийРесторан);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Столы.НомерСтола КАК Наименование,
	|	Столы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Столы КАК Столы
	|ГДЕ
	|	Столы.Владелец = &Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	//Создаем кнопки-столы
	КоличествоСтолбцов = 3;
	Счетчик = 1;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если Счетчик = 1 ИЛИ (Счетчик-1) % КоличествоСтолбцов = 0 Тогда
			НоваяГруппа = Элементы.Добавить("ГруппаСтол"+Счетчик, Тип("ГруппаФормы"), Элементы.ГруппаСтолы);
			НоваяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			НоваяГруппа.ОтображатьЗаголовок = Ложь;
			НоваяГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		КонецЕсли;
		
		ИмяКнопки = "Стол" + ВыборкаДетальныеЗаписи.Наименование;
		ИмяКоманды = ИмяКнопки;
		
		НоваяКоманда = ЭтаФорма.Команды.Добавить(ИмяКнопки);
		НоваяКоманда.Действие = "ОбработкаКнопокСтолы";
		НоваяКоманда.Заголовок = ВыборкаДетальныеЗаписи.Наименование;
		НовыйЭлемент = Элементы.Добавить(ИмяКнопки,Тип("КнопкаФормы"),НоваяГруппа);
		НовыйЭлемент.ИмяКоманды = ИмяКоманды;
		НовыйЭлемент.Заголовок = ВыборкаДетальныеЗаписи.Наименование;
		НовыйЭлемент.ЦветФона = Новый Цвет(0,255,0);
		НовыйЭлемент.Ширина = 15;
		НовыйЭлемент.Высота = 5;
		
		Счетчик = Счетчик + 1;
	КонецЦикла;
	
	ПрисвоениеЦветаНазванияСтолу();
	
КонецПроцедуры

////РАскраска столов//НЕ ХОРОШО ГОНЯТЬ ВСЮ ФОРМУ НА СЕРВЕР!
&НаСервере
Процедура ПрисвоениеЦветаНазванияСтолу()
		/////////////////////////Красим столы
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Столы.НомерСтола КАК НомерСтола,
	|	Заказы.Резерв КАК Резерв,
	|	Заказы.ЗаказЗакрыт КАК ЗаказЗакрыт,
	|	Заказы.Официант КАК Официант,
	|	Заказы.ДатаРезерва КАК ДатаРезерва
	|ИЗ
	|	Документ.Заказы КАК Заказы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Столы КАК Столы
	|		ПО Заказы.НомерСтола = Столы.Ссылка
	|ГДЕ
	|	Заказы.ЗаказЗакрыт = ЛОЖЬ
	|	И Заказы.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)
	|	И НЕ Заказы.Доставка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтола,
	|	Резерв УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Если ВыборкаДетальныеЗаписи.Резерв Тогда//Желтые

				Элементы["Стол" + ВыборкаДетальныеЗаписи.НомерСтола].Заголовок = Строка(ВыборкаДетальныеЗаписи.НомерСтола) + Символы.ПС +
				"Резерв " +  Символы.ПС  
				+ Формат(ВыборкаДетальныеЗаписи.ДатаРезерва,"ДФ='dd.MM.yy");
				Элементы["Стол" + ВыборкаДетальныеЗаписи.НомерСтола].ЦветФона = Новый Цвет(255,255,0);
			КонецЕсли;
			
		Если НЕ ВыборкаДетальныеЗаписи.ЗаказЗакрыт И НЕ ВыборкаДетальныеЗаписи.Резерв Тогда
			
			////////////////////Красные 
			
				Элементы["Стол" + ВыборкаДетальныеЗаписи.НомерСтола].Заголовок = Строка(ВыборкаДетальныеЗаписи.НомерСтола) 
				+ Символы.ПС + ВыборкаДетальныеЗаписи.Официант;
				Элементы["Стол" + ВыборкаДетальныеЗаписи.НомерСтола].ЦветФона = Новый Цвет(255,0,0);
			
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

//////////////////Печать Чека
&НаСервереБезКонтекста
Процедура ПечатьЧека(ТабДок, ПараметрКоманды)
	
	Документы.Заказы.Печать(ТабДок,ПараметрКоманды);

КонецПроцедуры

Функция УстановитьЦенуСертификата(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сертификаты.Сумма КАК Сумма
		|ИЗ
		|	Справочник.Сертификаты КАК Сертификаты
		|ГДЕ
		|	Сертификаты.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Сумма;
	КонецЦикла;
	
	Возврат 0;

КонецФункции

&НаСервереБезКонтекста
Функция УстановитьНомерСтола(НомерСтола)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Столы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Столы КАК Столы
		|ГДЕ
		|	Столы.НомерСтола = &НомерСтола";
	
	Запрос.УстановитьПараметр("НомерСтола", Число(НомерСтола));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
КонецФункции // УстановитьНомерСтола()

&НаСервере
Процедура ЗаполнениеТЗЗаказа(НомерСтола)
	
	ОчиститьДанные();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказыБлюда.Блюдо КАК Блюдо,
	|	ЗаказыБлюда.Количество КАК Количество,
	|	ЗаказыБлюда.Цена КАК Цена,
	|	ЗаказыБлюда.Сумма КАК Сумма,
	|	ЗаказыБлюда.Статус КАК Статус,
	|	ЗаказыБлюда.Повар КАК Повар,
	|	ЗаказыБлюда.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ЗаказыБлюда.ПричинаОтказа КАК ПричинаОтказа
	|ИЗ
	|	Документ.Заказы.Блюда КАК ЗаказыБлюда
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Заказы КАК Заказы
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Столы КАК Столы
	|			ПО Заказы.НомерСтола = Столы.Ссылка
	|		ПО ЗаказыБлюда.Ссылка = Заказы.Ссылка
	|ГДЕ
	|	Столы.НомерСтола = &НомерСтола
	|	И НЕ Заказы.ЗаказЗакрыт
	|	И Заказы.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)
	|	И Заказы.Резерв <> ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Заказы.Официант КАК Официант,
	|	Заказы.СкидочнаяКарта КАК СкидочнаяКарта,
	|	Заказы.Итого КАК Итого,
	|	Заказы.Клиент КАК Клиент,
	|	Заказы.СертификатОплаты КАК СертификатОплаты,
	|	Заказы.Дата КАК Дата,
	|	Заказы.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.Заказы КАК Заказы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Столы КАК Столы
	|		ПО Заказы.НомерСтола = Столы.Ссылка
	|ГДЕ
	|	Заказы.Ресторан = &Ресторан
	|	И Столы.НомерСтола = &НомерСтола
	|	И Заказы.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)
	|	И Заказы.Резерв <> ИСТИНА
	|	И НЕ Заказы.ЗаказЗакрыт";	
	
	Запрос.УстановитьПараметр("НомерСтола",	Число(СтрРазделить(НомерСтола,Символы.ПС)[0]));
	Запрос.УстановитьПараметр("Дата",		ТекущаяДата());
	Запрос.УстановитьПараметр("Ресторан",	ПараметрыСеанса.ТекущийРесторан);
	Запрос.УстановитьПараметр("Дата",		ТекущаяДата());	
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса[0].Выбрать();
	Объект.Блюда.Очистить();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаБлюда 					= Объект.Блюда.Добавить();
		СтрокаБлюда.Блюдо 				= ВыборкаДетальныеЗаписи.Блюдо;
		СтрокаБлюда.Количество 			= ВыборкаДетальныеЗаписи.Количество;
		СтрокаБлюда.Цена 				= ВыборкаДетальныеЗаписи.Цена;
		СтрокаБлюда.Сумма 				= ВыборкаДетальныеЗаписи.Сумма;
		СтрокаБлюда.Статус 				= ВыборкаДетальныеЗаписи.Статус;
		СтрокаБлюда.ИдентификаторСтроки = ВыборкаДетальныеЗаписи.ИдентификаторСтроки;
		СтрокаБлюда.ПричинаОтказа 		= ВыборкаДетальныеЗаписи.ПричинаОтказа;
	КонецЦикла; 

	ВыборкаДетальныеЗаписи = РезультатЗапроса[1].Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		Объект.Официант 			= ВыборкаДетальныеЗаписи.Официант;
		Объект.СкидочнаяКарта 		= ВыборкаДетальныеЗаписи.СкидочнаяКарта;
		Объект.Итого 				= ВыборкаДетальныеЗаписи.Итого;
		Объект.Клиент 				= ВыборкаДетальныеЗаписи.Клиент;
		Объект.СертификатОплаты 	= ВыборкаДетальныеЗаписи.СертификатОплаты;
		Объект.Дата					= ВыборкаДетальныеЗаписи.Дата;
		СсылкаЗаказ 				= ВыборкаДетальныеЗаписи.Ссылка;
		
	КонецЕсли;
	
КонецПроцедуры

///////Перенести в модуль менеджера регистра сведений сертификаты
&НаСервереБезКонтекста
Процедура ЗаписьИспользованногоСертификата(ТекущийОбъект)

		РегистрыСведений.Сертификаты.ЗарегистрироватьСертификат(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРезервНаСервере()
	
	ДокРезерв 						= Документы.Заказы.СоздатьДокумент();
	
	ДокРезерв.Дата 					= Объект.Дата;
	ДокРезерв.ДатаЗакрытияЗаказа 	= Объект.ДатаЗакрытияЗаказа;
	//ДокРезерв.ЗаказЗакрыт 			= Объект.ЗаказЗакрыт;
	ДокРезерв.Итого					= Объект.Итого;
	ДокРезерв.Клиент				= Объект.Клиент;
	ДокРезерв.НомерСтола			= Объект.НомерСтола;
	//ДокРезерв.ОплатаСертификатом	= Объект.ОплатаСертификатом;
	//ДокРезерв.Официант				= Объект.Официант;
	ДокРезерв.Резерв				= Объект.Резерв;
	ДокРезерв.Ресторан				= Объект.Ресторан;
	//ДокРезерв.СертификатОплаты		= Объект.СертификатОплаты;
	ДокРезерв.СкидочнаяКарта		= Объект.СкидочнаяКарта;
	ДокРезерв.ДатаРезерва			= Объект.ДатаРезерва;
	ДокРезерв.Резерв				= Объект.Резерв;
	
	
	
	ТЧДокРезервБлюта = ДокРезерв.Блюда;
	Для Каждого СтрТабЧасть Из Объект.Блюда Цикл
		НоваяСтрокаПриемник 			= ТЧДокРезервБлюта.Добавить();
		НоваяСтрокаПриемник.Блюдо 		= СтрТабЧасть.Блюдо;
		НоваяСтрокаПриемник.Количество 	= СтрТабЧасть.Количество;
		НоваяСтрокаПриемник.Статус 		= СтрТабЧасть.Статус;
		НоваяСтрокаПриемник.Сумма 		= СтрТабЧасть.Сумма;
		НоваяСтрокаПриемник.Цена 		= СтрТабЧасть.Цена;
		
		ЗаполнитьЗначенияСвойств(НоваяСтрокаПриемник, СтрТабЧасть);
	КонецЦикла;
	
	
	ДокРезерв.Записать();
	
	СсылкаЗаказ = Документы.Заказы.ПустаяСсылка();
	
	Сообщить("Резерв успешно устанволен на " + Объект.ДатаРезерва);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетИтого(РежимЗаписи)

	//Проверка на заполненность сертификата
	Если СуммаСертификата = Неопределено Тогда
		СуммаСертификата = 0;
	КонецЕсли;
	
	//Проверка заполненности скидки
	Если Не ЗначениеЗаполнено(РазмерСкидки) Тогда
		РазмерСкидки = 1;
	КонецЕсли;
	
	//Расчет суммы блюд и сертификатов
	СуммаБлюд = 0;
	СуммаСертификатов = 0;
	
	Для Каждого СтрТабЧасть Из Объект.Блюда Цикл
		Если СтрТабЧасть.Блюдо = ПредопределенноеЗначение("Справочник.Блюда.Сертификат") Тогда
			СуммаСертификатов = СуммаСертификатов + СтрТабЧасть.Сумма;
		Иначе
			СуммаБлюд = СуммаБлюд + СтрТабЧасть.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	///Расчет итоговой суммы заказа
	ИтогБезПокупаемыхСертификатов = СуммаБлюд * РазмерСкидки - СуммаСертификата;
	
	//Если номинал сертификата больше суммы блюд то записываем 0
	Если ИтогБезПокупаемыхСертификатов < 0 Тогда
		 ИтогБезПокупаемыхСертификатов = 0;
	КонецЕсли;
	
	//Подчсет итога
	Объект.Итого = ИтогБезПокупаемыхСертификатов + СуммаСертификатов; 
	ОбъектРедактирования = Объект;
	//РедактированиеДокумента(СсылкаЗаказ, ОбъектРедактирования, РежимЗаписи);


КонецПроцедуры

&НаСервереБезКонтекста
Процедура РедактированиеДокумента(СсылкаЗаказ, ОбъектРедактирования, РежимЗаписи)

		//ЗаписьДокумента либо создание
	///Если ЗначениеЗаполнено(СсылкаЗаказ) Тогда
		Документы.Заказы.РедактированиеДокумента(СсылкаЗаказ, ОбъектРедактирования, РежимЗаписи);
	//Иначе
		//СсылкаЗаказ = Документы.Заказы.СозданиеДокументаЗаказ(ОбъектРедактирования);
		//Сообщить("Тут должно быть РедактированиеДокумента");
	//КонецЕсли;	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗанятьСтол(Команда)	
	
	ПараметрыОбъекта = Объект;
	СсылкаЗаказ = ЗанятьСтолНаСервере(ПараметрыОбъекта);
	ИзменениеДоступностиКнопокФормы();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьСкидку(Команда)
	
	Объект.Итого = Объект.Блюда.Итог("Сумма") * РазмерСкидки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНаКухню(Команда)
	
	ТабличнаяЧасть = Объект.Блюда;
	Для каждого ТекущаяСтрока Из ТабличнаяЧасть Цикл
		
		 Если Не ЗначениеЗаполнено(ТекущаяСтрока.Блюдо) Или
			Не ЗначениеЗаполнено(ТекущаяСтрока.Количество) ИЛИ
			Не ЗначениеЗаполнено(ТекущаяСтрока.Цена) Тогда
		
			Сообщить("Заполните все значения блюд!");
			Возврат;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.Статус) Тогда
		
			ТекущаяСтрока.Статус = ОбщийСервер.СтатусЗаказа("ЗаказПринят");
		
		КонецЕсли;
	КонецЦикла;
	
	//ЗаписьДокумента либо создание 
	ОбъектРедактирования = Объект;
	РедактированиеДокумента(СсылкаЗаказ, ОбъектРедактирования, РежимЗаписиДокумента.Проведение);
	Элементы["Стол" + Объект.НомерСтола].Заголовок = Строка(Объект.НомерСтола) 
			+ Символы.ПС + Объект.Официант;
	Элементы["Стол" + Объект.НомерСтола].ЦветФона = Новый Цвет(255,0,0);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКнопокСтолы(Команда)
	
	ЗаполнениеТЗЗаказа(ТекущийЭлемент.Заголовок);
	ТекущийСтол = СтрРазделить(ТекущийЭлемент.Заголовок,Символы.ПС);
	Объект.НомерСтола = УстановитьНомерСтола(ТекущийСтол[0]);
	Объект.Дата = ТекущаяДата();
	
	ИзменениеДоступностиКнопокФормы()
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРезерв(Команда)
	
	///Проверка заполненности даты резерва
	Если НЕ ЗначениеЗаполнено(Объект.ДатаРезерва) Тогда		
		Сообщить("Дата резерва не заполнена!");
		Возврат;	
	КонецЕсли;
	
	///Проверка что дата резерва позже текущей даты
	Если Объект.ДатаРезерва < ТекущаяДата() Тогда		
		Сообщить("Дата резерва не заполнена!");
		Возврат;	
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.НомерСтола) Тогда
		
		СсылкаЗаказ = СозданиеНовогоДокументаЗаказ(Объект);
		//УстановитьРезервНаСервере();
		Если Объект.ДатаРезерва < КонецДня(ТекущаяДата()) Тогда 
			Элементы["Стол" + Объект.НомерСтола].Заголовок = Строка(Объект.НомерСтола) 
				+ Символы.ПС + "Резерв" + Символы.ПС + Объект.ДатаРезерва;
			Элементы["Стол" + Объект.НомерСтола].ЦветФона = Новый Цвет(255,255,0);
		КонецЕсли;
		
		СсылкаЗаказ = ПредопределенноеЗначение("Документ.Заказы.ПустаяСсылка");	
		Сообщить("Резерв успешно устанволен на " + Объект.ДатаРезерва);

	Иначе
		
		Сообщить("Выберите стол");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьЗаказ(Команда)
	
	ТабличнаяЧасть = Объект.Блюда;
	Для каждого ТекущаяСтрока Из ТабличнаяЧасть Цикл
		
		 Если Не ЗначениеЗаполнено(ТекущаяСтрока.Блюдо) Или
			Не ЗначениеЗаполнено(ТекущаяСтрока.Количество) ИЛИ
			Не ЗначениеЗаполнено(ТекущаяСтрока.Цена) Тогда
		
			Сообщить("Заполните все значения блюд!");
			Возврат;
		КонецЕсли;
	
	КонецЦикла;
	//установка стола не занятым
	Элементы["Стол" + Объект.НомерСтола].Заголовок = Строка(Объект.НомерСтола);
	Элементы["Стол" + Объект.НомерСтола].ЦветФона = Новый Цвет(0,255,0);
////////////////////////////////////////////Проверить где используется и убрать заменить на проверку даты закрытия///////////////////////////	
	Объект.ЗаказЗакрыт = Истина; 
		///Присваение дате закрытия текущей даты
	Объект.ДатаЗакрытияЗаказа = ТекущаяДата();

/////////////////////////////////////////////////////////////////////	
	///ЗАпредРедактирования и и запись
	ЗапретРедактирования();
	ЭтаФорма.Записать();
	///РасчетИтого
	РасчетИтого(РежимЗаписиДокумента.Проведение);
	
	//Проверка нужно ли выдать клиенту карту лояльности
	ТекущаяСуммаЗаказов = СуммаЗаказовКлиента(Объект.Клиент);

	Если ТекущаяСуммаЗаказов > СуммаВыдачиБонуснойКарты() Тогда
		ДиалогСоздатьНовуюКарту();
	КонецЕсли;
	
	///СОздание сертификатов
	МассивСертификатов = Новый Массив;
	Для Каждого СтрТабЧасть Из Объект.Блюда Цикл
		
		Если СтрТабЧасть.Блюдо = ПредопределенноеЗначение("Справочник.Блюда.Сертификат") Тогда
			Для Счетчик = 1 По СтрТабЧасть.Количество Цикл
				
				МассивСертификатов.Добавить(СоздатьНовыйСертификат(СтрТабЧасть.Сумма));
				
		    КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	ТабДок = Новый ТабличныйДокумент;
	Если МассивСертификатов.Количество() <> 0 Тогда
	
		//Печать Сертификатов
		ПараметрКоманды = МассивСертификатов;
		ПечатьСертификата(ТабДок, ПараметрКоманды);
		ТабДок.ОтображатьСетку = Ложь;
		ТабДок.Защита = Истина;
		ТабДок.ТолькоПросмотр = Истина;
		ТабДок.ОтображатьЗаголовки = Ложь;
		ТабДок.Показать();
	
	КонецЕсли;
	
	///Печать Чека
	ПараметрКоманды = СсылкаЗаказ;
	ПечатьЧека(ТабДок, ПараметрКоманды);
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
	
	Если ЗначениеЗаполнено(Объект.СертификатОплаты) Тогда
		
		ТекущийОбъект = Объект;
		ЗаписьИспользованногоСертификата(ТекущийОбъект);
				
	КонецЕсли;
	
	СертификатОплаты = "";
		
КонецПроцедуры 

#КонецОбласти

#Область СобытияТабличнойЧастиБлюда


&НаКлиенте
Процедура СертификатОплатыПриИзменении(Элемент)

	СтруктураСертификата = Новый Структура;
	СтруктураСертификата = ПрименитьСертификатНаСервере(СертификатОплатыПроверяемый);
	
	Если СтруктураСертификата = Неопределено Тогда
		Сообщить ("Сертификат не найден");
	Иначе
		Если СтруктураСертификата.Погашен Тогда
		
			Сообщить("Сертификат уже погашен");
		    Возврат;
			
		КонецЕсли;

		Объект.СертификатОплаты = СертификатОплатыПроверяемый;
		СуммаСертификата = СтруктураСертификата.СуммаСертификата;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрименитьСертификатНаСервере(НомерСертификата)
	
	СтруктураСертификата = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Сертификаты.СуммаСертификата КАК СуммаСертификата,
	|	Сертификаты.Погашен КАК Погашен
	|ИЗ
	|	РегистрСведений.Сертификаты КАК Сертификаты
	|ГДЕ
	|	Сертификаты.Сертификат = &Сертификат";
	
	Запрос.УстановитьПараметр("Сертификат", НомерСертификата);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтруктураСертификата.Вставить("СуммаСертификата", ВыборкаДетальныеЗаписи.СуммаСертификата);
		СтруктураСертификата.Вставить("Погашен", ВыборкаДетальныеЗаписи.Погашен);
		Возврат СтруктураСертификата;
	КонецЦикла;
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура СертификатОплатыАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	//СтандартнаяОбработка = ЛОЖЬ;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЧека1(Команда)
	
	ТабличнаяЧасть = Объект.Блюда;
	Для каждого ТекущаяСтрока Из ТабличнаяЧасть Цикл
		
		 Если Не ЗначениеЗаполнено(ТекущаяСтрока.Блюдо) Или
			Не ЗначениеЗаполнено(ТекущаяСтрока.Количество) ИЛИ
			Не ЗначениеЗаполнено(ТекущаяСтрока.Цена) Тогда
		
			Сообщить("Заполните все значения блюд!");
			Возврат;
		КонецЕсли;
	
	КонецЦикла;
	
	Если Объект.ЗаказЗакрыт Тогда
	
		Сообщить("Заказ закрыт, печать не возможна");
		Возврат;
	
	КонецЕсли;
	
	РасчетИтого(РежимЗаписиДокумента.Запись);
		///Печать Чека
	ТабДок = Новый ТабличныйДокумент;

	ПараметрКоманды = СсылкаЗаказ;
	ПечатьЧека(ТабДок, ПараметрКоманды);
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
	
КонецПроцедуры

&НаСервереБезконтекста
Функция ЗанятьСтолНаСервере(ПараметрыОбъекта)
	
	Возврат Документы.Заказы.СозданиеДокументаЗаказ(ПараметрыОбъекта);
	
КонецФункции

&НаКлиенте
Процедура ИзменениеДоступностиКнопокФормы()
	
	Если ЗначениеЗаполнено(СсылкаЗаказ) Тогда
	
		Элементы.ФормаЗанятьСтол.Доступность = Ложь;
		Элементы.КнопкиЗанятогоСтола.Доступность = Истина;
		Элементы.ЗаказЗакрыт.Доступность = Истина;
	Иначе 
		
		Элементы.ФормаЗанятьСтол.Доступность = Истина;
		Элементы.КнопкиЗанятогоСтола.Доступность = Ложь;
		Элементы.ЗаказЗакрыт.Доступность = Ложь;
	
	КонецЕсли;
	
	//Если ЗначениеЗаполнено(СсылкаЗаказ) Тогда
	//	
	//	Элементы.КнопкиЗанятогоСтола.Доступность = Истина;
	//	Элементы.ГруппаЗаказ.Доступность = Истина;
	//	
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДанные()

	Объект.Дата = Неопределено;
	СсылкаЗаказ = Документы.Заказы.ПустаяСсылка();
	
	Для Каждого Реквизит Из РеквизитФормыВЗначение("Объект").Метаданные().Реквизиты Цикл
		
		Если Реквизит.Имя = "Официант" Тогда
			Продолжить;	
		КонецЕсли;
		Если Реквизит.Имя = "Ресторан" Тогда
			Продолжить;	
		КонецЕсли;
		
		Объект[Реквизит.Имя] = Неопределено;
		
	КонецЦикла;

КонецПроцедуры

&НаСервереБезконтекста
Функция СозданиеНовогоДокументаЗаказ(Объект)
	
	Возврат Документы.Заказы.СозданиеДокументаЗаказ(Объект);
	
КонецФункции

#КонецОбласти

Процедура ОбновитьДанныеПользователяИБ(ПользовательИБ)
	
	ПользовательИБ.Имя = Наименование;
	ПользовательИБ.ПолноеИмя = ПолноеИмя; 
	ПользовательИБ.Пароль = Пароль; 
	ПользовательИБ.ПоказыватьВСпискеВыбора = ПоказыватьВСпискеВыбора;
	
	ПользовательИБ.Роли.Очистить();
	Если ДополнительныеСвойства.Свойство("СписокРолей") Тогда
		
		СписокРолей = ДополнительныеСвойства.СписокРолей;
		Для каждого РольЭлемент Из СписокРолей Цикл      
			
			Если РольЭлемент.Пометка = Ложь Тогда
				Продолжить;
			КонецЕсли;
			
			ИмяРоли = РольЭлемент.Значение;
			ПользовательИБ.Роли.Добавить(Метаданные.Роли[ИмяРоли]);
			
		КонецЦикла;
	
	КонецЕсли;
	
	ПользовательИБ.Записать();       
	
КонецПроцедуры

				
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
    	Возврат;
	КонецЕсли;
	 
	Если ЭтоНовый() Тогда
		
		НайденныйПользователь = ПользователиИнформационнойБазы.НайтиПоИмени(Наименование);
		Если НайденныйПользователь = Неопределено Тогда
			
			ПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
			ОбновитьДанныеПользователяИБ(ПользовательИБ);		
			
			ИдентификаторПользователяИБ = ПользовательИБ.УникальныйИдентификатор;
			
		Иначе
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "В списке уже есть пользователь с таким именем!";
			Сообщение.Сообщить();
			
			Отказ = Истина;
		КонецЕсли;           
		
	Иначе  
		
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);
		Если ПользовательИБ <> Неопределено Тогда
			ОбновитьДанныеПользователяИБ(ПользовательИБ);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

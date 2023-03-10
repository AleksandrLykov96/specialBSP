
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Выделение текущей базы
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Спец_ОбщегоНазначенияПовтИсп.ЗначениеПараметраСеанса("Спец_ТекущаяБаза");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.Спец_ШрифтВыделениеЖирным);
	
КонецПроцедуры

#КонецОбласти

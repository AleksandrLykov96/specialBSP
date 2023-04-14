
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля = Новый Массив();
	
	Поля.Добавить("Наименование");
	Поля.Добавить("НаименованиеВ1С");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Представление = ?(Не ПустаяСтрока(Данные.НаименованиеВ1С),
			СтрШаблон("%1 - %2", Данные.Наименование, Данные.НаименованиеВ1С),
			Данные.Наименование);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

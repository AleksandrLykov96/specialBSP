
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьКрасивуюПанельОтборов();
	Спец_РаботаСФормами.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Спец_РаботаСФормамиКлиент.ПриЗакрытии(ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_ОбработкаСобытияОтбора(Элемент, СтандартнаяОбработка = Истина)
	
	Спец_РаботаСФормамиКлиент.ОбработатьСобытиеОтбора(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьКрасивуюПанельОтборов()
	
	СтруктураПараметровПанели = Спец_РаботаСФормами.НоваяСтруктураПараметровВыводаПанелиКрасивыхОтборов(Элементы.Список,
			Элементы.НастройкаСписка,
			Элементы.СписокКомпоновщикНастроекПользовательскиеНастройки);
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"База",
			ВидСравненияКомпоновкиДанных.Равно,
			"База");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ИмяОбъектаМетаданныхИсточник",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Имя объекта метаданных (источник)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ИмяТабличнойЧастиИсточник",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Имя табличной части (источник)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ИмяРеквизитаИсточник",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Имя реквизита (источник)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ИмяОбъектаМетаданныхПриемник",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Имя объекта метаданных (приёмник)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ИмяТабличнойЧастиПриемник",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Имя табличной части (приёмник)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ИмяРеквизитаПриемник",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Имя реквизита (приёмник)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ПолноеИмяТипаОбъектаМетаданныхИсточник",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Полное имя типа объекта метаданных (источник)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ПолноеИмяТипаОбъектаМетаданныхПриемник",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Полное имя типа объекта метаданных (приёмник)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ТипПередачи",
			ВидСравненияКомпоновкиДанных.Равно,
			"Тип передачи");
	
	Спец_РаботаСФормами.ВывестиПанельОтборовНаФорму(ЭтотОбъект, СтруктураПараметровПанели);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// ++ Спец_БСП.Версия1С_19_Ниже
	Список.Параметры.УстановитьЗначениеПараметра("СмещениеЧасовогоПояса", СмещениеСтандартногоВремени());
	// -- Спец_БСП.Версия1С_19_Ниже
	
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

&НаСервере
Процедура Подключаемый_ОбработкаСобытияОтбораВызовСервера(Знач Элемент) Экспорт
	
	Спец_РаботаСФормами.ОбработатьСобытиеОтбора(ЭтотОбъект, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьКрасивуюПанельОтборов()
	
	СтруктураПараметровПанели = Спец_РаботаСФормами.НоваяСтруктураПараметровВыводаПанелиКрасивыхОтборов(Элементы.Список,
			Элементы.НастройкаСписка,
			Элементы.СписокКомпоновщикНастроекПользовательскиеНастройки);
	
	СтруктураПараметровПанели.ВывестиКоличествоЗаписей = Истина;
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ДатаРегистрации",
			ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
			,
			Истина,
			Спец_ОбщегоНазначенияКлиентСервер.ОписаниеТипаДата(ЧастиДаты.ДатаВремя));
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"База",
			ВидСравненияКомпоновкиДанных.Равно);
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"Объект_1",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Объект");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ПолноеИмяОбъектаМетаданных",
			ВидСравненияКомпоновкиДанных.Равно,
			"Полное имя метаданных");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"Приоритет",
			ВидСравненияКомпоновкиДанных.Равно);
	
	Спец_РаботаСФормами.ВывестиПанельОтборовНаФорму(ЭтотОбъект, СтруктураПараметровПанели);
	
КонецПроцедуры

#КонецОбласти


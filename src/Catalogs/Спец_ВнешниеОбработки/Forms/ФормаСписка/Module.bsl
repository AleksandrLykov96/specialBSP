
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
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ПоследняяДатаИзменения",
			ВидСравненияКомпоновкиДанных.Равно,
			"Дата измененения",
			Истина);
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"Наименование",
			ВидСравненияКомпоновкиДанных.Равно,
			"Наименование");
	
	Спец_РаботаСФормами.ВывестиПанельОтборовНаФорму(ЭтотОбъект, СтруктураПараметровПанели);
	
КонецПроцедуры

#КонецОбласти

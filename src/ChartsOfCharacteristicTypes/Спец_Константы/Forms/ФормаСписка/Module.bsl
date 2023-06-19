
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

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	СоответствиеСтрокДляЗаполнения = Новый Соответствие;
	МассивДляПолученияЗначений     = Новый Массив;
	
	Для Каждого СтрокаСписка Из Строки Цикл
		
		ДанныеСтроки = СтрокаСписка.Значение.Данные;
		Если ТипЗнч(ДанныеСтроки.ТекущееЗначение) = Тип("СправочникСсылка.Спец_МассивЗначенийКонстант")
			И ЗначениеЗаполнено(ДанныеСтроки.ТекущееЗначение) Тогда
			
			МассивДляПолученияЗначений.Добавить(ДанныеСтроки.ТекущееЗначение);
			СоответствиеСтрокДляЗаполнения[СтрокаСписка.Значение.Данные.ТекущееЗначение] = ДанныеСтроки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивДляПолученияЗначений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	Спец_МассивЗначенийКонстантЗначенияКонстанты.Ссылка КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(Спец_МассивЗначенийКонстантЗначенияКонстанты.Значение) КАК Значение
	|ИЗ
	|	Справочник.Спец_МассивЗначенийКонстант.ЗначенияКонстанты КАК Спец_МассивЗначенийКонстантЗначенияКонстанты
	|ГДЕ
	|	Спец_МассивЗначенийКонстантЗначенияКонстанты.Ссылка В (&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Спец_МассивЗначенийКонстантЗначенияКонстанты.НомерСтроки
	|ИТОГИ
	|	КОЛИЧЕСТВО(Значение)
	|ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивДляПолученияЗначений);
	
	ВыборкаПоМассовымЗначениям = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоМассовымЗначениям.Следующий() Цикл
		
		Если СоответствиеСтрокДляЗаполнения[ВыборкаПоМассовымЗначениям.Ссылка] = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		МассивРезультат = Новый Массив(); // Массив из Строка
		
		ВыборкаПоЗначениям = ВыборкаПоМассовымЗначениям.Выбрать();
		Пока ВыборкаПоЗначениям.Следующий() Цикл
			МассивРезультат.Добавить(ВыборкаПоЗначениям.Значение);
		КонецЦикла;
		
		СоответствиеСтрокДляЗаполнения[ВыборкаПоМассовымЗначениям.Ссылка]["ТекущееЗначение"] = СтрСоединить(МассивРезультат, "; ");
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьКрасивуюПанельОтборов()
	
	СтруктураПараметровПанели = Спец_РаботаСФормами.НоваяСтруктураПараметровВыводаПанелиКрасивыхОтборов(Элементы.Список,
			Элементы.НастройкаСписка,
			Элементы.СписокКомпоновщикНастроекПользовательскиеНастройки);
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"Наименование",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Наименование");
	
	Спец_РаботаСФормами.ВывестиПанельОтборовНаФорму(ЭтотОбъект, СтруктураПараметровПанели);
	
КонецПроцедуры

#КонецОбласти

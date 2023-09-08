
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТипБазы = Спец_ОбщегоНазначенияПовтИсп.СтруктураПараметровБазы().ТипБазыДанных;
	
	УстановитьУсловноеОформление();
	УстановитьПримерныйРазмерБазы();
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

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаКластеризацияОчисткаТаблиц(Команда)
	
	Если ТипБазы = ПредопределенноеЗначение("Перечисление.Спец_ТипыБазыДанных.PostgreSQL") Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеУточненияДляКластеризацииТаблиц", ЭтотОбъект);
		Спец_ОбщегоНазначенияКлиент.ПоказатьВопросДляДолгойОбработкиСБлокировкой(ОписаниеОповещения);
		
	Иначе
		
		ВызватьИсключение СтрШаблон("Тип базы данных ""%1"" не поддерживается", ТипБазы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаКэшироватьТаблицы(Команда)
	
	Если ТипБазы = ПредопределенноеЗначение("Перечисление.Спец_ТипыБазыДанных.PostgreSQL") Тогда
		
		#Если ТолстыйКлиентОбычноеПриложение Тогда
			Спец_PostgreSQL.ЗакинутьТаблицыВОперативнуюПамять();
		#Иначе
			КэшированиеТаблицВызовСервера();
		#КонецЕсли
		
		ПослеВыполненияЛюбогоРегламента(Неопределено, Неопределено);
		
	Иначе
		
		ВызватьИсключение СтрШаблон("Тип базы данных ""%1"" не поддерживается", ТипБазы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновитьСтруктуруТаблиц(Команда)
	
	Если ТипБазы = ПредопределенноеЗначение("Перечисление.Спец_ТипыБазыДанных.PostgreSQL") Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеУточненияДляОбновленияСтруктурыТаблиц", ЭтотОбъект);
		Спец_ОбщегоНазначенияКлиент.ПоказатьВопросДляДолгойОбработкиСБлокировкой(ОписаниеОповещения);
		
	Иначе
		
		ВызватьИсключение СтрШаблон("Тип базы данных ""%1"" не поддерживается", ТипБазы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Выделяем часто используемые таблицы
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.ЧастыеОбращения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.Спец_ШрифтВыделениеЖирным);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПримерныйРазмерБазы()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СУММА(Спец_СтруктураТаблицБазыДанных.ОбщийРазмерТаблицы) КАК ОбщийРазмерТаблицы
	|ИЗ
	|	Справочник.Спец_СтруктураТаблицБазыДанных КАК Спец_СтруктураТаблицБазыДанных
	|ГДЕ
	|	НЕ Спец_СтруктураТаблицБазыДанных.ПометкаУдаления";
	
	ПримерныйРазмерБазы = Спец_ОбщегоНазначения.ПолучитьСтруктуруПервойВыборкиЗапроса(Запрос, "ОбщийРазмерТаблицы");
	Если ТипЗнч(ПримерныйРазмерБазы) = Тип("Число") И ПримерныйРазмерБазы > 0 Тогда
		Элементы.ДекорацияНадписьПримерныйРазмерБазы.Заголовок = СтрШаблон("Примерный размер базы: " + Спец_СтроковыеФункцииКлиентСервер.ПеревестиРазмерИзБайтовВЧитемыйВид(ПримерныйРазмерБазы));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьКрасивуюПанельОтборов()
	
	СтруктураПараметровПанели = Спец_РаботаСФормами.НоваяСтруктураПараметровВыводаПанелиКрасивыхОтборов(Элементы.Список,
			Элементы.НастройкаСписка,
			Элементы.СписокКомпоновщикНастроекПользовательскиеНастройки);
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"Наименование",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Наименование (БД)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"НаименованиеВ1С",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Наименование (1С)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"Столбцы.ИмяСтолбца",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Столбец (БД)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"Столбцы.ИмяСтолбцаВ1С",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Столбец (1С)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"Индексы.ИмяИндекса",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Индекс (index)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"Ограничения.ИмяОграничения",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Ограничение (constraint)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"Триггеры.ИмяТриггера",
			ВидСравненияКомпоновкиДанных.Содержит,
			"Триггер (trigger)");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ПометкаУдаления",
			ВидСравненияКомпоновкиДанных.Равно,
			"Только удалённые");
	
	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели,
			"ПометкаУдаления",
			ВидСравненияКомпоновкиДанных.НеРавно,
			"Только НЕ удалённые");
	
	Спец_РаботаСФормами.ВывестиПанельОтборовНаФорму(ЭтотОбъект, СтруктураПараметровПанели);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУточненияДляКластеризацииТаблиц(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗадания = Спец_РаботаСФоновымиЗаданиямиКлиентСервер.ПолучитьСтруктуруПараметровВыполненияФоновогоЗадания();
	
	СтруктураЗадания.ИмяРегламентногоЗадания = "Спец_PostgreSQL.КластеризацияОчисткаВсехТаблиц";
	СтруктураЗадания.РаботаЧерезРегистр      = Истина;
	СтруктураЗадания.ТаймаутВыполнения       = Спец_КонстантыКлиентСервер.СекундВЧасе();
	СтруктураЗадания.ВывестиФорму            = Истина;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияЛюбогоРегламента", ЭтотОбъект);
	Спец_РаботаСФоновымиЗаданиямиКлиентСервер.ЗапуститьВыполнениеФоновогоЗадания(СтруктураЗадания,
			Спец_КонстантыКлиентСервер.СекундВЧасе(),
			ЭтотОбъект,
			ОписаниеОповещения);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура КэшированиеТаблицВызовСервера()
	
	Спец_PostgreSQL.ЗакинутьТаблицыВОперативнуюПамять();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУточненияДляОбновленияСтруктурыТаблиц(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗадания = Спец_РаботаСФоновымиЗаданиямиКлиентСервер.ПолучитьСтруктуруПараметровВыполненияФоновогоЗадания();
	
	СтруктураЗадания.ИмяРегламентногоЗадания  = "Спец_PostgreSQL.ОбновитьСтруктуруТаблицPostgreSQL";
	СтруктураЗадания.РаботаЧерезРегистр       = Истина;
	СтруктураЗадания.ТаймаутВыполнения        = Спец_КонстантыКлиентСервер.СекундВЧасе();
	СтруктураЗадания.ВывестиФорму             = Истина;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияЛюбогоРегламента", ЭтотОбъект);
	Спец_РаботаСФоновымиЗаданиямиКлиентСервер.ЗапуститьВыполнениеФоновогоЗадания(СтруктураЗадания,
			Спец_КонстантыКлиентСервер.СекундВЧасе(),
			ЭтотОбъект,
			ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыполненияЛюбогоРегламента(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТипБазы = Спец_ОбщегоНазначенияПовтИсп.СтруктураПараметровБазы().ТипБазыДанных;
	
	// Примерный размер базы
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
		Элементы.ДекорацияНадписьПримерныйРазмерБазы.Заголовок = СтрШаблон("Примерный размер базы: " + Спец_ОбщегоНазначенияКлиентСервер.ПеревестиРазмерИзБайтовВЧитемыйВид(ПримерныйРазмерБазы));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Для Каждого СтрокаДС Из Строки Цикл
		
		Попытка
			
			СтрокаДС.Значение.Оформление["ОбщийРазмерТаблицы"].УстановитьЗначениеПараметра("Текст",
					Спец_ОбщегоНазначенияКлиентСервер.ПеревестиРазмерИзБайтовВЧитемыйВид(СтрокаДС.Значение.Данные.ОбщийРазмерТаблицы));
			
		Исключение
			
			Возврат;
			
		КонецПопытки;
		
	КонецЦикла;
	
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

&НаКлиенте
Процедура ПослеУточненияДляКластеризацииТаблиц(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗадания = Спец_РаботаСФоновымиЗаданиямиКлиентСервер.ПолучитьСтруктуруПараметровВыполненияФоновогоЗадания();
	
	СтруктураЗадания.ИмяРегламентногоЗадания  = "Спец_PostgreSQL.КластеризацияОчисткаВсехТаблиц";
	СтруктураЗадания.РаботаЧерезРегистр       = Истина;
	СтруктураЗадания.ТаймаутВыполнения        = 3600;
	СтруктураЗадания.ВывестиФорму             = Истина;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияЛюбогоРегламента", ЭтотОбъект);
	Спец_РаботаСФоновымиЗаданиямиКлиентСервер.ЗапуститьВыполнениеФоновогоЗадания(СтруктураЗадания, 3600, ЭтотОбъект, ОписаниеОповещения);
	
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
	СтруктураЗадания.ТаймаутВыполнения        = 3600;
	СтруктураЗадания.ВывестиФорму             = Истина;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияЛюбогоРегламента", ЭтотОбъект);
	Спец_РаботаСФоновымиЗаданиямиКлиентСервер.ЗапуститьВыполнениеФоновогоЗадания(СтруктураЗадания, 3600, ЭтотОбъект, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыполненияЛюбогоРегламента(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

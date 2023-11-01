// @strict-types

//@skip-check method-too-many-params

#Область ПрограммныйИнтерфейс

// Выполнить запрос к PostgreSQL красиво, с открытием отдельной формы
// 
// Параметры:
//	ТекстЗапроса - Строка - Текст запроса PostgreSQL
//	ИмяТаблицы - Строка - Имя таблицы для обновления после выполнения запроса
//	ФормаВладелец - ФормаКлиентскогоПриложения, Форма, Неопределено - Форма владелец
//	ОписаниеОповещенияПослеЗакрытия - ОписаниеОповещения - Описание оповещения после закрытия
//	ОткрытьМодально - Булево - Открыть форму модально
//	Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
// 
// Возвращаемое значение:
//	Булево, Произвольный - Если ОткрытьМодально = ИСТИНА, тогда результат выполнения формы, иначе флаг успешности начала выполнения запроса.
//
Функция ВыполнитьЗапросPostgreSQLКрасиво(Знач ТекстЗапроса, Знач ИмяТаблицы = "", Знач ФормаВладелец = Неопределено, Знач ОписаниеОповещенияПослеЗакрытия = Неопределено, Знач ОткрытьМодально = Ложь, Кэш = Неопределено) Экспорт
	
	Спец_ЗаписатьЛог("Спец_PostgreSQLКлиент.ВыполнитьЗапросPostgreSQLКрасиво",
			ПредопределенноеЗначение("Перечисление.Спец_УровниЛогирования.Информация"),
			"Инициализация выполнения запроса красиво",
			Кэш);
	
	ПараметрыОткрытияФормы = Новый Структура("ТекстЗапроса, ИмяТаблицы", ТекстЗапроса, ИмяТаблицы);

#Если Не ВебКлиент Тогда

	Если ОткрытьМодально Тогда
		Возврат ОткрытьФормуМодально("ОбщаяФорма.Спец_ФормаВыполненияЗапросаPostgreSQL", ПараметрыОткрытияФормы, ФормаВладелец);
	КонецЕсли;

#КонецЕсли
	
	//@skip-check invocation-parameter-type-intersect
	ОткрытьФорму("ОбщаяФорма.Спец_ФормаВыполненияЗапросаPostgreSQL",
			ПараметрыОткрытияФормы,
			ФормаВладелец,
			, , ,
			ОписаниеОповещенияПослеЗакрытия,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	Возврат Истина;
	
КонецФункции

// ++ Спец_БСП.Версия1С_18_ВышеИлиРавно

// Асинхронный вариант (см. Спец_PostgreSQLКлиентСервер.ПодключитьКомпонентуСИнициализированнымПодключением)
// 
// Параметры:
//	КонстантноеИмяКомпоненты - см. Спец_PostgreSQLКлиентСервер.ПодключитьКомпонентуСИнициализированнымПодключением.КонстантноеИмяКомпоненты
// 
// Возвращаемое значение:
//	см. Спец_PostgreSQLКлиентСервер.ПодключитьКомпонентуСИнициализированнымПодключением
//
Асинх Функция ПодключитьКомпонентуСИнициализированнымПодключениемАсинх(Знач КонстантноеИмяКомпоненты = Истина) Экспорт

	Спец_PostgreSQLКлиентСервер.ИсключениеЕслиНеPostgreSQLБаза();
	
	ОбещаниеПодключенияКомпоненты = Спец_КомпонентаДополнительныеФункцииКлиент.ПолучитьКомпонентуPostgreSQLАсинх(КонстантноеИмяКомпоненты);
	СтрокаПодключения             = Спец_PostgreSQLКлиентСервер.ПодготовитьСтрокуПодключенияКPostgreSQL();
	
	ВнешняяКомпонента = Ждать ОбещаниеПодключенияКомпоненты; // см. Спец_КомпонентаДополнительныеФункцииКлиент.ПолучитьКомпонентуPostgreSQLАсинх
	Спец_Проверить(ВнешняяКомпонента <> Неопределено, "Не удалось подключить внешнюю компоненту", "Подключить компоненту с инициализированным подключением");
	
	ВременныйКэш = Новый Структура("КомпонентаPostgreSQL", ВнешняяКомпонента);
	Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLУстановитьСоединениеАсинх(СтрокаПодключения, ВременныйКэш);
	
	Возврат ВнешняяКомпонента;

КонецФункции

// Асинхронный вариант (см. Спец_PostgreSQLКлиентСервер.ПодключитьКомпонентуPostgreSQLДляДругойБазы)
// 
// Параметры:
//  База - см. Спец_PostgreSQLКлиентСервер.ПодключитьКомпонентуPostgreSQLДляДругойБазы.База
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
// 
// Возвращаемое значение:
//  см. Спец_PostgreSQLКлиентСервер.ПодключитьКомпонентуPostgreSQLДляДругойБазы
//
Асинх Функция ПодключитьКомпонентуPostgreSQLДляДругойБазыАсинх(Знач База, Кэш = Неопределено) Экспорт
	
	Если Кэш = Неопределено Тогда Кэш = Спец_ПолучитьКэш(); КонецЕсли;
	Если Кэш.КомпонентыPostgreSQLДляДругихБаз[База] <> Неопределено Тогда
		Возврат Кэш.КомпонентыPostgreSQLДляДругихБаз[База];
	КонецЕсли;
	
	СтруктураПараметровБазы = Спец_ОбщегоНазначенияКлиентСерверПовтИсп.СтруктураПараметровБазы(База);
	Если СтруктураПараметровБазы.ТипБазыДанных <> ПредопределенноеЗначение("Перечисление.Спец_ТипыБазыДанных.PostgreSQL")
		Или ПустаяСтрока(СтруктураПараметровБазы.СтрокаПодключенияКБазеДанных) Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Спец_ЗаписатьЛог("Получение компоненты PostgreSQL для другой базы (асинх)",
			ПредопределенноеЗначение("Перечисление.Спец_УровниЛогирования.Информация"),
			"Попытка получения компоненты PostgreSQL с подключением к базе " + СтруктураПараметровБазы.НаименованиеБазы,
			Кэш);
	
	Попытка
		
		КомпонентаРезультат = Ждать Спец_ОбщегоНазначенияКлиент.ПодключитьВнешнююКомпонентуДляРаботыАсинх("ОбщийМакет.Спец_КомпонентаLykovPostgreSQL",
				Спец_СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(СтруктураПараметровБазы.ИмяБазы),
				"PostgreSQL",
				Истина,
				Истина); // см. Спец_ОбщегоНазначенияКлиентСервер.ПодключитьВнешнююКомпонентуДляРаботы
		
		Спец_Проверить(КомпонентаРезультат <> Неопределено,
				"Не удалось подключить компоненту!",
				"Спец_PostgreSQLКлиентСервер.ПодключитьКомпонентуPostgreSQLДляДругойБазы");
		
		СтруктураРезультат = Новый Структура("КомпонентаPostgreSQL", КомпонентаРезультат);
		
		ОбещаниеУстановкаСоединения = Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLУстановитьСоединениеАсинх(СтруктураПараметровБазы.СтрокаПодключенияКБазеДанных, СтруктураРезультат);
		Кэш.КомпонентыPostgreSQLДляДругихБаз[База] = СтруктураРезультат;
		Ждать ОбещаниеУстановкаСоединения;
		
		Возврат Кэш.КомпонентыPostgreSQLДляДругихБаз[База];
		
	Исключение
		
		Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(ИнформацияОбОшибке(), "Подключение к PostgreSQL другой базы");
		Возврат Неопределено;
		
	КонецПопытки;
	
КонецФункции

// -- Спец_БСП.Версия1С_18_ВышеИлиРавно

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// ++ Спец_БСП.Версия1С_18_ВышеИлиРавно

// см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.ПоместитьТаблицу1СВоВременнуюТаблицу
// 
// Параметры:
//	ИсходныеДанные - см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.ПоместитьТаблицу1СВоВременнуюТаблицу.ИсходныеДанные
//	ПараметрыПомещения - см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.ПоместитьТаблицу1СВоВременнуюТаблицу.ПараметрыПомещения
//	ТекстОшибок - см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.ПоместитьТаблицу1СВоВременнуюТаблицу.ТекстОшибок
//	Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
// 
// Возвращаемое значение:
//  см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.ПоместитьТаблицу1СВоВременнуюТаблицу
//
Асинх Функция ПоместитьТаблицу1СВоВременнуюТаблицуАсинх(Знач ИсходныеДанные, Знач ПараметрыПомещения, ТекстОшибок, Знач Кэш) Экспорт
	
#Если Не ВебКлиент Тогда
	
	СтруктураТаблицыИзБД = Спец_PostgreSQLВызовСервераПовтИсп.ПолучитьСтруктуруТаблицыПоИмениМетаданных(ПараметрыПомещения.ИмяМетаданныхИз1С);
	СоответствиеКолонок  = Спец_PostgreSQLКлиентСервер.ПодготовитьКолонкиТаблицыДляПомещенияВоВременнуюТаблицу(ИсходныеДанные, ПараметрыПомещения, СтруктураТаблицыИзБД, ТекстОшибок, Кэш);
	Если СоответствиеКолонок = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПередаватьЧерезФайлы = Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.ЛучшеПередаватьЧерезФайлы(ИсходныеДанные);
	ОбещаниеСозданиеПотока = Неопределено;
	
	Если ПередаватьЧерезФайлы Тогда
		ОбещаниеСозданиеПотока = Спец_ОбщегоНазначенияКлиент.ПодготовитьФайловыйПотокСИменемФайлаАсинх();
	КонецЕсли;
	
	СтруктураТекстовЗапросов = Спец_PostgreSQLКлиентСервер.СформироватьТекстыЗапросовДляПомещенияВоВременнуюТаблицу(ПараметрыПомещения, СоответствиеКолонок, СтруктураТаблицыИзБД, ТекстОшибок, Кэш);
	
	ПотокДляЗаписи = Неопределено; // ФайловыйПоток;
	Если ПередаватьЧерезФайлы Тогда

		ПотокДляЗаписи = Ждать ОбещаниеСозданиеПотока; // ФайловыйПоток
		ЗаписьJSON = Спец_ОбщегоНазначенияКлиентСервер.ПодготовитьЗаписьJSONПоПотоку(ПотокДляЗаписи);

	Иначе
		
		ЗаписьJSON = Спец_ОбщегоНазначенияКлиентСервер.ПодготовитьЗаписьJSONДляПреобразованияВСтроку();

	КонецЕсли;
	
	// 1. Создание временной таблицы
	ОбещаниеСозданиеВременнойТаблицы = Неопределено;
	Если Не ПустаяСтрока(СтруктураТекстовЗапросов.ТекстЗапросаСозданиеВременнойТаблицы) Тогда
		ОбещаниеСозданиеВременнойТаблицы = Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLВыполнитьЗапросБезРезультатаАсинх(СтруктураТекстовЗапросов.ТекстЗапросаСозданиеВременнойТаблицы, ТекстОшибок, Кэш);
	КонецЕсли;
	
	// 2. Готовим данные для передачи
	// Почему такой своеобразный код - см. Спец_PostgreSQLКлиентСервер.ПоместитьТаблицу1СВоВременнуюТаблицу
	Если ПередаватьЧерезФайлы Тогда
		
		Попытка
			
			Спец_PostgreSQLКлиентСервер.ЗаписатьДанныеДляПередачиВКомпоненту(ИсходныеДанные, ЗаписьJSON, СоответствиеКолонок, СтруктураТаблицыИзБД, Кэш);
			
		Исключение
			
			ПередаватьЧерезФайлы = Ложь;
			
			ЗаписьJSON.Закрыть();
			Спец_ОбщегоНазначенияКлиент.ЗакрытьПотокНеМешаяРаботеАсинх(ПотокДляЗаписи);
			
			ПотокДляЗаписи = Неопределено;
			
			ЗаписьJSON = Спец_ОбщегоНазначенияКлиентСервер.ПодготовитьЗаписьJSONДляПреобразованияВСтроку();
			Спец_PostgreSQLКлиентСервер.ЗаписатьДанныеДляПередачиВКомпоненту(ИсходныеДанные, ЗаписьJSON, СоответствиеКолонок, СтруктураТаблицыИзБД, Кэш);
			
		КонецПопытки;
		
	Иначе
		
		Спец_PostgreSQLКлиентСервер.ЗаписатьДанныеДляПередачиВКомпоненту(ИсходныеДанные, ЗаписьJSON, СоответствиеКолонок, СтруктураТаблицыИзБД, Кэш);
		
	КонецЕсли;
	
	Если ПередаватьЧерезФайлы Тогда
		
		ЗаписьJSON.Закрыть();
		ДанныеДляПередачи = ПотокДляЗаписи.ИмяФайла;
		
	Иначе
		
		ДанныеДляПередачи = ЗаписьJSON.Закрыть();
		
	КонецЕсли;
	
	// Завершаем создание временнной таблицы
	Если ОбещаниеСозданиеВременнойТаблицы <> Неопределено Тогда
		
		Успешно = Ждать ОбещаниеСозданиеВременнойТаблицы;
		Если Не Успешно Тогда
			
			Если ПередаватьЧерезФайлы Тогда
				Спец_ОбщегоНазначенияКлиент.ЗакрытьПотокНеМешаяРаботеАсинх(ПотокДляЗаписи, Ложь, Истина);
			КонецЕсли;
			
			Возврат Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПотокДляЗаписи <> Неопределено Тогда
		Ждать Спец_ОбщегоНазначенияКлиент.ЗакрытьПотокНеМешаяРаботеАсинх(ПотокДляЗаписи, Истина, Ложь);
	КонецЕсли;
	
	// 3. Передача данных
	Попытка
		
		Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLВставитьДанныеВТаблицуАсинх(
				СтруктураТекстовЗапросов.НаименованиеТаблицыДляВставкиДанных,
				ДанныеДляПередачи,
				СтрСоединить(Спец_РаботаСКоллекциямиКлиентСервер.ВыгрузитьМассивЗначений(СоответствиеКолонок, "Ключ"), ","),
				ПередаватьЧерезФайлы,
				Кэш);
		
	Исключение
		
		Если ПередаватьЧерезФайлы Тогда
			Спец_ОбщегоНазначенияКлиент.УдалитьФайлыНеМешаяРаботеАсинх(ДанныеДляПередачи);
		КонецЕсли;
		
		ОбещаниеОтменаТранзакции = Неопределено;
		Если ПараметрыПомещения.НачинатьТранзакцию Тогда
			ОбещаниеОтменаТранзакции = Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLОтменитьТранзакциюАсинх(Кэш);
		КонецЕсли;
		
		ТекстОшибки = СтрШаблон(
				"Не удалось передать данные в новую временную таблицу!
				|	Текст ошибки: %1",
				
				Спец_ОбщегоНазначенияКлиентСервер.ПодробноеПредставлениеОшибкиЧерезОбработкуОшибок(ИнформацияОбОшибке(), Символы.Таб));
		
		Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(
				ТекстОшибки,
				"Помещение таблицы во временную таблицу в PostgreSQL -> Вставка данных в таблицу",
				ТекстОшибок);
		
		Ждать ОбещаниеОтменаТранзакции;
		Возврат Неопределено;
		
	КонецПопытки;
	
	Если ПередаватьЧерезФайлы Тогда
		Спец_ОбщегоНазначенияКлиент.УдалитьФайлыНеМешаяРаботеАсинх(ДанныеДляПередачи);
	КонецЕсли;
	
	// 4. Формирование готовой таблицы
	Если Не ПустаяСтрока(СтруктураТекстовЗапросов.ТекстЗапросаСозданиеГотовойТаблицы) Тогда
		
		Успешно = Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLВыполнитьЗапросБезРезультатаАсинх(СтруктураТекстовЗапросов.ТекстЗапросаСозданиеГотовойТаблицы, ТекстОшибок, Кэш);
		Если Не Успешно Тогда
			
			Если ПараметрыПомещения.НачинатьТранзакцию Тогда
				Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLОтменитьТранзакциюАсинх(Кэш);
			КонецЕсли;
			
			Возврат Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// 5. Если требуется анализ - делаем это
	Если СтруктураТекстовЗапросов.ТребуетсяАнализ Тогда
		
		Успешно = Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLВыполнитьЗапросБезРезультатаАсинх("ANALYZE " + ПараметрыПомещения.ИмяВременнойТаблицы, ТекстОшибок, Кэш);
		Если Не Успешно Тогда
			
			Если ПараметрыПомещения.НачинатьТранзакцию Тогда
				Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLОтменитьТранзакциюАсинх(Кэш);
			КонецЕсли;
			
			Возврат Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// 6. Возврат готовой структуры
	//@skip-check constructor-function-return-section
	Возврат Новый Структура("ИмяТаблицы, СоответствиеПолей", ПараметрыПомещения.ИмяВременнойТаблицы, СоответствиеКолонок);

#Иначе
	
	ВызватьИсключение "Недоступно на веб-клиенте!";
	
#КонецЕсли

КонецФункции

// Асинхронный вариант (см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.НайтиСоздатьОбъектыВБазеДанных
// 
// Параметры:
//  ИсходныеДанные - см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.НайтиСоздатьОбъектыВБазеДанных.ИсходныеДанные
//  СтруктураПараметров - см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.НайтиСоздатьОбъектыВБазеДанных.СтруктураПараметров
//  ТекстОшибок - см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.НайтиСоздатьОбъектыВБазеДанных.ТекстОшибок
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
// 
// Возвращаемое значение:
//  см. Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLВыполнитьЗапросАсинх
//
Асинх Функция НайтиСоздатьОбъектыВPostgreSQLАсинх(Знач ИсходныеДанные, Знач СтруктураПараметров, ТекстОшибок, Знач Кэш) Экспорт
	
	ТипИсходныхДанных = ТипЗнч(ИсходныеДанные);
	
	ЭтоТаблицаЗначений = Спец_РаботаСКоллекциямиКлиентСервер.ЭтоТаблицаЗначений(ИсходныеДанные, ТипИсходныхДанных);
	Если Не ЭтоТаблицаЗначений И Не Спец_РаботаСКоллекциямиКлиентСервер.ЭтоМассив(ИсходныеДанные, ТипИсходныхДанных) Тогда
		
		ТекстОшибки = "Некорректные входные данные! Могу читать только таблицу значений или массив структур / соответствий!";
		Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(
				ТекстОшибки,
				"Найти / создать объекты в PostgreSQL",
				ТекстОшибок);
		
		Возврат Новый Структура("Успешно, ТекстОшибки, РезультатЗапроса", Ложь, ТекстОшибки, Новый Массив());
		
	КонецЕсли;
	
	// 0. Подготовим поля для связи ссылок, если есть ТЧ
	ОжиданиеПроставитьУникальныеИдентификаторы = Неопределено; // Обещание
	
	МассивТабличныхЧастей = Спец_PostgreSQLКлиентСервер.ПодготовитьТабличныеЧастиДляЗаписиНапрямую(СтруктураПараметров, ИсходныеДанные, ЭтоТаблицаЗначений, ТекстОшибок, Кэш);
	Если МассивТабличныхЧастей.Количество() Тогда
		ОжиданиеПроставитьУникальныеИдентификаторы = ПроставитьУникальныеИдентификаторыДляСвязиСТабличнымиЧастямиАсинх(ИсходныеДанные, ЭтоТаблицаЗначений, Кэш);
	КонецЕсли;
	
	// 1. Помещаем исходные данные во временную таблицу
	ПараметрыПомещения = Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.ПодготовитьСтруктуруПараметровПомещениеДанныхВоВременнуюТаблицу();
	ПараметрыПомещения.ИмяМетаданныхИз1С = СтруктураПараметров.ИмяМетаданныхВ1С;
	ПараметрыПомещения.ИмяВременнойТаблицы = ПараметрыПомещения.ИмяМетаданныхИз1С;
	
	Для Каждого СтруктураПоля Из СтруктураПараметров.ПоляДляСвязи Цикл
		ПараметрыПомещения.МассивПолейДляИндекса.Добавить(СтруктураПоля.ИмяВ1С);
	КонецЦикла;
	
	ПараметрыПомещения.МассивПолейДляИндекса = Спец_РаботаСКоллекциямиКлиентСервер.СвернутьМассив(ПараметрыПомещения.МассивПолейДляИндекса);
	
	Если ОжиданиеПроставитьУникальныеИдентификаторы <> Неопределено Тогда
		Ждать ОжиданиеПроставитьУникальныеИдентификаторы;
	КонецЕсли;
	
	ОжиданиеРезультатПомещения = ПоместитьТаблицу1СВоВременнуюТаблицуАсинх(ИсходныеДанные, ПараметрыПомещения, ТекстОшибок, Кэш);
	
	// 2. Формируем текст запроса
	СтруктураДополнительныеПараметры = Спец_PostgreSQLКлиентСервер.НоваяСтруктураДополнительныхПараметров(ЭтоТаблицаЗначений, "", МассивТабличныхЧастей);
	
	СтруктураРезультатПомещения = Ждать ОжиданиеРезультатПомещения;
	Если СтруктураРезультатПомещения = Неопределено Тогда
		Возврат Новый Структура("Успешно, ТекстОшибки, РезультатЗапроса", Ложь, "", Новый Массив());
	КонецЕсли;
	
	ТекстЗапроса = Спец_PostgreSQLКлиентСервер.СформироватьТекстЗапросаДляПоискаЗаписиОбъектовНапрямую(СтруктураПараметров,
			СтруктураРезультатПомещения,
			СтруктураДополнительныеПараметры,
			ТекстОшибок,
			Кэш);
	
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		
		ОжиданиеЗавершениеТранзакции = Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLОтменитьТранзакциюАсинх(Кэш);
		
		ТекстОшибки = "Не удалось сформировать текст запроса!";
		Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(ТекстОшибки,
														 "Найти / создать объекты напрямую (PostgreSQL)",
														 ТекстОшибок);
		
		Ждать ОжиданиеЗавершениеТранзакции;
		Возврат Новый Структура("Успешно, ТекстОшибки, РезультатЗапроса", Ложь, ТекстОшибки, Новый Массив());
		
	КонецЕсли;
	
	// 3. Выполняем запрос
	СтруктураРезультат = Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLВыполнитьЗапросАсинх(ТекстЗапроса, , , Кэш);
	Если Не СтруктураРезультат.Успешно Тогда
		
		ОжиданиеЗавершениеТранзакции = Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLОтменитьТранзакциюАсинх(Кэш);
		Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку("Не удалось выполнить запрос!" + Символы.ПС + СтруктураРезультат.ТекстОшибки,
														 "Найти / создать объекты напрямую (PostgreSQL)",
														 ТекстОшибок);
		
		Ждать ОжиданиеЗавершениеТранзакции;
		Возврат СтруктураРезультат;
		
	КонецЕсли;
	
	// Чтобы не висело в блоке до завершения транзакции. Ничего страшного не будет, если запишется только ссылка без ТЧ.
	УспешноЗафиксирована = Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLЗафиксироватьТранзакциюАсинх(Кэш);
	Если Не УспешноЗафиксирована Тогда
		
		СтруктураРезультат.Успешно = Ложь;
		СтруктураРезультат.ТекстОшибки = "Не удалось зафиксировать транзакцию!";
		
		Возврат СтруктураРезультат;

	КонецЕсли;
	
	// 4. Проходим табличные части
	Если СтруктураПараметров.ТипОбновления <> ПредопределенноеЗначение("Перечисление.Спец_ТипыОбновленияТаблицыБазыДанных.НайтиНеОбновлятьНеСоздавать") Тогда
		Ждать ПройтиТабличныеЧастиПослеЗаписиНапрямуюАсинх(СтруктураРезультат, ИсходныеДанные, СтруктураПараметров, СтруктураДополнительныеПараметры, МассивТабличныхЧастей, ТекстОшибок, Кэш);
	КонецЕсли;
	
	Возврат СтруктураРезультат;

КонецФункции

// см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.УдалитьДанныеПоОбъекту1СВБазеДанных
//
// Параметры:
//  ИсходныеДанные - см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.УдалитьДанныеПоОбъекту1СВБазеДанных.ИсходныеДанные
//  ИмяМетаданныхИз1С - Строка
//  ТекстОшибок - см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.УдалитьДанныеПоОбъекту1СВБазеДанных.ТекстОшибок
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
// 
// Возвращаемое значение:
//  см. Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.УдалитьДанныеПоОбъекту1СВБазеДанных
//
Асинх Функция УдалитьДанныеПоОбъекту1СВБазеДанныхАсинх(Знач ИсходныеДанные, Знач ИмяМетаданныхИз1С, ТекстОшибок, Знач Кэш) Экспорт
	
	Спец_РаботаСКоллекциямиКлиентСервер.ЗначениеВМассив(ИсходныеДанные);

	СтруктураОсновнойТаблицы = Спец_PostgreSQLВызовСервераПовтИсп.ПолучитьСтруктуруТаблицыПоИмениМетаданных(ИмяМетаданныхИз1С);
	Если ПустаяСтрока(СтруктураОсновнойТаблицы.НаименованиеВPostgreSQL) Тогда
		
		ТекстОшибки = "Не удалось найти параметры таблицы в БД по таблице " + ИмяМетаданныхИз1С;
		Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(ТекстОшибки,
														 "Удалить данные по объекту (PostgreSQL)",
														 ТекстОшибок);
		
		Возврат Ложь;

	КонецЕсли;

	МассивТаблицДляОчистки = Спец_РаботаСКоллекциямиКлиентСервер.ЗначениеВМассиве(СтруктураОсновнойТаблицы); // Массив из см. Спец_PostgreSQLВызовСервераПовтИсп.ПолучитьСтруктуруТаблицыПоИмениМетаданных
	
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		МассивТЧ = Спец_ОбщегоНазначенияВызовСервера.ПолучитьМассивИменТабличныхЧастей(ИмяМетаданныхИз1С);
	#Иначе
		МассивТЧ = Спец_ОбщегоНазначения.ПолучитьМассивИменТабличныхЧастей(ИмяМетаданныхИз1С, Кэш);
	#КонецЕсли
	
	Для Каждого ИмяТабличнойЧасти Из МассивТЧ Цикл
		
		СтруктураТаблицы = Спец_PostgreSQLВызовСервераПовтИсп.ПолучитьСтруктуруТаблицыПоИмениМетаданных(ИмяМетаданныхИз1С + "." + ИмяТабличнойЧасти);
		Если Не ПустаяСтрока(СтруктураТаблицы.НаименованиеВPostgreSQL) Тогда
			МассивТаблицДляОчистки.Добавить(СтруктураТаблицы);
		КонецЕсли;

	КонецЦикла;

	Если ИсходныеДанные.Количество() = 0 Тогда

		МассивИменаТаблиц = Новый Массив(); // Массив из Строка
		Для Каждого СтруктураТаблицы Из МассивТаблицДляОчистки Цикл
			МассивИменаТаблиц.Добавить(СтруктураТаблицы.НаименованиеВPostgreSQL);
		КонецЦикла;
		
		Возврат Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLВыполнитьЗапросБезРезультатаАсинх("TRUNCATE " + СтрСоединить(МассивИменаТаблиц, ","), ТекстОшибок, Кэш);
		
	КонецЕсли;
	
	ПараметрыПомещения = Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.ПодготовитьСтруктуруПараметровПомещениеДанныхВоВременнуюТаблицу();
	ПараметрыПомещения.ИмяМетаданныхИз1С = ИмяМетаданныхИз1С;
	ПараметрыПомещения.ИмяВременнойТаблицы = ПараметрыПомещения.ИмяМетаданныхИз1С;
	
	СтруктураРезультатПомещения = Ждать ПоместитьТаблицу1СВоВременнуюТаблицуАсинх(ИсходныеДанные, ПараметрыПомещения, ТекстОшибок, Кэш);
	Если СтруктураРезультатПомещения = Неопределено Или ПустаяСтрока(СтруктураРезультатПомещения.ИмяТаблицы) Тогда
		
		Спец_ЗаписатьЛог("Удаление объектов через PostgreSQL",
				ПредопределенноеЗначение("Перечисление.Спец_УровниЛогирования.Ошибка"),
				ТекстОшибок,
				Кэш);
		
		Возврат Ложь;
		
	КонецЕсли;

	ГотовыйТекстЗапроса = Спец_PostgreSQLКлиентСервер.СформироватьТекстЗапросаДляУдаленияДанных(МассивТаблицДляОчистки, СтруктураРезультатПомещения);
	
	УспешноВыполнено = Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLВыполнитьЗапросБезРезультатаАсинх(ГотовыйТекстЗапроса, ТекстОшибок, Кэш);
	Если Не УспешноВыполнено Тогда
		
		Спец_ЗаписатьЛог("Удаление объектов через PostgreSQL",
				ПредопределенноеЗначение("Перечисление.Спец_УровниЛогирования.Ошибка"),
				ТекстОшибок,
				Кэш);
		
		Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLОтменитьТранзакциюАсинх(Кэш);
		Возврат Ложь;
		
	Иначе
		
		Возврат Истина;
	
	КонецЕсли;

КонецФункции

// -- Спец_БСП.Версия1С_18_ВышеИлиРавно

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//@skip-check function-should-return-value
//
// Параметры:
//  ИсходныеДанные - см. НайтиСоздатьОбъектыВPostgreSQLАсинх.ИсходныеДанные
//  ЭтоТаблицаЗначений - Булево
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
// 
// Возвращаемое значение:
//  Неопределено
//
Асинх Функция ПроставитьУникальныеИдентификаторыДляСвязиСТабличнымиЧастямиАсинх(Знач ИсходныеДанные, Знач ЭтоТаблицаЗначений, Знач Кэш)
	
	Если ЭтоТаблицаЗначений Тогда
		
		ИсходныеДанные.Колонки.Добавить(Спец_PostgreSQLКлиентСервер.ИмяПоляДляСвязиСТабличнымиЧастями(), Спец_ОбщегоНазначенияКлиентСервер.ОписаниеТипаСтрока(36));
		Для Каждого ИсходнаяСтрока Из ИсходныеДанные Цикл
			//@skip-check property-return-type
			ИсходнаяСтрока[Спец_PostgreSQLКлиентСервер.ИмяПоляДляСвязиСТабличнымиЧастями()] = Ждать Спец_КомпонентаДополнительныеФункцииКлиент.ПолучитьУникальныйИдентификаторАсинх(Кэш);
		КонецЦикла;

	Иначе

		Для Каждого ИсходнаяСтрока Из ИсходныеДанные Цикл
			ИсходнаяСтрока.Вставить(Спец_PostgreSQLКлиентСервер.ИмяПоляДляСвязиСТабличнымиЧастями(), Ждать Спец_КомпонентаДополнительныеФункцииКлиент.ПолучитьУникальныйИдентификаторАсинх(Кэш));
		КонецЦикла;

	КонецЕсли;
	
КонецФункции

//@skip-check structure-consructor-value-type
//@skip-check property-return-type
//
// Параметры:
//  СтруктураОбщийРезультат - см. Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLВыполнитьЗапросАсинх
//  ИсходныеДанные - см. НайтиСоздатьОбъектыВPostgreSQLАсинх.ИсходныеДанные
//  СтруктураПараметров - см. НайтиСоздатьОбъектыВPostgreSQLАсинх.СтруктураПараметров
//  СтруктураДополнительныеПараметры - см. Спец_PostgreSQLКлиентСервер.НоваяСтруктураДополнительныхПараметров
//  МассивТабличныхЧастей - Массив из Строка
//  ТекстОшибок - см. НайтиСоздатьОбъектыВPostgreSQLАсинх.ТекстОшибок
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
//
// Возвращаемое значение:
//  Неопределено
//
Асинх Функция ПройтиТабличныеЧастиПослеЗаписиНапрямуюАсинх(Знач СтруктураОбщийРезультат, Знач ИсходныеДанные, Знач СтруктураПараметров, Знач СтруктураДополнительныеПараметры,
		Знач МассивТабличныхЧастей, ТекстОшибок, Знач Кэш)
	
	Если МассивТабличныхЧастей.Количество() = 0 Или СтруктураОбщийРезультат.РезультатЗапроса.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Для Каждого ИмяТабличнойЧасти Из МассивТабличныхЧастей Цикл
		
		МассивДанныхДляЗапроса = Спец_PostgreSQLКлиентСервер.СформироватьМассивДанныхДляОтправкиПоТабличнойЧасти(СтруктураОбщийРезультат,
				ИсходныеДанные,
				СтруктураПараметров,
				СтруктураДополнительныеПараметры,
				ИмяТабличнойЧасти,
				Кэш);
		
		Если МассивДанныхДляЗапроса.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураПараметровПоТабличнойЧасти = Спец_PostgreSQLКлиентСервер.ПодготовитьСтруктуруПараметровДляЗаписиВPostgreSQL(СтруктураПараметров.ИмяМетаданныхВ1С + "." + ИмяТабличнойЧасти);
		СтруктураПараметровПоТабличнойЧасти.ВозвращатьРезультат = Ложь;
		
		СтруктураПоляДляСвязи = Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.ПолучитьСтруктуруПоляДляСвязиДляЗаписи(СтруктураПараметровПоТабличнойЧасти.ИмяМетаданныхВ1С, "Ссылка");
		
		СтруктураПараметровПоТабличнойЧасти.ПоляДляПроверкиКонфликтов.Добавить(СтруктураПоляДляСвязи.ИмяСтолбцаВБД);
		СтруктураПараметровПоТабличнойЧасти.ПоляДляПроверкиКонфликтов.Добавить("_keyfield");
		
		ПараметрыПомещенияТабличнойЧасти = Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.ПодготовитьСтруктуруПараметровПомещениеДанныхВоВременнуюТаблицу();
		ПараметрыПомещенияТабличнойЧасти.ИмяМетаданныхИз1С = СтруктураПараметровПоТабличнойЧасти.ИмяМетаданныхВ1С;
		ПараметрыПомещенияТабличнойЧасти.ИмяВременнойТаблицы = ПараметрыПомещенияТабличнойЧасти.ИмяМетаданныхИз1С;
		
		ПараметрыПомещенияТабличнойЧасти.МассивПолейДляИндекса.Добавить("Ссылка");
		
		СтруктураРезультатПомещенияПоТабличнойЧасти = Ждать ПоместитьТаблицу1СВоВременнуюТаблицуАсинх(МассивДанныхДляЗапроса, ПараметрыПомещенияТабличнойЧасти, ТекстОшибок, Кэш);
		Если СтруктураРезультатПомещенияПоТабличнойЧасти = Неопределено Тогда
			
			СтруктураОбщийРезультат.Успешно = Ложь;
			Возврат Неопределено;
			
		КонецЕсли;
		
		СтруктураДополнительныеПараметрыПоТабличнойЧасти = Спец_PostgreSQLКлиентСервер.НоваяСтруктураДополнительныхПараметров(Ложь, ИмяТабличнойЧасти, Новый Массив());
		ТекстЗапроса = Спец_PostgreSQLКлиентСервер.СформироватьТекстЗапросаДляПоискаЗаписиОбъектовНапрямую(СтруктураПараметровПоТабличнойЧасти,
				СтруктураРезультатПомещенияПоТабличнойЧасти,
				СтруктураДополнительныеПараметрыПоТабличнойЧасти,
				ТекстОшибок,
				Кэш);
		
		Если ПустаяСтрока(ТекстЗапроса) Тогда
			
			ОбещаниеОтменаТранзакции = Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLОтменитьТранзакциюАсинх(Кэш);
			
			ТекстОшибки = "Не удалось сформировать текст запроса для ТЧ " + ИмяТабличнойЧасти;
			Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(ТекстОшибки,
															 "Найти / создать объекты напрямую (PostgreSQL)",
															 ТекстОшибок);
			
			СтруктураОбщийРезультат.Успешно = Ложь;
			
			Ждать ОбещаниеОтменаТранзакции;
			Возврат Неопределено;
			
		КонецЕсли;
		
		СтруктураРезультат = Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLВыполнитьЗапросАсинх(ТекстЗапроса, , , Кэш);
		Если Не СтруктураРезультат.Успешно Тогда
			
			ОбещаниеОтменаТранзакции = Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLОтменитьТранзакциюАсинх(Кэш);
			
			Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку("Не удалось выполнить запрос!" + Символы.ПС + СтруктураРезультат.ТекстОшибки,
															 "Найти / создать объекты напрямую (PostgreSQL)",
															 ТекстОшибок);
			
			СтруктураОбщийРезультат.Успешно = Ложь;
			
			Ждать ОбещаниеОтменаТранзакции;
			Возврат Неопределено;
			
		КонецЕсли;
		
		ТранзакцияЗафиксирована = Ждать Спец_КомпонентаДополнительныеФункцииКлиент.PostgreSQLЗафиксироватьТранзакциюАсинх(Кэш);
		Если Не ТранзакцияЗафиксирована Тогда
			
			// Чтобы не висело в блоке до завершения транзакции. Ничего страшного не будет, если запишется только ссылка без ТЧ.
			
			СтруктураОбщийРезультат.Успешно = Ложь;
			СтруктураОбщийРезультат.ТекстОшибки = "Не удалось зафиксировать транзакцию!";
			
			Возврат Неопределено;
	
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

#КонецОбласти

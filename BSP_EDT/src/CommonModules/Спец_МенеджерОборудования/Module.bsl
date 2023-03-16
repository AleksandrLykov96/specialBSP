// @strict-types

#Область ПрограммныйИнтерфейс

// Массив структур оборудования по отборам
// 
// Параметры:
//  МассивТиповПО - Массив из ПеречислениеСсылка.Спец_ТипыПодключаемогоОборудования - Массив типов ПО (для отбора)
//  ИдентификаторУстройства - СправочникСсылка.Спец_ПодключаемоеОборудование - Идентификатор устройства (для отбора)
//  РабочееМесто - СправочникСсылка.Спец_РабочиеМеста - Рабочее место (для отбора)
// 
// Возвращаемое значение:
//  Массив из см. НоваяСтруктураОборудования - Массив структур оборудования по отборам
//
Функция МассивСтруктурОборудованияПоПараметрам(Знач МассивТиповПО = Неопределено, Знач ИдентификаторУстройства = Неопределено, Знач РабочееМесто = Неопределено) Экспорт
	
	МассивРезультат = Новый Массив; // см. МассивСтруктурОборудованияПоПараметрам
	
	ВыборкаРезультат = ПолучитьВыборкуПоСтруктурамОборудования(МассивТиповПО, ИдентификаторУстройства, РабочееМесто);
	Пока ВыборкаРезультат.Следующий() Цикл
		
		СтруктураОборудования = НоваяСтруктураОборудования();
		ЗаполнитьЗначенияСвойств(СтруктураОборудования, ВыборкаРезультат, , "Параметры");
		
		СтруктураОборудования.ИмяТипаОборудования = Спец_ОбщегоНазначения.ИмяПеречисленияВМетаданных(ВыборкаРезультат.ТипОборудования);
		
		ВыборкаПоПараметрам = ПолучитьВыборкуПоПараметрамПоВыборкеПоСтруктуреОборудования(ВыборкаРезультат);
		Пока ВыборкаПоПараметрам.Следующий() Цикл
			СтруктураОборудования.Параметры.Вставить(ВыборкаПоПараметрам.ИмяПараметра, ВыборкаПоПараметрам.ЗначениеПараметра);
		КонецЦикла;
		
		МассивРезультат.Добавить(СтруктураОборудования);
		
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции

// Структура параметров оборудования по идентификатору устройства.
// 
// Параметры:
//  ИдентификаторУстройства - СправочникСсылка.Спец_ПодключаемоеОборудование - Идентификатор устройства (для отбора)
// 
// Возвращаемое значение:
//  см. НоваяСтруктураОборудования
//
Функция СтруктураПараметровОборудования(Знач ИдентификаторУстройства) Экспорт
	
	МассивРезультат = МассивСтруктурОборудованияПоПараметрам(Новый Массив, ИдентификаторУстройства);
	//@skip-check constructor-function-return-section
	Возврат ?(МассивРезультат.Количество() > 0, МассивРезультат.Получить(0), НоваяСтруктураОборудования());
	
КонецФункции

// Структура параметров драйвера по ссылке драйвера оборудования
// 
// Параметры:
//  ДрайверОборудования - СправочникСсылка.Спец_ДрайверыОборудования
// 
// Возвращаемое значение:
//  Структура - Структура параметров драйвера:
//		* ИмяДрайвераОборудования - Строка
//		* ИдентификаторОбъекта - Строка
//		* ИмяМакетаДрайвера - Строка
//		* СпособПодключения - ПеречислениеСсылка.Спец_СпособыПодключенияДрайвера
//
Функция СтруктураДанныхПоДрайверуОборудования(Знач ДрайверОборудования) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДрайверыОборудования.Наименование КАК ИмяДрайвераОборудования,
	|	ДрайверыОборудования.ИдентификаторОбъекта КАК ИдентификаторОбъекта,
	|	ДрайверыОборудования.ТипОборудования КАК ТипОборудования,
	|	""ОбщийМакет."" + ДрайверыОборудования.ИмяМакетаДрайвера КАК ИмяМакетаДрайвера,
	|	ДрайверыОборудования.СпособПодключения КАК СпособПодключения
	|ИЗ
	|	Справочник.Спец_ДрайверыОборудования КАК ДрайверыОборудования
	|ГДЕ
	|	ДрайверыОборудования.Ссылка = &ДрайверОборудования";
	
	Запрос.УстановитьПараметр("ДрайверОборудования", ДрайверОборудования);
	
	//@skip-check constructor-function-return-section
	Возврат Спец_ОбщегоНазначения.ПолучитьСтруктуруПервойВыборкиЗапроса(Запрос);
	
КонецФункции

// Возвращает ссылку на рабочее место клиента по идентификатору
// 
// Параметры:
//  ИдентификаторКлиента - Строка - Идентификатор клиента (имя компьютера)
// 
// Возвращаемое значение:
//  СправочникСсылка.Спец_РабочиеМеста - Рабочее место
//
Функция РабочееМестоПоИдентификаторуКлиента(Знач ИдентификаторКлиента) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РабочиеМеста.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Спец_РабочиеМеста КАК РабочиеМеста
	|ГДЕ
	|	РабочиеМеста.ИмяКомпьютера = &ИдентификаторКлиента
	|	И НЕ РабочиеМеста.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ИдентификаторКлиента", ИдентификаторКлиента);
	Возврат Спец_ОбщегоНазначения.ПолучитьСтруктуруПервойВыборкиЗапроса(Запрос, "Ссылка");
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура для обновление драйверов, входящих в данную конфигурацию
// 
// Параметры:
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
//
Процедура ОбновитьПоставляемыеДрайвера(Кэш = Неопределено) Экспорт
	
	Если Кэш = Неопределено Тогда Кэш = Спец_ПолучитьКэш(); КонецЕсли;
	
	// ++ Спец_БСП.Спец_СканерыШтрихКода
	// Драйвер1ССканерыШтрихкодаNative
	Попытка
		
		СправочникОбъект = Спец_ОбщегоНазначения.ПолучитьОбъектСБлокированием(Справочники.Спец_ДрайверыОборудования.Драйвер1ССканерыШтрихкодаNative, Кэш);
		
	Исключение
		
		СправочникОбъект = Справочники.Спец_ДрайверыОборудования.СоздатьЭлемент();
		СправочникОбъект.ИмяПредопределенныхДанных = "Драйвер1ССканерыШтрихкодаNative";
		
	КонецПопытки;
	
	СправочникОбъект.Наименование         = "1С: Сканеры штрих-кода (Native Api)";
	СправочникОбъект.ТипОборудования      = Перечисления.Спец_ТипыПодключаемогоОборудования.СканерШтрихкода;
	СправочникОбъект.ИдентификаторОбъекта = "InputDevice";
	СправочникОбъект.ВерсияДрайвера       = "10.1.8.6";
	СправочникОбъект.СпособПодключения    = Перечисления.Спец_СпособыПодключенияДрайвера.ИзМакета;
	СправочникОбъект.ИмяМакетаДрайвера    = "Спец_Драйвер1СУстройстваВводаNative";
	
	Спец_ОбщегоНазначения.ЗаписатьОбъект(СправочникОбъект, , , , Кэш);
	// -- Спец_БСП.Спец_СканерыШтрихКода
	
	// ++ Спец_БСП.Спец_ЭквайринговыеТерминалы
	// Драйвер1СЭквайринговыеТерминалыСбербанк
	Попытка
		
		СправочникОбъект = Спец_ОбщегоНазначения.ПолучитьОбъектСБлокированием(Справочники.Спец_ДрайверыОборудования.Драйвер1СЭквайринговыеТерминалыСбербанк, Кэш);
		
	Исключение
		
		СправочникОбъект = Справочники.Спец_ДрайверыОборудования.СоздатьЭлемент();
		СправочникОбъект.ИмяПредопределенныхДанных = "Драйвер1СЭквайринговыеТерминалыСбербанк";
		
	КонецПопытки;
	
	СправочникОбъект.Наименование         = "1С: Эквайринговые терминалы Сбербанк (2.X)";
	СправочникОбъект.ТипОборудования      = Перечисления.Спец_ТипыПодключаемогоОборудования.ЭквайринговыйТерминал;
	СправочникОбъект.ИдентификаторОбъекта = "SberAcquiringTerminal2";
	СправочникОбъект.ВерсияДрайвера       = "2.3.6.3";
	СправочникОбъект.СпособПодключения    = Перечисления.Спец_СпособыПодключенияДрайвера.ИзМакета;
	СправочникОбъект.ИмяМакетаДрайвера    = "Спец_Драйвер1СЭквайринговыеТерминалыСбербанк";
	
	Спец_ОбщегоНазначения.ЗаписатьОбъект(СправочникОбъект, , , , Кэш);
	// -- Спец_БСП.Спец_ЭквайринговыеТерминалы
	
КонецПроцедуры

// Возвращает структуры драйверов для переустановки по рабочему месту (по признаку ТребуетсяПереустановка)
// 
// Параметры:
//  РабочееМесто - СправочникСсылка.Спец_РабочиеМеста - Рабочее место, для которого требуется переустановить драйвера
// 
// Возвращаемое значение:
//  Массив из см. НоваяСтруктураДрайвераДляПереустановки - Массив параметров драйверов для переустановки
//
Функция ДрайвераДляПереустановки(Знач РабочееМесто) Экспорт
	
	МассивРезультат = Новый Массив; // Массив из см. НоваяСтруктураДрайвераДляПереустановки
	
	ВыборкаРезультат = ПолучитьВыборкуПоДрайверамДляПереустановки(РабочееМесто);
	Пока ВыборкаРезультат.Следующий() Цикл
		
		СтруктураДляОбновления = НоваяСтруктураДрайвераДляПереустановки();
		ЗаполнитьЗначенияСвойств(СтруктураДляОбновления, СтруктураДанныхПоДрайверуОборудования(ВыборкаРезультат.ДрайверОборудования));
		
		СтруктураДляОбновления.ПодключаемоеОборудование = ВыборкаРезультат.ПодключаемоеОборудование;
		СтруктураДляОбновления.ДрайверОборудования      = ВыборкаРезультат.ДрайверОборудования;
		
		МассивРезультат.Добавить(СтруктураДляОбновления);
		
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции

// Устанавливает признак переустановки в элементе подключаемого оборудования
// 
// Параметры:
//  ПодключаемоеОборудование - СправочникСсылка.Спец_ПодключаемоеОборудование - Подключаемое оборудование, для которого необходимо установить признак переустновки
//  Признак - Булево - Флаг того, что требуется переустановка или нет.
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
//
Процедура УстановитьПризнакПереустановки(Знач ПодключаемоеОборудование, Знач Признак, Кэш = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ПодключаемоеОборудование) Тогда
		Возврат;
	КонецЕсли;
	
	ПодключаемоеОборудованиеОбъект = Спец_ОбщегоНазначения.ПолучитьОбъектСБлокированием(ПодключаемоеОборудование, Кэш); // СправочникОбъект.Спец_ПодключаемоеОборудование
	Если ПодключаемоеОборудованиеОбъект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПодключаемоеОборудованиеОбъект.ТребуетсяПереустановка = Признак;
	Спец_ОбщегоНазначения.ЗаписатьОбъект(ПодключаемоеОборудованиеОбъект, , , , Кэш);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  МассивТиповПО - см. МассивСтруктурОборудованияПоПараметрам.МассивТиповПО
//  ИдентификаторУстройства - см. МассивСтруктурОборудованияПоПараметрам.ИдентификаторУстройства
//  РабочееМесто - см. МассивСтруктурОборудованияПоПараметрам.РабочееМесто
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
//		* ИдентификаторУстройства - Строка
//		* Наименование - Строка
//		* ТипОборудования - ПеречислениеСсылка.Спец_ТипыПодключаемогоОборудования
//		* ДрайверОборудования - СправочникСсылка.Спец_ДрайверыОборудования
//		* ИдентификаторОбъекта - Строка
//		* НаименованиеДрайвераОборудования - Строка
//		* ИмяМакетаДрайвера - Строка
//		* СпособПодключения - ПеречислениеСсылка.Спец_СпособыПодключенияДрайвера
//		* РабочееМесто - СправочникСсылка.Спец_РабочиеМеста
// 		* ИмяКомпьютера - Строка
// 		* Параметры - РезультатЗапроса
//
Функция ПолучитьВыборкуПоСтруктурамОборудования(Знач МассивТиповПО, Знач ИдентификаторУстройства, Знач РабочееМесто)

	ПостроительЗапроса = Новый ПостроительЗапроса(
			
			"ВЫБРАТЬ
			|	ПодключаемоеОборудование.Ссылка КАК ИдентификаторУстройства,
			|	ПодключаемоеОборудование.Наименование КАК Наименование,
			|	ДрайверыОборудования.ТипОборудования КАК ТипОборудования,
			|	ПодключаемоеОборудование.ДрайверОборудования КАК ДрайверОборудования,
			|	ДрайверыОборудования.Наименование КАК НаименованиеДрайвераОборудования,
			|	ДрайверыОборудования.ИдентификаторОбъекта КАК ИдентификаторОбъекта,
			|	""ОбщийМакет."" + ДрайверыОборудования.ИмяМакетаДрайвера КАК ИмяМакетаДрайвера,
			|	ДрайверыОборудования.СпособПодключения КАК СпособПодключения,
			|	ПодключаемоеОборудование.РабочееМесто КАК РабочееМесто,
			|	РабочиеМеста.ИмяКомпьютера КАК ИмяКомпьютера,
			|	ПодключаемоеОборудование.ДополнительныеПараметры.(
			|		ИмяПараметра КАК ИмяПараметра,
			|		ЗначениеПараметра КАК ЗначениеПараметра
			|	) КАК Параметры
			|ИЗ
			|	Справочник.Спец_ПодключаемоеОборудование КАК ПодключаемоеОборудование
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Спец_ДрайверыОборудования КАК ДрайверыОборудования
			|		ПО ПодключаемоеОборудование.ДрайверОборудования = ДрайверыОборудования.Ссылка
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Спец_РабочиеМеста КАК РабочиеМеста
			|		ПО ПодключаемоеОборудование.РабочееМесто = РабочиеМеста.Ссылка
			|ГДЕ
			|	ПодключаемоеОборудование.УстройствоИспользуется
			|	И НЕ ПодключаемоеОборудование.ПометкаУдаления");
	
	ПостроительЗапроса.ЗаполнитьНастройки();
	
	// Массив типов ПО
	Спец_РаботаСКоллекциямиКлиентСервер.ЗначениеВМассив(МассивТиповПО);
	Если МассивТиповПО.Количество() > 0 Тогда
		
		СписокОтбор = Новый СписокЗначений;
		СписокОтбор.ЗагрузитьЗначения(МассивТиповПО);
		
		ЭлементОтбор = ПостроительЗапроса.Отбор.Добавить("ТипОборудования");
		ЭлементОтбор.Использование = Истина;
		ЭлементОтбор.ВидСравнения  = ВидСравнения.ВСписке;
		ЭлементОтбор.Значение      = СписокОтбор;
		
	КонецЕсли;
	
	// ИдентификаторУстройства
	Если ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		
		ЭлементОтбор = ПостроительЗапроса.Отбор.Добавить("ИдентификаторУстройства");
		ЭлементОтбор.Использование = Истина;
		ЭлементОтбор.ВидСравнения  = ВидСравнения.Равно;
		ЭлементОтбор.Значение      = ИдентификаторУстройства;
		
	КонецЕсли;
	
	// Рабочее место
	Если ЗначениеЗаполнено(РабочееМесто) Тогда
		
		ЭлементОтбор = ПостроительЗапроса.Отбор.Добавить("РабочееМесто");
		ЭлементОтбор.Использование = Истина;
		ЭлементОтбор.ВидСравнения  = ВидСравнения.Равно;
		ЭлементОтбор.Значение      = РабочееМесто;
		
	КонецЕсли;
	
	Возврат ПостроительЗапроса.ПолучитьЗапрос().Выполнить().Выбрать();

КонецФункции

// Параметры:
//  ВыборкаПоСтруктурам - см. ПолучитьВыборкуПоСтруктурамОборудования
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
//		* ИмяПараметра - Строка
//		* ЗначениеПараметра - Булево, Строка, Число -
//
Функция ПолучитьВыборкуПоПараметрамПоВыборкеПоСтруктуреОборудования(Знач ВыборкаПоСтруктурам)

	Возврат ВыборкаПоСтруктурам.Параметры.Выбрать();

КонецФункции

// Параметры:
//  РабочееМесто - см. ДрайвераДляПереустановки.РабочееМесто
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
//		* ПодключаемоеОборудование - СправочникСсылка.Спец_ПодключаемоеОборудование
//		* ДрайверОборудования - СправочникСсылка.Спец_ДрайверыОборудования
//
Функция ПолучитьВыборкуПоДрайверамДляПереустановки(Знач РабочееМесто)

	Запрос = Новый Запрос;
	Запрос.Текст =
	
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПодключаемоеОборудование.Ссылка КАК ПодключаемоеОборудование,
	|	ПодключаемоеОборудование.ДрайверОборудования КАК ДрайверОборудования
	|ИЗ
	|	Справочник.Спец_ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.РабочееМесто = &РабочееМесто
	|	И ПодключаемоеОборудование.ТребуетсяПереустановка
	|	И НЕ ПодключаемоеОборудование.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
	
	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

//@skip-check structure-consructor-too-many-keys
#Область Типизация

// Возвращаемое значение:
//  Структура:
//		* ИдентификаторУстройства - СправочникСсылка.Спец_ПодключаемоеОборудование
//		* Наименование - Строка
//		* ТипОборудования - ПеречислениеСсылка.Спец_ТипыПодключаемогоОборудования
//		* ИмяТипаОборудования - Строка
//		* ДрайверОборудования - СправочникСсылка.Спец_ДрайверыОборудования
//		* ИдентификаторОбъекта - Строка
//		* НаименованиеДрайвераОборудования - Строка
//		* ИмяМакетаДрайвера - Строка
//		* СпособПодключения - ПеречислениеСсылка.Спец_СпособыПодключенияДрайвера
//		* РабочееМесто - СправочникСсылка.Спец_РабочиеМеста
//		* ИмяКомпьютера - Строка
//		* Параметры - Структура из КлючИЗначение:
//			** Ключ - Строка
//			** Значение - Булево, Строка, Число -
//
Функция НоваяСтруктураОборудования() Экспорт
	
	Возврат Новый Структура(
			
			"ИдентификаторУстройства,
			|Наименование,
			|ТипОборудования,
			|ИмяТипаОборудования,
			|ДрайверОборудования,
			|ИдентификаторОбъекта,
			|НаименованиеДрайвераОборудования,
			|ИмяМакетаДрайвера,
			|СпособПодключения,
			|РабочееМесто,
			|ИмяКомпьютера,
			|Параметры",
			
			Справочники.Спец_ПодключаемоеОборудование.ПустаяСсылка(),
			"",
			Перечисления.Спец_ТипыПодключаемогоОборудования.ПустаяСсылка(),
			"",
			Справочники.Спец_ДрайверыОборудования.ПустаяСсылка(),
			"",
			"",
			"",
			Перечисления.Спец_СпособыПодключенияДрайвера.ПустаяСсылка(),
			Справочники.Спец_РабочиеМеста.ПустаяСсылка(),
			"",
			Новый Структура());
				
КонецФункции

// Возвращаемое значение:
//  Структура:
//		* ИмяДрайвераОборудования - Строка
//		* ИдентификаторОбъекта - Строка
//		* ИмяМакетаДрайвера - Строка
//		* СпособПодключения - ПеречислениеСсылка.Спец_СпособыПодключенияДрайвера
//		* ПодключаемоеОборудование - СправочникСсылка.Спец_ПодключаемоеОборудование
//		* ДрайверОборудования - СправочникСсылка.Спец_ДрайверыОборудования
//
Функция НоваяСтруктураДрайвераДляПереустановки()
	
	Возврат Новый Структура(
	
			"ИмяДрайвераОборудования,
			|ИдентификаторОбъекта,
			|ИмяМакетаДрайвера,
			|СпособПодключения,
			|ПодключаемоеОборудование,
			|ДрайверОборудования",
			
			"",
			"",
			"",
			Перечисления.Спец_СпособыПодключенияДрайвера.ПустаяСсылка(),
			Справочники.Спец_ПодключаемоеОборудование.ПустаяСсылка(),
			Справочники.Спец_ДрайверыОборудования.ПустаяСсылка());
	
КонецФункции

#КонецОбласти

#КонецОбласти

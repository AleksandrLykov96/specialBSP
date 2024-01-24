// @strict-types
//@skip-check common-module-type

#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
//  Хост - Строка
//  Порт - Число
//  Логин - Строка
//  Пароль - Строка
//  Таймаут - Число
// 
// Возвращаемое значение:
//  Неопределено, FTPСоединение - 
Функция FTPСоединение(Знач Хост, Знач Порт, Знач Логин, Знач Пароль, Знач Таймаут) Экспорт
	
	#Если Не ВебКлиент Тогда
		
		Попытка
			
			Возврат Новый FTPСоединение(Хост, Порт, Логин, Пароль, , Истина, Таймаут);
			
		Исключение
			
			ШаблонСообщения = "Не удалось подключить FTP ""%1""!%2%3";
			ТекстСообщения  = СтрШаблон(ШаблонСообщения,
					Хост,
					Символы.ПС,
					Спец_ОбщегоНазначенияКлиентСервер.ПодробноеПредставлениеОшибкиЧерезОбработкуОшибок(ИнформацияОбОшибке(), Символы.Таб));
			
			Спец_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Неопределено;
			
		КонецПопытки;
		
	#Иначе
		
		Возврат Неопределено;
		
	#КонецЕсли
	
КонецФункции

// Возвращаемое значение:
//  Строка
Функция ПодготовитьУникальноеИмяНаВремяСеанса() Экспорт
	
	Возврат Спец_СтроковыеФункцииКлиентСервер.ОчиститьИмяДляЗапроса(Строка(Новый УникальныйИдентификатор()));
	
КонецФункции

// Возвращаемое значение:
//  Строка
Функция ПодготовитьУникальноеИмяНаВремяРаботыРабочегоПроцесса() Экспорт
	
	PID = Спец_ОбщегоНазначенияКлиентСервер.PIDТекущегоПроцесса();
	Возврат ?(ПустаяСтрока(PID),
			Спец_ОбщегоНазначенияКлиентСерверПовтИсп.ПодготовитьУникальноеИмяНаВремяСеанса(),
			Спец_СтроковыеФункцииКлиентСервер.ОчиститьИмяДляЗапроса(PID));
	
КонецФункции

//@skip-check method-too-many-params
//
// Параметры:
//  Хост - Строка
//  Порт - Число
//  Логин - Строка
//  Пароль - Строка
//  Таймаут - Число
//  ИспользоватьЗащищенноеСоединение - Булево
// 
// Возвращаемое значение:
//  HTTPСоединение
Функция КэшированноеHTTPСоединение(Знач Хост, Знач Порт, Знач Логин = "", Знач Пароль = "", Знач Таймаут = 0, Знач ИспользоватьЗащищенноеСоединение = Ложь) Экспорт
	
	Возврат Новый HTTPСоединение(Хост,
			Порт,
			Логин,
			Пароль,
			,
			Таймаут,
			?(ИспользоватьЗащищенноеСоединение, Новый ЗащищенноеСоединениеOpenSSL(), Неопределено));
	
КонецФункции

// Возвращаемое значение:
//  ФиксированныйМассив из Строка
Функция ВсеТипыОбъектовИзМетаданных() Экспорт
	
	МассивОбъектов = Новый Массив(14);
	
	МассивОбъектов[0] = "Константы";
	МассивОбъектов[1] = "Справочники";
	МассивОбъектов[2] = "Документы";
	МассивОбъектов[3] = "ЖурналыДокументов";
	МассивОбъектов[4] = "Перечисления";
	МассивОбъектов[5] = "ПланыВидовХарактеристик";
	МассивОбъектов[6] = "ПланыСчетов";
	МассивОбъектов[7] = "ПланыВидовРасчета";
	МассивОбъектов[8] = "РегистрыСведений";
	МассивОбъектов[9] = "РегистрыНакопления";
	МассивОбъектов[10] = "РегистрыБухгалтерии";
	МассивОбъектов[11] = "РегистрыРасчета";
	МассивОбъектов[12] = "БизнесПроцессы";
	МассивОбъектов[13] = "Задачи";
	
	Возврат Новый ФиксированныйМассив(МассивОбъектов);
	
КонецФункции

// На linux может слетать идентификатор (х.з. почему, находится в /<домашнаяя папка>/.1cv8/1C/1cv8.1cv8u.pfl, видимо периодически зачищает файл)
// Плюс если устанавливать из образа (т.е. в 99% случаях), то этот идентификатор совпадает (не перезаписывает файл).
// Поэтому формируем этот идентификатор сами, с помощью идентификатора системы и имени пользователя
//
// Как мне сказали, на WIN аналогичная ситуация.
// Поэтому, переопределяем идентификатор клиента с учётом уникальности по компьютеру и пользователю ОС
// 
// Возвращаемое значение:
//	Строка
//
Функция ПолучитьИдентификаторКлиентаТекущегоКомпьютера() Экспорт
	
	#Если ВебКлиент Тогда
		
		СистемнаяИнформация = Новый СистемнаяИнформация();
		Возврат Строка(СистемнаяИнформация.ИдентификаторКлиента);
		
	#ИначеЕсли ТонкийКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		
		СтрокаУникальностиПользователяИКомпьютера = ИмяКомпьютера() + Спец_ОбщегоНазначенияКлиентСервер.ТекущийПользовательСистемы();
		
		//@skip-check transfer-object-between-client-server
		Возврат Спец_ОбщегоНазначенияВызовСервера.ПолучитьКонтрольнуюСуммуСтрокой(СтрокаУникальностиПользователяИКомпьютера);
		
	#Иначе
		
		ТекущийПользовательСистемы = Спец_ОбщегоНазначенияКлиентСервер.ТекущийПользовательСистемы(Истина);
		Если ПустаяСтрока(ТекущийПользовательСистемы) Тогда
			ТекущийПользовательСистемы = Спец_ОбщегоНазначенияКлиентСервер.ТекущийПользовательСистемы();
		КонецЕсли;
		
		ИмяКомпьютера = Спец_ОбщегоНазначенияКлиентСервер.ПолучитьИмяКомпьютера(Истина);
		Если ПустаяСтрока(ИмяКомпьютера) Тогда
			
			ИмяКомпьютера = Спец_ОбщегоНазначенияКлиентСервер.ПолучитьИмяКомпьютера();
			Если ПустаяСтрока(ИмяКомпьютера) Тогда
				ИмяКомпьютера = ИмяКомпьютера();
			КонецЕсли;
			
		КонецЕсли;
		
		СтрокаУникальностиПользователяИКомпьютера = ИмяКомпьютера + ТекущийПользовательСистемы;
		Возврат Спец_ОбщегоНазначения.ПолучитьКонтрольнуюСуммуСтрокой(СтрокаУникальностиПользователяИКомпьютера);
		
	#КонецЕсли
	
КонецФункции

#Область ВызовСервераЕслиТребуется

// Возвращаемое значение:
//  см. Спец_ОбщегоНазначенияВызовСервера.ОписаниеТипаВсеСсылки
Функция ОписаниеТипаВсеСсылки() Экспорт
	
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		Возврат Спец_ОбщегоНазначенияВызовСервера.ОписаниеТипаВсеСсылки();
	#Иначе
		Возврат Спец_ОбщегоНазначенияПовтИсп.ОписаниеТипаВсеСсылки();
	#КонецЕсли
	
КонецФункции

// Возвращаемое значение:
//  см. Спец_ОбщегоНазначенияВызовСервера.ОписаниеТипаПеречисления
Функция ОписаниеТипаПеречисления() Экспорт
	
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		Возврат Спец_ОбщегоНазначенияВызовСервера.ОписаниеТипаПеречисления();
	#Иначе
		Возврат Спец_ОбщегоНазначенияПовтИсп.ОписаниеТипаПеречисления();
	#КонецЕсли
	
КонецФункции

// Параметры:
//  КодИлиСсылкаПВХ - см. Спец_ОбщегоНазначения.ПолучитьКонстантуСпец.КодИлиСсылкаПВХ
//  ЗначениеПоУмолчанию - см. Спец_ОбщегоНазначения.ПолучитьКонстантуСпец.ЗначениеПоУмолчанию
//  НаДату - см. Спец_ОбщегоНазначения.ПолучитьКонстантуСпец.НаДату
// 
// Возвращаемое значение:
//  см. Спец_ОбщегоНазначения.ПолучитьКонстантуСпец
Функция ПолучитьКонстантуСпец(Знач КодИлиСсылкаПВХ, Знач ЗначениеПоУмолчанию = Неопределено, Знач НаДату = Неопределено) Экспорт
	
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		Возврат Спец_ОбщегоНазначенияВызовСервера.ПолучитьКонстантуСпец(КодИлиСсылкаПВХ, ЗначениеПоУмолчанию, НаДату, Истина);
	#Иначе
		Возврат Спец_ОбщегоНазначения.ПолучитьКонстантуСпец(КодИлиСсылкаПВХ, ЗначениеПоУмолчанию, НаДату);
	#КонецЕсли
	
КонецФункции

// Параметры:
//  ИмяПеременной - см. Спец_ОбщегоНазначения.ПолучитьЗначениеПеременной.ИмяПеременной
// 
// Возвращаемое значение:
//  см. Спец_ОбщегоНазначения.ПолучитьЗначениеПеременной
Функция ЗначениеПеременной(Знач ИмяПеременной) Экспорт
	
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		Возврат Спец_ОбщегоНазначенияВызовСервера.ЗначениеПеременной(ИмяПеременной, Истина);
	#Иначе
		Возврат Спец_ОбщегоНазначения.ПолучитьЗначениеПеременной(ИмяПеременной);
	#КонецЕсли
	
КонецФункции

// Параметры:
//  ИмяОбработкиИлиСсылка - см. Спец_ОбщегоНазначенияПовтИсп.ПодключитьВнешнююОбработку.ИмяОбработкиИлиСсылка
// 
// Возвращаемое значение:
//  см. Спец_ОбщегоНазначенияПовтИсп.ПодключитьВнешнююОбработку
Функция ПодключитьВнешнююОбработку(Знач ИмяОбработкиИлиСсылка) Экспорт
	
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		Возврат Спец_ОбщегоНазначенияВызовСервера.ПодключитьВнешнююОбработку(ИмяОбработкиИлиСсылка);
	#Иначе
		Возврат Спец_ОбщегоНазначенияПовтИсп.ПодключитьВнешнююОбработку(ИмяОбработкиИлиСсылка);
	#КонецЕсли
	
КонецФункции

// Возвращаемое значение:
//  см. Спец_ОбщегоНазначенияПовтИсп.ИменаПодсистем
Функция ИменаПодсистем() Экспорт
	
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		Возврат Спец_ОбщегоНазначенияВызовСервера.ИменаПодсистем();
	#Иначе
		Возврат Спец_ОбщегоНазначенияПовтИсп.ИменаПодсистем();
	#КонецЕсли
	
КонецФункции

// Параметры:
//  ИмяПараметра - см. Спец_ОбщегоНазначения.ЗначениеПараметраСеанса.ИмяПараметра
// 
// Возвращаемое значение:
//  см. Спец_ОбщегоНазначения.ЗначениеПараметраСеанса
Функция ЗначениеПараметраСеанса(Знач ИмяПараметра) Экспорт
	
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		Возврат Спец_ОбщегоНазначенияВызовСервера.ЗначениеПараметраСеанса(ИмяПараметра);
	#Иначе
		Возврат Спец_ОбщегоНазначения.ЗначениеПараметраСеанса(ИмяПараметра);
	#КонецЕсли
	
КонецФункции

// Параметры:
//  База - см. Спец_ОбщегоНазначения.СтруктураПараметровБазы.База
// 
// Возвращаемое значение:
//  см. Спец_ОбщегоНазначения.СтруктураПараметровБазы
//
Функция СтруктураПараметровБазы(Знач База = Неопределено) Экспорт
	
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		//@skip-check constructor-function-return-section
		Возврат Спец_ОбщегоНазначенияВызовСервера.СтруктураПараметровБазы(База);
	#Иначе
		//@skip-check constructor-function-return-section
		Возврат Спец_ОбщегоНазначения.СтруктураПараметровБазы(База);
	#КонецЕсли
	
КонецФункции

// Параметры:
//  ИсключитьПеречисления - см. Спец_ОбщегоНазначенияПовтИсп.ВсеИменаМетаданныхИзБазы.ИсключитьПеречисления
// 
// Возвращаемое значение:
//  см. Спец_ОбщегоНазначенияПовтИсп.ВсеИменаМетаданныхИзБазы
Функция ВсеИменаМетаданныхИзБазы(Знач ИсключитьПеречисления = Ложь) Экспорт
	
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		Возврат Спец_ОбщегоНазначенияВызовСервера.ВсеИменаМетаданныхИзБазы(ИсключитьПеречисления);
	#Иначе
		Возврат Спец_ОбщегоНазначенияПовтИсп.ВсеИменаМетаданныхИзБазы(ИсключитьПеречисления);
	#КонецЕсли
	
КонецФункции

// Параметры:
//  ПолноеИмяОбъекта - см. Спец_ОбщегоНазначенияПовтИсп.МассивИменПредопределенныхПоМетаданным.ПолноеИмяОбъекта
// 
// Возвращаемое значение:
//  см. Спец_ОбщегоНазначенияПовтИсп.МассивИменПредопределенныхПоМетаданным
Функция МассивИменПредопределенныхПоМетаданным(Знач ПолноеИмяОбъекта) Экспорт
		
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		Возврат Спец_ОбщегоНазначенияВызовСервера.МассивИменПредопределенныхПоМетаданным(ПолноеИмяОбъекта);
	#Иначе
		Возврат Спец_ОбщегоНазначенияПовтИсп.МассивИменПредопределенныхПоМетаданным(ПолноеИмяОбъекта);
	#КонецЕсли
	
КонецФункции

// Возвращаемое значение:
//  см. Спец_ОбщегоНазначенияПовтИсп.ЭтоПользовательСПолнымиПравами
Функция ЭтоПользовательСПолнымиПравами() Экспорт

	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		Возврат Спец_ОбщегоНазначенияВызовСервера.ЭтоПользовательСПолнымиПравами();
	#Иначе
		Возврат Спец_ОбщегоНазначенияПовтИсп.ЭтоПользовательСПолнымиПравами();
	#КонецЕсли

КонецФункции

#КонецОбласти

#КонецОбласти

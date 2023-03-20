// @strict-types

#Область ПрограммныйИнтерфейс

// Процедура добавляет кнопку "Логи по объекту" на форму (если по данному объекту включено логирование)
// 
// Параметры:
//  Форма - см. Спец_РаботаСФормами.ПриСозданииНаСервере.Форма
//  ЭтоУправляемаяФорма - Булево - Флаг того, что это управляемая форма
//
Процедура ДобавитьНаФормуКнопкуОткрытияЛогов(Знач Форма, Знач ЭтоУправляемаяФорма = Неопределено) Экспорт
	
	Если ЭтоУправляемаяФорма = Неопределено Тогда
		ЭтоУправляемаяФорма = Спец_ОбщегоНазначенияКлиентСервер.ЭтоУправляемаяФорма(Форма);
	КонецЕсли;
	
	Если Не ДобавляемКнопкуОткрытияЛогов(Форма, ЭтоУправляемаяФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоУправляемаяФорма Тогда
		
		НоваяКоманда = Форма.Команды.Добавить("Спец_ЛогиПоОбъекту");
		НоваяКоманда.Заголовок   = "Логи по объекту";
		НоваяКоманда.Действие    = "Подключаемый_ОткрытьЛогиПоОбъекту";
		НоваяКоманда.Подсказка   = "Открыть логи по объекту";
		НоваяКоманда.Отображение = ОтображениеКнопки.КартинкаИТекст;
		НоваяКоманда.Картинка    = БиблиотекаКартинок.История;
		
		КнопкаФормы = Форма.Элементы.Добавить("Спец_ЛогиПоОбъекту", Тип("КнопкаФормы"), Форма.КоманднаяПанель);  
		КнопкаФормы.ИмяКоманды = НоваяКоманда.Имя;
		КнопкаФормы.Вид        = ВидКнопкиФормы.КнопкаКоманднойПанели;
		
		// ++ Спец_БСП.Версия1С_15_ВышеИлиРавно
		КнопкаФормы.ПоложениеВКоманднойПанели = ПоложениеКнопкиВКоманднойПанели.ВДополнительномПодменю;
		// -- Спец_БСП.Версия1С_15_ВышеИлиРавно
		
	Иначе
		
		// Косяк EDT (не умеет с обычными формами)
		#Если ТолстыйКлиентОбычноеПриложение Тогда
				
			//@skip-check property-return-type
			//@skip-check dynamic-access-method-not-found
			//@skip-check variable-value-type
			ЭлементКоманднаяПанель = Форма.ЭлементыФормы.Найти("ДействияФормы");
			Если ЭлементКоманднаяПанель <> Неопределено Тогда
				
				//@skip-check property-return-type
				//@skip-check dynamic-access-method-not-found
				//@skip-check wrong-string-literal-content
				ЭлементКоманднаяПанель.Кнопки.Добавить("Спец_ЛогиПоОбъекту",
						ТипКнопкиКоманднойПанели.Действие,
						"Логи по объекту",
						Новый Действие("Подключаемый_ОткрытьЛогиПоОбъекту"));
				
			КонецЕсли;
		
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

// Имя метаданных для СКД.
// 
// Параметры:
//  Объект - см. Спец_ОбщегоНазначения.ЗаписатьОбъект.ОбъектДляЗаписи
//    	   
// Возвращаемое значение:
//  Строка - Имя метаданных для СКД
//
Функция ИмяМетаданныхДляСКД(Знач Объект) Экспорт
	
	СтруктураМетаданных = Спец_ОбщегоНазначения.ПолучитьСтруктуруИмениТипаДанныхОбъекта(Объект);
	Возврат СтрШаблон("%1: %2",
			СтруктураМетаданных.ТипОбъектаЕдинственноеЧисло,
			СтруктураМетаданных.МетаданныеОбъекта.Представление());
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Записать готовый лог в регистр через 1С (набор записей)
// 
// Параметры:
//  Источник - ЛюбаяСсылка, РегистрБухгалтерииНаборЗаписей, РегистрСведенийНаборЗаписей, РегистрРасчетаНаборЗаписей, РегистрНакопленияНаборЗаписей, Строка - Источник для лога
//  УровеньЛога - ПеречислениеСсылка.Спец_УровниЛогирования - Уровень лога
//  ТекстДляЗаписи - Строка - Текст для записи
//  UnixTimestamp - Число - Unix timestamp записи лога
//  ДвоичныеДанныеФайла - ДвоичныеДанные, Неопределено - Двоичные данные файла (если требуется)
//	Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
//
Процедура ЗаписатьГотовыйЛогВРегистрЧерез1С(Знач Источник, Знач УровеньЛога, Знач ТекстДляЗаписи, Знач UnixTimestamp,
		Знач ДвоичныеДанныеФайла, Знач Кэш = Неопределено) Экспорт

	Если UnixTimestamp = 0 Тогда
		UnixTimestampДляЗаписи = Спец_КомпонентаДополнительныеФункцииКлиентСервер.ТекущийUnixTimestampСервера(Кэш);
	Иначе
		UnixTimestampДляЗаписи = UnixTimestamp;
	КонецЕсли;
	
	Если ДвоичныеДанныеФайла <> Неопределено Тогда
		СодержимоеФайла = Новый ХранилищеЗначения(ДвоичныеДанныеФайла, Новый СжатиеДанных(9));
	КонецЕсли;
	
	Если ТипЗнч(УровеньЛога) = Тип("Строка") Тогда
		
		УровеньЛогаДляЗаписи = ?(ПустаяСтрока(УровеньЛога),
				ПредопределенноеЗначение("Перечисление.Спец_УровниЛогирования.ПустаяСсылка"),
				ПредопределенноеЗначение("Перечисление.Спец_УровниЛогирования." + УровеньЛога));
		
	ИначеЕсли УровеньЛога = Неопределено Тогда
		
		УровеньЛогаДляЗаписи = ПредопределенноеЗначение("Перечисление.Спец_УровниЛогирования.Информация");
		
	КонецЕсли;

	СтруктураИнформацииПоКомпьютеру = Спец_ЛогированиеОбъектовКлиентСерверПовтИсп.ПолучитьСтруктуруИнформацииПоТекущемуКомпьютеруДляЗаписи();

	НаборЗаписей = РегистрыСведений.Спец_ЛогиПоОбъектам.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.UnixTimestamp.Установить(UnixTimestampДляЗаписи);
	НаборЗаписей.Отбор.Источник.Установить(Источник);
	
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	ЗаписьДляРедактирования = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(ЗаписьДляРедактирования, СтруктураИнформацииПоКомпьютеру);
	
	ЗаписьДляРедактирования.Источник        = Источник;
	ЗаписьДляРедактирования.UnixTimestamp   = UnixTimestampДляЗаписи;
	ЗаписьДляРедактирования.ТекстИзменений  = ТекстДляЗаписи;
	ЗаписьДляРедактирования.СодержимоеФайла = СодержимоеФайла;
	ЗаписьДляРедактирования.УровеньЛога     = УровеньЛогаДляЗаписи;
	
	Попытка
		
		НаборЗаписей.Записать();
		
	Исключение
		
		ТекстСообщения = СтрШаблон("Не удалось записать лог!%1%2",
				Символы.ПС,
				Спец_ОбщегоНазначенияКлиентСервер.КраткоеПредставлениеОшибкиЧерезОбработкуОшибок(ИнформацияОбОшибке(), Символы.Таб));
		
		Спец_ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
	КонецПопытки;

КонецПроцедуры

// Параметры:
//  Источник - см. Спец_ОбщегоНазначения.ЗаписатьОбъект.ОбъектДляЗаписи
//  Отказ - Булево - Отказ
//	ДополнительныеСвойства - см. Спец_ОбработчикиПодписокНаСобытия.НоваяСтруктураДополнительныхСвойств
//	Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
//
Процедура ЛогированиеИсточникаПриЗаписи(Знач Источник, Отказ, Знач ДополнительныеСвойства, Знач Кэш) Экспорт
	
	ТипЛогирования = Спец_ЛогированиеОбъектовВызовСервераПовтИсп.ТипЛогированияОбъекта(ДополнительныеСвойства.ПолноеИмяМетаданных);
	Если ТипЛогирования = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураИнформацииПоКомпьютеру = Спец_ЛогированиеОбъектовКлиентСерверПовтИсп.ПолучитьСтруктуруИнформацииПоТекущемуКомпьютеруДляЗаписи();
	КомментарийВерсии = СтрШаблон(
			
			"Unix timestamp записи: %1
			|Версия ОС - %2
			|Версия приложения - %3
			|Имя компьютера - %4
			|Имя пользователя - %5
			|Имя пользователя ОС - %6
			|Тип клиента - %7
			|Тип ОС - %8",
			
			Формат(ДополнительныеСвойства.UnixTimestampЗаписи, "ЧРД=.; ЧН=0; ЧГ=;"),
			СтруктураИнформацииПоКомпьютеру.ВерсияОС,
			СтруктураИнформацииПоКомпьютеру.ВерсияПриложения,
			СтруктураИнформацииПоКомпьютеру.ИмяКомпьютера,
			СтруктураИнформацииПоКомпьютеру.ИмяПользователя,
			СтруктураИнформацииПоКомпьютеру.ИмяПользователяОперационнойСистемы,
			СтруктураИнформацииПоКомпьютеру.ТипКлиента,
			СтруктураИнформацииПоКомпьютеру.ТипОперационнойСистемы);
	
	// ++ Спец_БСП.Версия1С_15_ВышеИлиРавно
	Если ТипЛогирования = 1 Тогда // Для автоматического логирования добавляем комментарий (доступно только с 15 версии)
		Источник.ЗаписьИсторииДанных.КомментарийВерсии = КомментарийВерсии;
	КонецЕсли;
	// -- Спец_БСП.Версия1С_15_ВышеИлиРавно
	
	#Если Не ВнешнееСоединение Тогда
	
		// Включены логи по пользователю, пишем версию вручную
		Если ТипЛогирования = 2 И (ДополнительныеСвойства.ЭтоСсылочныйОбъект Или Источник.Количество() > 0) Тогда 
			
			// Включаем временно историю
			НужноОтключать = Ложь;
			
			ТекущиеНастройки = ИсторияДанных.ПолучитьНастройки(ДополнительныеСвойства.МетаданныеОбъекта);
			Если ТекущиеНастройки = Неопределено Или Не ТекущиеНастройки.Использование Тогда
				
				ВключитьТиповойМеханизмИсторииПоОбъектуМетаданных(ДополнительныеСвойства.МетаданныеОбъекта, Кэш);
				НужноОтключать = Истина;
				
			КонецЕсли;
			
			Пользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
			
			ТекущийВидИзменения = ВидИзмененияДанных.Изменение;
			Если ДополнительныеСвойства.ЭтоСсылочныйОбъект Тогда
				
				Если ДополнительныеСвойства.ЭтоНовый Тогда
					ТекущийВидИзменения = ВидИзмененияДанных.Добавление;
				ИначеЕсли ДополнительныеСвойства.ЭтоУдалениеОбъекта Тогда
					ТекущийВидИзменения = ВидИзмененияДанных.Удаление;
				КонецЕсли;
				
			КонецЕсли;
			
			//@skip-check wrong-type-expression
			Попытка
				
				ИсторияДанных.ЗаписатьВерсию(Источник,
						ТекущаяДатаСеанса(),
						Пользователь.УникальныйИдентификатор,
						Пользователь.Имя,
						СтруктураИнформацииПоКомпьютеру.ИмяПользователя,
						ТекущийВидИзменения,
						КомментарийВерсии);
				
			Исключение
				
				ШаблонСообщения = "Не удалось записать версию объекта в историю!%1%2";
				ТекстСообщения  = СтрШаблон(ШаблонСообщения,
						Символы.ПС,
						Спец_ОбщегоНазначенияКлиентСервер.КраткоеПредставлениеОшибкиЧерезОбработкуОшибок(ИнформацияОбОшибке(), Символы.Таб));
				
				Спец_ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
				
			КонецПопытки;
			
			Если НужноОтключать Тогда
				ИсторияДанных.УстановитьНастройки(ДополнительныеСвойства.МетаданныеОбъекта, ТекущиеНастройки);
			КонецЕсли;
			
		КонецЕсли;
	
	#КонецЕсли
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Включить историю по объекту метаданных.
// 
// Параметры:
//  ОбъектМетаданных - см. Спец_ОбщегоНазначения.ПолучитьСтруктуруИлиТаблицуОбъектаДоЗаписи.ОбъектМетаданных
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
Процедура ВключитьТиповойМеханизмИсторииПоОбъектуМетаданных(Знач ОбъектМетаданных, Знач Кэш) Экспорт
	
	// Включаем все поля по умолчанию
	НастройкиИстории = Новый НастройкиИсторииДанных();
	НастройкиИстории.Использование = Истина;
	
	СоответствиеПолей = Новый Соответствие;
	
	СтруктураРеквизитов = Спец_ОбщегоНазначения.ПолучитьСтруктуруВсехРеквизитовОбъекта(ОбъектМетаданных, Ложь, Кэш);
	Для Каждого Реквизит Из СтруктураРеквизитов.МассивРеквизитов Цикл
		СоответствиеПолей[Реквизит.Имя] = Истина;
	КонецЦикла;
	
	Для Каждого КлючЗначение Из СтруктураРеквизитов.ТабличныеЧасти Цикл
		
		Для Каждого Реквизит Из КлючЗначение.Значение Цикл
			//@skip-check property-return-type
			СоответствиеПолей[КлючЗначение.Ключ + "." + Реквизит.Имя] = Истина;
		КонецЦикла;
		
	КонецЦикла;
	
	НастройкиИстории.ИспользованиеПолей = СоответствиеПолей;
	ИсторияДанных.УстановитьНастройки(ОбъектМетаданных, НастройкиИстории);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  Форма - см. Спец_РаботаСФормами.ПриСозданииНаСервере.Форма
//  ЭтоУправляемаяФорма - Булево
// 
// Возвращаемое значение:
//  Булево
//
Функция ДобавляемКнопкуОткрытияЛогов(Знач Форма, Знач ЭтоУправляемаяФорма)
	
	Если (ЭтоУправляемаяФорма И Не Форма.Спец_ЭтоСсылочныйОбъект И Не Форма.Спец_ЭтоРегистр)
			Или (Не ЭтоУправляемаяФорма И Не Форма.ЭлементыФормы.Спец_ЭтоСсылочныйОбъект.Значение И Не Форма.ЭлементыФормы.Спец_ЭтоРегистр.Значение) Тогда
				
		Возврат Ложь;
		
	КонецЕсли;
	
	Если ЭтоУправляемаяФорма Тогда
		ТипЛогирования = Спец_ЛогированиеОбъектовВызовСервераПовтИсп.ТипЛогированияОбъекта(Форма.Спец_ПолноеИмяМетаданных);
	Иначе
		ТипЛогирования = Спец_ЛогированиеОбъектовВызовСервераПовтИсп.ТипЛогированияОбъекта(Форма.ЭлементыФормы.Спец_ПолноеИмяМетаданных.Значение);
	КонецЕсли;
	Если ТипЛогирования = 2 Тогда
		Возврат Истина;
	ИначеЕсли ТипЛогирования = 0 И Спец_ЛогированиеОбъектовВызовСервераПовтИсп.ПринудительноДобавлятьКнопкуФормы() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

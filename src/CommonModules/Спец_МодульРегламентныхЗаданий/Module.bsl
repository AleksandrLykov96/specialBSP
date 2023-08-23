// @strict-types

#Область ПрограммныйИнтерфейс

// Основная обработка для запуска ночного расчёта
//
Процедура НочнойРасчет() Экспорт
	
	ОбщийТекстОшибок = "";
	
	// См. РегистрСведений.Спец_НастройкиНочногоРасчета
	// В базе прямо в ней можно задать процедуру для выполнения (чтобы не добавлять новые "РегламентныеЗадания").
	ВыборкаПоПорядку = ПолучитьВыборкуПоПорядковымНомерамДляЗапуска();
	Пока ВыборкаПоПорядку.Следующий() Цикл
		
		МассивСтруктурЗаданий = Новый Массив; // Массив из см. Спец_РаботаСФоновымиЗаданиямиКлиентСервер.ПолучитьСтруктуруПараметровВыполненияФоновогоЗадания
		
		ВыборкаПоЗаданиям = ПолучитьВыборкуПоЗаданиямДляЗапуска(ВыборкаПоПорядку);
		Пока ВыборкаПоЗаданиям.Следующий() Цикл
			
			СтруктураЗадания = Спец_РаботаСФоновымиЗаданиямиКлиентСервер.ПолучитьСтруктуруПараметровВыполненияФоновогоЗадания();
			
			СтруктураЗадания.ИмяРегламентногоЗадания  = ВыборкаПоЗаданиям.ИмяПроцедурыВыполнения;
			СтруктураЗадания.ИдентификаторВыполнителя = "НочнойРасчет_" + ВыборкаПоЗаданиям.ИмяПроцедурыВыполнения;
			СтруктураЗадания.РаботаЧерезРегистр       = Ложь;
			СтруктураЗадания.ТаймаутВыполнения        = 14400;
			
			ВходныеПараметры = ВыборкаПоЗаданиям.ВходныеПараметры.Получить();
			Если ВходныеПараметры <> Неопределено Тогда
				СтруктураЗадания.ВходныеДанные = ВходныеПараметры;
			КонецЕсли;
			
			Спец_РаботаСФоновымиЗаданиями.ЗапуститьВыполнениеФоновогоЗадания(СтруктураЗадания);
			МассивСтруктурЗаданий.Добавить(СтруктураЗадания);
			
		КонецЦикла;
		
		Спец_РаботаСФоновымиЗаданиями.РезультатВыполненияВсехФоновыхЗаданий(МассивСтруктурЗаданий, 14400);
		Для Каждого СтруктураЗадания Из МассивСтруктурЗаданий Цикл
			
			Если Не ПустаяСтрока(СтруктураЗадания.ТекстОшибки) Тогда
				
				Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(СтруктураЗадания.ТекстОшибки,
						СтруктураЗадания.ИмяРегламентногоЗадания,
						ОбщийТекстОшибок);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Спец_ОбщегоНазначения.ЗаписатьОшибки("Спец_МодульРегламентныхЗаданий.НочнойРасчет", ОбщийТекстОшибок);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура для обновления индекса полнотекстового поиска
// 
// Параметры:
//  РазрешитьСлияние - Булево
//
Процедура ОбновлениеИндексаППД(Знач РазрешитьСлияние = Ложь) Экспорт
	
	ПолнотекстовыйПоиск.ОбновитьИндекс(РазрешитьСлияние, Истина);
	
КонецПроцедуры

// Процедура для очиски всякой фигни, которую нужно удалить или из базы, или из ОС.
//
Процедура ЧисткаСтарыхЛишнихДанных() Экспорт
	
	Если Спец_ОбщегоНазначенияКлиентСервер.ИдетРабочийДень() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаписьНапрямуюДоступна = Спец_РаботаСБазойДанныхНапрямуюВызовСервераПовтИсп.ЗаписьНапрямуюДоступна();
	Кэш                    = Спец_ПолучитьКэш();
	ТекстыОшибок           = "";
	
	Спец_Переопределяемый.ЧисткаСтарыхЛишнихДанных(Кэш, ТекстыОшибок);
	
	#Область Чистка_папки_TMP
	
	КоличествоЧасовОграничение = Спец_ПолучитьКонстанту(ПланыВидовХарактеристик.Спец_Константы.КоличествоЧасовДляЧисткиTMP, 36); // Число
	ГраницаПоследнегоИзмененияОбычныхФайлов = ТекущаяДатаСеанса() - Спец_КонстантыКлиентСервер.СекундВЧасе(КоличествоЧасовОграничение);
	
	ГраницаПоследнегоИзменения1СкихФайлов = ГраницаПоследнегоИзмененияОбычныхФайлов;
	
	// ++ Спец_БСП.Версия1С_14_ВышеИлиРавно
	#Если Не ВнешнееСоединение Тогда
		
		Кластер = Спец_ОбщегоНазначенияКлиентСервер.ПодключитьсяККластеруСервера("");
		Если Кластер <> Неопределено Тогда
			
			МинимальнаяДатаЗапускаРабочегоПроцесса = ТекущаяДатаСеанса();
			ЕстьХотьОдин = Ложь;
			
			Для Каждого РабочийПроцесс Из Кластер.ПолучитьРабочиеПроцессы() Цикл
				
				Если РабочийПроцесс.СостояниеРабочегоПроцесса <> АдминистрированиеСостояниеРабочегоПроцесса.Используется
					Или Не РабочийПроцесс.Включен
					Или Не РабочийПроцесс.Активен
					Или РабочийПроцесс.Резервный Тогда
					
					Продолжить;
					
				КонецЕсли;
				
				ЕстьХотьОдин = Истина;
				МинимальнаяДатаЗапускаРабочегоПроцесса = Мин(МинимальнаяДатаЗапускаРабочегоПроцесса, РабочийПроцесс.ВремяЗапуска);
				
			КонецЦикла;
			
			Если ЕстьХотьОдин Тогда
				ГраницаПоследнегоИзменения1СкихФайлов = МинимальнаяДатаЗапускаРабочегоПроцесса - 10; // На всякий случай
			Иначе
				ГраницаПоследнегоИзменения1СкихФайлов = ГраницаПоследнегоИзмененияОбычныхФайлов;
			КонецЕсли;
			
		КонецЕсли;
		
	#КонецЕсли
	// -- Спец_БСП.Версия1С_14_ВышеИлиРавно
	
	МассивКаталогов = Новый Массив(); // Массив из Файл
	Для Каждого Файл Из НайтиФайлы(КаталогВременныхФайлов(), "*", Ложь) Цикл
		
		Если Не Файл.Существует() Тогда
			Продолжить;
		КонецЕсли;
		
		ПоследняяДатаИзменения = Файл.ПолучитьВремяИзменения();
		Если Файл.ЭтоКаталог()
			И ПоследняяДатаИзменения < ГраницаПоследнегоИзмененияОбычныхФайлов Тогда
			
			МассивКаталогов.Добавить(Файл);
			Продолжить;
			
		КонецЕсли;
		
		Это1СкийФайл = СтрНачинаетсяС(ВРег(Файл.ПолноеИмя), "V8_");
		Если (Это1СкийФайл И ПоследняяДатаИзменения < ГраницаПоследнегоИзменения1СкихФайлов)
			Или (Не Это1СкийФайл И ПоследняяДатаИзменения < ГраницаПоследнегоИзмененияОбычныхФайлов) Тогда
			
			Спец_ОбщегоНазначенияКлиентСервер.УдалитьФайлыНеМешаяРаботе(Файл.ПолноеИмя);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Если в каталогах что-то лежит - не трогаем
	Для Каждого Каталог Из МассивКаталогов Цикл
		
		// 1С криво работает с каталогами, в названии которых есть точка (думает что это расширение)
		// Из-за этого не работает поиск файлов (по крайнем мере в *nix)
		Если СтрНайти(Каталог.ПолноеИмя, ".") > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ЕстьКакиеЛибоФайлы = Ложь;
		Для Каждого ФайлВКаталоге Из НайтиФайлы(Каталог.ПолноеИмя, "*", Истина) Цикл
			
			Если ФайлВКаталоге.ЭтоКаталог() Или Не ФайлВКаталоге.Существует() Тогда
				Продолжить;
			КонецЕсли;
			
			Если ПоследняяДатаИзменения >= ГраницаПоследнегоИзмененияОбычныхФайлов Тогда
				
				ЕстьКакиеЛибоФайлы = Истина;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если Не ЕстьКакиеЛибоФайлы Тогда
			Спец_ОбщегоНазначенияКлиентСервер.УдалитьФайлыНеМешаяРаботе(Каталог.ПолноеИмя);
		КонецЕсли;
		
	КонецЦикла;
	
	#КонецОбласти
	
	#Область Чистка_регистра_ошибок
	
	КоличествоДнейХраненияОшибок = Спец_ПолучитьКонстанту(ПланыВидовХарактеристик.Спец_Константы.СрокХраненияОшибок, 14); // Число
	Если КоличествоДнейХраненияОшибок > 0 Тогда
		
		КрайняяДата = ТекущаяДатаСеанса() - Спец_КонстантыКлиентСервер.СекундВСутках(КоличествоДнейХраненияОшибок);
		
		Успешно = Ложь;
		Если ЗаписьНапрямуюДоступна И Спец_КомпонентаДополнительныеФункцииКлиентСервер.PostgreSQLСоединениеУспешноУстановлено(Кэш) Тогда
			
			СтруктураОтбора = Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.ПодготовитьСтруктуруОтбораДляУдаленияОбъектовИзБД("Период");
			СтруктураОтбора.ВидСравнения = ВидСравнения.МеньшеИлиРавно;
			СтруктураОтбора.Значение = КрайняяДата;
			
			ТекстЗапроса = Спец_РаботаСБазойДанныхНапрямую.СформироватьТекстЗапросаДляУдаленияОбъектовИзБД(Метаданные.РегистрыСведений.Спец_РегистрОшибок, СтруктураОтбора, Кэш);
			Успешно = Спец_КомпонентаДополнительныеФункцииКлиентСервер.PostgreSQLВыполнитьЗапросБезРезультата(ТекстЗапроса, ТекстыОшибок, Кэш);
			
		КонецЕсли;
		
		Если Не Успешно Тогда
			
			ВыборкаРезультат = ПолучитьВыборкуДляУдаленияСтарыхОшибок(КрайняяДата);
			Пока ВыборкаРезультат.Следующий() Цикл
				
				НаборЗаписейРегистрОшибок = РегистрыСведений.Спец_РегистрОшибок.СоздатьНаборЗаписей();
				
				НаборЗаписейРегистрОшибок.Отбор.Период.Установить(ВыборкаРезультат.Период);
				НаборЗаписейРегистрОшибок.Отбор.Источник.Установить(ВыборкаРезультат.Источник);
				
				Спец_ОбщегоНазначения.ЗаписатьОбъект(НаборЗаписейРегистрОшибок, , ТекстыОшибок, , Кэш, , , Ложь);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	#КонецОбласти
	
	// ++ Спец_БСП.Спец_ЛогированиеОбъектов
	#Область Чистка_логов
	
	КоличествоХранениеЛогов = Спец_ПолучитьКонстанту(ПланыВидовХарактеристик.Спец_Константы.СрокХраненияЛогов, 24); // Число
	Если КоличествоХранениеЛогов > 0 Тогда

		UnixTimestampГраница = Спец_КомпонентаДополнительныеФункцииКлиентСервер.ТекущийUnixTimestampСервера(Кэш)
				- Спец_КонстантыКлиентСервер.СекундВЧасе(КоличествоХранениеЛогов);
		
		Успешно = Ложь;
		Если ЗаписьНапрямуюДоступна И Спец_КомпонентаДополнительныеФункцииКлиентСервер.PostgreSQLСоединениеУспешноУстановлено(Кэш) Тогда
			
			СтруктураОтбора = Спец_РаботаСБазойДанныхНапрямуюКлиентСервер.ПодготовитьСтруктуруОтбораДляУдаленияОбъектовИзБД("UnixTimestamp");
			СтруктураОтбора.ВидСравнения = ВидСравнения.МеньшеИлиРавно;
			СтруктураОтбора.Значение = UnixTimestampГраница;
			
			ТекстЗапроса = Спец_РаботаСБазойДанныхНапрямую.СформироватьТекстЗапросаДляУдаленияОбъектовИзБД(Метаданные.РегистрыСведений.Спец_ЛогиПоОбъектам, СтруктураОтбора, Кэш);
			Успешно = Спец_КомпонентаДополнительныеФункцииКлиентСервер.PostgreSQLВыполнитьЗапросБезРезультата(ТекстЗапроса, ТекстыОшибок, Кэш);
			
		КонецЕсли;
		
		Если Не Успешно Тогда
			
			ВыборкаРезультат = ПолучитьВыборкуДляУдаленияСтарыхЛогов(UnixTimestampГраница);
			Пока ВыборкаРезультат.Следующий() Цикл
				
				НаборЗаписейЛогиПоОбъекту = РегистрыСведений.Спец_ЛогиПоОбъектам.СоздатьНаборЗаписей();
				НаборЗаписейЛогиПоОбъекту.Отбор.UnixTimestamp.Установить(ВыборкаРезультат.UnixTimestamp);
				
				Спец_ОбщегоНазначения.ЗаписатьОбъект(НаборЗаписейЛогиПоОбъекту, , , , Кэш, , , Ложь);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область Чистка_истории_данных
	
	КоличествоДнейИстории = Спец_ПолучитьКонстанту(ПланыВидовХарактеристик.Спец_Константы.СрокХраненияИсторииДанных, 90); // Число
	Если КоличествоДнейИстории > 0 Тогда
			
		КрайняяДата = ТекущаяДатаСеанса() - Спец_КонстантыКлиентСервер.СекундВСутках(КоличествоДнейИстории);
		Для Каждого ИмяТипаМетаданных Из Спец_ОбщегоНазначенияКлиентСерверПовтИсп.ВсеТипыОбъектовИзМетаданных() Цикл
			
			Для Каждого ОбъектМетаданных Из Метаданные[ИмяТипаМетаданных] Цикл // см. Спец_ОбщегоНазначения.ПолучитьСтруктуруИлиТаблицуОбъектаДоЗаписи.ОбъектМетаданных
				
				Если Не Спец_РаботаСКоллекциямиКлиентСервер.ЕстьРеквизитОбъекта(ОбъектМетаданных, "ИсторияДанных") Тогда
					Продолжить;
				КонецЕсли;
				
				НужноОтключать = Ложь;
				
				ТекущиеНастройки = ИсторияДанных.ПолучитьНастройки(ОбъектМетаданных);
				Если ТекущиеНастройки = Неопределено Или Не ТекущиеНастройки.Использование Тогда
					
					Спец_ЛогированиеОбъектов.ВключитьТиповойМеханизмИсторииПоОбъектуМетаданных(ОбъектМетаданных, Кэш);
					НужноОтключать = Истина;
					
				КонецЕсли;
				
				ИсторияДанных.УдалитьВерсии(ОбъектМетаданных, КрайняяДата);
				
				Если НужноОтключать Тогда
					ИсторияДанных.УстановитьНастройки(ОбъектМетаданных, ТекущиеНастройки);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	#КонецОбласти
	
	ИсторияДанных.ОбновитьИсторию();
	// -- Спец_БСП.Спец_ЛогированиеОбъектов
	
	ПересчитатьИтогиРегистров(Кэш, ТекстыОшибок);
	
	Спец_ОбщегоНазначения.ЗаписатьОшибки("Очистка старых / лишних данных", ТекстыОшибок, , Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
//		* ПорядокВыполнения - Число
//
Функция ПолучитьВыборкуПоПорядковымНомерамДляЗапуска()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		
		"ВЫБРАТЬ
		|	НастройкаНочногоРасчета.ИмяПроцедурыВыполнения КАК ИмяПроцедурыВыполнения,
		|	НастройкаНочногоРасчета.ПорядокВыполнения КАК ПорядокВыполнения,
		|	НастройкаНочногоРасчета.ВходныеПараметры КАК ВходныеПараметры
		|ИЗ
		|	РегистрСведений.Спец_НастройкиНочногоРасчета КАК НастройкаНочногоРасчета
		|ГДЕ
		|	НастройкаНочногоРасчета.Запускать
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПорядокВыполнения
		|ИТОГИ ПО
		|	ПорядокВыполнения
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Возврат Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
КонецФункции

// Параметры:
//  ВыборкаРезультат - см. ПолучитьВыборкуПоПорядковымНомерамДляЗапуска;
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
//		* ИмяПроцедурыВыполнения - Строка
//		* ПорядокВыполнения - Число
//		* ВходныеПараметры - ХранилищеЗначения
Функция ПолучитьВыборкуПоЗаданиямДляЗапуска(Знач ВыборкаРезультат)
	
	Возврат ВыборкаРезультат.Выбрать();
	
КонецФункции

// Параметры:
//  UnixTimestampГраница - Число
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
//		* UnixTimestamp - Число
//
Функция ПолучитьВыборкуДляУдаленияСтарыхЛогов(Знач UnixTimestampГраница)
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Спец_ЛогиПоОбъектам.UnixTimestamp КАК UnixTimestamp
	|ИЗ
	|	РегистрСведений.Спец_ЛогиПоОбъектам КАК Спец_ЛогиПоОбъектам
	|ГДЕ
	|	Спец_ЛогиПоОбъектам.UnixTimestamp < &UnixTimestampГраница";

	Запрос.УстановитьПараметр("UnixTimestampГраница", UnixTimestampГраница);

	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

// Параметры:
//  КрайняяДата - Дата
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
//		* Период - Дата
//		* Источник - Строка
//
Функция ПолучитьВыборкуДляУдаленияСтарыхОшибок(Знач КрайняяДата)
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	РегистрОшибок.Период КАК Период,
	|	РегистрОшибок.Источник КАК Источник
	|ИЗ
	|	РегистрСведений.Спец_РегистрОшибок КАК РегистрОшибок
	|ГДЕ
	|	РегистрОшибок.Период <= &КрайняяДата";

	Запрос.УстановитьПараметр("КрайняяДата", КрайняяДата);

	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

// Параметры:
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
//  ТекстыОшибок - Строка
//
Процедура ПересчитатьИтогиРегистров(Знач Кэш, ТекстыОшибок)
	
	Если Спец_ОбщегоНазначенияКлиентСервер.ИдетРабочийДень() Тогда
		Возврат;
	КонецЕсли;
	
	НачалоМесяца            = НачалоМесяца(ТекущаяДатаСеанса());
	МаксимальнаяДатаИтогов  = НачалоМесяца(ДобавитьМесяц(НачалоМесяца, -1)) - 1; // Ставим на прошлый месяц, так как очень любят задним числом всё делать.
	ДатаПоследнегоПересчета = Спец_ПолучитьКонстанту(ПланыВидовХарактеристик.Спец_Константы.ДатаПоследнегоПересчетаИтогов, Дата(1, 1, 1)); // Дата
	ВремяПересчетаПришло    = НачалоМесяца(ДатаПоследнегоПересчета) < НачалоМесяца;
	
	// Для регистров сведений просто устанавливаем режим использования итогов и пересчитываем их
	Для Каждого ОбъектМетаданных Из Метаданные.РегистрыСведений Цикл
		
		УстановитьРежимыИтоговПересчитатьПриНеобходимости(ОбъектМетаданных,
				ВремяПересчетаПришло,
				МаксимальнаяДатаИтогов,
				ТекстыОшибок,
				Кэш);
		
	КонецЦикла;
	Для Каждого ОбъектМетаданных Из Метаданные.РегистрыНакопления Цикл
		
		УстановитьРежимыИтоговПересчитатьПриНеобходимости(ОбъектМетаданных,
				ВремяПересчетаПришло,
				МаксимальнаяДатаИтогов,
				ТекстыОшибок,
				Кэш);
		
	КонецЦикла;
	Для Каждого ОбъектМетаданных Из Метаданные.РегистрыБухгалтерии Цикл
		
		УстановитьРежимыИтоговПересчитатьПриНеобходимости(ОбъектМетаданных,
				ВремяПересчетаПришло,
				МаксимальнаяДатаИтогов,
				ТекстыОшибок,
				Кэш);
		
	КонецЦикла;
	
	Если ВремяПересчетаПришло Тогда
		Спец_УстановитьКонстанту(ПланыВидовХарактеристик.Спец_Константы.ДатаПоследнегоПересчетаИтогов, НачалоМесяца);
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  ОбъектМетаданных - ОбъектМетаданныхРегистрБухгалтерии, ОбъектМетаданныхРегистрНакопления, ОбъектМетаданныхРегистрСведений -
//  ВремяПересчетаПришло - Булево
//  МаксимальнаяДатаИтогов - Дата
//  ТекстыОшибок - Строка
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
//
Процедура УстановитьРежимыИтоговПересчитатьПриНеобходимости(Знач ОбъектМетаданных, Знач ВремяПересчетаПришло, Знач МаксимальнаяДатаИтогов, ТекстыОшибок, Знач Кэш)
	
	СтруктураПоМетаданным = Спец_ОбщегоНазначения.ПолучитьСтруктуруИмениТипаДанныхОбъекта(ОбъектМетаданных, Кэш);
	НужноПересчитывать    = ВремяПересчетаПришло;
	
	// По умолчанию включаем режим разделения итогов
	Если Не Спец_ОбщегоНазначенияКлиентСервер.ЭтоРегистрСведений(СтруктураПоМетаданным.ПолноеИмяОбъекта, Кэш, Тип("Строка")) Тогда
		
		Попытка
			
			Если Не СтруктураПоМетаданным.МенеджерОбъекта.ПолучитьРежимРазделенияИтогов() Тогда
				
				СтруктураПоМетаданным.МенеджерОбъекта.УстановитьРежимРазделенияИтогов(Истина);
				НужноПересчитывать = Истина;
				
			КонецЕсли;
			
		Исключение
			
			Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(ИнформацияОбОшибке(), "Установка режима разделения итогов для " + СтруктураПоМетаданным.ПолноеИмяОбъекта, ТекстыОшибок);
			
		КонецПопытки;
		
	КонецЕсли;
	
	// Использование итогов тоже включаем по умолчанию
	Попытка
		
		Если Не СтруктураПоМетаданным.МенеджерОбъекта.ПолучитьИспользованиеИтогов() Тогда
			
			СтруктураПоМетаданным.МенеджерОбъекта.УстановитьИспользованиеИтогов(Истина);
			НужноПересчитывать = Истина;
			
		КонецЕсли;
		
	Исключение
		
		Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(ИнформацияОбОшибке(), "Установка использования итогов для " + СтруктураПоМетаданным.ПолноеИмяОбъекта, ТекстыОшибок);
		
	КонецПопытки;
	
	// Для остаточных регистров ставим даты итогов
	Если Спец_ОбщегоНазначенияКлиентСервер.ЭтоРегистрНакопления(СтруктураПоМетаданным.ПолноеИмяОбъекта, Кэш, Тип("Строка"))
		И ОбъектМетаданных.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
		
		Попытка
			
			ТекущаяМаксимальнаяДатаИтогов = СтруктураПоМетаданным.МенеджерОбъекта.ПолучитьМаксимальныйПериодРассчитанныхИтогов();
			Если КонецДня(ТекущаяМаксимальнаяДатаИтогов) < МаксимальнаяДатаИтогов Тогда
				
				СтруктураПоМетаданным.МенеджерОбъекта.УстановитьМаксимальныйПериодРассчитанныхИтогов(МаксимальнаяДатаИтогов);
				НужноПересчитывать = Истина;
				
			КонецЕсли;
			
		Исключение
			
			Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(ИнформацияОбОшибке(), "Установка максимального периода расчёта итогов для " + СтруктураПоМетаданным.ПолноеИмяОбъекта, ТекстыОшибок);
			
		КонецПопытки;
		
		Попытка
			
			ТекущаяМинимальнаяДатаИтогов = СтруктураПоМетаданным.МенеджерОбъекта.ПолучитьМинимальныйПериодРассчитанныхИтогов();
			Если ТекущаяМинимальнаяДатаИтогов <> Дата(1, 1, 1) Тогда
				
				СтруктураПоМетаданным.МенеджерОбъекта.УстановитьМинимальныйПериодРассчитанныхИтогов(Дата(1, 1, 1));
				НужноПересчитывать = Истина;
				
			КонецЕсли;
			
		Исключение
			
			Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(ИнформацияОбОшибке(), "Установка минимального периода расчёта итогов для " + СтруктураПоМетаданным.ПолноеИмяОбъекта, ТекстыОшибок);
			
		КонецПопытки;
		
	КонецЕсли;
	
	// Пересчитываем
	Если НужноПересчитывать Тогда
		
		Попытка
			СтруктураПоМетаданным.МенеджерОбъекта.ПересчитатьИтоги();
		Исключение
			Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(ИнформацияОбОшибке(), "Пересчёт итогов для " + СтруктураПоМетаданным.ПолноеИмяОбъекта, ТекстыОшибок);
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

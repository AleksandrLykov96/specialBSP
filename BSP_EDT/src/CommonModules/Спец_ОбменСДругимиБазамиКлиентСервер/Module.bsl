
//@skip-check query-in-loop
//@skip-check method-too-many-params
//@skip-check structure-consructor-too-many-keys

#Область ПрограммныйИнтерфейс

#Область HTTPЗапросыКБазе

Функция ПолучитьВсеОбъектыМетаданныхИзБазы(Знач База, Знач ИмяОбъектаОтбор = "all", ТекстыОшибок = "", Знач Кэш = Неопределено, Знач ОписаниеОповещения = Неопределено) Экспорт
	
	СтруктураЗапроса = Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientПолучитьСтруктураЗапроса("hs/specialExchange/metadata/" + ИмяОбъектаОтбор,
			"ПолучитьВсеОбъектыМетаданныхИзБазы",
			"GET");
	
	#Если Клиент Тогда
		
		Если ОписаниеОповещения <> Неопределено Тогда
			
			ОписаниеОповещенияПослеВыполнения = Новый ОписаниеОповещения("ПолучитьВсеОбъектыМетаданныхИзБазы_ПослеВыполнения",
				Спец_ОбменСДругимиБазамиКлиент,
				ОписаниеОповещения);
			
			Спец_ОбменСДругимиБазамиКлиент.ОтправитьHTTPЗапросыКНужнойБазеАсинхронно(База, СтруктураЗапроса, ОписаниеОповещенияПослеВыполнения, Истина, Ложь, Кэш);
			Возврат Истина;
			
		КонецЕсли;
		
	#КонецЕсли
	
	СтруктураРезультатЗапроса = ОтправитьЗапросыКНужнойБазе(База, СтруктураЗапроса, , , , ТекстыОшибок, Кэш);
	Возврат ПолучитьВсеОбъектыМетаданныхИзБазы_ОбработатьРезультатВыполнения(СтруктураРезультатЗапроса, ТекстыОшибок, Ложь);
	
КонецФункции

Функция СтруктураТаблицБДИзДругойБазы(Знач База, ТекстыОшибок = "", Знач Кэш = Неопределено, Знач ОписаниеОповещения = Неопределено) Экспорт
	
	Если Кэш = Неопределено Тогда
		Кэш = Спец_ПолучитьКэш();
	КонецЕсли;
	
	СтруктураЗапроса = Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientПолучитьСтруктураЗапроса("hs/specialExchange/metadata/BD",
		"ОбновитьСтруктуруТаблицБДИзБазы",
		"GET");
	
	#Если Клиент Тогда
		
		Если ОписаниеОповещения <> Неопределено Тогда
			
			ДополнительныеПараметры = Новый Структура("ОписаниеОповещения, База", ОписаниеОповещения, База);
			ОписаниеОповещенияПослеВыполнения = Новый ОписаниеОповещения("СтруктураТаблицБДИзДругойБазы_ПослеВыполнения",
				Спец_ОбменСДругимиБазамиКлиент,
				ДополнительныеПараметры);
			
			Спец_ОбменСДругимиБазамиКлиент.ОтправитьHTTPЗапросыКНужнойБазеАсинхронно(База, СтруктураЗапроса, ОписаниеОповещенияПослеВыполнения, Истина, Ложь, Кэш);
			Возврат Истина;
			
		КонецЕсли;
		
	#КонецЕсли
	
	СтруктураРезультатЗапроса = ОтправитьЗапросыКНужнойБазе(База, СтруктураЗапроса, , , , ТекстыОшибок, Кэш);
	Возврат СтруктураТаблицБДИзДругойБазы_ОбработатьРезультатВыполнения(СтруктураРезультатЗапроса, ТекстыОшибок, База, Кэш);
	
КонецФункции

Функция ЗаписатьПараметрыОбменовВБазу(Знач База, ТекстыОшибок = "", Знач Кэш = Неопределено, Знач ОписаниеОповещения = Неопределено) Экспорт
	
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		
		ЧерезFTP        = Спец_ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(База, "ОбмениватьЧерезFTP");
		ГУИДТекущейБазы = Спец_ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(Спец_ОбщегоНазначенияКлиентСерверПовтИсп.ЗначениеПараметраСеанса("Спец_ТекущаяБаза"), "ГУИД");
		
	#Иначе
		
		ЧерезFTP        = Спец_ОбщегоНазначения.ЗначениеРеквизитаОбъекта(База, "ОбмениватьЧерезFTP", , Кэш);
		ГУИДТекущейБазы = Спец_ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Спец_ОбщегоНазначенияПовтИсп.ЗначениеПараметраСеанса("Спец_ТекущаяБаза"), "ГУИД", , Кэш);
		
	#КонецЕсли
	
	МассивДанныеДляПередачи = Спец_ОбменСДругимиБазамиВызовСервера.МассивПараметровДляПередачиВБазу(База);
	
	#Если Клиент Тогда
		
		Если Не ЧерезFTP И ОписаниеОповещения <> Неопределено Тогда
			
			СтруктураЗапроса = Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientПолучитьСтруктураЗапроса("hs/specialExchange/parameters",
					"ЗаписатьПараметрыОбменовВБазу",
					"POST",
					МассивДанныеДляПередачи);
			
			ОписаниеОповещенияПослеВыполнения = Новый ОписаниеОповещения("ПослеВыполненияЗапросаБезРезультата",
					Спец_ОбменСДругимиБазамиКлиент,
					ОписаниеОповещения);
			
			Спец_ОбменСДругимиБазамиКлиент.ОтправитьHTTPЗапросыКНужнойБазеАсинхронно(База, СтруктураЗапроса, ОписаниеОповещенияПослеВыполнения, Истина, Ложь, Кэш);
			Возврат Истина;
			
		КонецЕсли;
		
	#КонецЕсли
	
	Если ЧерезFTP Тогда
		
		FTPСоединение = ПолучитьFTPСоединениеДляОбменаСБазой(Истина, База, "specialExchange", Кэш);
		Если FTPСоединение = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ИмяФайлаДляЗапроса = СтрШаблон("params_%1.json", ГУИДТекущейБазы);
		
		ПотокДляЗаписи = Спец_ОбщегоНазначенияКлиентСервер.ПодготовитьВременныйФайловыйПоток();
		ЗаписьJSON     = Спец_ОбщегоНазначенияКлиентСервер.ПодготовитьЗаписьJSONПоПотоку(ПотокДляЗаписи);
		
		#Если Не ВебКлиент Тогда
			ЗаписатьJSON(ЗаписьJSON, МассивДанныеДляПередачи);
		#КонецЕсли
		
		ЗаписьJSON.Закрыть();
		Спец_ОбщегоНазначенияКлиентСервер.СброситьДанныеПотока(ПотокДляЗаписи);
		
		FTPСоединение.Записать(ИмяФайлаДляЗапроса, ПотокДляЗаписи);
		Спец_ОбщегоНазначенияКлиентСервер.ЗакрытьПотокНеМешаяРаботе(ПотокДляЗаписи);
		
		Возврат Истина;
		
	Иначе
		
		СтруктураЗапроса = Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientПолучитьСтруктураЗапроса("hs/specialExchange/parameters",
				"ЗаписатьПараметрыОбменовВБазу",
				"POST",
				МассивДанныеДляПередачи);
		
		СтруктураРезультатЗапроса = ОтправитьЗапросыКНужнойБазе(База, СтруктураЗапроса, , , , ТекстыОшибок, Кэш);
		Возврат СтруктураРезультатЗапроса <> Неопределено И СтруктураРезультатЗапроса.КодОтвета = 204;
		
	КонецЕсли;
	
КонецФункции

Функция ПропинговатьБазу(Знач База, Знач СначалаЛокальныеАдресаБазы = Истина, Знач ТолькоНужныеАдреса = Истина, ТекстыОшибок = "", Знач Кэш = Неопределено, Знач ОписаниеОповещения = Неопределено) Экспорт
	
	Если Кэш = Неопределено Тогда
		Кэш = Спец_ПолучитьКэш();
	КонецЕсли;
	
	СтруктураЗапроса = Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientПолучитьСтруктураЗапроса("hs/specialExchange/ping",
			"Пинг",
			"GET");
	
	#Если Клиент Тогда
		
		Если ОписаниеОповещения <> Неопределено Тогда
			
			ОписаниеОповещенияПослеВыполнения = Новый ОписаниеОповещения("ПослеВыполненияЗапросаБезРезультата",
					Спец_ОбменСДругимиБазамиКлиент,
					ОписаниеОповещения);
			
			Спец_ОбменСДругимиБазамиКлиент.ОтправитьHTTPЗапросыКНужнойБазеАсинхронно(База,
					СтруктураЗапроса,
					ОписаниеОповещенияПослеВыполнения,
					СначалаЛокальныеАдресаБазы,
					ТолькоНужныеАдреса,
					Кэш);
			
			Возврат Истина;
			
		КонецЕсли;
		
	#КонецЕсли
	
	СтруктураРезультатЗапроса = ОтправитьЗапросыКНужнойБазе(База, СтруктураЗапроса, СначалаЛокальныеАдресаБазы, Истина, ТолькоНужныеАдреса, ТекстыОшибок, Кэш);
	Возврат СтруктураРезультатЗапроса <> Неопределено И СтруктураРезультатЗапроса.КодОтвета = 204;
	
КонецФункции

Функция ОтправитьОшибкуВБазу(Знач ТекстОшибкиИлиИнформацияОбОшибке, Знач ИмяПроцедуры = "", Знач База = Неопределено,
		ТекстыОшибок = "", Знач Кэш = Неопределено, Знач ОписаниеОповещения = Неопределено) Экспорт
	
	Если Кэш = Неопределено Тогда
		Кэш = Спец_ПолучитьКэш();
	КонецЕсли;
	
	Если База = Неопределено Тогда
		База = ПредопределенноеЗначение("Справочник.Спец_Базы.Номенклатура");
	КонецЕсли;
	
	ДляОтправки = "";
	
	Спец_ОбщегоНазначенияКлиентСервер.ДобавитьОшибку(ТекстОшибкиИлиИнформацияОбОшибке, ИмяПроцедуры, ДляОтправки);
	Если ПустаяСтрока(ДляОтправки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	СтруктураЗапроса = Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientПолучитьСтруктураЗапроса("hs/specialExchange/errors",
			"ЗаписатьОшибку",
			"PUT",
			ДляОтправки);
	
	#Если Клиент Тогда
		
		Если ОписаниеОповещения <> Неопределено Тогда
			
			ОписаниеОповещенияПослеВыполнения = Новый ОписаниеОповещения("ПослеВыполненияЗапросаБезРезультата",
					Спец_ОбменСДругимиБазамиКлиент,
					ОписаниеОповещения);
			
			Спец_ОбменСДругимиБазамиКлиент.ОтправитьHTTPЗапросыКНужнойБазеАсинхронно(База,
					СтруктураЗапроса,
					ОписаниеОповещенияПослеВыполнения,
					Ложь,
					Ложь,
					Кэш);
			
			Возврат Истина;
			
		КонецЕсли;
		
	#КонецЕсли
	
	Попытка
		
		СтруктураРезультатЗапроса = ОтправитьЗапросыКНужнойБазе(База, СтруктураЗапроса, Ложь, Истина, Ложь, ТекстыОшибок, Кэш);
		Возврат СтруктураРезультатЗапроса <> Неопределено И СтруктураРезультатЗапроса.КодОтвета = 204;
		
	Исключение
		
		Спец_ОбщегоНазначенияВызовСервера.ЗаписатьОшибки("Спец_ОбменСДругимиБазамиКлиентСервер.ОтправитьОшибкуВБазу(...)",
				ИнформацияОбОшибке());
		
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции

#КонецОбласти

Функция МассивТиповМетаданныхДляОбмена() Экспорт
	
	МассивТипов = Спец_РаботаСКоллекциямиКлиентСервер.СкопироватьРекурсивно(Спец_ОбщегоНазначенияКлиентСерверПовтИсп.ВсеТипыОбъектовИзМетаданных(), Ложь);
	Спец_РаботаСКоллекциямиКлиентСервер.УдалитьЗначениеИзМассива(МассивТипов, "Константы");
	
	Возврат МассивТипов;
	
КонецФункции

Функция ПодготовитьСтруктуруРегистраПоСтроке(Знач Строка) Экспорт
	
	СтруктураОбъекта = Новый Структура("Объект_1, Объект_2, Объект_3, Объект_4, Объект_5");
	Для i = 1 По 5 Цикл
		СтруктураОбъекта["Объект_" + i] = Сред(Строка, i * 1024 + 1, 1024);
	КонецЦикла;
	
	Возврат СтруктураОбъекта;
	
КонецФункции

Функция ПолучитьFTPСоединениеДляОбменаСБазой(Знач ЭтоБазаОтправитель, Знач База, Знач ДополнительныйКаталогДляПерехода = "", Знач Кэш = Неопределено) Экспорт
	
	#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
		РеквизитыБазы = Спец_ОбщегоНазначенияВызовСервера.ЗначенияРеквизитовОбъекта(База, "АдресFTPДляОбменов, ВнутреннийПутьКаталогаFTP");
	#Иначе
		РеквизитыБазы = Спец_ОбщегоНазначения.ЗначенияРеквизитовОбъекта(База, "АдресFTPДляОбменов, ВнутреннийПутьКаталогаFTP", , Кэш);
	#КонецЕсли
	
	Если ПустаяСтрока(РеквизитыБазы.ВнутреннийПутьКаталогаFTP) Тогда
		ВызватьИсключение "Не установлен FTP каталог для обменов для базы " + База;
	КонецЕсли;
	
	АдресFTP = СтрШаблон("%1/%2/%3",
			?(ЭтоБазаОтправитель,
					Спец_ПолучитьКонстанту(ПредопределенноеЗначение("ПланВидовХарактеристик.Спец_Константы.ОбщийFTPКаталог"), ""),
					РеквизитыБазы.АдресFTPДляОбменов),
			РеквизитыБазы.ВнутреннийПутьКаталогаFTP,
			ДополнительныйКаталогДляПерехода);
	
	FTPСоединение = Спец_ОбщегоНазначенияКлиентСервер.ПолучитьFTPСоединениеПоURLИПерейтиККаталогу(АдресFTP, 3600);
	Если FTPСоединение = Неопределено Тогда
		ВызватьИсключение "Не удалось установить FTP соединение с папкой " + АдресFTP;
	Иначе
		Возврат FTPСоединение;
	КонецЕсли;
	
КонецФункции

#Область HTTPЗапросы
// МассивИлиСтруктураЗапросов - для компоненты (без базового URL базы) (неважно, с компонентой запрос или без).
// ОТПРАВЛЯЕМЫЕ ФАЙЛЫ НЕ ЧИСТЯТСЯ СПЕЦИАЛЬНО! Всё на совести кода, который вызывает его.

Функция ОтправитьЗапросыКНужнойБазе(Знач База, Знач МассивИлиСтруктураЗапросов, Знач СначалаЛокальныеАдресаБазы = Истина, Знач ЭтоКороткиеЗапросы = Ложь,
		Знач ТолькоНужныеАдреса = Ложь, ТекстыОшибок = "", Знач Кэш = Неопределено) Экспорт
	
	МассивБазовыхURL = Спец_ОбменСДругимиБазамиВызовСервераПовтИсп.МассивСтруктурБазовыхURLДляЗапросов(База, СначалаЛокальныеАдресаБазы, ТолькоНужныеАдреса);
	Если МассивБазовыхURL.Количество() = 0 Тогда
		
		Спец_СтроковыеФункцииКлиентСервер.ДобавитьСтрокуВТекст("Не удалось отправить запросы! Не установлены URL адреса.",
				ТекстыОшибок,
				Символы.ПС + Символы.ПС);
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClient_ПодключитьЕслиНеПодключали(Кэш);
	
	ТипПереданныхДанных     = ТипЗнч(МассивИлиСтруктураЗапросов);
	ВозвращатьОдинРезультат = Спец_РаботаСКоллекциямиКлиентСервер.ЭтоСтруктура(МассивИлиСтруктураЗапросов, ТипПереданныхДанных);
	Спец_РаботаСКоллекциямиКлиентСервер.ЗначениеВМассив(МассивИлиСтруктураЗапросов, ТипПереданныхДанных);
	
	НуженЧистыйURL                               = Кэш.КомпонентаHTTPClient <> Неопределено;
	МассивРезультатДляВозврата                   = Новый Массив;
	МассивИдентификаторовДляПовторногоВыполнения = Новый Массив;
	
	Для i = 0 По МассивБазовыхURL.ВГраница() Цикл
		
		СтруктураБазовогоURL        = МассивБазовыхURL.Получить(i);
		МассивЗапросовДляВыполнения = Новый Массив;
		
		Если НуженЧистыйURL Тогда
			ЧистыйURL = СтрЗаменить(СтруктураБазовогоURL.БазовыйURL, СтрШаблон("%1:%2@", СтруктураБазовогоURL.Пользователь, СтруктураБазовогоURL.Пароль), "");
		КонецЕсли;
		
		Если i = 0 Тогда
			
			j = 0;
			Для Каждого СтруктураЗапроса Из МассивИлиСтруктураЗапросов Цикл
				
				Если СтруктураЗапроса.ИдентификаторЗапроса = "default" Тогда
					СтруктураЗапроса.ИдентификаторЗапроса = Формат(j, "ЧН=0; ЧГ=");
				КонецЕсли;
				
				СтруктураЗапросаДляВыполнения     = Спец_РаботаСКоллекциямиКлиентСервер.СкопироватьРекурсивно(СтруктураЗапроса, Ложь);
				СтруктураЗапросаДляВыполнения.URL = ?(НуженЧистыйURL, ЧистыйURL, СтруктураБазовогоURL.БазовыйURL) + СтруктураЗапросаДляВыполнения.URL;
				
				МассивЗапросовДляВыполнения.Добавить(СтруктураЗапросаДляВыполнения);
				
				j = j + 1;
				
			КонецЦикла;
			
		Иначе
			
			Для Каждого СтруктураЗапроса Из МассивИлиСтруктураЗапросов Цикл
				
				Если МассивИдентификаторовДляПовторногоВыполнения.Найти(СтруктураЗапроса.ИдентификаторЗапроса) = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				СтруктураЗапросаДляВыполнения     = Спец_РаботаСКоллекциямиКлиентСервер.СкопироватьРекурсивно(СтруктураЗапроса, Ложь);
				СтруктураЗапросаДляВыполнения.URL = ?(НуженЧистыйURL, ЧистыйURL, СтруктураБазовогоURL.БазовыйURL) + СтруктураЗапросаДляВыполнения.URL;
				
				Если СтруктураЗапросаДляВыполнения.ИдентификаторЗапроса = "default" Тогда
					СтруктураЗапросаДляВыполнения.ИдентификаторЗапроса = Формат(j, "ЧН=0; ЧГ=");
				КонецЕсли;
				
				МассивЗапросовДляВыполнения.Добавить(СтруктураЗапросаДляВыполнения);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если НуженЧистыйURL Тогда
			
			// Имя пользователя, пароль и таймаут
			Кэш.КомпонентаHTTPClient.Username   = СтруктураБазовогоURL.Пользователь;
			Кэш.КомпонентаHTTPClient.Password   = СтруктураБазовогоURL.Пароль;
			Кэш.КомпонентаHTTPClient.Timeout_ms = ?(Не ЭтоКороткиеЗапросы, СтруктураБазовогоURL.ТаймаутДлинный * 1000, СтруктураБазовогоURL.ТаймаутКороткий) * МассивЗапросовДляВыполнения.Количество();
			
		Иначе
			
			Кэш.ТекущийТаймАутHTTPЗапросов = ?(Не ЭтоКороткиеЗапросы, СтруктураБазовогоURL.ТаймаутДлинный, Цел(СтруктураБазовогоURL.ТаймаутКороткий / 1000));
			
		КонецЕсли;
		
		МассивРезультат = Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientОтправитьЗапросыАсинхронно(МассивЗапросовДляВыполнения,
				ТекстыОшибок,
				Кэш);
		
		Спец_РаботаСКоллекциямиКлиентСервер.ЗначениеВМассив(МассивРезультат);
		ОбработатьРезультатыВыполненияЗапросов(МассивРезультат, ТекстыОшибок);
		
		Для Каждого СтруктураЗапроса Из МассивРезультат Цикл
			
			Если СтруктураЗапроса.КодОтвета > 0 Тогда
				
				МассивРезультатДляВозврата.Добавить(СтруктураЗапроса);
				Спец_РаботаСКоллекциямиКлиентСервер.УдалитьЗначениеИзМассива(МассивИдентификаторовДляПовторногоВыполнения, СтруктураЗапроса.ИдентификаторЗапроса);
				
			Иначе
				
				МассивИдентификаторовДляПовторногоВыполнения.Добавить(СтруктураЗапроса.ИдентификаторЗапроса);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если МассивИдентификаторовДляПовторногоВыполнения.Количество() = 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивРезультатДляВозврата.Количество() = 0 Тогда
		Возврат Неопределено;
	ИначеЕсли ВозвращатьОдинРезультат Тогда
		Возврат МассивРезультатДляВозврата.Получить(0);
	Иначе
		Возврат МассивРезультатДляВозврата;
	КонецЕсли;
	
КонецФункции

Функция ЗарегистрироватьЗапросыКОтправкеКНужнойБазе(Знач База, Знач МассивИлиСтруктураЗапросов, Знач СначалаЛокальныеАдресаБазы = Истина,
		Знач ТолькоНужныеАдреса = Ложь, ТекстыОшибок = "", Знач Кэш = Неопределено) Экспорт
	
	МассивБазовыхURL = Спец_ОбменСДругимиБазамиВызовСервераПовтИсп.МассивСтруктурБазовыхURLДляЗапросов(База, СначалаЛокальныеАдресаБазы, ТолькоНужныеАдреса);
	Если МассивБазовыхURL.Количество() = 0 Тогда
		
		Спец_СтроковыеФункцииКлиентСервер.ДобавитьСтрокуВТекст("Не удалось зарегистрировать запросы к отправке! Не установлены URL адреса.",
				ТекстыОшибок,
				Символы.ПС + Символы.ПС);
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClient_ПодключитьЕслиНеПодключали(Кэш);
	Спец_РаботаСКоллекциямиКлиентСервер.ЗначениеВМассив(МассивИлиСтруктураЗапросов);
	
	НуженЧистыйURL       = Кэш.КомпонентаHTTPClient <> Неопределено;
	СтруктураБазовогоURL = МассивБазовыхURL.Получить(0);
	
	Если НуженЧистыйURL Тогда
		ЧистыйURL = СтрЗаменить(СтруктураБазовогоURL.БазовыйURL, СтрШаблон("%1:%2@", СтруктураБазовогоURL.Пользователь, СтруктураБазовогоURL.Пароль), "");
	КонецЕсли;
	
	МассивЗапросовДляВыполнения = Новый Массив;
	
	j = 0;
	Для Каждого СтруктураЗапроса Из МассивИлиСтруктураЗапросов Цикл
		
		Если СтруктураЗапроса.ИдентификаторЗапроса = "default" Тогда
			СтруктураЗапроса.ИдентификаторЗапроса = Формат(j, "ЧН=0; ЧГ=");
		КонецЕсли;
		
		СтруктураЗапросаДляВыполнения     = Спец_РаботаСКоллекциямиКлиентСервер.СкопироватьРекурсивно(СтруктураЗапроса, Ложь);
		СтруктураЗапросаДляВыполнения.URL = ?(НуженЧистыйURL, ЧистыйURL, СтруктураБазовогоURL.БазовыйURL) + СтруктураЗапросаДляВыполнения.URL;
		
		МассивЗапросовДляВыполнения.Добавить(СтруктураЗапросаДляВыполнения);
		j = j + 1;
		
	КонецЦикла;
	
	Если НуженЧистыйURL Тогда
		
		// Имя пользователя, пароль и таймаут
		Кэш.КомпонентаHTTPClient.Username   = СтруктураБазовогоURL.Пользователь;
		Кэш.КомпонентаHTTPClient.Password   = СтруктураБазовогоURL.Пароль;
		Кэш.КомпонентаHTTPClient.Timeout_ms = СтруктураБазовогоURL.ТаймаутДлинный * 1000 * МассивЗапросовДляВыполнения.Количество();
		
	Иначе
		
		Кэш.ТекущийТаймАутHTTPЗапросов = СтруктураБазовогоURL.ТаймаутДлинный;
		
	КонецЕсли;
	
	Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientЗарегистрироватьЗапросыКВыполнению(МассивЗапросовДляВыполнения, Ложь, ТекстыОшибок, Кэш);
	Возврат Истина;
	
КонецФункции

Функция ОжидатьЗавершенияВыполненияЗарегистрированныхКОтправкеЗапросов(Знач База, Знач МассивИлиСтруктураЗапросов, Знач СначалаЛокальныеАдресаБазы = Истина,
		Знач ТолькоНужныеАдреса = Ложь, ТекстыОшибок = "", Знач Кэш = Неопределено) Экспорт
	
	МассивБазовыхURL = Спец_ОбменСДругимиБазамиВызовСервераПовтИсп.МассивСтруктурБазовыхURLДляЗапросов(База, СначалаЛокальныеАдресаБазы, ТолькоНужныеАдреса);
	Если МассивБазовыхURL.Количество() = 0 Тогда
		
		Спец_СтроковыеФункцииКлиентСервер.ДобавитьСтрокуВТекст("Не удалось получить зарегистрированные запросы! Не установлены URL адреса.",
				ТекстыОшибок,
				Символы.ПС + Символы.ПС);
		
		Возврат Новый Массив;
		
	КонецЕсли;
	
	Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClient_ПодключитьЕслиНеПодключали(Кэш);
	
	МассивРезультатДляВозврата            = Новый Массив;
	МассивЗапросовДляПовторногоВыполнения = Новый Массив;
	
	j = 0;
	
	Спец_РаботаСКоллекциямиКлиентСервер.ЗначениеВМассив(МассивИлиСтруктураЗапросов);
	Для Каждого СтруктураЗапроса Из МассивИлиСтруктураЗапросов Цикл
		
		Если СтруктураЗапроса.ИдентификаторЗапроса = "default" Тогда
			СтруктураЗапроса.ИдентификаторЗапроса = Формат(j, "ЧН=0; ЧГ=");
		КонецЕсли;
		
		j = j + 1;
		
	КонецЦикла;
	
	МассивРезультат = Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientПолучитьРезультатыЗарегистрированныхЗапросов(ТекстыОшибок, Кэш);
	Спец_РаботаСКоллекциямиКлиентСервер.ЗначениеВМассив(МассивРезультат);
	ОбработатьРезультатыВыполненияЗапросов(МассивРезультат, ТекстыОшибок);
	
	Для Каждого СтруктураЗапроса Из МассивРезультат Цикл
		
		Если СтруктураЗапроса.КодОтвета > 0 Тогда
			
			МассивРезультатДляВозврата.Добавить(СтруктураЗапроса);
			
		Иначе
			
			СтруктураОтбора = Новый Структура("ИдентификаторЗапроса", СтруктураЗапроса.ИдентификаторЗапроса);
			
			СтруктураЗапросаДляВыполненияЗаново = Спец_РаботаСКоллекциямиКлиентСервер.НайтиСтрокиВКоллекцииСтрок(СтруктураОтбора, МассивИлиСтруктураЗапросов, Истина);
			Если СтруктураЗапросаДляВыполненияЗаново <> Неопределено Тогда
				МассивЗапросовДляПовторногоВыполнения.Добавить(СтруктураЗапросаДляВыполненияЗаново);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивЗапросовДляПовторногоВыполнения.Количество() > 0 Тогда
		
		МассивРезультатДляВозврата_ПовторнаяОтправка = ОтправитьЗапросыКНужнойБазе(База,
				МассивЗапросовДляПовторногоВыполнения,
				СначалаЛокальныеАдресаБазы,
				Ложь,
				ТолькоНужныеАдреса,
				ТекстыОшибок,
				Кэш);
		
		Спец_РаботаСКоллекциямиКлиентСервер.ЗначениеВМассив(МассивРезультатДляВозврата_ПовторнаяОтправка);
		Спец_РаботаСКоллекциямиКлиентСервер.ДополнитьМассив(МассивРезультатДляВозврата_ПовторнаяОтправка, МассивРезультатДляВозврата);
		
	КонецЕсли;
	
	Возврат ?(МассивРезультатДляВозврата.Количество() = 1,
		МассивРезультатДляВозврата.Получить(0),
		МассивРезультатДляВозврата);
	
КонецФункции

Процедура ОбработатьРезультатыВыполненияЗапросов(Знач МассивРезультатовЗапросов, ТекстыОшибок = "") Экспорт
	
	ШаблонСообщения = НСтр("ru = 'Не удалось выполнить запрос ""%1""!
			|	URL запроса: %2
			|	Код ответа: %3
			|	Время ответа: %4 сек.
			|	Тело ответа:
			|		%5'");
	
	Спец_РаботаСКоллекциямиКлиентСервер.ЗначениеВМассив(МассивРезультатовЗапросов);
	Если МассивРезультатовЗапросов.Количество() = 0 Тогда
		
		ТекстСообщения = "Ни один запрос не был выполнен! Проверьте настройки подключения.";
		
		Спец_СтроковыеФункцииКлиентСервер.ДобавитьСтрокуВТекст(ТекстСообщения, ТекстыОшибок, Символы.ПС + Символы.ПС);
		Спец_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	Иначе
		
		Для Каждого СтруктураРезультат Из МассивРезультатовЗапросов Цикл
			
			Если Не СтруктураРезультат.Успешно Тогда
				
				Если СтруктураРезультат.Свойство("ФайлРезультат") Тогда
					
					ТелоОтвет = Спец_СтроковыеФункцииКлиентСервер.СместитьВесьТекстНаРазделитель(
							Спец_ОбщегоНазначенияКлиентСервер.ПрочитатьЧтениеТекста(СтруктураРезультат.ФайлРезультат));
					
				Иначе
					
					ТелоОтвет = Спец_СтроковыеФункцииКлиентСервер.СместитьВесьТекстНаРазделитель(СтруктураРезультат.ТелоРезультат);
					
				КонецЕсли;
				
				ТекстСообщения = СтрШаблон(ШаблонСообщения,
						СтруктураРезультат.ИдентификаторЗапроса,
						СтруктураРезультат.URL,
						СтруктураРезультат.КодОтвета,
						СтруктураРезультат.ВремяОтвета,
						ТелоОтвет);
				
				Спец_СтроковыеФункцииКлиентСервер.ДобавитьСтрокуВТекст(ТекстСообщения, ТекстыОшибок, Символы.ПС + Символы.ПС);
				Спец_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьВсеОбъектыМетаданныхИзБазы_ОбработатьРезультатВыполнения(Знач СтруктураРезультат, ТекстыОшибок, Знач ВызватьИсключениеЕслиНеУдалось) Экспорт
	
	ОбработатьРезультатыВыполненияЗапросов(СтруктураРезультат, ТекстыОшибок);
	Если СтруктураРезультат = Неопределено Или Не СтруктураРезультат.Успешно Тогда
		
		Если ВызватьИсключениеЕслиНеУдалось Тогда
			ВызватьИсключение ТекстыОшибок;
		Иначе
			Возврат Новый Структура;
		КонецЕсли;
		
	Иначе
		
		Возврат Спец_ОбщегоНазначенияКлиентСервер.ПолучитьСоответствиеJSON(СтруктураРезультат.ТелоРезультат, Ложь, Ложь);
		
	КонецЕсли;
	
КонецФункции

Функция СтруктураТаблицБДИзДругойБазы_ОбработатьРезультатВыполнения(Знач СтруктураРезультат, ТекстыОшибок, Знач База, Знач Кэш = Неопределено) Экспорт
	
	ОбработатьРезультатыВыполненияЗапросов(СтруктураРезультат, ТекстыОшибок);
	Если Не СтруктураРезультат.Успешно Тогда
		Возврат ТекстыОшибок;
	КонецЕсли;
	
	МассивРезультат = Спец_ОбщегоНазначенияКлиентСервер.ПолучитьСоответствиеJSON(СтруктураРезультат.ТелоРезультат, Ложь, Ложь);
	Для Каждого СтрокаРезультат Из МассивРезультат Цикл
	
		СтрокаРезультат.ТипДанных         = Спец_ОбщегоНазначенияКлиентСервер.ПолучитьXMLЗначениеПоНормальному(Тип("ПеречислениеСсылка.Спец_ТипыДанныхБазыДанных")         , СтрокаРезультат.ТипДанных);
		СтрокаРезультат.ТипСоставногоПоля = Спец_ОбщегоНазначенияКлиентСервер.ПолучитьXMLЗначениеПоНормальному(Тип("ПеречислениеСсылка.Спец_ТипыСоставныхПолейБазыДанных") , СтрокаРезультат.ТипСоставногоПоля);
	
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции

#КонецОбласти

// @strict-types

//@skip-check method-too-many-params

#Область ПрограммныйИнтерфейс

// Пустая структура для заполнения параметра "ПараметрыШтрихКода" используемого для получения изображения штрих кода.
// 
// Возвращаемое значение:
//	Структура:
//		* Ширина - Число - ширина изображения штрих кода.
//		* Высота - Число - высота изображения штрих кода.
//		* ТипКода - Число - штрихкода. Возможные значение:
//			99 -  Авто выбор
//			0 - EAN8
//			1 - EAN13
//			2 - EAN128
//			3 - Code39
//			4 - Code128
//			5 - Code16k
//			6 - PDF417
//			7 - Standart (Industrial) 2 of 5
//			8 - Interleaved 2 of 5
//			9 - Code39 Расширение
//			10 - Code93
//			11 - ITF14
//			12 - RSS14
//			14 - EAN13AddOn2
//			15 - EAN13AddOn5
//			16 - QR
//			17 - GS1DataBarExpandedStacked
//			18 - Datamatrix ASCII
//			19 - Datamatrix BASE256
//			20 - Datamatrix TEXT
//			21 - Datamatrix C40
//			22 - Datamatrix X12
//			23 - Datamatrix EDIFACT
//			24 - Datamatrix GS1ASCII:
//		* ОтображатьТекст - Булево - отображать HRI теста для штрихкода.
//		* РазмерШрифта - Число - размер шрифта HRI теста для штрихкода.
//		* УголПоворота - Число - угол поворота. Возможные значения: 0, 90, 180, 270.
//		* ШтрихКод - Строка - значение штрихкод в виде строки или Base64.
//		* ТипВходныхДанных - Число - тип входных данных. Возможные значения: 0 - Строка, 1 - Base64
//		* ПрозрачныйФон - Булево - прозрачный фон изображения штрихкода.
//		* УровеньКоррекцииQR - Число - уровень коррекции штрихкода QR. Возможные значения: 0 - L, 1 - M, 2 - Q, 3 - H.
//		* Масштабировать - Булево -  масштабировать изображение штрихкода.
//		* СохранятьПропорции - Булево - сохранять пропорции изображения штрихкода.                                                              
//		* ВертикальноеВыравнивание - Число - вертикальное выравнивание штрихкода. Возможные значения: 1 - По верхнему краю, 2 - По центру, 3 - По нижнему краю
//		* GS1DatabarКоличествоСтрок - Число - количество строк в штрихкоде GS1Databar.
//		* УбратьЛишнийФон - Булево
//		* ЛоготипКартинка - Строка - строка с base64 представлением png картинки логотипа.
//		* ЛоготипРазмерПроцентОтШК - Число - процент от генерированного QR для вписывания логотипа.
//
Функция ПодготовитьПараметрыГенерацииШтрихКода() Экспорт
	
	//@skip-check structure-consructor-too-many-keys
	СтруктураДляВозврата = Новый Структура(
			
			"Ширина,
			|Высота,
			|ТипКода,
			|ОтображатьТекст,
			|РазмерШрифта,
			|УголПоворота,
			|ШтрихКод,
			|ПрозрачныйФон,
			|УровеньКоррекцииQR,
			|Масштабировать,
			|СохранятьПропорции,
			|ВертикальноеВыравнивание,
			|GS1DatabarКоличествоСтрок,
			|ТипВходныхДанных,
			|УбратьЛишнийФон,
			|ЛоготипКартинка,
			|ЛоготипРазмерПроцентОтШК",
			
			100,
			100,
			99,
			Истина,
			12,
			0,
			"",
			Истина,
			1,
			Ложь,
			Ложь,
			1,
			2,
			0,
			Ложь,
			"",
			0);
	
	Возврат СтруктураДляВозврата;
	
КонецФункции

// Возвращает двоичные данные для формирования QR-кода.
//
// Параметры:
//	QRСтрока - Строка - данные, которые необходимо разместить в QR-коде.
//  УровеньКоррекции - Число - уровень погрешности изображения, при котором данный QR-код все еще возможно 100% распознать.
//                     Параметр должен иметь тип целого и принимать одно из 4 допустимых значений:
//                     0 (7 % погрешности), 1 (15 % погрешности), 2 (25 % погрешности), 3 (35 % погрешности).
//  Размер - Число - определяет длину стороны выходного изображения в пикселях.
//                     Если минимально возможный размер изображения больше этого параметра - код сформирован не будет.
//
// Возвращаемое значение:
//  ДвоичныеДанные - буфер, содержащий байты PNG-изображения QR-кода.
// 
// Пример:
//  
//  // Выводим на печать QR-код, содержащий в себе информацию зашифрованную по УФЭБС.
//
//  QRСтрока = УправлениеПечатью.ФорматнаяСтрокаУФЭБС(РеквизитыПлатежа);
//  ТекстОшибки = "";
//  ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRСтрока, 0, 190, ТекстОшибки);
//  Если Не ПустаяСтрока(ТекстОшибки)
//      ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
//  КонецЕсли;
//
//  КартинкаQRКода = Новый Картинка(ДанныеQRКода);
//  ОбластьМакета.Рисунки.QRКод.Картинка = КартинкаQRКода;
//
Функция ПолучитьДанныеQRКодаДляГенерации(Знач QRСтрока, Знач УровеньКоррекции, Знач Размер) Экспорт
	
	ПараметрыШтрихКода = ПодготовитьПараметрыГенерацииШтрихКода();
	ПараметрыШтрихКода.Ширина = Размер;
	ПараметрыШтрихКода.Высота = Размер;
	ПараметрыШтрихКода.ШтрихКод = QRСтрока;
	ПараметрыШтрихКода.УровеньКоррекцииQR = УровеньКоррекции;
	ПараметрыШтрихКода.ТипКода = 16; // QR
	ПараметрыШтрихКода.УбратьЛишнийФон = Истина;
	
	РезультатФормированияШтрихКода = ПолучитьИзображениеШтрихКода(ПараметрыШтрихКода);
	Возврат РезультатФормированияШтрихКода.ДвоичныеДанные;
	
КонецФункции

// Быстрый разбор штрих-кода DataMatrix.
//
// Параметры:
//	ШтрихКод - Строка - Штрих-код, который нужно разобрать. Есть возможность ручного ввода SGTIN или SSCC.
//
// Возвращаемое значение:
//	Структура - Получить данные QR кода при сканировании:
//		* Код - Строка - Либо SGTIN, либо SSCC (если это транпортная упаковка)
//		* ШтрихКод - Строка - Исходное представление штрих-кода (без разделителей и спец. символов)
//		* ШтрихКодBase64 - Строка - Исходный штрих-код в формате Base64 (если штрих-код был отсканирован, а не введён вручную)
//		* GTIN - ОпределяемыйТип.Спец_GTIN - GTIN позиции (если это НЕ транспортная упаковка)
//		* СерийныйНомерУпаковки - Строка - Серийный номер упаковки (серийный номер упаковки, если это НЕ транспортная упаковка)
//		* ТипУпаковки - ПеречислениеСсылка.Спец_ТипыУпаковок - Тип упаковки
//		* ТоварнаяГруппа - ПеречислениеСсылка.Спец_ТипыМаркируемогоТовара - Тип маркировки
//		* Количество - Число - Количество
//
//@skip-check statement-type-change
//@skip-check property-return-type
//@skip-check invocation-parameter-type-intersect
//
Функция ПолучитьДанныеDataMatrixКодаПриСканировании(Знач ШтрихКод) Экспорт
	
	Спец_ЗаписатьЛог("Отсканирован штрих-код", ПредопределенноеЗначение("Перечисление.Спец_УровниЛогирования.Информация"), "Отсканирован штрих-код: " + ШтрихКод);
	
	ДлинаВведенногоШтрихКода = СтрДлина(ШтрихКод);
	Если ДлинаВведенногоШтрихКода = 27 Тогда // SGTIN, введённый руками
		ШтрихКод = "(01)" + Лев(ШтрихКод, 14) + "(21)" + Сред(ШтрихКод, 15, 13);
	ИначеЕсли ДлинаВведенногоШтрихКода = 18 И МенеджерОборудованияКлиентСервер.РассчитатьКонтрольныйСимволGTIN(ШтрихКод) = Прав(ШтрихКод, 1) Тогда // SSCC, введённая руками
		ШтрихКод = "(00)" + ШтрихКод;
	КонецЕсли;
	
	ДанныеРазбора = МенеджерОборудованияМаркировкаКлиентСервер.РазобратьСтрокуШтрихкодаGS1(ШтрихКод);
	Спец_Проверить(ДанныеРазбора <> Неопределено, "Не удалось разобрать штрих-код GS1.");
	Спец_Проверить(ДанныеРазбора.Разобран, ДанныеРазбора.ОписаниеОшибки);
	
	СтруктураШтрихКода = НоваяСтруктураРезультатОбработкиШтрихКода(ШтрихКод, ДанныеРазбора.ПредставлениеШтрихКода);
	Для Каждого КлючЗначение Из ДанныеРазбора.ДанныеШтрихКода Цикл
		
		Если КлючЗначение.Ключ = "01" Тогда
			
			Спец_Проверить(МенеджерОборудованияКлиентСервер.ПроверитьКорректностьGTIN(КлючЗначение.Значение.Значение), "Некорректный GTIN");
			
			СтруктураШтрихКода.GTIN = КлючЗначение.Значение.Значение;
			
		ИначеЕсли КлючЗначение.Ключ = "00" Тогда
			
			Спец_Проверить(МенеджерОборудованияКлиентСервер.РассчитатьКонтрольныйСимволGTIN(КлючЗначение.Значение.Значение) = Прав(КлючЗначение.Значение.Значение, 1),
					"Некорректный номер групповой упаковки");
			
			СтруктураШтрихКода.Код = КлючЗначение.Значение.Значение;
			СтруктураШтрихКода.ТипУпаковки = ПредопределенноеЗначение("Перечисление.Спец_ТипыУпаковок.ГрупповаяУпаковка");
			
		ИначеЕсли КлючЗначение.Ключ = "21" Тогда
			
			СтруктураШтрихКода.СерийныйНомерУпаковки = КлючЗначение.Значение.Значение;
			
		ИначеЕсли СтрНачинаетсяС(КлючЗначение.Ключ, "30") Тогда
			
			СтруктураШтрихКода.Количество = КлючЗначение.Значение.Значение;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если СтруктураШтрихКода.ТипУпаковки = ПредопределенноеЗначение("Перечисление.Спец_ТипыУпаковок.ЕдиницаТовара") Тогда
		
		Спец_Проверить(Не ПустаяСтрока(СтруктураШтрихКода.GTIN) И Не ПустаяСтрока(СтруктураШтрихКода.СерийныйНомерУпаковки),
				"Некорректный код маркировочной позиции (не нашёл GTIN и серийный номер упаковки)");
		
		СтруктураШтрихКода.Код = СтруктураШтрихКода.GTIN + СтруктураШтрихКода.СерийныйНомерУпаковки;
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(СтруктураШтрихКода.GTIN) Тогда
		
		#Если ТонкийКлиент Или ВебКлиент Или ТолстыйКлиентУправляемоеПриложение Тогда
			СтруктураШтрихКода.ТоварнаяГруппа = Спец_ГенерацияЧтениеШтрихКодаВызовСервера.ТипМаркировкиПоGTIN(СтруктураШтрихКода.GTIN);
		#Иначе
			СтруктураШтрихКода.ТоварнаяГруппа = Спец_ГенерацияЧтениеШтрихКода.ТипМаркировкиПоGTIN(СтруктураШтрихКода.GTIN);
		#КонецЕсли
		
	КонецЕсли;
	
	Возврат СтруктураШтрихКода;
	
КонецФункции

// Формирует изображение штрих-кода.
// 
// Параметры:
//  ПараметрыШтрихКода - см. ПодготовитьПараметрыГенерацииШтрихКода
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
// 
// Возвращаемое значение:
//	Структура - Получить изображение штрих-кода:
//		* Результат - Булево - Флаг успешности выполнения
//		* ДвоичныеДанные - ДвоичныеДанные - Двоичные данные картинки
//		* Картинка - Картинка - Изображение штрих-кода
//
Функция ПолучитьИзображениеШтрихКода(Знач ПараметрыШтрихКода, Знач Кэш = Неопределено) Экспорт
	
	ПодключитьВнешнююКомпонентуГенерацииШК(Кэш);
	Спец_Проверить(Кэш.ПО_КомпонентаГенерацииШтрихКода <> Неопределено,
			"Не удалось подключить компоненту для генерации штрих-кодов!",
			"Спец_ГенерацияЧтениеШтрихКодаКлиентСервер.ПолучитьИзображениеШтрихКода");
	
	Возврат ПодготовитьИзображениеШтрихКода(Кэш.ПО_КомпонентаГенерацииШтрихКода, ПараметрыШтрихКода); 
	 
КонецФункции

// Сформировать SGTIN.
// 
// Параметры:
//  ДанныеШтрихКода - Структура - Данные штрих-кода, должна содержать следующие поля:
//  	* GTIN - Строка
// 		* СерийныйНомерУпаковки - Строка
//
// Возвращаемое значение:
//  Строка - Сформировать SGTIN
//
Функция СформироватьSGTIN(Знач ДанныеШтрихКода) Экспорт
	
	Возврат СтрШаблон("01%(1)21%2",
			Спец_РаботаСКоллекциямиКлиентСервер.СвойствоСтруктуры(ДанныеШтрихКода, "GTIN", ""),
			Спец_РаботаСКоллекциямиКлиентСервер.СвойствоСтруктуры(ДанныеШтрихКода, "СерийныйНомерУпаковки", ""));
	
КонецФункции

// Формирует SSCC по структуре данных по штрих-коду.
// 
// Параметры:
//  ДанныеШтрихКода - Структура - Данные штрих-кода
// 
// Возвращаемое значение:
//  Строка - SSCC
//
Функция СформироватьSSCC(Знач ДанныеШтрихКода) Экспорт
	
	Возврат "00" + Спец_РаботаСКоллекциямиКлиентСервер.СвойствоСтруктуры(ДанныеШтрихКода, "Код", "");
	
КонецФункции

#КонецОбласти

//@skip-check dynamic-access-method-not-found
#Область СлужебныеПроцедурыИФункции

// Параметры:
//  ВнешняяКомпонента - см. Спец_ГенерацияЧтениеШтрихКодаКлиентСерверПовтИсп.ПолучитьОбъектВнешнейКомпонентыГенерацияШтрихКода
//  ПараметрыШтрихКода - см. ПодготовитьПараметрыГенерацииШтрихКода
// 
// Возвращаемое значение:
//  см. НоваяСтруктураРезультатПодготовкиИзображенияШтрихКода
//
Функция ПодготовитьИзображениеШтрихКода(Знач ВнешняяКомпонента, Знач ПараметрыШтрихКода)
	
	// Результат 
	РезультатОперации = НоваяСтруктураРезультатПодготовкиИзображенияШтрихКода();
	
	// Зададим размер формируемой картинки.
	ШиринаШтрихКода = Окр(ПараметрыШтрихКода.Ширина);
	ВысотаШтрихКода = Окр(ПараметрыШтрихКода.Высота);
	Если ШиринаШтрихКода <= 0 Тогда
		ШиринаШтрихКода = 1
	КонецЕсли;
	Если ВысотаШтрихКода <= 0 Тогда
		ВысотаШтрихКода = 1
	КонецЕсли;
	ВнешняяКомпонента.Ширина = ШиринаШтрихКода;
	ВнешняяКомпонента.Высота = ВысотаШтрихКода;
	ВнешняяКомпонента.АвтоТип = Ложь;
	
	ШтрихКодВрем = Строка(ПараметрыШтрихКода.ШтрихКод); // Преобразуем явно в строку.
	
	Если ПараметрыШтрихКода.ТипКода = 99 Тогда
		ВнешняяКомпонента.АвтоТип = Истина;
	Иначе
		ВнешняяКомпонента.АвтоТип = Ложь;
		ВнешняяКомпонента.ТипКода = ПараметрыШтрихКода.ТипКода;
	КонецЕсли;
	
	Если ПараметрыШтрихКода.Свойство("ПрозрачныйФон") Тогда
		ВнешняяКомпонента.ПрозрачныйФон = ПараметрыШтрихКода.ПрозрачныйФон;
	КонецЕсли;
	
	Если ПараметрыШтрихКода.Свойство("ТипВходныхДанных") Тогда
		ВнешняяКомпонента.ТипВходныхДанных = ПараметрыШтрихКода.ТипВходныхДанных;
	КонецЕсли;
	
	Если ПараметрыШтрихКода.Свойство("GS1DatabarКоличествоСтрок") Тогда
		ВнешняяКомпонента.GS1DatabarКоличествоСтрок = ПараметрыШтрихКода.GS1DatabarКоличествоСтрок;
	КонецЕсли;
	
	Если ПараметрыШтрихКода.Свойство("УбратьЛишнийФон") Тогда
		ВнешняяКомпонента.УбратьЛишнийФон = ПараметрыШтрихКода.УбратьЛишнийФон;
	КонецЕсли;
	
	ВнешняяКомпонента.ОтображатьТекст = ПараметрыШтрихКода.ОтображатьТекст;
	// Формируем картинку штрихкода.
	ВнешняяКомпонента.ЗначениеКода = ШтрихКодВрем;
	// Угол поворота штрихкода.
	ВнешняяКомпонента.УголПоворота = ?(ПараметрыШтрихКода.Свойство("УголПоворота"), ПараметрыШтрихКода.УголПоворота, 0);
	// Уровень коррекции QR кода (L=0, M=1, Q=2, H=3).
	ВнешняяКомпонента.УровеньКоррекцииQR = ?(ПараметрыШтрихКода.Свойство("УровеньКоррекцииQR"), ПараметрыШтрихКода.УровеньКоррекцииQR, 1);
	
	// Для обеспечения совместимости с предыдущими версиями БПО.
	Если Не ПараметрыШтрихКода.Свойство("Масштабировать")
		Или (ПараметрыШтрихКода.Свойство("Масштабировать") И ПараметрыШтрихКода.Масштабировать) Тогда
		
		Если Не ПараметрыШтрихКода.Свойство("СохранятьПропорции")
				Или (ПараметрыШтрихКода.Свойство("СохранятьПропорции") И Не ПараметрыШтрихКода.СохранятьПропорции) Тогда
			// Если установленная нами ширина меньше минимально допустимой для этого штрихкода.
			Если ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода Тогда
				ВнешняяКомпонента.Ширина = ВнешняяКомпонента.МинимальнаяШиринаКода;
			КонецЕсли;
			// Если установленная нами высота меньше минимально допустимой для этого штрихкода.
			Если ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Тогда
				ВнешняяКомпонента.Высота = ВнешняяКомпонента.МинимальнаяВысотаКода;
			КонецЕсли;
		ИначеЕсли ПараметрыШтрихКода.Свойство("СохранятьПропорции") И ПараметрыШтрихКода.СохранятьПропорции Тогда
			Пока ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода 
				Или ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Цикл
				// Если установленная нами ширина меньше минимально допустимой для этого штрихкода.
				Если ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода Тогда
					ВнешняяКомпонента.Ширина = ВнешняяКомпонента.МинимальнаяШиринаКода;
					ВнешняяКомпонента.Высота = Окр(ВнешняяКомпонента.МинимальнаяШиринаКода / ШиринаШтрихКода) * ВысотаШтрихКода;
				КонецЕсли;
				// Если установленная нами высота меньше минимально допустимой для этого штрихкода.
				Если ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Тогда
					ВнешняяКомпонента.Высота = ВнешняяКомпонента.МинимальнаяВысотаКода;
					ВнешняяКомпонента.Ширина = Окр(ВнешняяКомпонента.МинимальнаяВысотаКода / ВысотаШтрихКода) * ШиринаШтрихКода;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	// ВертикальноеВыравниваниеКода: 1 - по верхнему краю, 2 - по центру, 3 - по нижнему краю.
	Если ПараметрыШтрихКода.Свойство("ВертикальноеВыравнивание") И (ПараметрыШтрихКода.ВертикальноеВыравнивание > 0) Тогда
		ВнешняяКомпонента.ВертикальноеВыравниваниеКода = ПараметрыШтрихКода.ВертикальноеВыравнивание;
	КонецЕсли;
	
	Если ПараметрыШтрихКода.Свойство("РазмерШрифта") И (ПараметрыШтрихКода.РазмерШрифта > 0) 
		И (ПараметрыШтрихКода.ОтображатьТекст) И (ВнешняяКомпонента.РазмерШрифта <> ПараметрыШтрихКода.РазмерШрифта) Тогда
			ВнешняяКомпонента.РазмерШрифта = ПараметрыШтрихКода.РазмерШрифта;
	КонецЕсли;
	
	Если ПараметрыШтрихКода.ТипКода = 16 Тогда // QR
		Если ПараметрыШтрихКода.Свойство("ЛоготипКартинка") И ЗначениеЗаполнено(ПараметрыШтрихКода.ЛоготипКартинка) Тогда 
			ВнешняяКомпонента.ЛоготипКартинка = ПараметрыШтрихКода.ЛоготипКартинка;    
		Иначе
			ВнешняяКомпонента.ЛоготипКартинка = "";
		КонецЕсли;
		Если ПараметрыШтрихКода.Свойство("ЛоготипРазмерПроцентОтШК") И ЗначениеЗаполнено(ПараметрыШтрихКода.ЛоготипРазмерПроцентОтШК) Тогда 
			ВнешняяКомпонента.ЛоготипРазмерПроцентОтШК = ПараметрыШтрихКода.ЛоготипРазмерПроцентОтШК;
		КонецЕсли;
	КонецЕсли;
		
	// Сформируем картинку
	ДвоичныеДанныеКартинки = ВнешняяКомпонента.ПолучитьШтрихкод(); // ДвоичныеДанные
	РезультатОперации.Результат = ВнешняяКомпонента.Результат = 0;
	// Если картинка сформировалась.
	Если ДвоичныеДанныеКартинки <> Неопределено Тогда
		РезультатОперации.ДвоичныеДанные = ДвоичныеДанныеКартинки;
		РезультатОперации.Картинка = Новый Картинка(ДвоичныеДанныеКартинки); // Формируем из двоичных данных.
	КонецЕсли;
	
	Возврат РезультатОперации;
	
КонецФункции

// Параметры:
//  Кэш см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
//
Процедура ПодключитьВнешнююКомпонентуГенерацииШК(Кэш)

	Если Кэш = Неопределено Тогда Кэш = Спец_ПолучитьКэш(); КонецЕсли;
	Если Кэш.Свойство("ПО_КомпонентаГенерацииШтрихКода") Тогда
		Возврат;
	КонецЕсли;

	Кэш.Вставить("ПО_КомпонентаГенерацииШтрихКода", Спец_ГенерацияЧтениеШтрихКодаКлиентСерверПовтИсп.ПолучитьОбъектВнешнейКомпонентыГенерацияШтрихКода());
			
	Если Кэш.ПО_КомпонентаГенерацииШтрихКода <> Неопределено Тогда
		
		Если Кэш.ПО_КомпонентаГенерацииШтрихКода.НайтиШрифт("Tahoma") Тогда
			
			Кэш.ПО_КомпонентаГенерацииШтрихКода.Шрифт = "Tahoma";
			
		Иначе
			
			Для i = 0 По Кэш.ПО_КомпонентаГенерацииШтрихКода.КоличествоШрифтов - 1 Цикл
				
				ТекущийШрифт = Кэш.ПО_КомпонентаГенерацииШтрихКода.ШрифтПоИндексу(i); // Строка
				Если ТекущийШрифт <> Неопределено Тогда
					
					Кэш.ПО_КомпонентаГенерацииШтрихКода.Шрифт = ТекущийШрифт;
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Кэш.ПО_КомпонентаГенерацииШтрихКода.РазмерШрифта = 12;
		
	КонецЕсли;
		
КонецПроцедуры

//@skip-check structure-consructor-too-many-keys
//@skip-check constructor-function-return-section
#Область Типизация

// Возвращаемое значение:
//	Структура:
//		* Результат - Булево - Флаг успешности выполнения
//		* ДвоичныеДанные - ДвоичныеДанные - Двоичные данные картинки
//		* Картинка - Картинка - Изображение штрих-кода
//
Функция НоваяСтруктураРезультатПодготовкиИзображенияШтрихКода()
	
	Возврат Новый Структура("Результат, ДвоичныеДанные, Картинка",
			Ложь, Неопределено, Неопределено);
	
КонецФункции

// Параметры:
//	ИсходныйШтрихКод - Строка
//	ШтрихКод - Строка
// 
// Возвращаемое значение:
// см. ПолучитьДанныеDataMatrixКодаПриСканировании
//
Функция НоваяСтруктураРезультатОбработкиШтрихКода(Знач ИсходныйШтрихКод, Знач ШтрихКод)
	
	Возврат Новый Структура(
		
		"ШтрихКод,
		|ШтрихКодBase64,
		|ТоварнаяГруппа,
		|Код,
		|GTIN,
		|СерийныйНомерУпаковки,
		|ТипУпаковки,
		|Количество",
		
		ШтрихКод,
		?(СтрНачинаетсяС(ИсходныйШтрихКод, "("), "", Спец_СтроковыеФункцииКлиентСервер.ЗакодироватьСтрокуВBase64(ИсходныйШтрихКод)),
		ПредопределенноеЗначение("Перечисление.Спец_ТипыМаркируемогоТовара.ПустаяСсылка"),
		"",
		"",
		"",
		ПредопределенноеЗначение("Перечисление.Спец_ТипыУпаковок.ЕдиницаТовара"),
		1);
	
КонецФункции

#КонецОбласти

#КонецОбласти

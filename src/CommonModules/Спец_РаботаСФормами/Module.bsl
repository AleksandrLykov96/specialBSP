
#Область ПрограммныйИнтерфейс

// Обработчик события формы "ПриСозданииНаСервере". Вызывается только с управляемых форм.
// 
// Параметры:
//	 Форма - ФормаКлиентскогоПриложения - форма для добавления кнопки:
//  		* Команды - КомандыФормы
//  		* Элементы - ВсеЭлементыФормы
//  		* КоманднаяПанель - ГруппаФормы
//  		* Спец_ЭтоСсылочныйОбъект - Булево
//  		* Спец_ЭтоРегистр - Булево
//  		* Спец_ПолноеИмяМетаданных - Строка
//  		* Объект - см. Спец_ОбщегоНазначения.ЗаписатьОбъект.ОбъектДляЗаписи
//  		* Запись - см. Спец_ОбщегоНазначения.ЗаписатьОбъект.ОбъектДляЗаписи
//  		* Спец_ИспользоватьПодключаемоеОборудование - Булево
//  	  - Форма - Обычная форма (EDT не умеет с обычными формами):
//  		* ЭлементыФормы - Структура:
//  			** Спец_ЭтоСсылочныйОбъект - Структура:
//  				*** Значение - Булево
//  			** Спец_ЭтоРегистр - Структура:
//  				*** Значение - Булево
//  			** Спец_ПолноеИмяМетаданных - Структура:
//  				*** Значение - Строка
//  			** Спец_УникальныйИдентификаторФормы - Структура:
//  				*** Значение - УникальныйИдентификатор
//  		* Ссылка - ЛюбаяСсылка
//  		* Спец_ИспользоватьПодключаемоеОборудование - Булево
//  		* РегистрСведенийМенеджерЗаписи - РегистрСведенийМенеджерЗаписи
//  Отказ - Булево
//  СтандартнаяОбработка - Булево
//
Процедура ПриСозданииНаСервере(Знач Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	#Если Не ТолстыйКлиентОбычноеПриложение Тогда
		
		Если Спец_ОбщегоНазначенияКлиентСервер.ЭтоУправляемаяФорма(Форма) Тогда
			
			// ++ Спец_БСП.Спец_ЛогированиеОбъектов
			Спец_ЛогированиеОбъектовКлиентСервер.НачатьЗамерДляЛогирования(Форма.ИмяФормы);
			// -- Спец_БСП.Спец_ЛогированиеОбъектов
			
			ДобавитьСлужебныеРеквизитыНаФорму(Форма, Истина);
			
			// ++ Спец_БСП.Спец_ЛогированиеОбъектов
			Спец_ЛогированиеОбъектов.ДобавитьНаФормуКнопкуОткрытияЛогов(Форма);
			// -- Спец_БСП.Спец_ЛогированиеОбъектов
			
			Спец_Переопределяемый.ПриСозданииНаСервереФормы(Форма);
			
		КонецЕсли;

		Если Спец_РаботаСКоллекциямиКлиентСервер.СвойствоСтруктуры(Форма.Параметры, "Спец_ПереопределениеФормыВыбора", Ложь) = Истина Тогда
			Форма.Элементы.Список.РежимВыбора = Истина;
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

#Область КрасиваяПанельОтборов

//@skip-check structure-consructor-too-many-keys
// Структура параметров для создания красивой панели отборов (на форме списка или форме выбора).
// ПолноеИмяОбъектаМетаданных будет взято из основной таблицы элемента списка. Если основная таблица не указана - необходимо указать это полное имя.
// 
// Параметры:
//	ЭлементСписок - ТаблицаФормы - Список, для которого будет сформирована панель отборов
//	КнопкаНастроитьСписок - КнопкаФормы - Так как нельзя программно создать кнопку "Настроить список", то её необходимо создать на форме и передать элемент формы
//	ГруппаПользовательскиеНастройки - ГруппаФормы - Группа пользовательских настроек, которая привязана к списку (тоже нельзя программно)
//
// Возвращаемое значение:
//	Структура - параметры для создания панели отборов:
//		* ЭлементСписок - ТаблицаФормы - Список, для которого будет сформирована панель отборов
//		* КнопкаНастроитьСписок - КнопкаФормы - Так как нельзя программно создать кнопку "Настроить список", то её необходимо создать на форме и передать элемент формы
//		* ГруппаПользовательскиеНастройки - ГруппаФормы - Группа пользовательских настроек, которая привязана к списку (тоже нельзя программно)
//		* ШиринаПанели - Число - ширина выдвигаемой панели отборов
//		* РодительПанели - ГруппаФормы, ФормаКлиентскогоПриложения, Неопределено - Родитель группы панели отборов
//		* ПолноеИмяОбъектаМетаданных - Строка - Полное имя объекта метаданных для типизации отборов
//		* ПараметрыОтборов - Массив из см. НоваяСтруктураОтбораДляПанелиОтборов
//		* ПорядокОтборов - Массив из Строка - Массив отборов в нужном порядке
//
Функция НоваяСтруктураПараметровВыводаПанелиКрасивыхОтборов(Знач ЭлементСписок, Знач КнопкаНастроитьСписок, Знач ГруппаПользовательскиеНастройки) Экспорт
	
	Возврат Новый Структура(
			
			"ЭлементСписок,
			|КнопкаНастроитьСписок,
			|ГруппаПользовательскиеНастройки,
			|ШиринаПанели,
			|РодительПанели,
			|ПолноеИмяОбъектаМетаданных,
			|ПараметрыОтборов,
			|ПорядокОтборов",
			
			ЭлементСписок,
			КнопкаНастроитьСписок,
			ГруппаПользовательскиеНастройки,
			30,
			Неопределено,
			?(ЭлементСписок = Неопределено, "", ЭлементСписок.Родитель[ЭлементСписок.ПутьКДанным].ОсновнаяТаблица),
			Новый Массив(),
			Новый Массив());
	
КонецФункции

// Функция для добавления нового отбора на красивую панель отборов. Возвращает структуру нового отбора
// 
// Параметры:
//	ПараметрыПанели - см. НоваяСтруктураПараметровВыводаПанелиКрасивыхОтборов
//	ИмяПоля - Строка - Имя поля для отбора
//	ВидСравнения - ВидСравненияКомпоновкиДанных - условие отбора.
//	Заголовок - Строка - Заголовок отбора
//	ЧерезСтандартныйПериод - Булево - Если ИСТИНА, то для поля типа "Дата" будет добавлен стандартный период
//	ОписаниеТипаРеквизита - ОписаниеТипов - Описание типа реквизита по умолчанию (если отсутствует в метаданных)
//	
// Возвращаемое значение:
//	Строка - Имя будущего реквизита, в котором будет храниться значение отбора
//
Функция ДобавитьНовыйОтборНаПанель(Знач ПараметрыПанели, Знач ИмяПоля, Знач ВидСравнения, Знач Заголовок,
		Знач ЧерезСтандартныйПериод = Ложь, Знач ОписаниеТипаРеквизита = Неопределено) Экспорт
	
	СтруктураОтбора = НоваяСтруктураОтбораДляПанелиОтборов(ИмяПоля, ВидСравнения, Заголовок, ЧерезСтандартныйПериод, ОписаниеТипаРеквизита);
	ПараметрыПанели.ПараметрыОтборов.Добавить(СтруктураОтбора);
	
	ПараметрыПанели.ПорядокОтборов.Добавить(СтруктураОтбора.ИмяРеквизита);
	Возврат СтруктураОтбора.ИмяРеквизита;
	
КонецФункции

// Основная процедура для вывода красивой панели отборов на форму
//
// Параметры:
//	Форма - см. ПриСозданииНаСервере.Форма
//	ПараметрыПанели - см. НоваяСтруктураПараметровВыводаПанелиКрасивыхОтборов
//
// Пример:
// 
// Для вывода отбора по полю "Дата" через стандартный период
//	СтруктураПараметровПанели = Спец_РаботаСФормами.НоваяСтруктураПараметровВыводаПанелиКрасивыхОтборов(Элементы.Список,
//			Элементы.НастройкаСписка,
//			Элементы.СписокКомпоновщикНастроекПользовательскиеНастройки);
//	
//	Спец_РаботаСФормами.ДобавитьНовыйОтборНаПанель(СтруктураПараметровПанели, "Дата", ВидСравненияКомпоновкиДанных.Равно, "Дата", Истина);
//	Спец_РаботаСФормами.ВывестиПанельОтборовНаФорму(ЭтотОбъект, СтруктураПараметровПанели);
//	
Процедура ВывестиПанельОтборовНаФорму(Знач Форма, Знач ПараметрыПанели) Экспорт
	
#Если Не ТолстыйКлиентОбычноеПриложение Тогда
	
	Если Спец_РаботаСКоллекциямиКлиентСервер.ЕстьРеквизитОбъекта(Форма, Спец_РаботаСФормамиКлиентСервер.ИмяРеквизитаКрасивыеОтборыДобавлены())
		И Форма[Спец_РаботаСФормамиКлиентСервер.ИмяРеквизитаКрасивыеОтборыДобавлены()] Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Кэш = Спец_ПолучитьКэш();
	
	МассивРеквизитовДляДобавления = Новый Массив();
	
	МассивРеквизитовДляДобавления.Добавить(Новый РеквизитФормы(Спец_РаботаСФормамиКлиентСервер.ИмяРеквизитаКрасивыеОтборыДобавлены() , Новый ОписаниеТипов("Булево")));
	МассивРеквизитовДляДобавления.Добавить(Новый РеквизитФормы(Спец_РаботаСФормамиКлиентСервер.ИмяРеквизитаДляИнформацииПоОтборам()  , Спец_ОбщегоНазначенияКлиентСервер.ОписаниеТипаСтрока()));
	
	ГруппаПанель = СоздатьГруппуПанельОтборов(Форма, ПараметрыПанели, МассивРеквизитовДляДобавления);
	СтруктураГруппыОтборов = РаспределитьОтборыПоГруппам(Форма, ПараметрыПанели, МассивРеквизитовДляДобавления, Кэш);
	Спец_ИзменениеФорм.СоздатьРеквизитыФормы(Форма, МассивРеквизитовДляДобавления);
	
	Форма[Спец_РаботаСФормамиКлиентСервер.ИмяРеквизитаКрасивыеОтборыДобавлены()] = Истина;
	
	ВывестиЭлементыФормы(Форма, ПараметрыПанели, ГруппаПанель, СтруктураГруппыОтборов);
	ВосстановитьЗначенияРеквизитов(Форма, МассивРеквизитовДляДобавления);
	УстановитьЗаголовкиПериодов(Форма, СтруктураГруппыОтборов);
	ПереместитьОстальныеЭлементыФормыНаНовуюПанель(Форма, ПараметрыПанели, ГруппаПанель);
	
#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Если Не ТолстыйКлиентОбычноеПриложение Тогда

Процедура ДобавитьСлужебныеРеквизитыНаФорму(Знач Форма, Знач ЭтоУправляемаяФорма)
	
	// Вставим реквизиты ПолноеИмяМетаданных, ЭтоСсылочныйОбъект и ЭтоРегистр
	МассивРеквизитовДляДобавления = Новый Массив();
	
	МассивРеквизитовДляДобавления.Добавить(Новый РеквизитФормы(
			"Спец_ПолноеИмяМетаданных",
			Спец_ОбщегоНазначенияКлиентСервер.ОписаниеТипаСтрока(256)));
	МассивРеквизитовДляДобавления.Добавить(Новый РеквизитФормы(
			"Спец_ЭтоСсылочныйОбъект",
			Новый ОписаниеТипов("Булево")));
	МассивРеквизитовДляДобавления.Добавить(Новый РеквизитФормы(
			"Спец_ЭтоРегистр",
			Новый ОписаниеТипов("Булево")));
	
	Спец_ИзменениеФорм.СоздатьРеквизитыФормы(Форма, МассивРеквизитовДляДобавления);
	
	// Заполним эти реквизиты
	Если Спец_РаботаСКоллекциямиКлиентСервер.ЕстьРеквизитОбъекта(Форма, "Объект")
		И Спец_РаботаСКоллекциямиКлиентСервер.ЕстьРеквизитОбъекта(Форма.Объект, "Ссылка") Тогда // Это ссылочный объект
		
		Форма.Спец_ПолноеИмяМетаданных = Форма.Объект.Ссылка.Метаданные().ПолноеИмя();
		Форма.Спец_ЭтоСсылочныйОбъект  = Истина;
		
	ИначеЕсли Спец_РаботаСКоллекциямиКлиентСервер.ЕстьРеквизитОбъекта(Форма, "Запись")
		И Спец_РаботаСКоллекциямиКлиентСервер.ЕстьРеквизитОбъекта(Форма.Запись, "ИсходныйКлючЗаписи") Тогда // Это регистр
		
		Форма.Спец_ПолноеИмяМетаданных = Форма.Запись.ИсходныйКлючЗаписи.Метаданные().ПолноеИмя();
		Форма.Спец_ЭтоРегистр          = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли

#Область КрасиваяПанельОтборов

#Если Не ТолстыйКлиентОбычноеПриложение Тогда

//@skip-check Undefined variable
//
// Возвращаемое значение:
//	см. Спец_ИзменениеФорм.ДобавитьГруппуБезОтображения
//
Функция СоздатьГруппуПанельОтборов(Знач Форма, Знач ПараметрыПанели, Знач МассивРеквизитовДляДобавления)
	
	// 1. Создаём горизонтальную группу для объединения списка и новых элементов
	ГруппаРодитель = Спец_ИзменениеФорм.ДобавитьГруппуБезОтображения(Форма,
			"ГруппаСпец_ПанельКрасивыхОтборов",
			ПараметрыПанели.РодительПанели);
	
	ГруппаРодитель.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	
	// 2. Перемещаем список на данную форму
	Если ПараметрыПанели.ЭлементСписок <> Неопределено Тогда
		Форма.Элементы.Переместить(ПараметрыПанели.ЭлементСписок, ГруппаРодитель);
	КонецЕсли;
	
	// 3. Создаём декорацию для раскрытия / скрытия панели
	ДекорацияРазделитель = Спец_ИзменениеФорм.ДобавитьДекорациюНадпись(Форма,
			Спец_РаботаСФормамиКлиентСервер.ИмяДекорацииРазделителяГруппыОсновныхПанелей(),
			ГруппаРодитель);
	
	ДекорацияРазделитель.Гиперссылка                    = Истина;
	ДекорацияРазделитель.Шрифт                          = ШрифтыСтиля.ОченьКрупныйШрифтТекста;
	ДекорацияРазделитель.ЦветТекста                     = ЦветаСтиля.ЦветТекстаПоля;
	ДекорацияРазделитель.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Центр;
	ДекорацияРазделитель.ВертикальноеПоложениеВГруппе   = ВертикальноеПоложениеЭлемента.Центр;
	ДекорацияРазделитель.ВертикальноеПоложение          = ВертикальноеПоложениеЭлемента.Центр;
	ДекорацияРазделитель.ГоризонтальноеПоложение        = ГоризонтальноеПоложениеЭлемента.Центр;
	ДекорацияРазделитель.РастягиватьПоГоризонтали       = Ложь;
	ДекорацияРазделитель.РастягиватьПоВертикали         = Ложь;
	
	ДекорацияРазделитель.УстановитьДействие("Нажатие", Спец_РаботаСФормамиКлиентСервер.ИмяПроцедурыДляОбработкиСобытияОтбора());
	МассивРеквизитовДляДобавления.Добавить(Новый РеквизитФормы(Спец_РаботаСФормамиКлиентСервер.ИмяРеквизитаРазделительНажат(), Новый ОписаниеТипов("Булево")));
	
	// 4. Создаём группу для размещения панели
	ГруппаПанель = Спец_ИзменениеФорм.ДобавитьГруппуБезОтображения(Форма,
			Спец_РаботаСФормамиКлиентСервер.ИмяОсновнойГруппыПанелейОтборов(),
			ГруппаРодитель);
	
	ГруппаПанель.Группировка              = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаПанель.Ширина                   = ПараметрыПанели.ШиринаПанели;
	ГруппаПанель.Видимость                = Ложь;
	ГруппаПанель.ЦветФона                 = ЦветаСтиля.АльтернативныйЦветФонаПоля;
	ГруппаПанель.РастягиватьПоГоризонтали = Ложь;
	ГруппаПанель.РастягиватьПоВертикали   = Истина;
	
	Возврат ГруппаПанель;
	
КонецФункции

// Возвращаемое значение:
//	Структура:
//		* ПоляВвода - Массив из см. НоваяСтруктураРеквизитаДляПанелиОтборов
//		* ПоляКоличеств - Массив из см. НоваяСтруктураРеквизитаДляПанелиОтборов
//		* ПоляФлагов - Массив из см. НоваяСтруктураРеквизитаДляПанелиОтборов
//		* ДекорацииДляПериодов - Массив из см. НоваяСтруктураРеквизитаДляПанелиОтборов
//
Функция РаспределитьОтборыПоГруппам(Знач Форма, Знач ПараметрыПанели, Знач МассивРеквизитовДляДобавления, Знач Кэш)
	
	//@skip-check structure-consructor-too-many-keys
	СтруктураРезультат = Новый Структура("ПоляВвода, ПоляКоличеств, ПоляФлагов, ДекорацииДляПериодов", Новый Массив(), Новый Массив(), Новый Массив(), Новый Массив());
	
	ОтборыПриОткрытииФормы = Спец_РаботаСКоллекциямиКлиентСервер.СвойствоСтруктуры(Форма.Параметры, "Отбор", Новый Структура());
	
	СтруктураРеквизитовОбъекта = Спец_ОбщегоНазначения.ПолучитьСтруктуруВсехРеквизитовОбъекта(ПараметрыПанели.ПолноеИмяОбъектаМетаданных, Ложь, Кэш);
	Для Каждого СтруктураОтбора Из ПараметрыПанели.ПараметрыОтборов Цикл
		
		// Если этот параметр передан при открытии формы, то пропускаем его (иначе будет пересечение отборов)
		Если СтрНайти(СтруктураОтбора.ИмяПоля, ".") = 0 И ОтборыПриОткрытииФормы.Свойство(СтруктураОтбора.ИмяПоля) Тогда
			Продолжить;
		КонецЕсли;
		
		НужныйРеквизит    = Неопределено;
		МассивРазделенный = СтрРазделить(СтруктураОтбора.ИмяПоля, ".", Ложь);
		КоличествоВПути   = МассивРазделенный.Количество();
		
		Если КоличествоВПути = 1 Тогда
			
			СтруктураДляПоиска = Новый Структура("Имя", МассивРазделенный.Получить(0));
			НужныйРеквизит = Спец_РаботаСКоллекциямиКлиентСервер.НайтиСтрокиВКоллекцииСтрок(СтруктураДляПоиска, СтруктураРеквизитовОбъекта.МассивРеквизитов, Истина);
			
		ИначеЕсли КоличествоВПути = 2 Тогда
			
			РеквизитыТабличнойЧасти = Спец_РаботаСКоллекциямиКлиентСервер.СвойствоСтруктуры(СтруктураРеквизитовОбъекта.ТабличныеЧасти, МассивРазделенный.Получить(0));
			Если РеквизитыТабличнойЧасти <> Неопределено Тогда
				
				СтруктураДляПоиска = Новый Структура("Имя", МассивРазделенный.Получить(1));
				НужныйРеквизит = Спец_РаботаСКоллекциямиКлиентСервер.НайтиСтрокиВКоллекцииСтрок(СтруктураДляПоиска, РеквизитыТабличнойЧасти, Истина);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ОписаниеТипаРеквизита = ?(НужныйРеквизит = Неопределено, СтруктураОтбора.ОписаниеТипаРеквизитаПоУмолчанию, НужныйРеквизит.Тип);
		Если ОписаниеТипаРеквизита = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураРеквизита = НоваяСтруктураРеквизитаДляПанелиОтборов(СтруктураОтбора, ОписаниеТипаРеквизита);
		
		ТипыРеквизита = СтруктураРеквизита.ТипРеквизита.Типы();
		Если ТипыРеквизита.Количество() = 1 Тогда
			
			НулевойТип = ТипыРеквизита.Получить(0);
			Если НулевойТип = Тип("Булево") Тогда
				
				СтруктураРезультат.ПоляФлагов.Добавить(СтруктураРеквизита);
				
			ИначеЕсли НулевойТип = Тип("Число") Тогда
				
				СтруктураРезультат.ПоляКоличеств.Добавить(СтруктураРеквизита);
				
			ИначеЕсли НулевойТип = Тип("Дата") Тогда
				
				Если СтруктураОтбора.ЧерезСтандартныйПериод Тогда
					
					СтруктураРеквизита.ТипРеквизита = Новый ОписаниеТипов("СтандартныйПериод");
					СтруктураРезультат.ДекорацииДляПериодов.Добавить(СтруктураРеквизита);
					
				Иначе
					
					СтруктураРезультат.ПоляВвода.Добавить(СтруктураРеквизита);
					
				КонецЕсли;
				
			Иначе
				
				СтруктураРезультат.ПоляВвода.Добавить(СтруктураРеквизита);
				
			КонецЕсли;
			
		Иначе
			
			СтруктураРезультат.ПоляВвода.Добавить(СтруктураРеквизита);
			
		КонецЕсли;
		
		МассивРеквизитовДляДобавления.Добавить(Новый РеквизитФормы(СтруктураРеквизита.ИмяРеквизита,
				СтруктураРеквизита.ТипРеквизита,
				,
				СтруктураРеквизита.Заголовок));
		
	КонецЦикла;
	
	Возврат СтруктураРезультат;
	
КонецФункции

Процедура ВывестиЭлементыФормы(Знач Форма, Знач ПараметрыПанели, Знач РодительЭлементов, Знач СтруктураГруппыОтборов)
	
	ЗаписьJSON = Спец_ОбщегоНазначенияКлиентСервер.ПодготовитьЗаписьJSONДляПреобразованияВСтроку(Ложь);
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	
	Спец_ОбщегоНазначенияКлиентСервер.ЗаписатьЗначениеРеквизитаВJSON(ЗаписьJSON,
			"ИмяСписка",
			?(ПараметрыПанели.ЭлементСписок = Неопределено, "", ПараметрыПанели.ЭлементСписок.Имя));
	
	Спец_ОбщегоНазначенияКлиентСервер.ЗаписатьЗначениеРеквизитаВJSON(ЗаписьJSON,
			"ПутьКДаннымСписка",
			?(ПараметрыПанели.ЭлементСписок = Неопределено, "", ПараметрыПанели.ЭлементСписок.ПутьКДанным));
	
	ЗаписьJSON.ЗаписатьИмяСвойства("МассивОтборов");
	ЗаписьJSON.ЗаписатьНачалоМассива();
	
	Для Каждого ИмяОтбора Из ПараметрыПанели.ПорядокОтборов Цикл
		
		СтруктураОтбора = Новый Структура("ИмяРеквизита", ИмяОтбора);
		
		СтруктураПоляВвода = Спец_РаботаСКоллекциямиКлиентСервер.НайтиСтрокиВКоллекцииСтрок(СтруктураОтбора, СтруктураГруппыОтборов.ПоляВвода, Истина);
		Если СтруктураПоляВвода <> Неопределено Тогда
			
			ВывестиОтбор_ПолеВвода(Форма, СтруктураПоляВвода, РодительЭлементов, ЗаписьJSON);
			Продолжить;
			
		КонецЕсли;
		
		СтруктураПоляКоличества = Спец_РаботаСКоллекциямиКлиентСервер.НайтиСтрокиВКоллекцииСтрок(СтруктураОтбора, СтруктураГруппыОтборов.ПоляКоличеств, Истина);
		Если СтруктураПоляКоличества <> Неопределено Тогда
			
			ВывестиОтбор_ПолеКоличество(Форма, СтруктураПоляКоличества, РодительЭлементов, ЗаписьJSON);
			Продолжить;
			
		КонецЕсли;
		
		СтруктураПоляФлага = Спец_РаботаСКоллекциямиКлиентСервер.НайтиСтрокиВКоллекцииСтрок(СтруктураОтбора, СтруктураГруппыОтборов.ПоляФлагов, Истина);
		Если СтруктураПоляФлага <> Неопределено Тогда
			
			ВывестиОтбор_ПолеФлага(Форма, СтруктураПоляФлага, РодительЭлементов, ЗаписьJSON);
			Продолжить;
			
		КонецЕсли;
		
		СтруктураДекорацииПериода = Спец_РаботаСКоллекциямиКлиентСервер.НайтиСтрокиВКоллекцииСтрок(СтруктураОтбора, СтруктураГруппыОтборов.ДекорацииДляПериодов, Истина);
		Если СтруктураДекорацииПериода <> Неопределено Тогда
			ВывестиОтбор_ДекорацияПериода(Форма, СтруктураДекорацииПериода, РодительЭлементов, ЗаписьJSON);
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаписьJSON.ЗаписатьКонецМассива();
	
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	Форма[Спец_РаботаСФормамиКлиентСервер.ИмяРеквизитаДляИнформацииПоОтборам()] = ЗаписьJSON.Закрыть();
	
КонецПроцедуры

Процедура ВывестиОтбор_ПолеВвода(Знач Форма, Знач СтруктураПоляВвода, Знач РодительЭлементов, Знач ЗаписьJSON)
	
	НовыйРеквизит = Спец_ИзменениеФорм.ДобавитьПолеВвода(Форма,
			СтруктураПоляВвода.ИмяРеквизита,
			СтруктураПоляВвода.ИмяРеквизита,
			РодительЭлементов,
			,
			СтруктураПоляВвода.Заголовок);
	
	НовыйРеквизит.РастягиватьПоГоризонтали = Истина;
	НовыйРеквизит.АвтоМаксимальнаяШирина   = Ложь;
	НовыйРеквизит.КнопкаОчистки            = Истина;
	
	НужнаПодсказкаВвода = Истина;
	
	ТипыРеквизита = СтруктураПоляВвода.ТипРеквизита.Типы();
	Если ТипыРеквизита.Количество() = 1 Тогда
		
		НулевойТип = ТипыРеквизита.Получить(0);
		НужнаПодсказкаВвода = Не
				(НулевойТип = Тип("Строка") И СтруктураПоляВвода.ТипРеквизита.КвалификаторыСтроки.ДопустимаяДлина = ДопустимаяДлина.Фиксированная
						Или НулевойТип = Тип("Число")
						Или НулевойТип = Тип("Дата"));
		
	КонецЕсли;
	
	Если НужнаПодсказкаВвода Тогда
		
		НовыйРеквизит.ПодсказкаВвода     = СтруктураПоляВвода.Заголовок;
		НовыйРеквизит.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		
	КонецЕсли;
	
	НовыйРеквизит.УстановитьДействие("ПриИзменении", Спец_РаботаСФормамиКлиентСервер.ИмяПроцедурыДляОбработкиСобытияОтбора());
	ЗаписатьИнформациюПроОтборВJSON(ЗаписьJSON, СтруктураПоляВвода);
	
КонецПроцедуры

Процедура ВывестиОтбор_ПолеКоличество(Знач Форма, Знач СтруктураПоляКоличества, Знач РодительЭлементов, Знач ЗаписьJSON)
	
	НовыйРеквизит = Спец_ИзменениеФорм.ДобавитьПолеВвода_Количество(Форма,
			СтруктураПоляКоличества.ИмяРеквизита,
			СтруктураПоляКоличества.ИмяРеквизита,
			РодительЭлементов,
			,
			СтруктураПоляКоличества.Заголовок);
	
	НовыйРеквизит.КнопкаОчистки = Истина;
	
	НовыйРеквизит.УстановитьДействие("ПриИзменении", Спец_РаботаСФормамиКлиентСервер.ИмяПроцедурыДляОбработкиСобытияОтбора());
	ЗаписатьИнформациюПроОтборВJSON(ЗаписьJSON, СтруктураПоляКоличества);
	
КонецПроцедуры

Процедура ВывестиОтбор_ПолеФлага(Знач Форма, Знач СтруктураПоляФлага, Знач РодительЭлементов, Знач ЗаписьJSON)
	
	НовыйРеквизит = Спец_ИзменениеФорм.ДобавитьПолеФлажка(Форма,
			СтруктураПоляФлага.ИмяРеквизита,
			СтруктураПоляФлага.ИмяРеквизита,
			РодительЭлементов,
			,
			СтруктураПоляФлага.Заголовок);
	
	НовыйРеквизит.УстановитьДействие("ПриИзменении", Спец_РаботаСФормамиКлиентСервер.ИмяПроцедурыДляОбработкиСобытияОтбора());
	ЗаписатьИнформациюПроОтборВJSON(ЗаписьJSON, СтруктураПоляФлага);
	
КонецПроцедуры

Процедура ВывестиОтбор_ДекорацияПериода(Знач Форма, Знач СтруктураДекорацииПериода, Знач РодительЭлементов, Знач ЗаписьJSON)
	
	НовыйРеквизит = Спец_ИзменениеФорм.ДобавитьДекорациюНадпись(Форма,
			СтруктураДекорацииПериода.ИмяРеквизита,
			РодительЭлементов,
			,
			СтруктураДекорацииПериода.Заголовок);
	
	НовыйРеквизит.Гиперссылка              = Истина;
	НовыйРеквизит.РастягиватьПоГоризонтали = Истина;
	НовыйРеквизит.АвтоМаксимальнаяШирина   = Ложь;
	
	НовыйРеквизит.УстановитьДействие("Нажатие", Спец_РаботаСФормамиКлиентСервер.ИмяПроцедурыДляОбработкиСобытияОтбора());
	ЗаписатьИнформациюПроОтборВJSON(ЗаписьJSON, СтруктураДекорацииПериода);
	
КонецПроцедуры

Процедура ПереместитьОстальныеЭлементыФормыНаНовуюПанель(Знач Форма, Знач ПараметрыПанели, Знач РодительЭлементов)
	
	// Перенесём пользовательские настройки на нашу панель
	Если ПараметрыПанели.ГруппаПользовательскиеНастройки <> Неопределено Тогда
		
		ПараметрыПанели.ГруппаПользовательскиеНастройки.Видимость = Истина;
		Форма.Элементы.Переместить(ПараметрыПанели.ГруппаПользовательскиеНастройки, РодительЭлементов);
		
	КонецЕсли;
	
	Если ПараметрыПанели.КнопкаНастроитьСписок <> Неопределено Тогда
		
		// Создадим декорацию, чтобы отделить кнопку "Настроить список" от отборов
		ДекорацияРазделитель = Спец_ИзменениеФорм.ДобавитьДекорациюКартинку(Форма,
				"Спец_РазделительКнопкиНастроитьСписокИОтборов",
				РодительЭлементов);
		
		ДекорацияРазделитель.АвтоМаксимальнаяВысота = Ложь;
		ДекорацияРазделитель.РастягиватьПоВертикали = Истина;
		
		
		ПараметрыПанели.КнопкаНастроитьСписок.Видимость                = Истина;
		ПараметрыПанели.КнопкаНастроитьСписок.РастягиватьПоГоризонтали = Истина;
		ПараметрыПанели.КнопкаНастроитьСписок.АвтоМаксимальнаяШирина   = Ложь;
		
		Форма.Элементы.Переместить(ПараметрыПанели.КнопкаНастроитьСписок, РодительЭлементов);
		
	КонецЕсли;
	
	Спец_РаботаСФормамиКлиентСервер.УстановитьВидимостьГруппыОтборов(Форма);
	
КонецПроцедуры

#КонецЕсли

Процедура ЗаписатьИнформациюПроОтборВJSON(Знач ЗаписьJSON, Знач СтруктураПоляВвода)
	
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	
	Спец_ОбщегоНазначенияКлиентСервер.ЗаписатьЗначениеРеквизитаВJSON(ЗаписьJSON, "ИмяЭлемента"  , СтруктураПоляВвода.ИмяРеквизита);
	Спец_ОбщегоНазначенияКлиентСервер.ЗаписатьЗначениеРеквизитаВJSON(ЗаписьJSON, "Заголовок"    , СтруктураПоляВвода.Заголовок);
	Спец_ОбщегоНазначенияКлиентСервер.ЗаписатьЗначениеРеквизитаВJSON(ЗаписьJSON, "ИмяПоля"      , СтруктураПоляВвода.ИмяПоля);
	Спец_ОбщегоНазначенияКлиентСервер.ЗаписатьЗначениеРеквизитаВJSON(ЗаписьJSON, "ВидСравнения" , СериализаторXDTO.XMLСтрока(СтруктураПоляВвода.ВидСравнения));
	
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	
КонецПроцедуры

Процедура ВосстановитьЗначенияРеквизитов(Знач Форма, Знач МассивРеквизитовДляДобавления)
	
	УстановитьПривилегированныйРежим(Истина);
	СтруктураОтборов = ХранилищеНастроекДанныхФорм.Загрузить(Форма.ИмяФормы, Спец_РаботаСФормамиКлиентСервер.ИмяКлючаНастроекВХранилищеНастроек());
	УстановитьПривилегированныйРежим(Ложь);
	
	Если СтруктураОтборов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого КлючЗначение Из СтруктураОтборов Цикл
		
		Если Не Спец_РаботаСКоллекциямиКлиентСервер.ЕстьРеквизитОбъекта(Форма, КлючЗначение.Ключ) Тогда
			Продолжить;
		КонецЕсли;
		
		Форма[КлючЗначение.Ключ] = КлючЗначение.Значение;
		Если КлючЗначение.Ключ = Спец_РаботаСФормамиКлиентСервер.ИмяРеквизитаРазделительНажат() Тогда
			Спец_РаботаСФормамиКлиентСервер.УстановитьВидимостьГруппыОтборов(Форма);
		ИначеЕсли Форма[КлючЗначение.Ключ] <> Ложь Тогда
			Спец_РаботаСФормамиКлиентСервер.УстановитьНовоеЗначениеОтбора(Форма, КлючЗначение.Ключ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьЗаголовкиПериодов(Знач Форма, Знач СтруктураГруппыОтборов)
	
	Для Каждого СтруктураРеквизита Из СтруктураГруппыОтборов.ДекорацииДляПериодов Цикл
		Спец_РаботаСФормамиКлиентСервер.УстановитьЗаголовокПериода(Форма, СтруктураРеквизита.ИмяРеквизита);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

//@skip-check constructor-function-return-section
//@skip-check structure-consructor-too-many-keys
#Область Типизация

// Возвращаемое значение:
//	Структура:
//		* ИмяПоля - Строка
//		* ВидСравнения - ВидСравненияКомпоновкиДанных
//		* Заголовок - Строка
//		* ЧерезСтандартныйПериод - Булево
//		* ОписаниеТипаРеквизита - ОписаниеТипов
//		* ИмяРеквизита - Строка
//
Функция НоваяСтруктураОтбораДляПанелиОтборов(Знач ИмяПоля, Знач ВидСравнения, Знач Заголовок, Знач ЧерезСтандартныйПериод, Знач ОписаниеТипаРеквизита)
	
	ИмяРеквизита = Лев(Спец_СтроковыеФункцииКлиентСервер.ОчиститьИмяДляЗапроса(СтрШаблон("Спец_%2_Отбор_%1",
			ИмяПоля,
			Спец_ОбщегоНазначения.ПолучитьКонтрольнуюСуммуСтрокой(Заголовок))), 128);
	
	Возврат Новый Структура("ИмяПоля, ВидСравнения, Заголовок, ЧерезСтандартныйПериод, ОписаниеТипаРеквизитаПоУмолчанию, ИмяРеквизита",
			ИмяПоля,
			ВидСравнения,
			Заголовок,
			ЧерезСтандартныйПериод,
			ОписаниеТипаРеквизита,
			ИмяРеквизита);
	
КонецФункции

// Возвращаемое значение:
//	Структура:
//		* ИмяПоля - Строка
//		* ВидСравнения - ВидСравненияКомпоновкиДанных
//		* Заголовок - Строка
//		* ЧерезСтандартныйПериод - Булево
//		* ИмяРеквизита - Строка
//		* ТипРеквизита - ОписаниеТипов
//
Функция НоваяСтруктураРеквизитаДляПанелиОтборов(Знач СтруктураОтбора, Знач ТипРеквизита)
	
	Возврат Новый Структура("ИмяПоля, ВидСравнения, Заголовок, ЧерезСтандартныйПериод, ИмяРеквизита, ТипРеквизита",
			СтруктураОтбора.ИмяПоля,
			СтруктураОтбора.ВидСравнения,
			СтруктураОтбора.Заголовок,
			СтруктураОтбора.ЧерезСтандартныйПериод,
			СтруктураОтбора.ИмяРеквизита,
			ТипРеквизита);
	
КонецФункции

#КонецОбласти

#КонецОбласти


#Область ОписаниеПеременных

// ++ Подсистема "Спец_БСП" Лыков А.А.
Перем Спец_КэшКлиент Экспорт; // см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
// -- Лыков А.А.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередНачаломРаботыСистемы(Отказ)
	
	// ++ Подсистема "Спец_БСП" Лыков А.А.
	Спец_ОбщегоНазначенияКлиент.ПередНачаломРаботыСистемы(Отказ);
	// -- Лыков А.А.
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// ++ Подсистема "Спец_БСП" Лыков А.А.
	Спец_ОбщегоНазначенияКлиент.ПриНачалеРаботыСистемы();
	// -- Лыков А.А.
	
КонецПроцедуры

Процедура ПриЗавершенииРаботыСистемы()
	
	// ++ Подсистема "Спец_БСП" Лыков А.А.
	Спец_ОбщегоНазначенияКлиент.ПриЗавершенииРаботыСистемы();
	// -- Лыков А.А.
	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	// ++ Подсистема "Спец_БСП" Лыков А.А.
	Если Спец_ОбщегоНазначенияКлиент.ОбработкаВнешнегоСобытияКомпоненты(Источник, Событие, Данные) Тогда
		Возврат;
	КонецЕсли;
	// -- Лыков А.А.
	
КонецПроцедуры

// ++ Спец_БСП.Версия1С_17_ВышеИлиРавно
Процедура ОбработкаОтображенияОшибки(ИнформацияОбОшибке, ТребуетсяЗавершениеСеанса, СтандартнаяОбработка)
	
	// ++ Подсистема "Спец_БСП" Лыков А.А.
	Спец_ОбщегоНазначенияКлиент.ОбработкаОтображенияОшибки(ИнформацияОбОшибке, ТребуетсяЗавершениеСеанса, СтандартнаяОбработка);
	// -- Лыков А.А.
	
КонецПроцедуры
// -- Спец_БСП.Версия1С_17_ВышеИлиРавно

// ++ Спец_БСП.Версия1С_21_ВышеИлиРавно
Процедура ОбработкаОтключенияВнешнейКомпонентыПриОшибке(Местоположение, Имя)
	
	// ++ Подсистема "Спец_БСП" Лыков А.А.
	Спец_ОбщегоНазначенияВызовСервера.ЗаписатьОшибки(Местоположение, СтрШаблон("Упала компонента '%1 (%2)'", Местоположение, Имя));
	// -- Лыков А.А.
	
КонецПроцедуры
// -- Спец_БСП.Версия1С_21_ВышеИлиРавно

#КонецОбласти

#Область Инициализация

// ++ Подсистема "Спец_БСП" Лыков А.А.
Спец_КэшКлиент = Спец_ОбщегоНазначенияКлиентСервер.БазовыйКэш();
// -- Подсистема "Спец_БСП" Лыков А.А.

#КонецОбласти

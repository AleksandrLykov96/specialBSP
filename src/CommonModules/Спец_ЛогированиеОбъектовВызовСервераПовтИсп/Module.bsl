// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Нужный тип логирования объекта по имени объекта в 1С.
// 
// Параметры:
//  ПолноеИмяОбъекта - Строка - Полное имя объекта в 1С
// 
// Возвращаемое значение:
//  Число - Тип логирования:
//		0 - Логирование по объекту отключено
//		1 - Автоматическое логирование через 1С
//		2 - Ручное логирование
//
Функция ТипЛогированияОбъекта(Знач ПолноеИмяОбъекта) Экспорт
	
	Если ПустаяСтрока(ПолноеИмяОбъекта) Тогда
		Возврат 0;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// По метаданным
	НаборЗаписей = РегистрыСведений.Спец_ОбъектыДляЛогирования.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИмяМетаданных.Установить(ПолноеИмяОбъекта);
	
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() Тогда
		
		УстановитьПривилегированныйРежим(Ложь);
		Возврат 1;
		
	КонецЕсли;
	
	// По пользователю
	НаборЗаписей.Отбор.ИмяМетаданных.Установить(Спец_ОбщегоНазначенияКлиентСервер.ТекущийПользователь1СПолноеИмя());
	НаборЗаписей.Прочитать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НаборЗаписей.Количество() Тогда
		Возврат 2;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

// Возвращаемое значение:
//  Булево
//
Функция ПринудительноДобавлятьКнопкуФормы() Экспорт
	
	Если Спец_ОбщегоНазначенияПовтИсп.ЭтоПользовательСПолнымиПравами() Тогда
		// Если логи включены по какому-либо пользователю, то всё-равно включаем кнопку логов.
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА
		|ИЗ
		|	РегистрСведений.Спец_ОбъектыДляЛогирования КАК ОбъектыДляЛогирования
		|ГДЕ
		|	ОбъектыДляЛогирования.ЭтоПользователь";
		
		Возврат Не Запрос.Выполнить().Пустой();
		
	Иначе
		
		Возврат Ложь;
	
	КонецЕсли;
	
КонецФункции

#КонецОбласти

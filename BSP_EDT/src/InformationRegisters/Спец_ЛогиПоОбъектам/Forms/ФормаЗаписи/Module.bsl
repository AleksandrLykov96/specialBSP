
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда     
		Возврат;
	КонецЕсли;
	
	Спец_РаботаСФормами.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ЗаписьОбъект = РеквизитФормыВЗначение("Запись");
	Если ЗаписьОбъект.Выбран() Тогда

		СодержимоеФайла = ЗаписьОбъект.СодержимоеФайла.Получить();
		Если СодержимоеФайла <> Неопределено Тогда

			ПотокДляЧтения = СодержимоеФайла.ОткрытьПотокДляЧтения();
			СодержимоеФайлаСтрокой = Спец_ОбщегоНазначенияКлиентСервер.ПрочитатьЧтениеТекста(ПотокДляЧтения);

		КонецЕсли;
		
		ДатаЗаписи = Спец_ОбщегоНазначенияКлиентСервер.UnixTimestampВДату(Запись.UnixTimestamp);
		
	КонецЕсли;
	
	Элементы.ГруппаСодержимоеФайла.Видимость = Не ПустаяСтрока(СодержимоеФайлаСтрокой);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Спец_РаботаСФормамиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Спец_РаботаСФормамиКлиент.ПриЗакрытии(ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура UnixTimestampПриИзменении(Элемент)
	
	ДатаЗаписи = Спец_ОбщегоНазначенияКлиентСервер.UnixTimestampВДату(Запись.UnixTimestamp);

КонецПроцедуры

#КонецОбласти

// ++ Спец_БСП.Спец_ЛогированиеОбъектов
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ОткрытьЛогиПоОбъекту(Команда)
	
	Спец_ЛогированиеОбъектовКлиент.ОткрытьЛогиПоОбъекту(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
// -- Спец_БСП.Спец_ЛогированиеОбъектов

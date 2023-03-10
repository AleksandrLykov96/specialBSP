
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда     
		Возврат;
	КонецЕсли;
	
	Спец_РаботаСФормами.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Спец_РаботаСФормамиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Спец_РаботаСФормамиКлиент.ПриЗакрытии(ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВключитьОбменПриИзменении(Элемент)
	
	Элементы.СтраницаПараметрыОбменов.Видимость = Объект.ВключитьОбмен;
	
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

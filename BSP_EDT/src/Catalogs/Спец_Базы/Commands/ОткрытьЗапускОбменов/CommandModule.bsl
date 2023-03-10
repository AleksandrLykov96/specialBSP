// @strict-types

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если Не Спец_ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("Спец_БСП.Спец_ОбменыСДругимиБазами.Спец_ОбменыСДругимиБазами_Отправитель") Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.Спец_ОбменСДругимиБазами.Форма",
			Новый Структура("База", ПараметрКоманды),
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно,
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти

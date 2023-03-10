
// @strict-types

#Область ОбработчикиСобытий

// Параметры:
//  ПараметрКоманды - СправочникСсылка.Спец_ВнешниеОбработки
//  ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если Не ЗначениеЗаполнено(ПараметрКоманды) Тогда
		ВызватьИсключение "Не указан элемент для получения данных из обработки!";
	КонецЕсли;
	
	// ++ Спец_БСП.Версия1С_15_Ниже
	////ВызватьИсключение "Недоступно!";
	// -- Спец_БСП.Версия1С_15_Ниже
	
	// ++ Спец_БСП.Версия1С_15_ВышеИлиРавно
	//@skip-check transfer-object-between-client-server
	ОписаниеФайла = ОписаниеПередаваемогоФайлаДляЗагрузкиОбработки(ПараметрКоманды);
	
	ПараметрыДиалога = Новый ПараметрыДиалогаПолученияФайлов("Выберите куда сохранить обработку", Ложь);
	Спец_ОбщегоНазначенияКлиент.ЗагрузитьФайлыССервера(ПараметрыДиалога, ОписаниеФайла);
	// -- Спец_БСП.Версия1С_15_ВышеИлиРавно
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// ++ Спец_БСП.Версия1С_15_ВышеИлиРавно

// Параметры:
//  СправочникСсылка - СправочникСсылка.Спец_ВнешниеОбработки
// 
// Возвращаемое значение:
//  ОписаниеПередаваемогоФайла
&НаСервере
Функция ОписаниеПередаваемогоФайлаДляЗагрузкиОбработки(Знач СправочникСсылка)
	
	РеквизитыОбработки = Спец_ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СправочникСсылка, "Наименование, ХранилищеВнешнейОбработки");
	//@skip-check property-return-type
	//@skip-check dynamic-access-method-not-found
	Возврат Новый ОписаниеПередаваемогоФайла(РеквизитыОбработки.Наименование + ".epf", ПоместитьВоВременноеХранилище(РеквизитыОбработки.ХранилищеВнешнейОбработки.Получить()));
	
КонецФункции

// -- Спец_БСП.Версия1С_15_ВышеИлиРавно

#КонецОбласти

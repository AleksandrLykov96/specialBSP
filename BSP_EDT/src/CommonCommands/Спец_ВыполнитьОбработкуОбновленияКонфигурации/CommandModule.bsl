// @strict-types

#Область ОбработчикиСобытий

// Параметры:
//  ПараметрКоманды - Произвольный
//  ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаКоманды_ПослеУточнения", ЭтотОбъект);
	Спец_ОбщегоНазначенияКлиент.ПоказатьВопросДляДолгойОбработкиСБлокировкой(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  Результат - КодВозвратаДиалога
//  ДополнительныеПараметры - Неопределено
&НаКлиенте
Процедура ОбработкаКоманды_ПослеУточнения(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Спец_ПолучитьКонстанту(ПредопределенноеЗначение("ПланВидовХарактеристик.Спец_Константы.ПервоначальноеЗаполнениеВыполнено"), Ложь) Тогда
		
		Спец_ОбщегоНазначенияКлиент.ВывестиСостояние("Первоначальное заполнение констант...", 1, , БиблиотекаКартинок.Спец_ДлительнаяОперация);
		Спец_ОбщегоНазначенияВызовСервера.УстановитьКонстантыПоУмолчанию();
		
		ОбновитьПовторноИспользуемыеЗначения();
		
	КонецЕсли;
	
	СтруктураЗадания = Спец_РаботаСФоновымиЗаданиямиКлиентСервер.ПолучитьСтруктуруПараметровВыполненияФоновогоЗадания();
	
	СтруктураЗадания.ИмяРегламентногоЗадания = "Спец_ОбщегоНазначения.ОбновлениеКонфигурации";
	СтруктураЗадания.РаботаЧерезРегистр      = Истина;
	СтруктураЗадания.ТаймаутВыполнения       = 3600;
	СтруктураЗадания.ВывестиФорму            = Истина;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаКоманды_ПослеВыполнения", ЭтотОбъект);
	Спец_РаботаСФоновымиЗаданиямиКлиентСервер.ЗапуститьВыполнениеФоновогоЗадания(СтруктураЗадания, 3600, , ОписаниеОповещения, , РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

// Параметры:
//  Результат - Булево
//  ДополнительныеПараметры - Неопределено
&НаКлиенте
Процедура ОбработкаКоманды_ПослеВыполнения(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаКоманды_ПослеВопросаПереустановитьКомпоненту", ЭтотОбъект);
	//@skip-check invocation-parameter-type-intersect
	ПоказатьВопрос(ОписаниеОповещения, "Внешняя компонента была изменена?", РежимДиалогаВопрос.ДаНет, , , "Переустановка компоненты");
	
КонецПроцедуры

// Параметры:
//  Результат - КодВозвратаДиалога
//  ДополнительныеПараметры - Неопределено
&НаКлиенте
Процедура ОбработкаКоманды_ПослеВопросаПереустановитьКомпоненту(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОбработкаКоманды_ИнициализироватьПереустановкуКомпонентуНаСервере();
	КонецЕсли;
	
	Спец_ОбщегоНазначенияКлиент.СообщитьПользователю("Успешно");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаКоманды_ИнициализироватьПереустановкуКомпонентуНаСервере()
	
	Кэш = Спец_ПолучитьКэш();
	
	ВыборкаПоПользователям = Справочники.Спец_Пользователи.Выбрать();
	Пока ВыборкаПоПользователям.Следующий() Цикл
		
		СправочникОбъект = Спец_ОбщегоНазначения.ПолучитьОбъектСБлокированием(ВыборкаПоПользователям.Ссылка, Кэш);
		Если СправочникОбъект = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СправочникОбъект.ПереустановитьКомпоненту = Истина;
		
		Спец_ОбщегоНазначения.ЗаписатьОбъект(СправочникОбъект, , , , Кэш);
		
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

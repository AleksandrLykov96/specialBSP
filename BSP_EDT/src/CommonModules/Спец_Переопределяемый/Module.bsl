
//@skip-check doc-comment-ref-link
//@skip-check module-empty-method
//@skip-check doc-comment-collection-item-type

#Область ПрограммныйИнтерфейс

// Блокировка данных для набора записей. Выполняется перед записью.
// Если нужна какая-то особенная блокировка, то пишем сюда и возвращаем ИСТИНА.
// В противном случае (если вернули ЛОЖЬ), то будет заблокировано по умолчанию
// (для подчинённых регистров по регистратору, для остальных по ВСЕМ ключевым измерениям).
// 
// Параметры:
//  Источник - РегистрРасчетаНаборЗаписей, РегистрБухгалтерииНаборЗаписей, ПерерасчетНаборЗаписей, РегистрНакопленияНаборЗаписей, РегистрСведенийНаборЗаписей - Источник
//	ДополнительныеСвойства - см. Спец_ОбработчикиПодписокНаСобытия.НоваяСтруктураДополнительныхСвойств
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
// 
// Возвращаемое значение:
//  Булево - Если ИСТИНА, то блокировка по умолчанию не будет выполнена
//
// Пример:
//  Если ДополнительныеСвойства.МетаданныеОбъекта = Метаданные.РегистрыСведений.Спец_ЗарегистрированныеОбъектыДляОбмена_Ссылки Тогда
//      БлокировкаДанных = Новый БлокировкаДанных();
//      <код нужной блокировки>
//      Возврат Истина;
//  КонецЕсли;
//  Возврат Ложь;
//
Функция ОсобеннаяБлокировкаДанныхДляНабораЗаписей(Знач Источник, Знач ДополнительныеСвойства, Знач Кэш) Экспорт

	Возврат Ложь;

КонецФункции

// Метод для дополнения массива структур данных для обновления таблиц в PostgreSQL.
// Есть возможность добавления новых индексов, триггеров, ограничений (констрейнов) и различных параметров таблицы (например, fillfactor).
// Для просмотра всевозможных параметров для установки, см. Спец_PostgreSQL.ПодготовитьСтруктуруДляУстановкиВPostgreSQL.
// Проверка соответствия нужных индексов происходит каждую ночь (в ночном расчёте) либо при ручном запуске "Обновления структур таблиц PostgreSQL"
// 
// Параметры:
//  МассивСтруктурДляОбновления - Массив из см. Спец_PostgreSQL.ПодготовитьСтруктуруДляУстановкиВPostgreSQL - Дополнять данный массив
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
//  
// Пример:
//	СтруктураДляИндексации = Спец_PostgreSQL.ПодготовитьСтруктуруДляУстановкиВPostgreSQL("Справочник.Номенклатура");
//	
//	СтруктураОграничения = Спец_PostgreSQL.ПодготовитьСтруктуруОграниченияДляУстановкиВPostgreSQL("Ссылка");
//	СтруктураОграничения.Кластер    = Истина;
//	СтруктураОграничения.Fillfactor = 97;
//	СтруктураДляИндексации.МассивОграничений.Добавить(СтруктураОграничения);
//	
//	СтруктураИндекса = Спец_PostgreSQL.ПодготовитьСтруктуруИндексаДляУстановкиВPostgreSQL("Наименование, Код, Родитель, Ссылка");
//	СтруктураИндекса.Fillfactor = 97;
//	СтруктураДляИндексации.МассивИндексов.Добавить(СтруктураИндекса);
//	
//	МассивСтруктурДляОбновления.Добавить(СтруктураДляИндексации);
//
Процедура ОбновитьСтруктуруТаблицPostgreSQLТолькоДляТекущейБазы(Знач МассивСтруктурДляОбновления, Знач Кэш) Экспорт
	
	
КонецПроцедуры

// Метод для очистки любых лишних данных из базы. Вызывается каждую ночь из ночного расчёта.
// 
// Параметры:
//  Кэш - см. Спец_КлиентСерверГлобальный.Спец_ПолучитьКэш
//  ТекстыОшибок - Строка - Сюда класть ошибки при выполнении. После выполнения они будут записаны в регистр ошибок.
// 
// Пример:
// 	Запрос = Новый Запрос;
//	Запрос.Текст =
//	
//	"ВЫБРАТЬ ПЕРВЫЕ 100
//	|	ТаблицаОбъекта.Ссылка КАК Ссылка
//	|ИЗ
//	|	Справочник.Номенклатура КАК ТаблицаОбъекта
//	|ГДЕ
//	|	ТаблицаОбъекта.Код = """"";
//	
//	ВыборкаРезультат = Запрос.Выполнить().Выбрать();
//	Пока ВыборкаРезультат.Следующий() Цикл
//		
//		СправочникОбъект = ВыборкаРезультат.Ссылка.ПолучитьОбъект();
//		
//		Попытка
//			СправочникОбъект.Удалить();
//		Исключение
//		КонецПопытки;
//		
//	КонецЦикла;
//
Процедура ЧисткаСтарыхЛишнихДанных(Знач Кэш, ТекстыОшибок) Экспорт
	
	
КонецПроцедуры

// Если вернуть ИСТИНА, то никакие подписки на события выполнены не будут.
// Передаётся источник подписки на события (регистра или ссылочного).
// 
// Параметры:
//	Источник - см. Спец_ОбщегоНазначения.ЗаписатьОбъект.ОбъектДляЗаписи
// 
// Возвращаемое значение:
//  Булево
//
Функция ОтключитьВсеОбработкиПринудительно(Знач Источник) Экспорт
	
	Возврат Ложь;
	
КонецФункции

#Область ДляТиповойКонфы

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ИдентификаторИнтернетПоддержки - Строка - уникальное имя программы в сервисах Интернет-поддержки.
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//   * РежимВыполненияОтложенныхОбработчиков - Строка - "Последовательно" - отложенные обработчики обновления выполняются
//                                    последовательно в интервале от номера версии информационной базы до номера
//                                    версии конфигурации включительно или "Параллельно" - отложенный обработчик после
//                                    обработки первой порции данных передает управление следующему обработчику, а после
//                                    выполнения последнего обработчика цикл повторяется заново.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Версия                                = "1.0.0.0";
	Описание.Имя                                   = "Спец_БСП";
	Описание.РежимВыполненияОтложенныхОбработчиков = "Последовательно";
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
// Параметры:
//  Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
// Пример:
//  Для добавления своей процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.РежимВыполнения     = "Оперативно";
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	
	Обработчик.Версия           = "*";
	Обработчик.Процедура        = "Спец_ОбщегоНазначения.ОбновлениеКонфигурации";
	Обработчик.РежимВыполнения  = "Оперативно";
	Обработчик.МонопольныйРежим = Истина;
	
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Вызывается перед обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсияИБ - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсияИБ - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - если установить Истина, то будет выведена форма
//                                с описанием обновлений. По умолчанию, Истина.
//                                Возвращаемое значение.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсияИБ, Знач ТекущаяВерсияИБ,
	Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений системы.
//
// Параметры:
//  Макет - ТабличныйДокумент - описание обновлений. См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//	Обработчики - ТаблицаЗначений - с колонками:
//		* ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//			или "*", если нужно выполнять при переходе с любой конфигурации.
//		* Процедура - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//			Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//			Обязательно должна быть экспортной.
//
// Пример:
//	Обработчик = Обработчики.Добавить();
//	Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//	Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
	
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - :
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, 
	Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
	
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// при запуске конфигурации (в обработчиках событий ПередНачаломРаботыСистемы и ПриНачалеРаботыСистемы) 
// без дополнительных серверных вызовов. 
// Для получения значений этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске.
//
// Важно: недопустимо использовать команды сброса кэша повторно используемых модулей, 
// иначе запуск может привести к непредсказуемым ошибкам и лишним серверным вызовам.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента при запуске, которые необходимо задать.
//                           Для установки параметров работы клиента при запуске:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ПриДобавленииПараметровРаботыКлиента(Параметры);
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// конфигурации без дополнительных серверных вызовов.
// Для получения этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента, которые необходимо задать.
//                           Для установки параметров работы клиента:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	
КонецПроцедуры

// Получает описание предопределенных наборов свойств.
//
// Параметры:
//  Наборы - ДеревоЗначений:
//     * Имя           - Строка - имя набора свойств. Формируется из полного имени объекта
//          метаданных заменой символа "." на "_".
//          Например, "Документ_ЗаказПокупателя".
//     * Идентификатор - УникальныйИдентификатор - уникальный идентификатор предопределенного набора свойств.
//          Не должен повторяться в других наборах свойств.
//          Формат идентификатора Random UUID (Version 4).
//          Чтобы получить идентификатор, нужно в режиме 1С:Предприятие вычислить значение
//          конструктора платформы "Новый УникальныйИдентификатор" или воспользоваться online-генератором,
//          например, https://www.uuidgenerator.net/version4.
//     * Используется  - Неопределено
//                     - Булево - признак того, что набор свойств используется.
//          Например, можно использовать для скрытия набора по функциональным опциям.
//          Значение по умолчанию - Неопределено, соответствует значению Истина.
//     * ЭтоГруппа     - Булево - Истина, если набор свойств является группой.
//
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

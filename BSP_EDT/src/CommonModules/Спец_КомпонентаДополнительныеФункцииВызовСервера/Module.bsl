// @strict-types

//@skip-check method-too-many-params

#Область ПрограммныйИнтерфейс

#Область BaseFunction

// См. Спец_КомпонентаДополнительныеФункцииКлиентСервер.Пауза
// 
// Параметры:
//  Миллисекунд - Число - количество миллисекунд для задержки
//
Процедура Пауза(Знач Миллисекунд = 500) Экспорт
	
	Спец_КомпонентаДополнительныеФункцииКлиентСервер.Пауза(Миллисекунд);
	
КонецПроцедуры

// См. Спец_КомпонентаДополнительныеФункцииКлиентСервер.СтрокаВЧисло
// 
// Параметры:
//  ИсходнаяСтрока - Строка - строка для преобразования
//
// Возвращаемое значение:
//  см. Спец_КомпонентаДополнительныеФункцииКлиентСервер.СтрокаВЧисло
//
Функция СтрокаВЧисло(Знач ИсходнаяСтрока) Экспорт
	
	Возврат Спец_КомпонентаДополнительныеФункцииКлиентСервер.СтрокаВЧисло(ИсходнаяСтрока);
	
КонецФункции

// См. Спец_КомпонентаДополнительныеФункцииКлиентСервер.ТолькоБуквыВСтроку
// 
// Параметры:
//  ИсходнаяСтрока - Строка - строка для преобразования
//  СимволыКоторыеНеТрогать - Строка - символы, которые останутся в строке.
//
// Возвращаемое значение:
//  см. Спец_КомпонентаДополнительныеФункцииКлиентСервер.ТолькоБуквыВСтроку
//
Функция ТолькоБуквыВСтроку(Знач ИсходнаяСтрока, Знач СимволыКоторыеНеТрогать = " _") Экспорт
	
	Возврат Спец_КомпонентаДополнительныеФункцииКлиентСервер.ТолькоБуквыВСтроку(ИсходнаяСтрока, СимволыКоторыеНеТрогать);
	
КонецФункции

// См. Спец_КомпонентаДополнительныеФункцииКлиентСервер.ТолькоБуквыВСтрокуJSON
// 
// Параметры:
//  ИсходнаяСтрокаИлиИмяФайла - Строка - строка для преобразования (или имя файла для преобразования)
//  СимволыКоторыеНеТрогать - Строка - символы, которые останутся в ключе.
//  ПрефиксКолонки - Строка - если строка начинается с цифры, то добавляет данный префикс к ключу.
//  ИмяКолонкиПоУмолчанию - Строка - если после преобразования остается пустая строка, то имя ключа будет задано из данного параметра.
//  ЧитатьИзФайла - Булево - флаг того, читаем JSON из файла или из строки. Если указано ИСТИНА, то в "ИсходнаяСтрокаИлиИмяФайла" необходимо передать имя файла.
//  ТекстОшибки - Строка - в данный параметр будет добавлен текст ошибки во время выполнения.
//
// Возвращаемое значение:
//  см. Спец_КомпонентаДополнительныеФункцииКлиентСервер.ТолькоБуквыВСтрокуJSON
//
Функция ТолькоБуквыВСтрокуJSON(Знач ИсходнаяСтрокаИлиИмяФайла, Знач СимволыКоторыеНеТрогать = "_", Знач ПрефиксКолонки = "_def", Знач ИмяКолонкиПоУмолчанию = "default",
		Знач ЧитатьИзФайла = Ложь, ТекстОшибки = "") Экспорт
	
	Возврат Спец_КомпонентаДополнительныеФункцииКлиентСервер.ТолькоБуквыВСтрокуJSON(ИсходнаяСтрокаИлиИмяФайла,
			СимволыКоторыеНеТрогать,
			ПрефиксКолонки,
			ИмяКолонкиПоУмолчанию,
			ЧитатьИзФайла,
			ТекстОшибки);
	
КонецФункции

// См. Спец_КомпонентаДополнительныеФункцииКлиентСервер.СжатьDeflate
// 
// Параметры:
//  ИмяФайлаДляЧтения - Строка - имя файла, содержащего данные для сжатия.
//  ИмяФайлаРезультат - Строка - имя файла для помещения результата
//  УровеньСжатия - Число - уровень сжатия (от 0 до 9)
//  НомерСтратегии - Число - номер стратегии (от 0 до 4, подробнее тут: https://www.zlib.net/manual.html (Compression strategy))
//  ТекстОшибки - Строка - в данный параметр будет добавлен текст ошибки во время выполнения.
//
// Возвращаемое значение:
//  см. Спец_КомпонентаДополнительныеФункцииКлиентСервер.СжатьDeflate
//
Функция СжатьDeflate(Знач ИмяФайлаДляЧтения, Знач ИмяФайлаРезультат, Знач УровеньСжатия = 4, Знач НомерСтратегии = 0, ТекстОшибки = "") Экспорт
	
	Возврат Спец_КомпонентаДополнительныеФункцииКлиентСервер.СжатьDeflate(ИмяФайлаДляЧтения, ИмяФайлаРезультат, УровеньСжатия, НомерСтратегии, ТекстОшибки);
	
КонецФункции

// См. Спец_КомпонентаДополнительныеФункцииКлиентСервер.РазжатьDeflate
// 
// Параметры:
//  ИмяФайлаДляЧтения - Строка - имя файла, содержащего данные для разжатия.
//  ИмяФайлаРезультат - Строка - имя файла для помещения результата
//  ТекстОшибки - Строка - в данный параметр будет добавлен текст ошибки во время выполнения.
//
// Возвращаемое значение:
//  см. Спец_КомпонентаДополнительныеФункцииКлиентСервер.РазжатьDeflate
//
Функция РазжатьDeflate(Знач ИмяФайлаДляЧтения, Знач ИмяФайлаРезультат, ТекстОшибки = "") Экспорт
	
	Возврат Спец_КомпонентаДополнительныеФункцииКлиентСервер.РазжатьDeflate(ИмяФайлаДляЧтения, ИмяФайлаРезультат, ТекстОшибки);
	
КонецФункции

// См. Спец_КомпонентаДополнительныеФункцииКлиентСервер.ТекущийUnixTimestamp
// 
// Возвращаемое значение:
//  см. Спец_КомпонентаДополнительныеФункцииКлиентСервер.ТекущийUnixTimestamp
//
Функция ТекущийUnixTimestamp() Экспорт
	
	Возврат Спец_КомпонентаДополнительныеФункцииКлиентСервер.ТекущийUnixTimestamp();
	
КонецФункции

#КонецОбласти

#Область HTTPClient

// См. Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientПреобразоватьJsonВРезультат
// 
// Параметры:
//  МассивИлиСтруктураЗапросов - Массив из см. Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientПолучитьСтруктураЗапроса
//  ТекстОшибки - Строка - Текст ошибки
// 
// Возвращаемое значение:
//  см. Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientПреобразоватьJsonВРезультат
//
Функция HTTPClientОтправитьЗапросыАсинхронно(Знач МассивИлиСтруктураЗапросов, ТекстОшибки = "") Экспорт
	
	Возврат Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientОтправитьЗапросыАсинхронно(МассивИлиСтруктураЗапросов, ТекстОшибки);
	
КонецФункции

// См. Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientОтправитьЗапросыСинхронно
//
// Параметры:
//  МассивИлиСтруктураЗапросов - Массив из см. HTTPClientПолучитьСтруктураЗапроса
//  ЗадержкаМеждуОтправками - Число - задержка между отправками запросов (миллисекунд)
//  ТекстОшибки - Строка - в данный параметр будет добавлен текст ошибки во время выполнения.
//
// Возвращаемое значение:
//  см. Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientОтправитьЗапросыСинхронно
//
Функция HTTPClientОтправитьЗапросыСинхронно(Знач МассивИлиСтруктураЗапросов, Знач ЗадержкаМеждуОтправками = 0, ТекстОшибки = "") Экспорт
	
	Возврат Спец_КомпонентаДополнительныеФункцииКлиентСервер.HTTPClientОтправитьЗапросыСинхронно(МассивИлиСтруктураЗапросов, ЗадержкаМеждуОтправками, ТекстОшибки);
	
КонецФункции

#КонецОбласти

#КонецОбласти

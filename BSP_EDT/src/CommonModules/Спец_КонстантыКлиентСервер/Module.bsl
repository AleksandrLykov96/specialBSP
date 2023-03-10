// @strict-types

#Область ПрограммныйИнтерфейс

// Строка английского алфавита (в верхнем регистре)
// 
// Возвращаемое значение:
//  Строка
//
Функция АнглийскийАлфавит() Экспорт
	
	Возврат "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
КонецФункции

// Строка русского алфавита (в верхнем регистре)
// 
// Возвращаемое значение:
//  Строка
//
Функция РусскийАлфавит() Экспорт
	
	Возврат "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";
	
КонецФункции

// Строка, содержащая все цифры
// 
// Возвращаемое значение:
//  Строка
//
Функция ВсеЦифры() Экспорт
	
	Возврат "1234567890";
	
КонецФункции

// Длина идентификатора ссылки (UID)
// 
// Возвращаемое значение:
//  Число
//
Функция ДлинаИдентификатораСсылки() Экспорт
	
	Возврат 36;
	
КонецФункции

// Количество секунд в сутках
// 
// Параметры:
//  КоличествоСуток - Число
// 
// Возвращаемое значение:
//  Число
//
Функция СекундВСутках(Знач КоличествоСуток = 1) Экспорт
	
	Возврат КоличествоСуток * 86400;
	
КонецФункции

#КонецОбласти

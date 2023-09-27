// @strict-types

#Область СлужебныеПроцедурыИФункции

// См. Спец_ОбщегоНазначенияВызовСервера.ПолучитьЦветСтиля
//
// Параметры:
//   ИмяЦветаСтиля - см. Спец_ОбщегоНазначенияВызовСервера.ПолучитьЦветСтиля.ИмяЦветаСтиля
//
// Возвращаемое значение:
//   см. Спец_ОбщегоНазначенияВызовСервера.ПолучитьЦветСтиля
Функция ПолучитьЦветСтиля(ИмяЦветаСтиля) Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		Возврат ЦветаСтиля[ИмяЦветаСтиля];
	#Иначе
		//@skip-check transfer-object-between-client-server
		Возврат Спец_ОбщегоНазначенияВызовСервера.ПолучитьЦветСтиля(ИмяЦветаСтиля);
	#КонецЕсли
	
КонецФункции

// См. Спец_ОбщегоНазначенияВызовСервера.ПолучитьШрифтСтиля
//
// Параметры:
//   ИмяШрифтаСтиля - см. Спец_ОбщегоНазначенияВызовСервера.ПолучитьШрифтСтиля.ИмяШрифтаСтиля
//
// Возвращаемое значение:
//   см. Спец_ОбщегоНазначенияВызовСервера.ПолучитьШрифтСтиля
Функция ПолучитьШрифтСтиля(ИмяШрифтаСтиля) Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		Возврат ШрифтыСтиля[ИмяШрифтаСтиля];
	#Иначе
		//@skip-check transfer-object-between-client-server
		Возврат Спец_ОбщегоНазначенияВызовСервера.ПолучитьШрифтСтиля(ИмяШрифтаСтиля);
	#КонецЕсли
	
КонецФункции

// См. Спец_ОбщегоНазначенияВызовСервера.ПолучитьСтруктуруИмениТипаДанныхОбъекта
// 
// Параметры:
//	Объект - см. Спец_ОбщегоНазначенияВызовСервера.ПолучитьСтруктуруИмениТипаДанныхОбъекта.Объект
// 
// Возвращаемое значение:
//	см. Спец_ОбщегоНазначенияВызовСервера.ПолучитьСтруктуруИмениТипаДанныхОбъекта
//
Функция ПолучитьСтруктуруИмениТипаДанныхОбъекта(Знач Объект) Экспорт
	
	//@skip-check constructor-function-return-section
	//@skip-check transfer-object-between-client-server
	Возврат Спец_ОбщегоНазначенияВызовСервера.ПолучитьСтруктуруИмениТипаДанныхОбъекта(Объект);
	
КонецФункции

#КонецОбласти

﻿////////////////////////////////////////////////////////////////////////////////
// 
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет наличие свойств в стуктуре. Если отсутствуют, то добавляет в структуру
//
// Параметры
//  мКлючРезультата  - Строка - список проверяемых свойств
//  Результат  - Структура - Структура в которой проверяется наличие свойств
//
Функция ДополнитьСтруктуру(КлючРезультата, Результат) Экспорт
	Ключи = СтрРазделить(КлючРезультата, ",", Ложь); // Получаем Массив ключей
	
	Для каждого Ключ Из Ключи Цикл
		Если Не Результат.Свойство(Ключ) Тогда // проверяем есть ли у структуры Результат ключ из массива ключей
			Ключ = СокрЛП(Ключ); // Если нет, то добавляем ключ в структуру Результат
			Результат.Вставить(Ключ);
			РезультатФункции = Результат;
		КонецЕсли;
	КонецЦикла;
	
	Возврат РезультатФункции;
КонецФункции

// Проверяет наличие свойства у Объекта
//
// Параметры
//  Объект  - <Любой> - проверяемый объект
//  ИмяРеквизита  - Строка - Имя проверяемого реквизита
//
// Возвращаемое значение:
//   Булево   - Истина если свойство обнаружено у Объекта
//
Функция ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяРеквизита) Экспорт
	
	Если Объект = Неопределено  // если параметр объект не заполнен
		Или Объект = Null
		Или ТипЗнч(Объект) = Тип("Строка") // или значение параметра не является объектом
		Или ИмяРеквизита = "" // или не заполнен параметр ИмяРеквизита
	Тогда
		Возврат Ложь; // функция возвращает Ложь
	КонецЕсли;
	
	ЗначениеРеквизита = Новый УникальныйИдентификатор;
	// Создаем структуру с ключом ИмяРеквизита и уникальным значением ЗначениеРеквизита
	Реквизит = Новый Структура(ИмяРеквизита, ЗначениеРеквизита);
	// Используем глобальный метод ЗаполнитьЗначенияСвойств() и скопируем значение свойства ИмяРеквизита из Объекта 
	// в созданную структуру Реквизит если такое свойство имеется у Объекта
	ЗаполнитьЗначенияСвойств(Реквизит, Объект);
	
	Если Реквизит[ИмяРеквизита] = ЗначениеРеквизита Тогда
	// если значение свойства ИмяРеквизита у структуры Реквизит не изменилось
	// значит у Объекта нет такого свойства
		возврат Ложь;
	Иначе 
		возврат Истина;
	КонецЕсли;
	
КонецФункции 

// Возвращает значение параметра Ключ
//
// Параметры
//  Объект  -<Любой> - проверяемый объект
//  Ключ  - Строка - свойство объекта
//  ЗначениеПоУмолчанию - Неопределено - 
//
Функция СвойствоОбъекта(Объект, Ключ, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Если Объект = Неопределено Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, Ключ) Тогда
	 // если у параметра Объект есть свойство Ключ то получаем его значение
		Возврат Объект[Ключ];
	Иначе 
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

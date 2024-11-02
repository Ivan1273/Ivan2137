﻿
#Область ОбработчикиСобытийФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы
&НаКлиенте
Процедура РазмерностьПриИзменении(Элемент)
	РазмерностьПриИзмененииНаСервере();
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	Если не ПроверитьЗаполнение() Тогда
		Возврат
	КонецЕсли;
	
	ЗаполнитьТаблицуНаСервере("ВекторСтолбец");
	ЗаполнитьТаблицуНаСервере("ВекторСтрока");
КонецПроцедуры

&НаКлиенте
Процедура Решить(Команда)
	Если не ПроверитьЗаполнение() Тогда
		Возврат
	КонецЕсли;
	
	Для Индекс = 0 По ВекторСтолбец.Количество() - 1 Цикл
		Число1 = ВекторСтолбец[Индекс]["СтолбецВекторСтолбец"];
		Для Индекс1 = 1 по Размерность Цикл
			Число2 = ВекторСтрока[0]["СтолбецВекторСтрока" + Индекс1];
			РезультатУмножения = Число1 * Число2;
			// Записать в Таблицу Результат 
			Результат[Индекс]["СтолбецРезультат" + Индекс1] = РезультатУмножения;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура РешитьНаСервере(Команда)
	Если не ПроверитьЗаполнение() Тогда
		Возврат
	КонецЕсли;
	
	РешитьНаСервереНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РешитьВФоне(Команда)
	Адрес = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор); // инициализировали Адрес
	РешитьВФонеНаСервере();
	ПодключитьОбработчикОжидания("ПроверитьВыполнение", 1);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура РазмерностьПриИзмененииНаСервере()
	// Удалить Старые Реквизиты
	РеквизитыДляУдаления = Новый Массив;
	СписокТаблиц = Новый СписокЗначений;
	СписокТаблиц.Добавить("ВекторСтолбец");
	СписокТаблиц.Добавить("ВекторСтрока");
	СписокТаблиц.Добавить("Результат");
	ПолучитьРеквизитыДляУдаления(РеквизитыДляУдаления, СписокТаблиц);
	
	// Удаление Старых ЭлементовФормы
	УдалениеСтарыхЭлементовФормы(РеквизитыДляУдаления);
	
	// УдалениеСтарыхСтрок
	УдалениеСтрокТаблицы(СписокТаблиц);
	
	// Сформировать Реквизиты заново
	ОписаниеРеквизитов = Новый Массив;
	Если Размерность <> 0 Тогда
		ДобавитьРеквизитыТаблицы(ОписаниеРеквизитов, "СтолбецВекторСтолбец", "ВекторСтолбец", "Столбец");
		Для Индекс = 1 По Размерность Цикл
			ДобавитьРеквизитыТаблицы(ОписаниеРеквизитов,"СтолбецВекторСтрока" + Индекс, "ВекторСтрока", "Столбец" + Индекс); 
			ДобавитьРеквизитыТаблицы(ОписаниеРеквизитов,"СтолбецРезультат" + Индекс, "Результат", "Столбец" + Индекс); 
		КонецЦикла;
		ИзменитьРеквизиты(ОписаниеРеквизитов, РеквизитыДляУдаления);
	Иначе
		Возврат
	КонецЕсли;
	
	//ДобавитьСтрокиТаблицам 
	Для Индекс = 1 по Размерность Цикл
		ДобавитьСтрокуТаблицы(ВекторСтолбец);
		ДобавитьСтрокуТаблицы(Результат);
	КонецЦикла;
	ДобавитьСтрокуТаблицы(ВекторСтрока);
	
	//Добавить ЭлементыФормы
	ДобавлениеЭлементаФормы(ОписаниеРеквизитов);
КонецПроцедуры

#Область ОБработкаУдаленияСтарыхРеквизитовИЭлементов

&НаСервере
Процедура ПолучитьРеквизитыДляУдаления(РеквизитыДляУдаления, СписокТаблиц)
	Для каждого Реквизит Из СписокТаблиц Цикл
		СтарыеРеквизиты = ЭтаФорма.ПолучитьРеквизиты(Реквизит);
		Если СтарыеРеквизиты.Количество() = 0 Тогда
			Возврат
		КонецЕсли;
		ЗаполнитьМассивРеквизитовДляУдаления(РеквизитыДляУдаления, СтарыеРеквизиты, Реквизит.Значение)
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьМассивРеквизитовДляУдаления(РеквизитыДляУдаления, СтарыеРеквизиты, Путь)
	
	Для каждого Реквизит Из СтарыеРеквизиты Цикл
		РеквизитыДляУдаления.Добавить(Путь + "." + Реквизит.Имя);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УдалениеСтарыхЭлементовФормы(РеквизитыДляУдаления)
	
	Для каждого Реквизит Из РеквизитыДляУдаления Цикл
		МассивРеквизит = СтрРазделить(Реквизит, ".");
		ИмяЭлемента = "Элемент" + МассивРеквизит[1];
		НайденныйЭлемент = Элементы.Найти(ИмяЭлемента);
		Если НайденныйЭлемент <> Неопределено Тогда
			Элементы.Удалить(НайденныйЭлемент);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура УдалениеСтрокТаблицы(СписокТаблиц)
	Для каждого Таблица Из СписокТаблиц Цикл
		РеквизитТаблицы = ЭтаФорма[Строка(Таблица)];
		РеквизитТаблицы.Очистить();
	КонецЦикла;
КонецПроцедуры
#КонецОбласти

#Область ОбработкаДобавленияРеквизитовИЭлементов
&НаСервере
Процедура ДобавитьРеквизитыТаблицы(ОписаниеРеквизитов, ИмяРеквизита, ИмяТаблицы, ЗаголовокРеквизита)
		НовыйРеквизит = Новый РеквизитФормы(ИмяРеквизита, новый ОписаниеТипов("Число"), ИмяТаблицы, ЗаголовокРеквизита);
		ОписаниеРеквизитов.Добавить(НовыйРеквизит);
КонецПроцедуры

&НаСервере
Процедура ДобавлениеЭлементаФормы(ОписаниеРеквизитов)
	Для каждого Реквизит из ОписаниеРеквизитов Цикл
		ИмяЭлемента = "Элемент" + Реквизит.Имя;
		НовыйЭлементФормы = Элементы.Добавить(ИмяЭлемента, Тип("ПолеФормы"), Элементы.Найти("Элемент" + Реквизит.Путь));
		НовыйЭлементФормы.ПутьКДанным = Реквизит.Путь + "." + Реквизит.Имя;
		НовыйЭлементФормы.Вид = ВидПоляФормы.ПолеВвода;
		НовыйЭлементФормы.ТолькоПросмотр = Истина;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуТаблицы(ТаблицаФормы)
	НоваяСтрока = ТаблицаФормы.Добавить(); 
КонецПроцедуры

#КонецОбласти

#Область ОбработкаЗаполненияТаблиц

&НаСервере
Процедура ЗаполнитьТаблицуНаСервере(ТаблицаФормы)
	ГСЧ = Новый ГенераторСлучайныхЧисел();
	СписокСтолбцовТаблицы = ЭтаФорма.ПолучитьРеквизиты(ТаблицаФормы);
	Таблица = ЭтаФорма[ТаблицаФормы];
	Для Индекс = 0 По ЭтаФорма[ТаблицаФормы].Количество() - 1 Цикл
		Для каждого Столбец Из СписокСтолбцовТаблицы Цикл
			НовоеЧисло = ПолучитьСлучайноеЧисло(ГСЧ);
			Таблица[Индекс][Столбец.Имя] = НовоеЧисло;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСлучайноеЧисло(ГСЧ);
	РезультатФункции = ГСЧ.СлучайноеЧисло(1, 99);
	Возврат РезультатФункции;
КонецФункции

#КонецОбласти

#Область ОбработкаРешения

&НаСервере
Процедура РешитьНаСервереНаСервере()
	ТаблицаВекторСтолбец = РеквизитФормыВЗначение("ВекторСтолбец");
	ТаблицаВекторСтрока = РеквизитФормыВЗначение("ВекторСтрока");
	ТаблицаРезультат = РеквизитФормыВЗначение("Результат");
	КолонокиТаблицыВекторСтрока = ТаблицаВекторСтрока.Колонки;
	
	Для Индекс = 0 По ТаблицаВекторСтолбец.Количество() - 1 Цикл
		Число1 = ТаблицаВекторСтолбец[Индекс].Получить(0);
		Для Индекс1 = 0 По КолонокиТаблицыВекторСтрока.Количество() - 1 Цикл
			Число2 = ТаблицаВекторСтрока[0].Получить(Индекс1); 
			РезультатУмножения = Число1 * Число2;
			ТаблицаРезультат[Индекс].Установить(Индекс1, РезультатУмножения);
		КонецЦикла;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТаблицаРезультат, "Результат");
КонецПроцедуры


#КонецОбласти

#Область ФоновоеЗадание

&НаСервере
Процедура РешитьВФонеНаСервере()
	ТаблицаСтолбец = РеквизитФормыВЗначение("ВекторСтолбец"); // получили таблицу значений из реквизита ВекторСтолбец
	ТаблицаСтрока = РеквизитФормыВЗначение("ВекторСтрока");  // получили таблицу значений из реквизита ВекторСтрока
	
	// Создадим массив параметров для фонового задания
	ПараметрыФЗ = Новый Массив;
	// Добавим в качестве параметров наши таблицы и Адрес
	ПараметрыФЗ.Добавить(ТаблицаСтрока);
	ПараметрыФЗ.Добавить(ТаблицаСтолбец);
	ПараметрыФЗ.Добавить(Адрес);
	
	// Запустим процедуру из общего модуля ВыполнитьРасчет в фоновом задании
	ЗаданиеРасчета = ФоновыеЗадания.Выполнить("ОбщегоНазначенияВызовСервера.ВыполнитьРасчет", ПараметрыФЗ, 
												Новый УникальныйИдентификатор, "Расчитывает результат умножения векторов");
	// Запишем УникальныйИдентификатор нашего ФЗ в реквизит формы ИдентификаторЗадания
	ИдентификаторЗадания = ЗаданиеРасчета.УникальныйИдентификатор;
КонецПроцедуры

// функция только проверяет статус
// получение результата отдельно
//
&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания, Адрес)
	РезультатФункции = Новый Структура("Статус, ОписаниеОшибки, Выполняется", "");
	// Находим наше ФЗ по УникальномуИдентификатору
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	
	// Проверяем Статус
	Если Задание.Состояние = СостояниеФоновогоЗадания.Завершено Тогда
		РезультатФункции.Статус = "Завершено";
	ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		РезультатФункции.Статус = "Выполняется";
	Иначе 
		РезультатФункции.Статус = "Ошибка";
		Сообщить(РезультатФункции.ОписаниеОшибки);
	КонецЕсли; 
	
	Возврат РезультатФункции;
КонецФункции

&НаСервере
Процедура ПоказатьРезультатЗадания(Адрес, РезультатФункции)
	
	// проверка адреса временного хранилища
	Если Не ЭтоАдресВременногоХранилища(Адрес) Тогда
		РезультатФункции.Статус = "Ошибка";
		РезультатФункции.ОписаниеОшибки = "Ошибка получения результат";
		Возврат;
	КонецЕсли;
	
	Данные = ПолучитьИзВременногоХранилища(Адрес); // получаем данные выполнения расчета
	// получаем свойство Выполнено у результата расчета
	Выполнено = ОбщегоНазначенияКлиентСервер.СвойствоОбъекта(Данные, "Выполнено", Ложь); 
	
	// Проверка свойства Выполнено
	Если Не Выполнено Тогда
		РезультатФункции.Статус = "Ошибка";
		РезультатФункции.ОписаниеОшибки = СтрШаблон("Ошибка фонового задания: %1", 
				ОбщегоНазначенияКлиентСервер.СвойствоОбъекта(Данные, "ОписаниеОшибки", "Неизвестная ошибка"));
		Возврат;
	КонецЕсли;
	
	// Получаем таблицу с результатами вычисления
	ТаблицаРезультата = ОбщегоНазначенияКлиентСервер.СвойствоОбъекта(Данные, "Данные");
	
	// проверка на тип результата
	Если ТипЗнч(ТаблицаРезультата) <> тип("ТаблицаЗначений")Тогда
		РезультатФункции.Статус = "Ошибка";
		РезультатФункции.ОписаниеОшибки = "Результат не является таблицей";
		Возврат;
	КонецЕсли;
	
	// попытка загрузить результат в форму 
	Попытка
		ЗначениеВРеквизитФормы(ТаблицаРезультата, "Результат");
	Исключение
		РезультатФункции.Статус = "Ошибка";
		РезультатФункции.ОписаниеОшибки = ОписаниеОшибки();
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнение()
	РезультатФункции = ЗаданиеВыполнено(ИдентификаторЗадания, Адрес);
	
	Если РезультатФункции.Статус = "Выполняется" Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатФункции.Статус = "Завершено" Тогда
		ПоказатьРезультатЗадания(Адрес, РезультатФункции);
	КонецЕсли;
	
	Если РезультатФункции.Статус = "Ошибка" Тогда
		Сообщить(РезультатФункции.ОписаниеОшибки);
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("ПроверитьВыполнение");
КонецПроцедуры

#КонецОбласти

#КонецОбласти


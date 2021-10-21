# currencies

test for pb

```
git clone https://github.com/gor-che/currencies.git
make deps
make run
```

http://localhost:8088/


Тестовое задание: Реализовать апи для получения курсов валют

Задание:
Необходимо реализовать веб сервер для получения курсов валют в XML формате.
Веб сервер должен быть реализован используя библиотеку https://github.com/ninenines/cowboy
В момент запроса приложение должно выполнить запрос сервер-сервер на апи приватбанка и получить реальные курсы валют в JSON формате (https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5). Дальше необходимо распарсить JSON и сохранить полученные данные в ets таблицу на 1 минуту. Все последующие запросы в течении одной минуты должны брать данные из кэша ets таблицы.
В ответ на запрос приложение должно вернуть курсы валют в XML формате, для этого необходимо преобразовать полученные данные из JSON в XML формат

Пример ответа XML формате:
<exchangerates>
	<row>
		<exchangerate ccy="USD" base_ccy="UAH" buy="27.60000" sale="28.02000"/>
	</row>
	<row>
		<exchangerate ccy="EUR" base_ccy="UAH" buy="32.40000" sale="33.01000"/>
	</row>
	<row>
		<exchangerate ccy="RUR" base_ccy="UAH" buy="0.35500" sale="0.38200"/>
	</row>
	<row>
		<exchangerate ccy="BTC" base_ccy="USD" buy="9766.8318" sale="10794.9194"/>
	</row>
</exchangerates>

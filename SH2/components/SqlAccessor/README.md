Как пользоваться библиотекой SqlAccessor: 
	
	--Подключение к базе данных:
		1) Метод SqlConnectorManager::addConnection() для создания объекта SqlDatabaseConnector
		2) Метод SqlConnectorManager::openConnectio() для открытия соединения
		3) Метод SqlConnectorManager::getConnector() для получения доступа к объекту SqlDatabaseConnector (по имени соединения)
	
	--Создание новых ISqlTableItem
		1) Создать класс MyTableItemPrivate, унаследованный от ISqlTableItemPrivate 
		2) Создать класс MyTableItem, унаследованный от ISqlTableItem
		3) В обоих классах объявить Q_OBJECT
		4) В классе MyTableItemPrivate объявить friend MyTableItem
		5) В классе MyTableItemPrivate объявить поля, как в таблице в базе данных, через макрос DECLARE_SQL_FIELD
		6) В конструкторе MyTableItem полю _private присвоить новый объект MyTableItemPrivate (через new)
		7) В классе MyTableItem написать:
			using ptr = QSharedPointer<MyTableItem>;
			static ptr create () { return ptr(new MyTableItem); }
	
	--Создание новых ISqlTableManager
		1) Создать класс MyTableManager, унаследованный от ISqlTableManager
		2) В конструкторе родительскому классу передать в качестве параметров: 
			1) Указатель на SqlDatabaseConnector (достается через SqlConnectorManager::getConnector(), имя соединения - Config::dbName())
			2) Название схемы, в которой находится таблица
			3) Название таблицы
			4) Функцию для парсинга объектов. (ISqlTableManager::standardParser<MyTableItem>) 
			5) Указатель на родитель QObject
		
	--Модификация ISqlTableManager
		1) Есть возможность для модификации запросов, которые будет формировать менеджер.
		Для этого нужно перегрузить функции selectQuery, insertQuery, updateQuery и deleteQuery соответственно
		
		2) Для того, чтобы менеджер отображал свои данные в модели, нужно перегрузить метод plotItem, который вносит MyTableItem в модель (1 строчка)
		или перегрузить метод updateModel, который отображает все данные в модели сразу. Во втором случае не забыть, что поле _model изначально равно nullptr.
		Указать модель, в которой нужно будет отображать данные нужно через метод ISqlTableManager::setModel(). 
		
		3) Есть возможность предварительной проверки элемента на возможность внесения в базу данных. Для этого нужно перегрузить метод ISqlTableManager::checkItemValid, 
		в котором вернуть код ошибки, указывающей, по какой причине элемент не подходит. Коды ошибок можно перечислить в enum. Текст, объясняющий ошибку можно поместить
		в поле _lastItemCheckString, для того, чтобы позже отобразить причину пользователю. 
	
	

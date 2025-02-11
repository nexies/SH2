#include "ISqlTableManager.h"
#include <QUuid>
#include <QSqlQuery>
#include <QDebug>
#include <QMetaClassInfo>
#include <QJsonObject>


namespace
{
    QByteArray Title = QByteArrayLiteral("[ISqlTableManager] :");
}


ISqlTableManager::ISqlTableManager(SqlDatabaseConnector *connector, const QString &tableScheme, const QString &tableName,
                                   ISqlTableItem::ptr (*parserFunction) (const QJsonObject & record), QObject * parent) :
    QObject(parent)
{
    _connector = connector;
    _parserFunction = parserFunction;
    setTableName(tableName);
    setTableScheme(tableScheme);

    // _parserFunction = ISqlTableManager::standardParser<ISqlTableItem>;

    connect(this, &ISqlTableManager::execQuerySignal,
            _connector, &SqlDatabaseConnector::sendQuery);

    connect(_connector, &SqlDatabaseConnector::queryFinishedSignal,
            this, &ISqlTableManager::onQueryFinished);

    connect(_connector, &SqlDatabaseConnector::dbNotification,
            this, &ISqlTableManager::onDBNotification);

    connect(this, &ISqlTableManager::updated,
            this, &ISqlTableManager::updateModel);

    _model = new QStandardItemModel(this);
    connect(this->model(), &QObject::destroyed,  //TODO: УБРАТЬ КОННЕКТЫ ИЗ ТЫЩИ (100500) МЕСТ И СДЕЛАТЬ НОРМАЛЬНО!!!
            this, &ISqlTableManager::onModelDeleted,
            Qt::UniqueConnection);
}

ISqlTableManager::~ISqlTableManager()
{
    disconnect(this->model(), &QObject::destroyed,
               this, &ISqlTableManager::onModelDeleted);
}

int ISqlTableManager::insert(ISqlTableItem::ptr row)
{
    int validCode = checkItemValid(row);
    if(validCode == 0)
        createQueryRequest(QueryRequest::INSERT, insertQuery(row), row);

    return validCode;
}

int ISqlTableManager::update(ISqlTableItem::ptr row)
{
    int validCode = checkItemValid(row);
    if(validCode == 0)
        createQueryRequest(QueryRequest::UPDATE, updateQuery(row), row);

    return validCode;
}

int ISqlTableManager::remove(ISqlTableItem::ptr row)
{
//    if(checkItemValid(row))
    createQueryRequest(QueryRequest::DELETE, deleteQuery(row), row);
    return 0;
}

int ISqlTableManager::removeByUuid(const QString &uuid)
{
    ISqlTableItem::ptr item = this->item(uuid);

    if(item == nullptr)
    {
        qWarning().noquote() << QString("[ISqlTableManager][remove] : no item with uuid '%1' in table \"%2.%3\"")
                                .arg(uuid, tableScheme(), tableName());
        return 1;

    }
    return this->remove(item);
}

int ISqlTableManager::checkItemValid(ISqlTableItem::ptr item)
{
    Q_UNUSED(item)
    return 0;
}

QString ISqlTableManager::lastItemCheckString()
{
    return _lastItemCheckString;
}

const QList<ISqlTableItem::ptr> ISqlTableManager::items()
{
    QList<ISqlTableItem::ptr> out;
    for(auto key: _items.keys())
        out << _items[key];
    return out;
}

ISqlTableItem::ptr ISqlTableManager::item(const QString &uuid)
{
    if(_items.contains(uuid))
        return _items[uuid];
    else
        return ISqlTableItem::ptr(nullptr);
}

QString ISqlTableManager::selectQuery()
{
    return QString("SELECT * FROM %1.%2;").arg(tableScheme(), tableName());
}

QString ISqlTableManager::insertQuery(ISqlTableItem::ptr item)
{
    auto sqlValues = item->sqlValues();
    QStringList namesList;
    QStringList bindNamesList;

    for(auto it = sqlValues.begin(); it != sqlValues.end(); it++)
    {
        namesList << it.key();
        bindNamesList << ":" + it.key();
    }

    return QString("INSERT INTO %1.%2 (%3, _uuid) VALUES (%4, %5);").
            arg(tableScheme(), tableName(),
                namesList.join(", "),
                bindNamesList.join(", "),
                QString("'%1'").arg(item->uuid()));
}

QString ISqlTableManager::updateQuery(ISqlTableItem::ptr item)
{
    auto sqlValues = item->sqlValues();
    QStringList namesList;
    QStringList bindNamesList;

    for(auto it = sqlValues.begin(); it != sqlValues.end(); it++)
    {
        namesList << it.key();
        bindNamesList << ":" + it.key();
    }

    QStringList fieldNameValue;
    for(int i = 0; i < namesList.size(); i++)
    {
        fieldNameValue << QString("%1=%2").arg(namesList[i], bindNamesList[i]);
    }

    return QString("UPDATE %1.%2 SET %3 WHERE _uuid=%4").
            arg(tableScheme(), tableName(),
                fieldNameValue.join(", "),
                QString("'%1'").arg(item->uuid()));
}

QString ISqlTableManager::deleteQuery(ISqlTableItem::ptr item)
{
    return QString("DELETE FROM %1.%2 WHERE _uuid=%3;").
            arg(tableScheme(), tableName(),
                QString("'%1'").arg(item->uuid()));
}

ISqlTableItem::ptr ISqlTableManager::parseSingleQuery(const QJsonObject &record)
{
    if(!_parserFunction)
    {
        qWarning().noquote() << Title << "function for parsing is not set! \n"
                                         "Add '_parserFuncion = ISqlTableManager::standardParser<YourItemType>;' \n"
                                         "to the constructor of your manager!";
        return ISqlTableItem::create();
    }
    return _parserFunction(record);
}



void ISqlTableManager::load()
{
    createQueryRequest(QueryRequest::SELECT, selectQuery());
    _loadedState = Loading;
}

void ISqlTableManager::unload()
{
    _items.clear();
    _loadedState = NotLoaded;
}

void ISqlTableManager::fullReload()
{
    unload();
    load();
}

ISqlTableManager::LoadedState ISqlTableManager::loadedState() const
{
    if(!_awaitedQueries.isEmpty())
        return Loading;
    return _loadedState;
}

void ISqlTableManager::plotItem(ISqlTableItem::ptr item)
{
    Q_UNUSED(item)
    return;
}

void ISqlTableManager::updateModel()
{
    if(!_model)
        return;

    _model->setRowCount(0);

    for(auto item: items())
        plotItem(item);
}

int ISqlTableManager::count() const
{
    return _items.count();
}

QStandardItemModel * ISqlTableManager::model() const
{
    return _model;
}

void ISqlTableManager::setModel(QStandardItemModel *newModel)
{    
    switch(_modelUsage)
    {
    case UsingOwnModel:
        if(!newModel)  // Если пытаемся удалить, когда используем свою, то ничего не делаем
            break;

        if(_model) // Очищаем собственную модель
        {
            disconnect(this->model(), &QObject::destroyed,
                       this, &ISqlTableManager::onModelDeleted);
            delete _model;
        }

        _model = newModel;
        break;
    case UsingForeignModel:
        if(!newModel) // Перестаем использовать внешнюю модель
        {
            _model = new QStandardItemModel(this);
            updateModel();
            break;
        }
        _model = newModel; // Переключаемся на другую внешнюю модель
        break;
    }

    connect(this->model(), &QObject::destroyed,
            this, &ISqlTableManager::onModelDeleted,
            Qt::UniqueConnection);
}

const QString &ISqlTableManager::tableName() const
{
    return m_tableName;
}

void ISqlTableManager::setTableName(const QString &newTableName)
{
    m_tableName = newTableName;
}

const QString &ISqlTableManager::tableScheme() const
{
    return m_tableScheme;
}

void ISqlTableManager::setTableScheme(const QString &newTableScheme)
{
    m_tableScheme = newTableScheme;
}

void ISqlTableManager::createQueryRequest(QueryRequest::Type type, const QString & query, ISqlTableItem::ptr item)
{
    QueryRequest request;
    request.type = type;
    QUuid uuid = QUuid::createUuid();
    request.uuid = uuid;
    request.str = query;
    request.item = item;
    _awaitedQueries << uuid;

    emit execQuerySignal(request);
}

void ISqlTableManager::onQueryFinished(const QUuid &uuid, QueryResult result)
{
//    qDebug() << _awaitedQueries << uuid;

    if(!_awaitedQueries.contains(uuid))
    {
        return;
    }

    _awaitedQueries.removeAll(uuid);
    if(_debug) qDebug().noquote() << Title << QString("query finished for table %1.%2!").arg(m_tableScheme, m_tableName);

    if(result.error.type() != QSqlError::NoError)
    {
        qWarning().noquote() << QString("[%1] query error : %2").arg(this->metaObject()->className(), result.error.text());
        return;
    }

//    qDebug() << "Qeury size" << query.size();
    if(result.isSelect)
    {
        if(_debug) qDebug().noquote() << Title << "type - SELECT";
        if(_debug) qDebug().noquote() << Title << "size - " << result.records.size();
        //qDebug().noquote() << Title << "data - " << result.records;
        unload();
        for(auto record: result.records)
        {
            auto item = parseSingleQuery(record);
            if(item)
                _items[record.value("_uuid").toString()] = item;
            else
                qWarning().noquote() << Title << "not adding item to the list";
        }
        emit updated();
        _loadedState = Loaded;
    }
}

void ISqlTableManager::onDBNotification(const SqlNotification notif)
{
//    qDebug().noquote() << QString("[ISqlTableManager] : notification for %1.%2").arg(notif.schema, notif.table);
    if(notif.table != tableName() || notif.schema != tableScheme())
    {
        if(_items.contains(notif.itemUuid))
            qWarning().noquote() << QString("[%1][onDBNotification] : table name (%2) or scheme (%3) didn't match the notification(%4.%5),\n"
                                            "but the manager has an item with such uuid. What went wrong?")
                                    .arg(metaObject()->className(),
                                         tableName(),
                                         tableScheme(),
                                         notif.schema,
                                         notif.table);
        return;
    }

    switch(notif.actionType)
    {
    case SqlNotification::INSERT:
    {
        if(_debug) qDebug().noquote() << Title << QString("Received INSERT for table %1.%2").arg(tableScheme(), tableName());
        auto newItem = parseSingleQuery(notif.data);
        _items.insert(notif.itemUuid, newItem);
    }
    break;
    case SqlNotification::UPDATE:
    {
        if(_debug) qDebug().noquote() << Title << QString("Received UPDATE for table %1.%2").arg(tableScheme(), tableName());
        auto item = parseSingleQuery(notif.data);
        if(_items.contains(notif.itemUuid))
            _items[notif.itemUuid] = item;
        else
            qWarning () << Title << "UPDATE for non-existing item!";
    }
    break;
    case SqlNotification::DELETE:
    {
        if(_debug) qDebug().noquote() << Title << QString("Received DELETE for table %1.%2").arg(tableScheme(), tableName());
        if(_items.contains(notif.itemUuid))
            _items.remove(notif.itemUuid);
        else
            qWarning () << Title << "REMOVE for non-existing item!";
    }
    break;
    }

    emit updated();
    emit updatedItem(item(notif.itemUuid));
    _loadedState = Loaded;
}

void ISqlTableManager::onModelDeleted()
{
    QString className = metaObject()->className();

    if(_modelUsage == UsingOwnModel)
    {
        qWarning() << QString("[%1][onModelDeleted] : manager's own model is deleted from elsewhere. DON'T DO THIS")
                      .arg(className);
        _model = new QStandardItemModel(this);
        connect(this->model(), &QObject::destroyed,
                this, &ISqlTableManager::onModelDeleted,
                Qt::UniqueConnection);
        updateModel();
    }
    else if(_modelUsage == UsingForeignModel)
    {
        qWarning() << QString("[%1][onModelDeleted] : manager's foeign model was deleted from elsewhere. Switching to own model")
                      .arg(className);
        setModel(nullptr);
    }
}


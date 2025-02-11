#include "SqlQueryThread.h"
#include <QDebug>


namespace
{
const QByteArray Title = "[SqlQueryThread] : ";

inline QJsonObject recordToJson(const QSqlRecord & record)
{
    QJsonObject out;
    for(int i = 0; i < record.count(); i++)
    {
        QJsonValue value;
        value = QJsonValue::fromVariant(record.value(i));
        out.insert(record.fieldName(i), value);
    }
    return out;
}

}

SqlQueryThread::SqlQueryThread(const QSqlDatabase & database, QObject *parent) :
    QThread(parent)
{
    _database = QSqlDatabase::cloneDatabase(database, database.connectionName() + "_query_executor");
}

SqlQueryThread::~SqlQueryThread()
{

}

bool SqlQueryThread::exec(QueryRequest request)
{
    if(isRunning())
    {
        qWarning().noquote() << Title << "refusing to exec query. Thread is busy!";
        return false;
    }

    _lastRequest = request;
    this->start();
    return true;
}

void SqlQueryThread::run()
{
    if(!_database.isOpen())
    {
        _database.open();
    }

    if(!_query)
    {
        if(debug) qDebug().noquote() << Title << "constructing query object. Thread ID:" << QThread::currentThreadId();
        _query = new QSqlQuery(_database);
        _query->setForwardOnly(true);
    }

    auto outResult = QueryResult(); // clear the last result
    _query->finish(); // finish the whatever is going on in the query now

    _query->prepare(_lastRequest.str);
    auto bindValues = _query->boundValues();
    for(auto it = bindValues.begin(); it != bindValues.end(); it++)
    {
        QString fieldName = it.key().mid(1, -1);
        _query->bindValue(it.key(), _lastRequest.item->value(fieldName));
        qDebug().noquote() << Title << "adding bind value"
                           << fieldName << "=" << _lastRequest.item->value(fieldName);
    }


    bool ok = _query->exec(); // execute the query

    outResult.requestUuid = _lastRequest.uuid;

    if(!ok) // there was an error
    {
        qWarning() << Title << "query error" << _query->lastError();
        outResult.error = _query->lastError();
        outResult.isError = true;
        outResult.isSelect = false;
        emit result (outResult);
        return;
    }

    outResult.isError = false;
    outResult.isSelect = false;
    if(_query->isSelect())
    {
        outResult.isSelect = true;
        while(_query->next())
            outResult.records << recordToJson(_query->record());
    }
    _query->finish();
    emit result(outResult);

}

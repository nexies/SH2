#pragma once
#include <QThread>

#include <QSqlQuery>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlDriver>
#include <QUuid>
#include <QJsonValue>
#include <QSqlRecord>
#include <QJsonObject>
#include "SqlDatabaseConnector.h"

class SqlQueryThread : public QThread
{
    Q_OBJECT

public:
    explicit SqlQueryThread(const QSqlDatabase & database, QObject * parent = nullptr);
    ~SqlQueryThread();

    bool exec(QueryRequest request);

protected:
    void run () override;
private:
    QSqlQuery * _query { nullptr };
    QSqlDatabase _database;

    QueryRequest _lastRequest;
    QueryResult _lastResult;

    bool debug { true };

signals:
    void result (QueryResult res);
};

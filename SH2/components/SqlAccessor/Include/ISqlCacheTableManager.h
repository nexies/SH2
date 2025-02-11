#ifndef ISQLCACHETABLEMANAGER_H
#define ISQLCACHETABLEMANAGER_H

#include "ISqlTableManager.h"
#include <QCache>

typedef ISqlTableManager * (*TableManagerCreatorFunc) ();


class ISqlCacheTableManager
{
public:
    ISqlCacheTableManager();
    ~ISqlCacheTableManager();

    template<typename NameOfType>
    bool RegisterManage(QString name);

private:
    QMap<QString, TableManagerCreatorFunc> creatorFuncs;

};

#endif // ISQLCACHETABLEMANAGER_H

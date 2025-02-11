#include "Pool.h"

QMap<QString, ManagerCreatorFunc> Pool::_creationMap;
//QMap<QString, ISqlTableManager *> Pool::_managers;
SharedCache<QString, ISqlTableManager> Pool::_managers;

QSharedPointer<ISqlTableManager> Pool::request_x(const QString &name)
{
    if(!Pool::_creationMap.contains(name))
    {
        qWarning() << "[Pool][request] : name" << name << "is not registered!";
        return QSharedPointer<ISqlTableManager>(nullptr);
    }
    if(!Pool::_managers.contains(name))
    {
        QSharedPointer<ISqlTableManager> ptr (_creationMap[name] ());
        Pool::_managers.insert(name, ptr, 50); //TODO: ISqlTableManager should estimate it's size
        qDebug() << _managers.keys();
        qDebug() << _managers.totalCost();
    }
    return Pool::_managers[name];
}

bool Pool::registerManager(const QString &name, ManagerCreatorFunc creator)
{
    if(Pool::_creationMap.contains(name)) // проверка на уникальность
    {
        qDebug() << "[Pool][registerManager] : manager" << name << "already registered";
        return false;
    }


    qDebug() << "[Pool][registerManager] : registered manager" << name << "with custom creation function";
    Pool::_creationMap.insert(name, creator);
    return true;
}

#ifndef ISQLCACHETABLEMANAGER_H
#define ISQLCACHETABLEMANAGER_H

#include "ISqlTableManager.h"
#include <type_traits>
#include <QDebug>
#include <Utils/SharedCache.h>

typedef ISqlTableManager * (*ManagerCreatorFunc) ();

class Pool
{
    static QMap<QString, ManagerCreatorFunc> _creationMap;
//    static QMap<QString, ISqlTableManager *> _managers;
    static SharedCache<QString, ISqlTableManager> _managers;

    using ManPtr = SharedCache<QString, ISqlTableManager>::type_ptr;


public:
    template<typename ManagerType>
    static bool registerManager(const QString & name);

    static bool registerManager(const QString & name, ManagerCreatorFunc creator);

    static QSharedPointer<ISqlTableManager> request_x (const QString &name);

    template<typename ManagerType>
    static QSharedPointer<ManagerType> request (const QString & name);
};

template<typename ManagerType>
bool Pool::registerManager(const QString &name)
{
    // Проверка на то, что тип является менеджером (наследуется от TableManager)
    static_assert(std::is_base_of<ISqlTableManager, ManagerType>::value, "ManagerType must inherit from ISqlTableManager");

    if(Pool::_creationMap.contains(name)) // проверка на уникальность
        return false;

    Pool::_creationMap.insert(name, []() -> ISqlTableManager *
    {
        return static_cast<ISqlTableManager *> (new ManagerType());
    });
    qDebug() << "[Pool][registerManager] : Registered manager typeof"
             << ManagerType::staticMetaObject.className() << "as" << name;

    return true;
}

template<typename ManagerType>
QSharedPointer<ManagerType> Pool::request(const QString &name)
{

    if(!std::is_base_of<ISqlTableManager, ManagerType>::value)
    {
        qWarning() << "[Pool][request] : Manager type must inherit from ISqlTableManager!";
        return QSharedPointer<ManagerType>(nullptr);
    }
    auto virt = request_x(name);
    if(!virt) return QSharedPointer<ManagerType>(nullptr);

    auto out = virt.dynamicCast<ManagerType>();
    if(!out)
    {
        qWarning() << "[Pool][request] : manager type is not compatable!";
        return QSharedPointer<ManagerType>(nullptr);
    }
    return out;
}

#endif // ISQLCACHETABLEMANAGER_H

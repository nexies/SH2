#include <QCoreApplication>

#include "Include/Utils/SharedCache.h"
#include <QList>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    // Set up code that uses the Qt event loop here.
    // Call a.quit() or a.exit() to quit the application.
    // A not very useful example would be including
    // #include <QTimer>
    // near the top of the file and calling
    // QTimer::singleShot(5000, &a, &QCoreApplication::quit);
    // which quits the application after 5 seconds.

    // If you do not need a running Qt event loop, remove the call
    // to a.exec() or use the Non-Qt Plain C++ Application template.

    SharedCache<QString, QObject> cache;
    // QCache<QString, QObject> cache;
    using ptr = SharedCache<QString, QObject>::type_ptr;
    // auto control = ptr(new QObject);
    cache.insert("control", ptr(new QObject), 10);
    // cache.insert("control", new QObject, 10);
    auto control = cache["control"];
    control->setObjectName("control");

    for(int i = 0; i < 100; i++)
    {
        qDebug() << control->objectName() << "exists";
        // if(cache["object_10"]) qDebug() << "Object 10 exists";
        // ptr obj_ptr = ptr(new QObject());
        cache.insert(QString("object_%1").arg(QString::number(i + 1)), QSharedPointer<QObject>(new QObject), 10);
        // cache.insert(QString("object_%1").arg(QString::number(i + 1)), new QObject, 10);
        qDebug() << cache.keys();
    }


    return a.exec();
}

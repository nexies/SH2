#pragma once
#include <QSettings>
#include "Utils/Singleton.h"

class AppConfig : public QObject
{
    Q_OBJECT

    AppConfig();
    static AppConfig * _instance;
    QSettings * _settings { nullptr };

    void load();
    void save();

public:
    static AppConfig & instance();
    static void freeInstance();

    QString getMasterXmlFile ();
    QString getLogFile ();
    QString getNetInFile ();
    QString getNetOutFile ();

    QString getDBDriver ();
    QString getDBHost ();
    quint16 getDBPort ();
    QString getDBName ();
    QString getDBUser ();
    QString getDBPass ();

};

using Config = Singleton<AppConfig>;

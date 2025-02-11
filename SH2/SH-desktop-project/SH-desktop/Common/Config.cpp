#include "Config.h"
#include <QApplication>
#include <QDir>
#include <QStandardPaths>
#include <QSettings>

AppConfig * AppConfig::_instance { nullptr };

AppConfig::AppConfig() :
    QObject()
{
    QDir iniDir (QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation));
    QString fileName = qApp->applicationName() + ".ini";

    _settings = new QSettings(iniDir.absoluteFilePath(fileName), QSettings::IniFormat, this);

    connect(qApp, &QCoreApplication::aboutToQuit,
            _settings, &QSettings::sync);
}

void AppConfig::load()
{
    QDir defaultDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));

    _settings->beginGroup("main");
    setProperty("masterXmlFile", _settings->value("masterXmlFile", defaultDir.absoluteFilePath("master.xml")));
    setProperty("logFile", _settings->value("logFile", defaultDir.absoluteFilePath("log.txt")));
    setProperty("netInFile", _settings->value("netInFile", defaultDir.absoluteFilePath("ethernet_recieve.txt")));
    setProperty("netOutFile", _settings->value("netOutFile", defaultDir.absoluteFilePath("ethernet_send.txt")));
    _settings->endGroup();

    _settings->beginGroup("db");
    setProperty("driver", _settings->value("db_driver", "QPSQL"));
    setProperty("host",   _settings->value("db_host", "localhost"));
    setProperty("port",   _settings->value("db_port", "localhost"));
    setProperty("name",   _settings->value("db_name", "localhost"));
    setProperty("user",   _settings->value("db_username", "localhost"));
    setProperty("pass",   _settings->value("db_password", "localhost"));
    _settings->endGroup();

}

void AppConfig::save()
{
    _settings->beginGroup("main");
    _settings->setValue("masterXmlFile", property("masterXmlFile"));
    _settings->setValue("logFile", property("logFile"));
    _settings->setValue("netInFile", property("netInFile"));
    _settings->setValue("netOutFile", property("netOutFile"));
    _settings->endGroup();

    _settings->beginGroup("db");
    _settings->setValue("db_driver", property("driver"));
    _settings->setValue("db_host", property("host"));
    _settings->setValue("db_port", property("port"));
    _settings->setValue("db_name", property("name"));
    _settings->setValue("db_user", property("username"));
    _settings->setValue("db_pass", property("password"));
    _settings->endGroup();

    _settings->sync();
}

AppConfig &AppConfig::instance()
{
    if(!_instance)
        _instance = new AppConfig();
    return *_instance;
}

QString AppConfig::getMasterXmlFile()
{
    return property("masterXmlFile").toString();
}

QString AppConfig::getLogFile()
{
    return property("logFile").toString();
}

QString AppConfig::getNetInFile()
{
    return property("netInFile").toString();
}

QString AppConfig::getNetOutFile()
{
    return property("netOutFile").toString();
}

QString AppConfig::getDBHost()
{
    return property("db_host").toString();
}

quint16 AppConfig::getDBPort()
{
    return property("db_port").toUInt();
}

QString AppConfig::getDBName()
{
    return property("db_name").toString();
}

QString AppConfig::getDBUser()
{
    return property("db_user").toString();
}

QString AppConfig::getDBPass()
{
    return property("db_pass").toString();
}


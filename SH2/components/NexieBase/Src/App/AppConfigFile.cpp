#include "App/AppConfigFile.h"
#include <QCoreApplication>
#include <QStandardPaths>
#include <QDir>

AppConfigFile::AppConfigFile(const QString &confFile, QSettings::Format format)
{
    QDir iniDir (QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation));
    QString fileName;

    if(confFile.isEmpty())
        fileName = qApp->applicationName() + ".ini";
    else
        fileName = confFile;

    _settings = new QSettings(iniDir.absoluteFilePath(fileName), format, this);

    load();

    connect(qApp, &QCoreApplication::aboutToQuit,
            this, &AppConfigFile::save);
}

AppConfigFile::~AppConfigFile()
{

}


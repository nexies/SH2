#pragma once
#include <QObject>
#include <QString>
#include <QSettings>

class AppConfigFile : public QObject
{
    Q_OBJECT

public:
    AppConfigFile (const QString & confFile = QString(), QSettings::Format format = QSettings::IniFormat);
    ~AppConfigFile ();

protected:
    QSettings * _settings { nullptr };

protected slots:
    virtual void load () {};
    virtual void save () {};
};

#include "App/AppHelper.h"
#include <QByteArray>
#include <QCoreApplication>
#include <QFileInfo>
#include <QDateTime>
#include <QTextCodec>
#include <QThread>
#include <QDebug>

#include "Utils/DebugWrapper.h"
#include "Utils/AppTranslator.h"

namespace
{
void outputVersionInfo()
{
    qInfo()           << "----------------------------------------------------------";
    qInfo()           << "Application:" << qApp->applicationName();
    qInfo().noquote() << "CPU architecture:" <<QSysInfo::currentCpuArchitecture();
    qInfo().noquote() << "Build abi:" << QSysInfo::buildAbi();
    qInfo()           << "----------------------------------------------------------";
    qInfo().noquote() << "Build Version:" << qApp->applicationVersion();
    QString path = QCoreApplication::applicationFilePath();
    QFileInfo appfi(QCoreApplication::applicationFilePath());
    QDateTime dt = appfi.lastModified();
    qInfo().noquote() << "Build date-time:" << dt.toString("yyyy-MM-dd hh:mm:ss");
    qInfo().noquote() << "QT build version:" << qVersion();
    qInfo()           << "Codec for locale:" << QTextCodec::codecForLocale()->name();
    qInfo()           << "----------------------------------------------------------";
    qInfo().noquote() << "Main Thread:" << QThread::currentThread();
    qInfo()           << "----------------------------------------------------------";
}
}

AppHelper::AppHelper()
{
#ifdef APP_VERSION
    qApp->setApplicationVersion( QString::number(APP_VERSION) );
#endif
}

void AppHelper::installTranslations(const QString & sourceDir)
{
    _translator = new AppTranslator(qApp, sourceDir);
}

void AppHelper::installDebugHelper(bool install)
{
    DebugWrapper::instance().installPrettyDebug(install);
}

void AppHelper::displayAppInfo()
{
    outputVersionInfo();
}

int AppHelper::init()
{
    return 0;
}

AppTranslator &AppHelper::translator()
{
    return *_translator;
}

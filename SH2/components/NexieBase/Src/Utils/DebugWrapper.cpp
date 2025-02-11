#include "Utils/DebugWrapper.h"
#include "Utils/FuncInfo.h"
#include <QDateTime>
#include <QMutex>


namespace
{
QMutex mutex;
void debugWrapperFunction (QtMsgType type, const QMessageLogContext & context, const QString & message)
{
    QByteArray out = DebugWrapper::instance().constructDebugMessage(context, message);

    mutex.lock();
    switch(type)
    {
    case QtMsgType::QtInfoMsg:
        fprintf(stdout, "%s\n", out.data());
        fflush(stdout);
        break;
    case QtMsgType::QtDebugMsg:
        fprintf(stdout, "%s\n", out.data());
        fflush(stdout);
        break;
    case QtMsgType::QtWarningMsg:
        fprintf(stdout, "Warning:    %s\n", out.data());
        break;
    case QtMsgType::QtCriticalMsg:
        fprintf(stdout, "CRITICAL    %s\n", out.data());
        break;
    case QtMsgType::QtFatalMsg:
        fprintf(stdout, "!!!FATAL!!! %s\n", out.data());
        break;
    }
    mutex.unlock();
}
}

DebugWrapper * DebugWrapper::_instance { nullptr };

DebugWrapper::DebugWrapper()
{

}

DebugWrapper &DebugWrapper::instance()
{
    if(!_instance)
        _instance = new DebugWrapper;
    return *_instance;
}

void DebugWrapper::installPrettyDebug(bool install)
{
    qInstallMessageHandler(install ? debugWrapperFunction : nullptr);
}

void DebugWrapper::setDebugFlag(DebugFlags p_flag, bool on)
{
    if(on)
        _flags |= p_flag;
    else
        _flags &= ~p_flag;
}

void DebugWrapper::setDebugFlags(DebugFlags flags)
{
    _flags |= flags;
}

QByteArray DebugWrapper::constructDebugMessage(const QMessageLogContext &context, const QString &message)
{
    FuncInfo finfo(context.function);
    QByteArray out;
    if(_flags & DebugTime)
        out += QDateTime::currentDateTime().toString("hh:mm:ss ").toLocal8Bit();
    if((_flags & DebugScope) && !finfo.scope.isEmpty())
        out += QStringLiteral("[%1]").arg(finfo.scope).toLocal8Bit();

    out += QStringLiteral("[%1]").arg(finfo.name).toLocal8Bit();

    out += QStringLiteral(" : %1").arg(message).toLocal8Bit();
    return out;
}

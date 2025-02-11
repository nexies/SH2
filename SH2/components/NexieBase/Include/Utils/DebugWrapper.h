#pragma once
#include <QMap>

class DebugWrapper
{
public:
    enum DebugFlags
    {
        DebugTime       = 0x0001,
        DebugScope      = 0x0002,
        DebugArguments  = 0x0004,
        DebugTemplates  = 0x0008,
        UseStdOut       = 0x0010,
        DebugFunctionVirtual = 0x0020,
        DebugFunctionConst   = 0x0040,

        DefaultFlags    = DebugTime | DebugScope | UseStdOut
    };

private:

    DebugWrapper();
    static DebugWrapper * _instance;
    unsigned int _flags { DefaultFlags };

public:
    static DebugWrapper & instance();
    void installPrettyDebug (bool install = true);

    void setDebugFlag(DebugFlags flag, bool on = true);
    void setDebugFlags(DebugFlags flags);

    QByteArray constructDebugMessage (const QMessageLogContext & context, const QString & message);
};

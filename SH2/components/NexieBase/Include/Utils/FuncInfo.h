#pragma once

#include <QString>
#include <QStringList>
#include <QMap>

struct ScopeDescriptor
{
    QString name;
    QMap<QString, QString> tmpl;
};

class FuncInfo
{
public:
    FuncInfo();
    FuncInfo(const char * pretty_function);
    bool parsePrettyFunction (const char * pretty_function);

public:
    bool isVirtual;
    bool isConst;
    QString scope;
    QString returnType;
    QString name;
    QStringList args;
    QStringList templates;
    QString unparsed;
};

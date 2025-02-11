#include "Utils/FuncInfo.h"
#include <QRegularExpression>
#include <QRegularExpressionMatch>

FuncInfo::FuncInfo() {}

FuncInfo::FuncInfo(const char *pretty_function)
{
    parsePrettyFunction(pretty_function);
}

bool FuncInfo::parsePrettyFunction(const char *pretty_function)
{
    QString str = pretty_function;
    QStringList list;

    QRegularExpression virtualExp(R"(^virtual)");
    auto match = virtualExp.match(str);
    isVirtual = match.hasMatch();
    str.remove(match.capturedStart(), match.capturedLength());


    QRegularExpression returnTypeExp(R"((\w| |\*|&)* )");
    match = returnTypeExp.match(str, QRegularExpression::NormalMatch);

    returnType = match.captured().simplified();
    str.remove(match.capturedStart(), match.capturedLength());

    QRegularExpression scopeAndNameExp (R"((\w|::|<|>|,| |{anonymous})+)");
    // QRegularExpression scopeAndNameExp (R"((?:::)?(\w|<|>|,| |)+(?:::|\())");
    match = scopeAndNameExp.match(str);
    name = match.captured().simplified();
    list = name.split("::");
    name = list.last();
    scope = list.mid(0, list.size() - 1).join("::");

    str.remove(match.capturedStart(), match.capturedLength());

    QRegularExpression argumentsExp(R"(\((.*)\) ?)");
    match = argumentsExp.match(str);
    args = match.captured(1).split(",");
    str.remove(match.capturedStart(0), match.capturedLength(0));

    QRegularExpression constExp(R"(^const\b)");
    match = constExp.match(str);
    isConst = match.hasMatch();
    str.remove(match.capturedStart(0), match.capturedLength(0));

    QRegularExpression templatesExp(R"(\[with (\w|\s|=|;)*\])");
    match = templatesExp.match(str);
    QString templStr = match.captured(0);
    str.remove(match.capturedStart(0), match.capturedLength(0));

    QRegularExpression templateExp(R"((?:\w+)\s*=\s*(?:\w+))");
    auto matchIterator = templateExp.globalMatch(templStr);
    while(matchIterator.hasNext())
    {
        templates << matchIterator.next().captured();
    }

    unparsed = str;
    return true;
}


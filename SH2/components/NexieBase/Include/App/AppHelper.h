#pragma once

#include "Utils/AppTranslator.h"

class AppHelper
{
public:

    AppHelper();
    void installTranslations (const QString & sourceDir = QString());
    void installDebugHelper (bool install = true);
    void displayAppInfo ();
    virtual int init ();

    AppTranslator & translator ();

private:
    AppTranslator * _translator { nullptr };
};

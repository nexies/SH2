#pragma once
#include <QApplication>
#include "AppHelper.h"

class Application : public QApplication, public AppHelper
{
public:
    Application (int & argc, char * argv[]);

};

#include "App/Application.h"

Application::Application(int &argc, char *argv[]) :
    QApplication(argc, argv)
{
    init();
    installTranslations();
    displayAppInfo();
    installDebugHelper();
}

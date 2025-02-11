QT += core sql widgets
QT += concurrent
QT += gui

#CONFIG += c++17

TEMPLATE = lib
TARGET = NexieBase
#CONFIG += staticlib

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

include(../../common.pri)
#include($$PWD/LinkLibs.pri)

INCLUDEPATH += $$PWD/Include

SOURCES += \
        Src/App/AppConfigFile.cpp \
        Src/App/AppHelper.cpp \
        Src/App/Application.cpp \
        Src/Utils/AppTranslator.cpp \
        Src/Utils/DebugWrapper.cpp \
        Src/Utils/FuncInfo.cpp \
        Src/Utils/SharedCache.cpp \
        Src/Utils/mtk2Coding.cpp

HEADERS += \
        Defs/qproperty_declare.h \
        Include/App/AppConfigFile.h \
        Include/App/AppHelper.h \
        Include/App/Application.h \
        Include/Utils/AppTranslator.h \
        Include/Utils/DebugWrapper.h \
        Include/Utils/FuncInfo.h \
        Include/Utils/Singleton.h \
        Include/Utils/SharedCache.h \
        Include/Utils/mtk2Coding.h



# Default rules for deployment.
qnx: target.path = /usr/lib
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


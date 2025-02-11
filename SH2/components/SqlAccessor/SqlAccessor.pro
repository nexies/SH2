QT += core sql

TEMPLATE = lib
TARGET = SqlAccessor

include(../../common.pri)
include($$PWD/LinkLibs.pri)
INCLUDEPATH += $$PWD/Include

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


# Default rules for deployment.
unix {
    target.path = $${QNX_TARGET_LIB_PATH}
}
!isEmpty(target.path): INSTALLS += target

SOURCES += \
    Src/Pool.cpp \
    Src/SqlQueryThread.cpp \
    Src/ISqlTableItem.cpp \
    Src/ISqlTableManager.cpp \
    Src/SqlConnectorManager.cpp \
    Src/SqlDataMapper.cpp \
    Src/SqlDatabaseConnector.cpp \
    Src/SqlValue.cpp

HEADERS += \
    Include/ISqlTableItem.h \
    Include/ISqlTableManager.h \
    Include/Pool.h \
    Include/SqlConnectorManager.h \
    Include/SqlDataMapper.h \
    Include/SqlDatabaseConnector.h \
    Include/SqlNotification.h \
    Include/SqlQueryThread.h \
    Include/SqlValue.h \
    Include/sql_accessor_defs.h


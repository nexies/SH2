#include "Utils/AppTranslator.h"
#include <QLibraryInfo>
#include <QDebug>
#include <QFileInfoList>
#include <QDir>

AppTranslator::AppTranslator(QApplication * p_app, const QString & sourceDir)
{
    app = p_app;
    connect(app, &QApplication::aboutToQuit,
            this, &AppTranslator::clearTranslations);

    installStandartTranslator("qt_ru");
    if(!sourceDir.isEmpty())
        installTranslationsFrom(sourceDir);
    else
    {
        qDebug() << "[AppTranslator] : Installing translations from application's directory";
        installTranslationsFrom(app->applicationDirPath());
    }
}

bool AppTranslator::installStandartTranslator(const QString &language)
{
    QTranslator *qtTranslator = new QTranslator (app);
    if (!qtTranslator->load (language, QLibraryInfo::location (QLibraryInfo::TranslationsPath))) {
        qWarning ().noquote() << QString("[AppTranslator] : Could not load translations file \"%1\"").arg(language);
        delete qtTranslator;
        return false;
    }

    if (!app->installTranslator (qtTranslator)) {
        qWarning ().noquote() << QString("[AppTranslator] : Could not install translation \"%1\"").arg(language);
        delete qtTranslator;
        return false;
    }

    qInfo ().noquote() << QString("[AppTranslator] : Successfuly loaded and installed translation \"%1\"").arg(language);
    return true;
}

void AppTranslator::installTranslationsFrom(const QString &path)
{
    //-- файлы переводов в папке с ресурсами
    QFileInfoList trfiles;
    QDir trDir (path);
    trfiles = trDir.entryInfoList ({"*.qm"}, QDir::Files);

    for (int i = 0; i < trfiles.size (); ++i)
    {
        QTranslator *translator = new QTranslator ();
        if (!translator->load (trfiles[i].absoluteFilePath ()))
        {
            qWarning () << "[AppTranslator] : Could not load translation file"
                        << trfiles[i].fileName ();
            delete translator;
            continue;
        }

        if (app->installTranslator (translator)) {
            translators.append(translator);
            qInfo () << "[AppTranslator] : Successfuly loaded and installed translation" << trfiles[i].fileName ();
        }
        else
        {
            qWarning () << "[AppTranslator] : Could not install translation file" << trfiles[i].fileName ();
            delete translator;
        }
    }
}

void AppTranslator::clearTranslations()
{
    for (QTranslator *translator : qAsConst (translators)) {
        if (!app->removeTranslator (translator))
            qDebug () << "[AppTranslator] : Cannot remove translator";
        else
            qDebug () << "[AppTranslator] : Deleted translator";
        delete translator;
    }
}


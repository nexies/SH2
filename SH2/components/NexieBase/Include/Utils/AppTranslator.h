#pragma once
#include <QApplication>
#include <QList>
#include <QTranslator>


//!
//! \brief The AppTranslator class
//!
//! Класс для загрузки и установки на приложение доступных переводов.
//!
//! \author Ivanov GD
class AppTranslator : public QObject
{
    Q_OBJECT

    QList<QTranslator *> translators;
    QApplication * app;

public:

    //!
    //! \brief Конструктор
    //! \param app - Указатель на объект приложение
    //! \param sourceDir - Путь к директории с файлами переводов
    //!
    //! В случае, когда путь к директории с файлами переводов не указан, переводы будут искаться
    //! по пути исполняемого файла
    AppTranslator(QApplication * app = qApp, const QString & sourceDir = QString());

    //!
    //! \brief Метод для установки стандатного файла переводов.
    //! Этот метод устанавливает стандартный пакет переводов Qt для указанного языка
    //! \param language - Язык
    //! \return true/false - получилось установить перевод или нет
    bool installStandartTranslator (const QString & language);

    //!
    //! \brief Метод для установки доступных файлов переводов, находящихся
    //! в директории по указанному пути
    //! \param path - Путь к папке с файлами переводов
    void installTranslationsFrom (const QString & path);

public slots:

    //!
    //! \brief Слот для удаления загруженных переводов
    void clearTranslations ();
};


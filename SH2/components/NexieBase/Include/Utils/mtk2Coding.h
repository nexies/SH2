#ifndef MTK2CODING_H
#define MTK2CODING_H

#include <QByteArray>
#include <QMap>

//!
//! \brief The Mtk2Coder class
//! Класс для кодировки текста в формат МТК-2 и обратно
//! \author Ivanov GD
//!
//! Класс реализован через паттерн синглтон, это значит, что в программе
//! будет инициализирован всего лишь один объект этого класса (в момент
//! первого обращения)
class Mtk2Coder
{
    //!
    //! \brief Mtk2Coder
    //! Конструктор
    Mtk2Coder ();

    //!
    //! \brief _symbolCodesLittleFirst
    //! Карта соответствия кодов МТК-2 символам
    QMap<char, QString> _symbolCodesLittleFirst;
    //!
    //! \brief _codesOfSymbolsLittleFirst
    //! Карта соответствия символов кодам МТК-2
    QMap<QString, char> _codesOfSymbolsLittleFirst;
    //!
    //! \brief _registersOfSymbols
    //! Карта соответствия символов регистрам МТК-2
    QMap<QChar, int> _registersOfSymbols;
    //!
    //! \brief _registerCode
    //! Коды регистров МТК-2
    QList<char> _registerCode;

    //!
    //! \brief initAlphabeth
    //! Приватный метод для инициализации данных для работы класса
    void initAlphabeth ();

    //!
    //! \brief _instance
    //! Статический указатель на сингтон объект
    static Mtk2Coder * _instance;

    //!
    //! \brief loadInstance
    //! Статический метод для инициализации синглтон объекта
    static void loadInstance ();

    //!
    //! \brief stringToMtk2Private Приватный метод для перевода строки в формате unicode в формат МТК-2
    //! \param str - строка для перевода
    //! \return байты в МТК-2
    //!
    QByteArray stringToMtk2Private (const QString & str);

    //!
    //! \brief mtk2ToStringPrivate Приватный метод для перевода строки в формате МТК-2 в формат unicode
    //! \param mkt2 - строка для перевода
    //! \return строка в unicode
    //!
    QString mtk2ToStringPrivate (const QByteArray & mkt2);

    //!
    //! \brief The Register enum
    //! Регистр МТК-2
    enum Register
    {
        Undefined = -1, //!< Не определен
        Latin = 0,      //!< Латинские буквы
        Cyrillic = 1,   //!< Кириллица
        Numbers = 2     //!< Цифры
    };

    //!
    //! \brief The BitOrder enum
    //! Порядок битов при кодировке.
    enum BitOrder
    {
        LittleFirst,    //!< Младшие биты впереди
        BigFirst        //!< Старшие биты впереди (задом-наперед)
    };

    int _register { Undefined };
    int _bitOrder { LittleFirst };

public:
    //!
    //! \brief stringToMtk2 Статический метод для перевода строки в unicode в формат МТК-2
    //! \param str - строка для перевода
    //! \return закодированные байты
    //!
    //! Сначала проверяет, что объект сингтон инициализирован, после чего
    //! вызывет его приватный метод stringToMtk2Private
    static QByteArray stringToMtk2 (const QString & str);

    //!
    //! \brief mtk2ToString метод для перевода строки в формате МТК-2 в unicode
    //! \param mtk2 - байты для перевода
    //! \return строка
    //!
    //! Сначала проверяет, что объект сингтон инициализирован, после чего
    //! вызывает его приватный метод mtk2ToStringPrivate
    static QString mtk2ToString (const QByteArray & mtk2);
};

#endif // MTK2CODING_H

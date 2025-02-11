#pragma once
#include <QObject>
#include <QSharedPointer>
#include <QVariant>
#include <QUuid>
#include <QDateTime>
#include <QRegularExpression>
#include <QDebug>

#include "sql_accessor_defs.h"

/**
        \title ISqlTableItem

    Классы ISqlTableItem и ISqlTableItemPrivate служат для сопоставления
    информации в том виде, в котором она записана в базе данных, с тем, который
    используется в программе.

    Класс ISqlTableItemPrivate соответствует представлению информации в базе данных

    Класс ISqlTableItem предоставляет интерфейс для работы с этой информацией
    в удобном для использования виде

    Для того, чтобы создать новое представление, нужно определить два новых класса
    (далее - TableItemPrivate и TableItem), унаследованных от ISqlTableItemPrivate
    и ISqlTableItem соответственно.
    Оба эти класса должны соответствовать следующим правилам:

    -# Класс TableItemPrivate должен иметь свойста (properties),
    зарегестрированные в системе метаобъектов Qt через макрос Q_PROPERTY
    с модификаторами READ и WRITE
        -  Не забывайте, что для использования системы Q_PROPERTY
        так же придется использовать макрос Q_OBJECT

    -# Свойства класса TableItemPrivate должны называться так же, как
    называются соответствующие поля в запросе в базу данных.

    -# Класс TableItemPrivate должен реализовывать геттеры и сеттеры для
    всех своих свойств
        -  Для удобства использования реккомендуется пользоваться макросом
        DECLARE_SQL_FIELD(type, name), который объявляет Q_PROPERTY
        с данным типом данных и названием, а так же реализует функции
        get и set


    -# При создании TableItem в приватное поле TableItem::_private
    должен присваиваться новый объект класса TableItemPrivate
**/


//!
//! \brief The ISqlTableItemPrivate class
//! \author Ivanov GD
//!
//! Приватная часть элемента
//! Предназначена для того, чтобы хранить данные в том виде,
//! в котором они реально представлены в базе данных
//!
//! Внутри тела класса ISqlTableItemPrivate нужно перечислить
//! поля в таблице БД.
//!
//! Например, для таблицы Users:
//! \code{.cpp}
//! DECLARE_SQL_FIELD(QString, username)
//! DECLARE_SQL_FIELD(QString, password)
//! DECLARE_SQL_FIELD(quint64, lastLogin)
//! ...
//! \endcode
//!
class ISqlTableItemPrivate : public QObject
{
    friend class ISqlTableItem;




protected:
    //!
    //! \brief ISqlTableItemPrivate
    //! \param parent
    //! Конструктор
    //!
    ISqlTableItemPrivate (QObject * parent);
public:
    //!
    //! \brief fieldNames
    //! \return Список названий полей в таблице БД
    //!
    QStringList fieldNames() const;

    //!
    //! \brief value
    //! \param name - Название поля
    //! \return Значение поля по названию
    //!
    QVariant value (const QString & name) const;

    // //!
    // //! \brief values
    // //! \return Список всех значений строчки таблицы по порядку
    // //!
    // QVariantList values() const ;

    QMap<QString, QVariant> values() const;

    //!
    //! \brief sqlValue
    //! \param name - Название поля
    //! \return Значение поля в формате SQL
    //!
    //! Значения возвращаются в строчках, в формате, чтобы SQL их правильно принял,
    //! потому что дальше они будут использоваться для составления запросов.
    //!
    //! К строчным значениям (char, varchar, text) будут добавлены одинарные ковычки
    //! с двух сторон: "'abc'"
    //! К бинарным (bit) будет добавлена приставка B: "B'010010'"
    //!
    QString sqlValue(const QString & name) const;

    //!
    //! \brief sqlValues
    //! \return Значения всех полей элемента в формате SQL по порядку
    //!
    //! Значения возвращаются в строчках, в формате, чтобы SQL их правильно принял,
    //! потому что дальше они будут использоваться для составления запросов.
    //!
    //! К строчным значениям (char, varchar, text) будут добавлены одинарные ковычки
    //! с двух сторон: "'abc'"
    //! К бинарным (bit) будет добавлена приставка B: "B'010010'"
    //!
    QStringList sqlValues () const ;

    //!
    //! \brief count
    //! \return Количество полей в элементе
    //!
    int count() const ;
};


//!
//! \brief The ISqlTableItem class
//! \author Ivanov GD
//!
//! Класс для предоставления доступа к данным БД в том виде,
//! в котором они представленны в программе
class ISqlTableItem : public QObject
{
    friend class ISqlTableManager;
public:
    //!
    //! \brief ISqlTableItem
    //! Конструктор
    //!
    //! В конструкторе должно инициализироваться поле _private
    //! соответствующим классом приватной части элемента
    //!
    //! Например:
    //! <MySqlTableItem.cpp>
    //!
    //! MySqlTableItem::MySqlTableItem () : ISqlTableItem ()
    //! {
    //!     _private = new MySqlTableItemPrivate(this);
    //! }
    //!
    ISqlTableItem();
    //!
    //! \brief ~ISqlTableItem
    //! Деструктор
    virtual ~ISqlTableItem ();

    //!
    //! \brief Тип ptr и статическая функция create:
    //!
    //! В классе наследнике нужно добавить такое же, например:
    //! <MySqlTableItem.h>
    //!
    //! class MySqlTableItem : public ISqlTableItem {
    //!     ...
    //!     using ptr = QSharedPointer<MySqlTableItem>;
    //!     static ptr create() { return ptr(new MySqlTableItem); }
    //!     ...
    //! }
    using ptr = QSharedPointer<ISqlTableItem>;
    static ptr create() { return ptr(new ISqlTableItem); }

    //!
    //! \brief makeUuid Статический метод для генерации uuid
    //! \return
    //!
    static QString makeUuid ();

    //!
    //! \brief sqlFieldNames Метод, возвращающий список названий полей в SQL таблице
    //! \return
    //!
    QStringList sqlFieldNames() const;


    // //!
    // //! \brief sqlValues Метод, возвращающий список значений полей в SQL таблице
    // //! Значения возвращаются в строчках, в формате, чтобы SQL их правильно принял,
    // //! потому что дальше они будут использоваться для составления запросов.
    // //!
    // //! К строчным значениям (char, varchar, text) будут добавлены одинарные ковычки
    // //! с двух сторон: "'abc'"
    // //! К бинарным (bit) будет добавлена приставка B: "B'010010'"
    // //! \return
    // //!
    // QStringList sqlValues() const;


    QMap<QString, QVariant> sqlValues() const;

    //!
    //! \brief sqlValuesCount
    //! \return Количество колонок в таблице БД
    //!
    int sqlValuesCount() const;

    //!
    //! \brief value Метод для получения значения поля из таблицы БД
    //! \param name - название поля
    //! \return
    //!
    QVariant value (const QString & name);

    //!
    //! \brief uuid
    //! \return Уникальный идентификатор элемента
    //!
    const QString &uuid() const;

    //!
    //! \brief setUuid Метод для установки уникального идентификатора элемента
    //! \param uuid - Новое значение
    //!
    void setUuid (const QString & uuid);

    //!
    //! \brief fromJsonObject Метод для десериализации из объекта Json
    //! \param obj - данные
    //! \return true/false - получилось или нет
    //!
    bool fromJsonObject(const QJsonObject & obj);

    //!
    //! \brief toJsonObject Метод для сериализации в Json объект
    //! \return данные
    //!
    QJsonObject toJsonObject() const;
protected:
    //!
    //! \brief _private
    //! Указатель на приватную часть элемента.
    //! Должен быть инициализирован в конструкторе
    ISqlTableItemPrivate * _private { nullptr };

    //!
    //! \brief _uuid
    //! Уникальный идентификатор элемента
    QString _uuid;

    //!
    //! \brief _creationTime
    //! Время создания элемента
    QDateTime _creationTime;
};

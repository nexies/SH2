#pragma once

//! \def DECLARE_SQL_FIELD(type, name)
//!
//! Макрос для объявления поля SQL таблицы в ISqlTableItemPrivate
//! Может быть вызван только внутри класса QObject!
//!
//! Создает Q_PROPERTY указанного типа и названия, а так же добавляет в класс
//! поле, геттер и сеттер указанного типа и названия
//!
//! Например, строчка:
//! \code{.cpp}
//!     DECLARE_SQL_FIELD(QString, username)
//! \endcode
//! Преобразуется в:
//! \code{.cpp}
//!     Q_PROPERTY(QString username READ username WRITE set_username)
//!     QString m_username;
//!     inline QString username () { return m_username; }
//!     inline void set_username (QString value) { m_username = value; }
//! \endcode
#define DECLARE_SQL_FIELD(type, name) \
Q_PROPERTY(type name READ name WRITE set_##name) \
type m_##name; \
inline type name () { return m_##name; }; \
inline void set_##name (type value) { m_##name = value; }


//! \def WARNING_NOT_IMPLEMENTED
//!
//! Просто макрос, который удобно использовать для нереализованных методов
//! класса ISqlTableItem, когда непонятно, что именно они должны делать
//!
//! например, внутри метода класса MySqlItem::getCredentianls:
//! \code{.cpp}
//! QString MySqlItem::getCredentials()
//! {
//!     WARNING_NOT_IMPLEMENTED
//! }
//!\endcode
//! Вызов метода выведет в консоль следующее:
//!
//!  >>> [MySqlItem][getCredentials] : не реализована!
//!
#define WARNING_NOT_IMPLEMENTED  \
QRegularExpression rx ("(\\w+)::(\\w+)"); \
QRegularExpressionMatch match = rx.match(Q_FUNC_INFO); \
qWarning().noquote() << QString("[%1][%2] : не реализована!").arg(match.captured(1), match.captured(2));




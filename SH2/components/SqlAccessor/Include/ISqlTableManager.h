#pragma once
#include <QObject>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QStandardItemModel>
#include "ISqlTableItem.h"
#include "SqlDatabaseConnector.h"
#include <QDebug>



/****************************************************************************
 *                           ISqlTableManager                               *
 *                                                                          *
 *  Класс для управления конкретной таблицей (или несколькими таблицами)    *
 *  в базе данных, предоставляющий возможности для вставки, редактирования  *
 *  и удаления данных, а так же синхронизации данных в БД с данными в       *
 *  программе.                                                              *
 *                                                                          *
 ****************************************************************************
*/



//!
//! \brief The ISqlTableManager class
//! \author Ivanov GD
//!
class ISqlTableManager : public QObject
{
    Q_OBJECT

public:
    //!
    //! \brief The LoadedState enum
    //! Состояние данных
    enum LoadedState
    {
        NotLoaded,
        Loading,
        Loaded,
    };
    Q_ENUM(LoadedState)

    enum ModelUsage
    {
        UsingOwnModel,
        UsingForeignModel
    };
    Q_ENUM(ModelUsage)

    // enum SyncMode
    // {
    //     DoFullReloads,
    //     SyncChanges,
    // };
    // Q_ENUM(SyncMode)

    // enum UpdateMode
    // {
    //     UpdateModelFull,
    //     UpdateModelChanges,
    //     NoUpdate
    // };
    // Q_ENUM(UpdateMode)

    Q_PROPERTY(QString tableName READ tableName WRITE setTableName)
    Q_PROPERTY(QString tableScheme READ tableScheme WRITE setTableScheme)

protected:
    //!
    //! \brief m_baseName
    //! Название БД
    QString m_baseName;

    //!
    //! \brief m_tableName
    //! Название таблицы в БД
    QString m_tableName;

    //!
    //! \brief m_tableScheme
    //! Название схемы, в которой находится таблица в БД
    QString m_tableScheme;

    //!
    //! \brief _connector
    //! Указатель на коннектор к базе данных
    SqlDatabaseConnector * _connector { nullptr };

    //!
    //! \brief _model
    //! Указатель на модель данных, которая представляет данные из базы
    //! в программе
    QStandardItemModel * _model { nullptr };



    ModelUsage _modelUsage { UsingOwnModel };

    //!
    //! \brief _items
    //! Данные таблицы
    QMap<QString, ISqlTableItem::ptr> _items;

    //!
    //! \brief _awaitedQueries
    //! Список идентификаторов sql-запросов, которые были сделаны,
    //! но результат еще не вернулся
    QList<QUuid> _awaitedQueries;

    //!
    //! \brief _lastItemCheckString
    //! Строка с результатом последней проверки методом checkItemValid()
    QString _lastItemCheckString;


    //! Выводить или не выводить дебаг в консоль.
    bool _debug { true };

    //!
    //! \brief _parserFunction
    //! Указатель на функцию для парсинга данных из БД и преобразования
    //! в элемент определенного типа
    ISqlTableItem::ptr (*_parserFunction) (const QJsonObject & record);

    LoadedState _loadedState { NotLoaded };

public:
    //!
    //! \brief ISqlTableManager - конструктор
    //! \param connector - Указатель на коннектор к БД
    //! \param tableScheme - Название схемы
    //! \param tableName - Название таблицы
    //! \param parent - Указатель на родителя QObject
    ISqlTableManager(SqlDatabaseConnector * connector, const QString & tableScheme, const QString & tableName,
                     ISqlTableItem::ptr (*parserFunction) (const QJsonObject & record), QObject * parent = nullptr);

    virtual ~ISqlTableManager();

    //!
    //! \brief Метод для вставки элемента в таблицу БД
    //! \param row - Элемент
    //! \return Код причины, почему нельзя выполнить запрос (проверяется функцией checkItemValid)
    //!         0 - если запрос был успешно отправлен
    virtual int  insert(ISqlTableItem::ptr row);

    //!
    //! \brief Метод для обновления элемента в таблице БД
    //! \param row - Элемент
    //! \return Код причины, почему нельзя выполнить запрос (проверяется функцией checkItemValid)
    //!         0 - если запрос был успешно отправлен
    virtual int  update(ISqlTableItem::ptr row);

    //!
    //! \brief Метод для удаления элемента из таблицы БД
    //! \param row - Элемент
    //! \return Код причины, почему нельзя выполнить запрос (проверяется функцией checkItemValid)
    //!         0 - если запрос был успешно отправлен
    virtual int  remove(ISqlTableItem::ptr row);


    //!
    //! \brief removeByUuid Метод для удаоения элемента из таблицы БД по uuid
    //! \param uuid - Uuid
    //! \return Код причины, почему нельзя выполнить запрос (проверяется функцией checkItemValid)
    //!         0 - если запрос был успешно отправлен
    //!
    virtual int  removeByUuid(const QString & uuid);

    //!
    //! \brief Метод для проверки, что элемент корректный
    //! \param item - Элемент
    //! \return Код причины, почему элемент не корректный, или 0 в противном случае
    virtual int  checkItemValid(ISqlTableItem::ptr item);

    //!
    //! \brief lastItemCheckString Метод для получения строки с объяснением
    //! некорректности элемента при последней проверке
    //! \return
    //!
    QString lastItemCheckString();

    //!
    //! \brief items
    //! \return Список всех элементов, сейчас загруженных из базы
    const QList<ISqlTableItem::ptr> items();

    //!
    //! \brief item Метод для получения конкретного элемента
    //! \param uuid - Идентификатор элемента
    //! \return Элемент
    ISqlTableItem::ptr item(const QString & uuid);

    //!
    //! \brief load Метод для загрузки элементов из БД
    //!
    void load();

    //!
    //! \brief unload Метод для выгрузки элементов из памяти
    //!
    void unload();

    //!
    //! \brief fullReload Полная перезагрузка всех элементов
    //!
    void fullReload();

    //!
    //! \brief Состояние загрузки менеджера.
    //! \return Возвращает одно из возможных состояний:
    //!     - ISqlTableManager::NotLoaded - данные из БД еще не были загружены
    //!     - ISqlTableManager::Loading   - Запрос в БД был послан, но еще не был обработан
    //!     - ISqlTableManager::Loaded    - данные соответствуют БД
    LoadedState loadedState () const;


    //!
    //! \brief plotItem Отобразить элемент в модели данных
    //!
    virtual void plotItem (ISqlTableItem::ptr item);

    //!
    //! \brief updateModel Метод для обновления данных в модели представления
    //!
    //! Этот метод должен быть переопределен в классе-наследнике,
    //! иначе ваш менеджер будет являться виртуальным классом
    virtual void updateModel();

    //!
    //! \brief count
    //! \return Количество элементов, загруженных в память
    //!
    int count () const;

    //!
    //! \brief model
    //! \return Доступ к модели данных
    //!
    QStandardItemModel * model() const;;

    //!
    //! \brief setModel Метод для задания модели данных
    //! \param newModel - Модель данных
    //!
    void setModel (QStandardItemModel * newModel);

    //!
    //! \brief tableName
    //! \return Название таблицы в БД
    //!
    const QString &tableName() const;

    //!
    //! \brief setTableName Метод для задания названия таблицы в БД
    //! \param newTableName - Новое название
    //!
    void setTableName(const QString &newTableName);

    //!
    //! \brief tableScheme
    //! \return Название схемы в БД
    //!
    const QString &tableScheme() const;

    //!
    //! \brief setTableScheme Метод для задания названия схемы БД
    //! \param newTableScheme - Новое название
    //!
    void setTableScheme(const QString &newTableScheme);

protected:
    //!
    //! \brief selectQuery Метод для создания SQL запроса SELECT
    //! \return
    //!
    virtual QString selectQuery();

    //!
    //! \brief insertQuery Метод для создания SQL запроса INSERT
    //! \param item - Элемент, который будет вставлен
    //! \return
    //!
    virtual QString insertQuery(ISqlTableItem::ptr item);

    //!
    //! \brief updateQuery Метод для создания SQL запроса UPDATE
    //! \param item - Элемент, который будет обновлен
    //! \return
    //!
    virtual QString updateQuery(ISqlTableItem::ptr item);

    //!
    //! \brief deleteQuery Метод для создания SQL запроса DELETE
    //! \param item - Элемент, который будет удален
    //! \return
    //!
    virtual QString deleteQuery(ISqlTableItem::ptr item);

    //!
    //! \brief parseSingleQuery Метод для десериализации элемента таблицы из
    //! его описания в формате Json
    //! \param record - Данные в формате Json
    //! \return Элемент таблицы
    //!
    //! Должен быть переопределен в классе-наследнике, иначе ваш менеджер
    //! будет являться виртуальным классом
    virtual ISqlTableItem::ptr parseSingleQuery(const QJsonObject & record);


    //!
    //! \brief standardParser Стандартная статическая функция для парсинга
    //! данных
    //! \param record Json-объект
    //! \return элемент
    //!
    //! Типичное применение: передать в конструкторе класса-наследника в качестве параметра.
    //!
    //! ...
    //! MyTableManager(connector, sheme, name, ISqlTableManager::standardParser<MyTableItem>, parent)
    //! ...
    template<typename ItemPtrType>
    static ISqlTableItem::ptr standardParser(const QJsonObject & record);


protected slots:
    //!
    //! \brief createQueryRequest Слот для отправки запроса в БД.
    //! Создает уникальный идентификатор для данного запроса, помещает его
    //! в список ожидаемых результатов и отправляет сигнал execQuerySignal
    //! \param query - Строка запроса
    //!
    void createQueryRequest(QueryRequest::Type type, const QString & preparedQuery, ISqlTableItem::ptr item = ISqlTableItem::ptr());

    //!
    //! \brief onQueryFinished Слот обработки результата запроса в БД.
    //! Если идентификатор не совпадает ни с одним из ожидаемых, то
    //! результат игнорируется
    //! \param uuid - Идентификатор
    //! \param result - Результат запроса
    //!
    void onQueryFinished (const QUuid & uuid, QueryResult result);

    //!
    //! \brief onDBNotification Слот обработки уведомления из базы данных
    //!
    virtual void onDBNotification(const SqlNotification);



    void onModelDeleted();

signals:
    //!
    //! \brief execQuerySignal Сигнал для отправки запроса в БД
    //!
    void execQuerySignal(QueryRequest);

    //!
    //! \brief updated Сигнал того, что данные в менеджере обновились
    //!
    void updated();

    //!
    //! \brief updatedItem
    //!
    void updatedItem(ISqlTableItem::ptr item);

    //!
    //! \brief modelUpdated Сигнал того, что модель данных обновилась
    //!
    void modelUpdated();
};

template<typename ItemPtrType>
inline ISqlTableItem::ptr ISqlTableManager::standardParser(const QJsonObject &record)
{
    QString funcInfo = QString("[ISqlTableManager][standardParser<%1>] :").arg(ItemPtrType::staticMetaObject.className());
    ISqlTableItem::ptr item = ItemPtrType::create();
    QStringList fields = item->sqlFieldNames();


    if(!record.contains("_uuid"))
    {
        qCritical().noquote() << funcInfo << "can't auto parse the query - '_uuid' does not exist!";
        return item;
    }
    item->setUuid(record.value("_uuid").toString());

    for(auto field: fields)
    {
        if(!record.contains(field))
        {
            qWarning().noquote() << funcInfo << "warning - record doesn't contain field" << field;
        }
        item->_private->setProperty(field.toStdString().c_str(), record.value(field));
    }
    return item;
}



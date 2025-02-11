#pragma once
#include <QCache>
#include <QSharedPointer>

template <typename Key, typename Type>
class SharedCache : public QCache<Key, QSharedPointer<Type>>
{
public:
    using type_ptr = QSharedPointer<Type>;
    explicit SharedCache(int maxCost = 100) noexcept;
    virtual ~SharedCache();

    bool insert (const Key &key, type_ptr object, int cost);

    type_ptr operator [] (const Key & key) const;
};

template<typename Key, typename Type>
SharedCache<Key, Type>::SharedCache(int maxCost) noexcept :
    QCache<Key, QSharedPointer<Type>>(maxCost)
{

}

template<typename Key, typename Type>
inline SharedCache<Key, Type>::~SharedCache()
{

}

template<typename Key, typename Type>
inline bool SharedCache<Key, Type>::insert(const Key &key, type_ptr object, int cost)
{
    type_ptr * v = new type_ptr(object);
    return QCache<Key, type_ptr>::insert(key, v, cost);
}

template<typename Key, typename Type>
inline typename SharedCache<Key, Type>::type_ptr SharedCache<Key, Type>::operator [](const Key &key) const
{
    auto obj = this->QCache<Key, type_ptr>::object(key);
    if(obj == nullptr)
        return type_ptr(nullptr);
    return *obj;
}

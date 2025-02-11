#pragma once

template< typename Class>
class Singleton final
{
public:
    static Class & instance()
    {
        static Class _instance;
        return _instance;
    }
private:
    Singleton() = default;
    ~Singleton() = default;

    Singleton(const Singleton&) = delete;
    Singleton& operator=(const Singleton&) = delete;
    Singleton(Singleton&&) = delete;
    Singleton& operator=(Singleton&&) = delete;
};


#include "Utils/mtk2Coding.h"

#include <QDataStream>
#include <QDebug>

#define SYMBOL_MASK 0b11111

namespace {
    // Функция для переворота порядка битов
    char swapBits (char c)
    {
        return (c & 0b10000) >> 4
             | (c & 0b01000) >> 2
             | (c & 0b00100)
             | (c & 0b00010) << 2
             | (c & 0b00001) << 4;
    }

}

Mtk2Coder * Mtk2Coder::_instance { nullptr };

Mtk2Coder::Mtk2Coder()
{
    initAlphabeth();
}

void Mtk2Coder::initAlphabeth()
{
    // На всякий случай отчищаем карты соответствий.
    _symbolCodesLittleFirst.clear();
    _codesOfSymbolsLittleFirst.clear();
    _registersOfSymbols.clear();
    _registerCode.clear();
//    _symbolCodesBigFirst.clear();
//    _codesOfSymbolsBigFirst.clear();

    // Вручную задаем карту соответствия кода в MTK-2 набору символов (младший бит первый)
    _symbolCodesLittleFirst =
    {
        {0b00011, QString("aа-")},
        {0b11001, QString("bб?")},
        {0b01110, QString("cц:")},
        {0b01001, QString("dд*")},
        {0b00001, QString("eе3")},
        {0b01101, QString("fфэ")},
        {0b11010, QString("gгш")},
        {0b10100, QString("hхщ")},
        {0b00110, QString("iи8")},
        {0b01011, QString("jйю")},
        {0b01111, QString("kк(")},
        {0b10010, QString("lл)")},
        {0b11100, QString("mм.")},
        {0b01100, QString("nн,")},
        {0b11000, QString("oо9")},
        {0b10110, QString("pп0")},
        {0b10111, QString("qя1")},
        {0b01010, QString("rр4")},
        {0b00101, QString("sс`")},
        {0b10000, QString("tт5")},
        {0b00111, QString("uу7")},
        {0b11110, QString("vж=")},
        {0b10011, QString("wв2")},
        {0b11101, QString("xь/")},
        {0b10101, QString("yы6")},
        {0b10001, QString("zз+")},
        {0b01000, QString("\r\r\r")},
        {0b00010, QString("\n\n\n")},
        {0b11111, QString("LAT")},
        {0b11011, QString("NUM")},
        {0b00100, QString("   ")},
        {0b00000, QString("RUS")},
    };

    // Устанавливаем соответствие между символом и кодом в МТК-2 (младший бит первый)
    for(auto it = _symbolCodesLittleFirst.begin(); it != _symbolCodesLittleFirst.end(); it++)
    {
        if(it.value().toLower() != it.value()) // строчки LAT RUS NUM (проверить)
        {
            _codesOfSymbolsLittleFirst[it.value()] = it.key();
            continue;
        }
        // Также устанавливаем соответсвие между символом и регистром, в котором он находится
        for(int i = 0; i < 3; i++)
        {
            _codesOfSymbolsLittleFirst[QString(it.value()[i])] = it.key();
            _registersOfSymbols[it.value()[i]] = i;
        }
    }

    _registerCode << 0b11111 << 0b00000 << 0b11011;

    // конец. Алфавит инициализирован
    qDebug() << "[Mtk2Coder] : initialized alphabeth";

}

void Mtk2Coder::loadInstance()
{
    if(!_instance)
        _instance = new Mtk2Coder();
}

QByteArray Mtk2Coder::stringToMtk2Private(const QString &str)
{
    _register = Undefined;
    QByteArray out;
    QDataStream stream(&out, QIODevice::WriteOnly);

    QList<QChar> alowedSymbols = _registersOfSymbols.keys();

    QString prepared = str.toLower();
    prepared = prepared.replace("ч", "4");
    prepared = prepared.replace("ё", "е");
    prepared = prepared.replace("ъ", "ь");

    if(prepared.isEmpty())
        return QByteArray();

    auto switchRegister  = [&] (QChar charRef)
    {
        if(_registersOfSymbols[charRef] != _register)
        {
            _register = _registersOfSymbols[charRef];

            char code = _registerCode[_register];
            if(_bitOrder == BigFirst)
                code = swapBits(code);

            stream << static_cast<quint8> (code);
        }
    };

    for(int i = 0; i < prepared.size(); i++)
    {
        QChar symbol = prepared[i];
        if(!alowedSymbols.contains(symbol))
            continue;

        switchRegister(symbol);
        char code = _codesOfSymbolsLittleFirst[QString(symbol)];
        if(_bitOrder == BigFirst)
            code = swapBits(code);

        stream << static_cast<quint8> (code);
    }

    return out;
}

QString Mtk2Coder::mtk2ToStringPrivate(const QByteArray &mtk2)
{
    _register = Undefined;
    QString out;
    QTextStream stream(&out);

    if(mtk2.isEmpty())
        return QString();

    auto switchRegister = [&] (char c) {
        if(_symbolCodesLittleFirst[c] == "RUS")
            _register = Cyrillic;
        else if(_symbolCodesLittleFirst[c] == "LAT")
            _register = Latin;
        else if(_symbolCodesLittleFirst[c] == "NUM")
            _register = Numbers;
        else
            return false;
        return true;
    };

    for(int i = 0; i < mtk2.size(); i++)
    {
        char code = mtk2[i] & SYMBOL_MASK;
        if(_bitOrder == BigFirst)
            code = swapBits(code);

        if(switchRegister(code))
            continue;

        if(_register == Undefined)
        {
            qWarning() << "Error";
            return QString();
        }

        stream << _symbolCodesLittleFirst[code][_register];
    }
    return out;
}

QByteArray Mtk2Coder::stringToMtk2(const QString &str)
{
    loadInstance();
    return Mtk2Coder::_instance->stringToMtk2Private(str);

}

QString Mtk2Coder::mtk2ToString(const QByteArray &mtk2)
{
    loadInstance();
    return Mtk2Coder::_instance->mtk2ToStringPrivate(mtk2);

}

#include <QCoreApplication>
#include <QDebug>

#include <QFile>
#include <QXmlStreamReader>

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>

bool connectToShBase ()
{
    auto db = QSqlDatabase::addDatabase("QPSQL", "sh_database");
    db.setHostName("localhost");
    db.setPort(5432);

    db.setUserName("postgres");
    db.setDatabaseName("sh");
    db.setPassword("12345678");

    return db.open();
}

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QFile file (PROJECT_DIR "/xml/master.xml");

    // if(!connectToShBase())
    // {
    //     qWarning() << "failed to connect to the database!";
    //     return 1;
    // }

    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qWarning() << "failed to open file" << file.fileName();
        return 1;
    }


    // QSqlQuery query(QSqlDatabase::database("sh_database"));

    QXmlStreamReader reader(&file);

    while(!reader.atEnd() && !reader.hasError())
    {
        QXmlStreamReader::TokenType token = reader.readNext();
        if(token == QXmlStreamReader::StartDocument)
            continue;

        if(token == QXmlStreamReader::StartElement)
        {
            if(false /*reader.name() == "device_RS"*/)
            {
                // qDebug() << "device_RS";
                auto attrs = reader.attributes();
                QMap<QString, QString> attrMap;

                for(auto attr : attrs)
                {
                    attrMap[attr.name().toString()] = attr.value().toString();
                }

                QString str("INSERT INTO \"Rs485Device\" (name, definition, description, net_interface_id, is_input, \n"
                              "box, parity, base_address, noise_filters, word_len, net_max_timeout, stop_bit, type_id, \n"
                              "net_address_len, version, protocol_id, baud_rate) \n"
                              "VALUES "
                              "(':name', '', '', 2, :is_input, :box, 'false', ':base_address', 'false', 8, 5, 1, :type_id, "
                              "8, '1.0', 1, 9600);");

                str.replace(":name", attrMap["name"]);
                str.replace(":is_input", attrMap["box"].contains("IN") ? "true" : "false");
                str.replace(":box", attrMap["box"].split("_")[1]);
                str.replace(":base_address", attrMap["base_address"]);
                str.replace(":type_id", attrMap["type"] == "MV110-16D" ? "2" :
                                        attrMap["type"] == "MV110-16R" ? "1" : "0");

                qDebug().noquote().nospace() << str << "\n";

            }
            static int id = 1;
            if(false && (reader.name() == "key"))
            {
                auto attrs = reader.attributes();
                QMap<QString, QString> attrMap;

                for(auto attr : attrs)
                {
                    attrMap[attr.name().toString()] = attr.value().toString();
                }
                QStringList idList = attrMap["id"].split(" ")[0].split("_");
                QString shift = idList[4];
                QString box   = idList[3];

                QString str ("INSERT INTO public.\"Rs485Key\" "
                            "(id, rs_device_id, shift, name, state, counter) \n "
                            "SELECT :id, id, :shift, ':name', :state, :counter FROM public.\"Rs485Device\"\n"
                            "WHERE box = :box AND is_input = true;");

                str.replace(":id", QString::number(id++));
                str.replace(":shift", QString::number(shift.toInt()));
                str.replace(":name", attrMap["id"]);
                str.replace(":state", attrMap["state"]);
                str.replace(":counter", attrMap["counter"]);
                str.replace(":box", box);

                qDebug().noquote().nospace() << str << '\n';
            }

            if(reader.name() == "contact")
            {
                auto attrs = reader.attributes();
                QMap<QString, QString> attrMap;

                for(auto attr : attrs)
                {
                    attrMap[attr.name().toString()] = attr.value().toString();
                }
                int space = attrMap["id"].indexOf(" ");
                QString name;
                QString definition;
                if(space == -1)
                    name = attrMap["id"];
                else
                {
                    name = attrMap["id"].mid(0, space);
                    definition = attrMap["id"].mid(space + 1, -1).remove(QRegExp(R"((\(|\)))"));
                }

                QStringList idList = attrMap["id"].split(" ")[0].split("_");
                QString shift = attrMap["shift"];
                QString box   = idList[3];

                QString str ("INSERT INTO public.\"Rs485Contact\" "
                            "(rs_device_id, shift, name, emergency, pwm, output, definition) \n "
                            "SELECT id, :shift, ':name', :emergency, :pwm, :output, ':definition' FROM public.\"Rs485Device\"\n"
                            "WHERE box = :box AND is_input = false;");

                str.replace(":id", QString::number(id++));
                str.replace(":shift", QString::number(shift.toInt()));
                str.replace(":name", name);
                str.replace(":emergency", attrMap["emergency"] != "0" ? "true" : "false");
                str.replace(":pwm", attrMap["pwm"]);
                str.replace(":output", attrMap["output"] != "0" ? "true" : "false");
                str.replace(":box", box);
                str.replace(":definition", definition);

                qDebug().noquote().nospace() << str << '\n';
            }
        }
    }

    return a.exec();
}

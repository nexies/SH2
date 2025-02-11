#include "mainwindow.h"
#include "App/Application.h"
#include <QDebug>

#include <QGraphicsWidget>
#include <QGraphicsScene>
#include <QGraphicsView>


int main(int argc, char *argv[])
{
    Application a(argc, argv);
    // MainWindow w;
    // w.show();

    QGraphicsScene scene;
    QGraphicsView view (&scene);

    QGraphicsWidget w;
    // w.show();

    scene.addItem(&w);

    view.show();

    // qDebug() << "Hello world!";
    return a.exec();
}

 #pragma once

#include <QAbstractListModel>
#include <QUrl>

class FeedSearchModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit FeedSearchModel(QObject *parent = nullptr);
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
};

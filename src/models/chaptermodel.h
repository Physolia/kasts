/**
 * SPDX-FileCopyrightText: 2021 Swapnil Tripathi <swapnil06.st@gmail.com>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#pragma once

#include <KFormat>
#include <QAbstractListModel>

#include <mpegfile.h>

struct ChapterEntry {
    QString title;
    QString link;
    QString image;
    int start;
};

class ChapterModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(QString enclosureId READ enclosureId WRITE setEnclosureId NOTIFY enclosureIdChanged)
    Q_PROPERTY(QString enclosurePath READ enclosurePath WRITE setEnclosurePath NOTIFY enclosurePathChanged)
    Q_PROPERTY(int duration READ duration WRITE setDuration NOTIFY durationChanged)
    Q_PROPERTY(int size READ size NOTIFY sizeChanged)

public:
    enum RoleNames {
        Title = Qt::UserRole,
        Link,
        Image,
        StartTime,
        FormattedStartTime,
        Duration,
    };

    explicit ChapterModel(QObject *parent = nullptr);

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent) const override;

    void setEnclosureId(QString newEnclosureId);
    QString enclosureId() const;

    void setEnclosurePath(const QString &enclosurePath);
    QString enclosurePath() const;

    void setDuration(int duration);
    int duration() const;
    int size() const;

Q_SIGNALS:
    void enclosureIdChanged();
    void enclosurePathChanged();
    void durationChanged();
    void sizeChanged();

private:
    void load();
    void loadFromDatabase();
    void loadChaptersFromFile();
    void loadMPEGChapters(TagLib::MPEG::File &f);

    QString m_enclosureId;
    QVector<ChapterEntry> m_chapters;
    KFormat m_kformat;
    QString m_enclosurePath;
    int m_duration;
};

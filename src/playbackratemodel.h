/**
 * SPDX-FileCopyrightText: 2021 Swapnil Tripathi <swapnil06.st@gmail.com>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */
#ifndef PLAYBACKRATEMODEL_H
#define PLAYBACKRATEMODEL_H

#include <QAbstractListModel>
#include <QCoreApplication>
#include <QJsonObject>
#include <QObject>

#include <KConfigGroup>
#include <KLocalizedString>
#include <KSharedConfig>

class PlaybackRate : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int playbackRate READ playbackRate WRITE setPlaybackRate NOTIFY playbackRateChanged)
public:
    explicit PlaybackRate(QObject *parent = nullptr, const int &rate = {});
    explicit PlaybackRate(const QJsonObject &obj);

    ~PlaybackRate();

    QJsonObject toJson() const;

    int playbackRate() const
    {
        return m_playbackRate;
    }

    void setPlaybackRate(const int &rate);

private:
    int m_playbackRate;

signals:
    void playbackRateChanged();
};

// MODEL

class PlaybackRateModel;
static PlaybackRateModel *s_playbackRateModel = nullptr;

class PlaybackRateModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles { PlaybackRateRole = Qt::UserRole };

    static PlaybackRateModel *instance()
    {
        if (!s_playbackRateModel) {
            s_playbackRateModel = new PlaybackRateModel(qApp);
        }
        return s_playbackRateModel;
    }

    void load();
    void save();

    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    Q_INVOKABLE void insertPlaybackRate(int rate);
    Q_INVOKABLE void deletePlaybackRate(const int index);
    Q_INVOKABLE void resetToDefault();

private:
    explicit PlaybackRateModel(QObject *parent = nullptr);
    ~PlaybackRateModel();

    QList<PlaybackRate *> m_playbackRates;
};

#endif // PLAYBACKRATEMODEL_H

/**
 * SPDX-FileCopyrightText: 2021 Swapnil Tripathi <swapnil06.st@gmail.com>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "playbackratemodel.h"

#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

const QString RATE_CFG_GROUP = QStringLiteral("General"), RATE_CFG_KEY = QStringLiteral("rates");

PlaybackRate::PlaybackRate(const QJsonObject &obj)
    : m_playbackRate(obj[QStringLiteral("playbackRate")].toInt())
{
}

PlaybackRate::PlaybackRate(QObject *parent, const int &rate)
    : QObject(parent)
    , m_playbackRate(rate)
{
}

void PlaybackRate::setPlaybackRate(const int &rate)
{
    m_playbackRate = rate;
    emit playbackRateChanged();
}

QJsonObject PlaybackRate::toJson() const
{
    QJsonObject obj;
    obj[QStringLiteral("playbackRate")] = m_playbackRate;
    return obj;
}

PlaybackRate::~PlaybackRate()
{
}

PlaybackRateModel::PlaybackRateModel(QObject *parent)
    : QAbstractListModel(parent)
{
    load();
}

PlaybackRateModel::~PlaybackRateModel()
{
    save();

    qDeleteAll(m_playbackRates);
}

void PlaybackRateModel::load()
{
    auto config = KSharedConfig::openConfig();
    KConfigGroup group = config->group(RATE_CFG_GROUP);
    QJsonDocument doc = QJsonDocument::fromJson(group.readEntry(RATE_CFG_KEY, "{}").toUtf8());

    const auto array = doc.array();
    std::transform(array.begin(), array.end(), std::back_inserter(m_playbackRates), [](const QJsonValue &ser) {
        return new PlaybackRate(ser.toObject());
    });
}

void PlaybackRateModel::save()
{
    QJsonArray arr;

    const auto rates = qAsConst(m_playbackRates);
    std::transform(rates.begin(), rates.end(), std::back_inserter(arr), [](const PlaybackRate *rate) {
        return QJsonValue(rate->toJson());
    });

    auto config = KSharedConfig::openConfig();
    KConfigGroup group = config->group(RATE_CFG_GROUP);
    group.writeEntry(RATE_CFG_KEY, QJsonDocument(arr).toJson(QJsonDocument::Compact));

    group.sync();
}

QHash<int, QByteArray> PlaybackRateModel::roleNames() const
{
    return {{Roles::PlaybackRateRole, "rate"}};
}

QVariant PlaybackRateModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_playbackRates.count() || index.row() < 0)
        return {};

    auto *search = m_playbackRates.at(index.row());
    if (role == Roles::PlaybackRateRole)
        return QVariant::fromValue(search);

    return {};
}

int PlaybackRateModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_playbackRates.count();
}

void PlaybackRateModel::insertPlaybackRate(int rate)
{
    Q_EMIT beginInsertRows({}, 0, 0);
    m_playbackRates.insert(0, new PlaybackRate(this, rate));
    Q_EMIT endInsertRows();
    qDebug() << "Inserted.";

    save();
}

void PlaybackRateModel::deletePlaybackRate(const int index)
{
    beginRemoveRows({}, index, index);
    m_playbackRates.removeAt(index);
    endRemoveRows();

    save();
}

void PlaybackRateModel::resetToDefault()
{
    beginResetModel();
    for (auto &search : m_playbackRates) {
        delete search;
    }
    m_playbackRates.clear();
    endResetModel();
    qDebug() << "Success! The rates value are now set to default.";

    save();
}

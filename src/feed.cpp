/*
 * Copyright 2020 Tobias Fella <fella@posteo.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include <QVariant>

#include "database.h"
#include "feed.h"
#include "fetcher.h"

Feed::Feed(int index)
    : QObject(nullptr)
{

    QSqlQuery query;
    query.prepare(QStringLiteral("SELECT * FROM Feeds LIMIT 1 OFFSET :index;"));
    query.bindValue(QStringLiteral(":index"), index);
    Database::instance().execute(query);
    if (!query.next())
        qWarning() << "Failed to load feed" << index;

    QSqlQuery authorQuery;
    authorQuery.prepare(QStringLiteral("SELECT * FROM Authors WHERE id='' AND feed=:feed"));
    authorQuery.bindValue(QStringLiteral(":feed"), query.value(QStringLiteral("url")).toString());
    Database::instance().execute(authorQuery);
    while (authorQuery.next()) {
        m_authors += new Author(authorQuery.value(QStringLiteral("name")).toString(), authorQuery.value(QStringLiteral("email")).toString(), authorQuery.value(QStringLiteral("uri")).toString(), nullptr);
    }

    m_subscribed.setSecsSinceEpoch(query.value(QStringLiteral("subscribed")).toInt());

    m_lastUpdated.setSecsSinceEpoch(query.value(QStringLiteral("lastUpdated")).toInt());

    m_url = query.value(QStringLiteral("url")).toString();
    m_name = query.value(QStringLiteral("name")).toString();
    m_image = query.value(QStringLiteral("image")).toString();
    m_link = query.value(QStringLiteral("link")).toString();
    m_description = query.value(QStringLiteral("description")).toString();
    m_deleteAfterCount = query.value(QStringLiteral("deleteAfterCount")).toInt();
    m_deleteAfterType = query.value(QStringLiteral("deleteAfterType")).toInt();
    m_autoUpdateCount = query.value(QStringLiteral("autoUpdateCount")).toInt();
    m_autoUpdateType = query.value(QStringLiteral("autoUpdateType")).toInt();
    m_notify = query.value(QStringLiteral("notify")).toBool();

    connect(&Fetcher::instance(), &Fetcher::startedFetchingFeed, this, [this](QString url) {
        if (url == m_url) {
            setRefreshing(true);
        }
    });
    connect(&Fetcher::instance(), &Fetcher::feedUpdated, this, [this](QString url) {
        if (url == m_url) {
            setRefreshing(false);
            Q_EMIT entryCountChanged();
            Q_EMIT unreadEntryCountChanged();
            setErrorId(0);
            setErrorString(QLatin1String(""));
        }
    });
    connect(&Fetcher::instance(), &Fetcher::error, this, [this](QString url, int errorId, QString errorString) {
        if(url == m_url) {
            setErrorId(errorId);
            setErrorString(errorString);
        }
    });
}

Feed::~Feed()
{
}

QString Feed::url() const
{
    return m_url;
}

QString Feed::name() const
{
    return m_name;
}

QString Feed::image() const
{
    return m_image;
}

QString Feed::link() const
{
    return m_link;
}

QString Feed::description() const
{
    return m_description;
}

QVector<Author *> Feed::authors() const
{
    return m_authors;
}

int Feed::deleteAfterCount() const
{
    return m_deleteAfterCount;
}

int Feed::deleteAfterType() const
{
    return m_deleteAfterType;
}

QDateTime Feed::subscribed() const
{
    return m_subscribed;
}

QDateTime Feed::lastUpdated() const
{
    return m_lastUpdated;
}

int Feed::autoUpdateCount() const
{
    return m_autoUpdateCount;
}

int Feed::autoUpdateType() const
{
    return m_autoUpdateType;
}

bool Feed::notify() const
{
    return m_notify;
}

int Feed::entryCount() const
{
    QSqlQuery query;
    query.prepare(QStringLiteral("SELECT COUNT (id) FROM Entries where feed=:feed;"));
    query.bindValue(QStringLiteral(":feed"), m_url);
    Database::instance().execute(query);
    if (!query.next())
        return -1;
    return query.value(0).toInt();
}

int Feed::unreadEntryCount() const
{
    QSqlQuery query;
    query.prepare(QStringLiteral("SELECT COUNT (id) FROM Entries where feed=:feed AND read=false;"));
    query.bindValue(QStringLiteral(":feed"), m_url);
    Database::instance().execute(query);
    if (!query.next())
        return -1;
    return query.value(0).toInt();
}

bool Feed::refreshing() const
{
    return m_refreshing;
}

int Feed::errorId() const
{
    return m_errorId;
}

QString Feed::errorString() const
{
    return m_errorString;
}

void Feed::setName(QString name)
{
    m_name = name;
    Q_EMIT nameChanged(m_name);
}

void Feed::setImage(QString image)
{
    m_image = image;
    Q_EMIT imageChanged(m_image);
}

void Feed::setLink(QString link)
{
    m_link = link;
    Q_EMIT linkChanged(m_link);
}

void Feed::setDescription(QString description)
{
    m_description = description;
    Q_EMIT descriptionChanged(m_description);
}

void Feed::setAuthors(QVector<Author *> authors)
{
    m_authors = authors;
    Q_EMIT authorsChanged(m_authors);
}

void Feed::setDeleteAfterCount(int count)
{
    m_deleteAfterCount = count;
    Q_EMIT deleteAfterCountChanged(m_deleteAfterCount);
}

void Feed::setDeleteAfterType(int type)
{
    m_deleteAfterType = type;
    Q_EMIT deleteAfterTypeChanged(m_deleteAfterType);
}

void Feed::setLastUpdated(QDateTime lastUpdated)
{
    m_lastUpdated = lastUpdated;
    Q_EMIT lastUpdatedChanged(m_lastUpdated);
}

void Feed::setAutoUpdateCount(int count)
{
    m_autoUpdateCount = count;
    Q_EMIT autoUpdateCountChanged(m_autoUpdateCount);
}

void Feed::setAutoUpdateType(int type)
{
    m_autoUpdateType = type;
    Q_EMIT autoUpdateTypeChanged(m_autoUpdateType);
}

void Feed::setNotify(bool notify)
{
    m_notify = notify;
    Q_EMIT notifyChanged(m_notify);
}

void Feed::setRefreshing(bool refreshing)
{
    m_refreshing = refreshing;
    Q_EMIT refreshingChanged(m_refreshing);
}

void Feed::setErrorId(int errorId)
{
    m_errorId = errorId;
    Q_EMIT errorIdChanged(m_errorId);
}

void Feed::setErrorString(QString errorString)
{
    m_errorString = errorString;
    Q_EMIT errorStringChanged(m_errorString);
}

void Feed::refresh()
{
    Fetcher::instance().fetch(m_url);
}

void Feed::remove()
{
    // Delete Authors
    QSqlQuery query;
    query.prepare(QStringLiteral("DELETE FROM Authors WHERE feed=:feed;"));
    query.bindValue(QStringLiteral(":feed"), m_url);
    Database::instance().execute(query);

    // Delete Entries
    query.prepare(QStringLiteral("DELETE FROM Entries WHERE feed=:feed;"));
    query.bindValue(QStringLiteral(":feed"), m_url);
    Database::instance().execute(query);

    // TODO Delete Enclosures

    // Delete Feed
    query.prepare(QStringLiteral("DELETE FROM Feeds WHERE url=:url;"));
    query.bindValue(QStringLiteral(":url"), m_url);
    Database::instance().execute(query);
}

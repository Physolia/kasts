/*
 * SPDX-FileCopyrightText: 2020 Tobias Fella <tobias.fella@kde.org>
 * SPDX-FileCopyrightText: 2021 Bart De Vries <bart@mogwai.be>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#pragma once

#include <QDateTime>
#include <QObject>
#include <QString>
#include <QVector>

#include "author.h"
#include "models/entriesproxymodel.h"

class Feed : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString url READ url CONSTANT)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(QString cachedImage READ cachedImage NOTIFY cachedImageChanged)
    Q_PROPERTY(QString link READ link WRITE setLink NOTIFY linkChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(QVector<Author *> authors READ authors WRITE setAuthors NOTIFY authorsChanged)
    Q_PROPERTY(bool refreshing READ refreshing WRITE setRefreshing NOTIFY refreshingChanged)
    Q_PROPERTY(int deleteAfterCount READ deleteAfterCount WRITE setDeleteAfterCount NOTIFY deleteAfterCountChanged)
    Q_PROPERTY(int deleteAfterType READ deleteAfterType WRITE setDeleteAfterType NOTIFY deleteAfterTypeChanged)
    Q_PROPERTY(QDateTime subscribed READ subscribed CONSTANT)
    Q_PROPERTY(QDateTime lastUpdated READ lastUpdated WRITE setLastUpdated NOTIFY lastUpdatedChanged)
    Q_PROPERTY(bool notify READ notify WRITE setNotify NOTIFY notifyChanged)
    Q_PROPERTY(QString dirname READ dirname WRITE setDirname NOTIFY dirnameChanged)
    Q_PROPERTY(int entryCount READ entryCount NOTIFY entryCountChanged)
    Q_PROPERTY(int unreadEntryCount READ unreadEntryCount WRITE setUnreadEntryCount NOTIFY unreadEntryCountChanged)
    Q_PROPERTY(int newEntryCount READ newEntryCount NOTIFY newEntryCountChanged)
    Q_PROPERTY(int favoriteEntryCount READ favoriteEntryCount NOTIFY favoriteEntryCountChanged)
    Q_PROPERTY(int errorId READ errorId WRITE setErrorId NOTIFY errorIdChanged)
    Q_PROPERTY(QString errorString READ errorString WRITE setErrorString NOTIFY errorStringChanged)
    Q_PROPERTY(EntriesProxyModel *entries MEMBER m_entries CONSTANT)

public:
    Feed(const QString &feedurl);

    ~Feed();

    void updateAuthors();

    QString url() const;
    QString name() const;
    QString image() const;
    QString cachedImage() const;
    QString link() const;
    QString description() const;
    QVector<Author *> authors() const;
    int deleteAfterCount() const;
    int deleteAfterType() const;
    QDateTime subscribed() const;
    QDateTime lastUpdated() const;
    bool notify() const;
    QString dirname() const;
    int entryCount() const;
    int unreadEntryCount() const;
    int newEntryCount() const;
    int favoriteEntryCount() const;
    bool read() const;
    int errorId() const;
    QString errorString() const;

    bool refreshing() const;

    void setName(const QString &name);
    void setImage(const QString &image);
    void setLink(const QString &link);
    void setDescription(const QString &description);
    void setAuthors(const QVector<Author *> &authors);
    void setDeleteAfterCount(int count);
    void setDeleteAfterType(int type);
    void setLastUpdated(const QDateTime &lastUpdated);
    void setNotify(bool notify);
    void setDirname(const QString &dirname);
    void setUnreadEntryCount(const int count);
    void setRefreshing(bool refreshing);
    void setErrorId(int errorId);
    void setErrorString(const QString &errorString);

    Q_INVOKABLE void refresh();

Q_SIGNALS:
    void nameChanged(const QString &name);
    void imageChanged(const QString &image);
    void cachedImageChanged(const QString &imagePath);
    void linkChanged(const QString &link);
    void descriptionChanged(const QString &description);
    void authorsChanged(const QVector<Author *> &authors);
    void deleteAfterCountChanged(int count);
    void deleteAfterTypeChanged(int type);
    void lastUpdatedChanged(const QDateTime &lastUpdated);
    void notifyChanged(bool notify);
    void dirnameChanged(const QString &dirname);
    void entryCountChanged();
    void unreadEntryCountChanged();
    void newEntryCountChanged();
    void favoriteEntryCountChanged();
    void errorIdChanged(int &errorId);
    void errorStringChanged(const QString &errorString);

    void refreshingChanged(bool refreshing);

private:
    void updateUnreadEntryCountFromDB();
    void updateNewEntryCountFromDB();
    void updateFavoriteEntryCountFromDB();

    QString m_url;
    QString m_name;
    QString m_image;
    QString m_link;
    QString m_description;
    QVector<Author *> m_authors;
    int m_deleteAfterCount;
    int m_deleteAfterType;
    QDateTime m_subscribed;
    QDateTime m_lastUpdated;
    bool m_notify;
    QString m_dirname;
    int m_errorId;
    QString m_errorString;
    int m_unreadEntryCount = -1;
    int m_newEntryCount = -1;
    int m_favoriteEntryCount = -1;

    EntriesProxyModel *m_entries;

    bool m_refreshing = false;
};

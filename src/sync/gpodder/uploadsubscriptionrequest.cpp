/**
 * SPDX-FileCopyrightText: 2021 Bart De Vries <bart@mogwai.be>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "uploadsubscriptionrequest.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <QPair>
#include <QString>
#include <QUrl>
#include <QVector>

#include "synclogging.h"

UploadSubscriptionRequest::UploadSubscriptionRequest(SyncUtils::Provider provider, QNetworkReply *reply, QObject *parent)
    : GenericRequest(provider, reply, parent)
{
}

QVector<QPair<QString, QString>> UploadSubscriptionRequest::updateUrls() const
{
    return m_updateUrls;
}

qulonglong UploadSubscriptionRequest::timestamp() const
{
    return m_timestamp;
}

void UploadSubscriptionRequest::processResults()
{
    if (m_reply->error()) {
        m_error = m_reply->error();
        m_errorString = m_reply->errorString();
        qCDebug(kastsSync) << "m_reply error" << m_reply->errorString();
    } else if (!m_abort) {
        QJsonParseError *error = nullptr;
        QJsonDocument data = QJsonDocument::fromJson(m_reply->readAll(), error);
        if (error) {
            qCDebug(kastsSync) << "parse error" << error->errorString();
            m_error = 1;
            m_errorString = error->errorString();
        } else {
            for (auto jsonFeed : data.object().value(QStringLiteral("update_urls")).toArray()) {
                m_updateUrls += QPair(jsonFeed.toArray().at(0).toString(), jsonFeed.toArray().at(1).toString());
            }
            m_timestamp = data.object().value(QStringLiteral("timestamp")).toInt();
        }
    }
    Q_EMIT finished();
    m_reply->deleteLater();
    deleteLater();
}

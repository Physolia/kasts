// SPDX-FileCopyrightText: 2021 Tobias Fella <fella@posteo.de>
// SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

#include "imageprovider.h"

#include <QQuickTextureFactory>

#include "fetcher.h"
#include "storagemanager.h"

QQuickImageResponse *ImageProvider::requestImageResponse(const QString &id, const QSize &requestedSize)
{
    return new CacheResponse(id, requestedSize);
}

CacheResponse::CacheResponse(const QString &url, const QSize &size)
    : m_url(url)
    , m_size(size)
{
    moveToThread(Fetcher::instance().thread());
    QMetaObject::invokeMethod(this, &CacheResponse::execute, Qt::QueuedConnection);
}

void CacheResponse::execute()
{
    const auto result = Fetcher::instance().image(m_url);
    if (result == QLatin1String("no-image")) {
        Q_EMIT finished();
    } else if (result == QLatin1String("fetching")) {
        connect(&Fetcher::instance(), &Fetcher::downloadFinished, this, [=](QString url) {
            if (m_url == url) {
                m_path = StorageManager::instance().imagePath(url);
                Q_EMIT finished();
            }
        });
    } else {
        m_path = StorageManager::instance().imagePath(m_url);
        Q_EMIT finished();
    }
}

QQuickTextureFactory *CacheResponse::textureFactory() const
{
    QImage image(m_path);
    return QQuickTextureFactory::textureFactoryForImage(image.scaled(m_size, Qt::KeepAspectRatio, Qt::SmoothTransformation));
}

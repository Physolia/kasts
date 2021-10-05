// SPDX-FileCopyrightText: 2021 Tobias Fella <fella@posteo.de>
// SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

#pragma once

#include <QQuickAsyncImageProvider>
#include <QQuickImageResponse>
#include <QSize>
#include <QString>

class QQuickTextureFactory;

class ImageProvider : public QQuickAsyncImageProvider
{
public:
    QQuickImageResponse *requestImageResponse(const QString &id, const QSize &requestedSize) override;
};

class CacheResponse : public QQuickImageResponse
{
public:
    CacheResponse(const QString &url, const QSize &size);
    QQuickTextureFactory *textureFactory() const override;

private:
    void execute();
    QString m_url;
    QString m_path;
    QSize m_size;
};

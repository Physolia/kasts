/**
 * SPDX-FileCopyrightText: 2021 Bart De Vries <bart@mogwai.be>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#pragma once

#include <QNetworkReply>
#include <QObject>

#include "sync/gpodder/genericrequest.h"
#include "sync/syncutils.h"

class UpdateDeviceRequest : public GenericRequest
{
    Q_OBJECT

public:
    UpdateDeviceRequest(SyncUtils::Provider provider, QNetworkReply *reply, QObject *parent);

    bool success() const;

private:
    void processResults() override;

    bool m_success = false;
};

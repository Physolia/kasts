/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.14
import QtQuick.Controls 2.14 as Controls
import QtQuick.Layouts 1.14

import org.kde.kirigami 2.14 as Kirigami

import org.kde.kasts 1.0

Kirigami.OverlaySheet {
    id: addSheet
    parent: applicationWindow().overlay
    showCloseButton: true

    header: Kirigami.Heading {
        text: i18n("Add New Podcast")
    }

    contentItem: ColumnLayout {
        Controls.Label {
            text: i18n("Url:")
        }
        Controls.TextField {
            id: urlField
            Layout.fillWidth: true
            text: "https://"
        }
    }

    footer: Controls.Button {
        text: i18n("Add Podcast")
        enabled: urlField.text
        onClicked: {
            DataManager.addFeed(urlField.text)
            addSheet.close()
        }
    }
}

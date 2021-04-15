/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.14
import QtQuick.Controls 2.14 as Controls
import QtQuick.Layouts 1.14

import QtMultimedia 5.15

import org.kde.kirigami 2.12 as Kirigami

import org.kde.alligator 1.0

Kirigami.ScrollablePage {
    id: page

    property QtObject entry

    title: entry.title


    Controls.Label {
        width: page.width - 30
        id: text
        text: page.entry.content
        baseUrl: page.entry.baseUrl
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
        Layout.fillHeight: true
        onLinkActivated: Qt.openUrlExternally(link)
        //onWidthChanged: { text = entry.adjustedContent(width, font.pixelSize) }
    }
    actions.main: Kirigami.Action {
        text: !entry.enclosure ? i18n("Open in Browser") :
            entry.enclosure.status === Enclosure.Downloadable ? i18n("Download") :
            entry.enclosure.status === Enclosure.Downloading ? i18n("Cancel download") :
            i18n("Delete downloaded file")
        icon.name: !entry.enclosure ? "globe" :
            entry.enclosure.status === Enclosure.Downloadable ? "download" :
            entry.enclosure.status === Enclosure.Downloading ? "edit-delete-remove" :
            "delete"
        onTriggered: {
            if(!entry.enclosure) Qt.openUrlExternally(entry.link)
            else if(entry.enclosure.status === Enclosure.Downloadable) entry.enclosure.download()
            else if(entry.enclosure.status === Enclosure.Downloading) entry.enclosure.cancelDownload()
            else entry.enclosure.deleteFile()
        }
    }
    actions.left: Kirigami.Action {
        text: "Add to queue"
        icon.name: "media-playlist-append"
        visible: entry.enclosure && !entry.queueStatus
        onTriggered: { DataManager.addtoQueue(entry.feed.url, entry.id) }
    }
}

/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.14
import QtQuick.Controls 2.14 as Controls
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.15

import org.kde.kirigami 2.12 as Kirigami

import org.kde.kasts 1.0

Kirigami.ScrollablePage {
    id: page

    property QtObject feed;
    property bool isSubscribed: true

    property string author: isSubscribed ? (page.feed.authors.length === 0 ? "" : page.feed.authors[0].name) : feed.author
    title: i18n("Podcast Details")

    header: GenericHeader {
        id: headerImage

        image: isSubscribed ? feed.cachedImage : feed.image
        title: isSubscribed ? feed.name : feed.title
        subtitle: author !== "" ? i18nc("by <Author(s)>", "by %1", author) : ""
        Controls.Button {
            text: enabled ? i18n("Subscribe") : i18n("Subscribed")
            icon.name: "kt-add-feeds"
            visible: !isSubscribed
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: Kirigami.Units.largeSpacing
            anchors.topMargin: Kirigami.Units.largeSpacing
            onClicked: {
                DataManager.addFeed(feed.url)
            }
            enabled: !DataManager.isFeedExists(feed.url)
        }
    }

    ColumnLayout {
        TextEdit {
            readOnly: true
            selectByMouse: true
            textFormat:TextEdit.RichText
            text: feed.description
            font.pointSize: Math.round(Kirigami.Theme.defaultFont.pointSize * 1.2)
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
        TextEdit {
            readOnly: true
            selectByMouse: true
            textFormat:TextEdit.RichText
            text: i18nc("by <Author(s)>", "by %1", author)
            visible: author !== ""
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
        TextEdit {
            readOnly: true
            selectByMouse: true
            textFormat:TextEdit.RichText
            text: i18n("Podcast URL") + ": <a href='%1'>%1</a>".arg(feed.url)
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
        TextEdit {
            readOnly: true
            selectByMouse: true
            textFormat:TextEdit.RichText
            text: i18n("Weblink") + ": <a href='%1'>%1</a>".arg(feed.link)
            onLinkActivated: Qt.openUrlExternally(link)
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
        TextEdit {
            readOnly: true
            selectByMouse: true
            textFormat:TextEdit.RichText
            text: isSubscribed ? i18n("Subscribed since: %1", feed.subscribed.toLocaleString(Qt.locale(), Locale.ShortFormat)) : ""
            visible: isSubscribed
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
        TextEdit {
            readOnly: true
            selectByMouse: true
            textFormat:TextEdit.RichText
            text: isSubscribed ? i18n("Last Updated: %1", feed.lastUpdated.toLocaleString(Qt.locale(), Locale.ShortFormat)) : ""
            visible: isSubscribed
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
        TextEdit {
            readOnly: true
            selectByMouse: true
            textFormat:TextEdit.RichText
            text: i18np("1 Episode", "%1 Episodes", feed.entryCount) + ", " + i18np("1 Unplayed", "%1 Unplayed", feed.unreadEntryCount)
            visible: isSubscribed
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}

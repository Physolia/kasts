/**
 * SPDX-FileCopyrightText: 2021 Swapnil Tripathi <swapnil06.st@gmail.com>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.14
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.14
import QtQuick.XmlListModel 2.15

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kasts 1.0

Kirigami.ScrollablePage {
    title: i18n("Search")
    property string searchText: "https://gpodder.net/search.opml?q="
    property string feedUrl: ""
    property string name: ""
    onFeedUrlChanged: {
        xmlFeedModel.source = feedUrl
        console.log("Feed URL changed")
    }
    header: RowLayout {
        width: parent.width
        Kirigami.SearchField {
            id: textField
            placeholderText: i18n("What's on your mind?")
            Layout.fillWidth: true
            Layout.leftMargin: Kirigami.Units.smallSpacing
            onAccepted: searchButton.clicked()
        }
        Controls.Button {
            id: searchButton
            text: isWidescreen ? i18n("Search") : ""
            icon.name: "search"
            Layout.rightMargin: Kirigami.Units.smallSpacing
            onClicked: xmlSearchModel.source = searchText + textField.text
        }
    }
    Component.onCompleted: {
        textField.forceActiveFocus();
    }
    XmlListModel {
        id: xmlSearchModel
        source: searchText !== "" ? "https://gpodder.net/search.opml?q=" + searchText : ""
        query: "/opml/body/outline"

        XmlRole { name: "xmlUrl"; query: "@xmlUrl/string()";isKey: true }
        XmlRole { name: "description"; query: "@description/string()" }
        XmlRole { name: "htmlUrl"; query: "@htmlUrl/string()" }
        XmlRole { name: "type"; query: "@type/string()" }
        XmlRole { name: "title"; query: "@title/string()" }
        XmlRole { name: "text"; query: "@text/string()" }
    }
    XmlListModel {
        id: xmlFeedModel
        source: ""
        query: "/rss/channel"
        namespaceDeclarations: "declare namespace itunes='http://www.itunes.com/dtds/podcast-1.0.dtd';"

        XmlRole { name: "description"; query: "description/string()" }
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "link"; query: "link/string()" }
        XmlRole { name: "imageUrl"; query: "image/url/string()" }
        XmlRole { name: "subtitle"; query: "itunes:subtitle/string()" }
        XmlRole { name: "author"; query: "itunes:author/string()" }
        XmlRole { name: "keywords"; query: "itunes:keywords/string()" }
        XmlRole { name: "ownername"; query: "itunes:owner/itunes:name/string()" }
        XmlRole { name: "owneremail"; query: "itunes:owner/itunes:email/string()" }
    }
    XmlListModel {
        id: xmlTitleModel
        source: ""
        query: "/rss/channel/item"

        XmlRole { name: "title"; query: "title/string()" }
    }
    Component {
        id: delegateComponent
        Kirigami.SwipeListItem {
            id: listItem
            contentItem: RowLayout {
                Controls.Label {
                    Layout.fillWidth: true
                    height: Math.max(implicitHeight, Kirigami.Units.iconSizes.smallMedium)
                    text: title
                    color: listItem.checked || (listItem.pressed && !listItem.checked && !listItem.sectionDelegate) ? listItem.activeTextColor : listItem.textColor
                }
            }
            onClicked: {
                xmlFeedModel.source = xmlUrl
                feedUrl = xmlUrl
                xmlTitleModel.source = xmlUrl
                previewDrawer.open()
            }
        }
    }
    ListView {
        anchors.fill: parent
        model: xmlSearchModel
        spacing: 5
        clip: true
        delegate: Kirigami.DelegateRecycler {
            width: parent ? parent.width : implicitWidth
            sourceComponent: delegateComponent
        }
    }
}

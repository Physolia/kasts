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
    id: page
    title: i18n("Discover")
    actions.main: Kirigami.Action {
        iconName: "search"
        text: i18n("Search")
        onTriggered: pageStack.push("qrc:/SearchPage.qml")
    }
    ListModel {
        id: categoryModel
        ListElement {
            categoryTitle: "Technology"
            categoryUrl: "https://gpodder.net/search.opml?q=technology"
        }
        ListElement {
            categoryTitle: "Science"
            categoryUrl: "https://gpodder.net/search.opml?q=science"
        }
        ListElement {
            categoryTitle: "Politics"
            categoryUrl: "https://gpodder.net/search.opml?q=politics"
        }
        ListElement {
            categoryTitle: "Educational"
            categoryUrl: "https://gpodder.net/search.opml?q=educational"
        }
        ListElement {
            categoryTitle: "Stories"
            categoryUrl: "https://gpodder.net/search.opml?q=stories"
        }
        ListElement {
            categoryTitle: "Sports"
            categoryUrl: "https://gpodder.net/search.opml?q=sports"
        }
        ListElement {
            categoryTitle: "Health"
            categoryUrl: "https://gpodder.net/search.opml?q=health"
        }
        ListElement {
            categoryTitle: "Games"
            categoryUrl: "https://gpodder.net/search.opml?q=games"
        }
        ListElement {
            categoryTitle: "Comedy"
            categoryUrl: "https://gpodder.net/search.opml?q=comedy"
        }
        ListElement {
            categoryTitle: "Family"
            categoryUrl: "https://gpodder.net/search.opml?q=family"
        }
        ListElement {
            categoryTitle: "Arts"
            categoryUrl: "https://gpodder.net/search.opml?q=arts"
        }
    }
    XmlListModel {
        id: xmlSearchModel
        source: categoryUrl
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
        }
    }
    ListView {
        id: mainList
        model: categoryModel
        delegate: ColumnLayout {
            width: parent.width
            Kirigami.Heading {
                Layout.fillWidth: true
                Layout.topMargin: Kirigami.Units.gridUnit
                Layout.leftMargin: Kirigami.Units.gridUnit
                text: categoryTitle
            }
        }
    }
}

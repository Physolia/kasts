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
    property string searchText: "https://gpodder.net/search.opml?q="

    //Looking to create a more fancier search bar but for now its bare minimum to test the functionality.
    header: RowLayout {
        width: parent.width
        Controls.TextField {
            id: textField
            placeholderText: "Enter Search"
            Layout.fillWidth: true
            Layout.leftMargin: Kirigami.Units.smallSpacing
            focus: true
        }
        Controls.Button {
            text: "Search"
            Layout.rightMargin: Kirigami.Units.smallSpacing
            onClicked: xmlSearchModel.source = searchText + textField.text
        }
    }

    //Model for the search query. I decided to go with the XmlListModel as it is easier to implement and it seemed ideal for a read-only model that we require for this page.
    XmlListModel {
        id: xmlSearchModel
        source: searchText
        query: "/opml/body/outline"

        XmlRole { name: "xmlUrl"; query: "@xmlUrl/string()" }
        XmlRole { name: "description"; query: "@description/string()" }
        XmlRole { name: "htmlUrl"; query: "@htmlUrl/string()" }
        XmlRole { name: "type"; query: "@type/string()" }
        XmlRole { name: "title"; query: "@title/string()"; isKey: true }
        XmlRole { name: "text"; query: "@text/string()" }
    }
    //Model to populate the OverlayDrawer which would allow to preview the feed. Currently this logic seems pretty broken so I am not sure how that would work.
    XmlListModel {
        id: xmlFeedModel
        source: ""
        query: "/rss/channel"

        XmlRole { name: "description"; query: "description/string()" }
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "link"; query: "link/string()" }
        XmlRole { name: "url"; query: "image/url/string()" }
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
                console.log(xmlFeedModel.get(0).url) //unfinished
            }
        }
    }
    //The opml does not come with an icon entry hence I am forced to use a ListView and I know it looks pretty bland when you only display the texts and no pics :(
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
    Kirigami.OverlayDrawer {
        id: feedInfoDrawer
        edge: Qt.BottomEdge
        contentItem: ColumnLayout {
            anchors.fill: parent
            //TODO: Allows the user to preview the feed, will contain important feed details fetched from the "xmlFeedModel" and might use a listview to display the entries, a latter addon would be to add a "subscribe" button that would add the current list to the subscriptions list. Now this would be an bottom OverlayDrawer for the mobile app and OverlaySheet for the desktop app but this is open for discussion as there is already the mediaFooter. (not so sure with the scope of the XmlListModel). I can provide mockups.
        }
    }
}

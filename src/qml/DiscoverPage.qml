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
    property string feedUrl: ""
    property string name: ""
    onFeedUrlChanged: {
        xmlFeedModel.source = feedUrl
        console.log("Feed URL changed")
    }
    Component.onCompleted: {
        textField.forceActiveFocus();
    }

    //Looking to create a more fancier search bar but for now its bare minimum to test the functionality.
    header: RowLayout {
        width: parent.width
        Controls.TextField {
            id: textField
            placeholderText: "What's on your mind?"
            Layout.fillWidth: true
            Layout.leftMargin: Kirigami.Units.smallSpacing
            Keys.onReturnPressed: {
                searchButton.clicked()
            }
        }
        Controls.Button {
            id: searchButton
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

        XmlRole { name: "xmlUrl"; query: "@xmlUrl/string()";isKey: true }
        XmlRole { name: "description"; query: "@description/string()" }
        XmlRole { name: "htmlUrl"; query: "@htmlUrl/string()" }
        XmlRole { name: "type"; query: "@type/string()" }
        XmlRole { name: "title"; query: "@title/string()" }
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
        XmlRole { name: "imageUrl"; query: "image/url/string()" }
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
                previewDrawer.open()
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
        id: previewDrawer
        edge: Qt.BottomEdge
        height: 600
        parent: page
        Column {
            width: parent.width
            spacing: 10
            visible: xmlFeedModel.status == 1
            GenericHeader {
                id: previewHeader
                width: parent.width
                image: (xmlFeedModel.status == 1) ? xmlFeedModel.get(0).imageUrl : ""
                title: (xmlFeedModel.status == 1) ? xmlFeedModel.get(0).title : "No Title"
                subtitle: (xmlFeedModel.status == 1) ? xmlFeedModel.get(0).title : "No Title"
                Controls.Button {
                    text: enabled ? "Subscribe" : "Subscribed"
                    icon.name: "kt-add-feeds"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: Kirigami.Units.largeSpacing * 2
                    anchors.topMargin: Kirigami.Units.largeSpacing * 2
                    onClicked: {
                        DataManager.addFeed(feedUrl)
                    }
                    enabled: !DataManager.isFeedExists(feedUrl)
                }
            }
            Controls.Label {
                id: previewLabel
                Layout.margins: Kirigami.Units.gridUnit
                text: (xmlFeedModel.status == 1) ? xmlFeedModel.get(0).description : "No Description"
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                width: parent.width
                onLinkActivated: Qt.openUrlExternally(link)
                font.pointSize: SettingsManager && !(SettingsManager.articleFontUseSystem) ? SettingsManager.articleFontSize : Kirigami.Units.fontMetrics.font.pointSize
            }
        }
    }
}

/**
 * SPDX-FileCopyrightText: 2021 Bart De Vries <bart@mogwai.be>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.14 as Controls
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.15

import org.kde.kirigami 2.15 as Kirigami

import org.kde.kasts 1.0

Item {
    id: root
    property string imageSource: ""
    property real imageOpacity: 1
    property int absoluteRadius: 0
    property real fractionalRadius: 0.0
    property string imageTitle: ""
    property bool isLoading: false
    property int imageFillMode: Image.PreserveAspectCrop

    opacity: root.imageOpacity
    layer.enabled: (root.absoluteRadius > 0 || root.fractionalRadius > 0)
    layer.effect: OpacityMask {
        maskSource: Item {
            width: root.width
            height: root.height
            Rectangle {
                anchors.centerIn: parent
                width: root.adapt ? root.width : Math.min(root.width, root.height)
                height: root.adapt ? root.height : width
                radius: (absoluteRadius > 0) ? absoluteRadius : ( (fractionalRadius > 0) ? Math.min(width, height)*fractionalRadius : 0 )
            }
        }
    }

    Image {
        id: realImg
        anchors.fill: parent
        source: "image://img/" + root.imageSource
        fillMode: root.imageFillMode
        sourceSize.width: width
        sourceSize.height: height
        asynchronous: true
    }

    Item {
        id: fallbackImg
        visible: realImg.implicitWidth === 0 && realImg.implicitHeight === 0 && !realImg.status === Image.Loading
        anchors.fill: parent
        // Add white background color in order to use coloroverlay later on
        Rectangle {
            anchors.fill: parent
            color: "white"
        }
        Kirigami.Icon {
            anchors.fill: parent
            source: "rss"
            isMask: true
            color: "black"
        }
    }

    Component {
        id: imageText
        Item {
            Rectangle {
                anchors.fill: header
                opacity: 0.5
                color: "black"
            }

            Kirigami.Heading {
                id: header
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                padding: 10
                text: root.imageTitle
                level: 3
                font.bold: true
                color: "white"
                wrapMode: Text.Wrap
                elide: Text.ElideRight
            }
        }
    }

    Loader {
        anchors.fill: parent
        active: root.imageTitle !== "" && (SettingsManager.alwaysShowFeedTitles || fallbackImg.visible)
        sourceComponent: imageText
    }

    Item {
        id: loaderSymbol
        visible: realImg.status === Image.Loading || root.isLoading
        anchors.fill: parent
        Rectangle {
            color: "white"
            opacity: 0.5
            anchors.fill: parent
        }
        Controls.BusyIndicator {
            anchors.centerIn: parent
            width: parent.width / 2
            height: parent.height / 2
        }
    }
}

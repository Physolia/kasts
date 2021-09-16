/**
 * SPDX-FileCopyrightText: 2021 Bart De Vries <bart@mogwai.be>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.14
import QtQuick.Controls 2.14 as Controls
import QtQuick.Layouts 1.14
import QtMultimedia 5.15
import QtGraphicalEffects 1.0

import org.kde.kirigami 2.12 as Kirigami

import org.kde.kasts 1.0

Item {
    property int miniplayerheight: Math.round(Kirigami.Units.gridUnit * 3.5)
    property int progressbarheight: Kirigami.Units.gridUnit / 6
    property int buttonsize: Kirigami.Units.gridUnit * 2
    height: miniplayerheight + progressbarheight

    visible: AudioManager.entry

    Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
    Kirigami.Theme.inherit: false

    // Set background
    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.backgroundColor
    }

    Image {
        source: AudioManager.entry.cachedImage
        asynchronous: true

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        // make the FastBlur effect more strong
        //sourceSize.height: 10
        layer.enabled: true
        layer.effect: HueSaturation {
            cached: true

            lightness: -0.5
            saturation: 0.9

            layer.enabled: true
            layer.effect: FastBlur {
                cached: true
                radius: 64
                transparentBorder: false
            }
        }
    }

    // progress bar for limited width (phones)
    Rectangle {
        id: miniprogressbar
        z: 1
        anchors.top: parent.top
        anchors.left: parent.left
        height: parent.progressbarheight
        color: Kirigami.Theme.highlightColor
        width: parent.width * AudioManager.position / AudioManager.duration
        visible: true
    }

    RowLayout {
        id: footerrowlayout
        anchors.fill: parent
        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true

            // press feedback
            color: (trackClick.pressed || trackClick.containsMouse) ? Qt.rgba(0, 0, 0, 0.2) : "transparent"

            RowLayout {
                anchors.fill: parent

                ImageWithFallback {
                    imageSource: AudioManager.entry.cachedImage
                    Layout.fillHeight: true
                    Layout.preferredWidth: height
                }

                // track information
                ColumnLayout {
                    Layout.maximumHeight: parent.height
                    Layout.fillWidth: true
                    Layout.leftMargin: Kirigami.Units.smallSpacing
                    spacing: Kirigami.Units.smallSpacing

                    Controls.Label {
                        id: mainLabel
                        text: AudioManager.entry.title
                        wrapMode: Text.Wrap
                        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1
                    }

                    Controls.Label {
                        id: feedLabel
                        text: AudioManager.entry.feed.name
                        wrapMode: Text.Wrap
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        opacity: 0.6
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1
                    }
                }
            }
            MouseArea {
                id: trackClick
                anchors.fill: parent
                hoverEnabled: true
                onClicked: toOpen.restart()
            }
        }
        Controls.Button {
            id: playButton
            icon.name: AudioManager.playbackState === Audio.PlayingState ? "media-playback-pause" : "media-playback-start"
            icon.height: parent.parent.buttonsize
            icon.width: parent.parent.buttonsize
            icon.color: "white"
            flat: true
            Layout.preferredHeight: parent.parent.miniplayerheight - Kirigami.Units.smallSpacing * 2
            Layout.preferredWidth: height
            onClicked: AudioManager.playbackState === Audio.PlayingState ? AudioManager.pause() : AudioManager.play()
            Layout.alignment: Qt.AlignVCenter
            Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
            Kirigami.Theme.inherit: false
        }
    }
}


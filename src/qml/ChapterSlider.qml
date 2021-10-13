// SPDX-FileCopyrightText: 2021 Tobias Fella <fella@posteo.de>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.7
import QtQuick.Controls 2.3

import org.kde.kasts 1.0

Control {
    id: chapterSlider
    property alias model: chapters.model
    required property int duration

    property int value: 0

    function setPlaybackPosition(x) {
        AudioManager.position = (x-handle.width/2) / (chapterSlider.width - handle.width) * duration
    }

    MouseArea {
        anchors.fill: parent
        onReleased: setPlaybackPosition(mouseX)
    }

    Repeater {
        id: chapters
        delegate: Rectangle {
            x: model.start * 1000 / chapterSlider.duration * (chapterSlider.width - chapterSlider.model.size - handle.width / 2) + index + handle.width / 2
            height: 6
            anchors.verticalCenter: parent.verticalCenter
            width: model.duration * 1000 / chapterSlider.duration * (chapterSlider.width - chapterSlider.model.size - handle.width / 2)
            radius: height / 2
            y: 7
            z: 1
            color: x < handle.x + handle.width / 2 && x + width > handle.x + handle.width / 2 ? "gray" : "lightgray"
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                z: 0
                ToolTip {
                    text: model.title
                    visible: parent.containsMouse
                }
                onReleased: setPlaybackPosition(mouseX + parent.x)
            }
        }
    }

    Rectangle {
        color: "lightgray"
        visible: chapterSlider.model.size === 0
        width: parent.width
        height: 6
        radius: height / 2
        anchors.centerIn: parent
    }

    Rectangle {
        id: handle
        width: parent.height
        height: parent.height
        radius: width / 2
        anchors.verticalCenter: chapterSlider.verticalCenter
        border.width: 1
        border.color: "gray"
        x: dragArea.drag.active ? 0 : chapterSlider.value / chapterSlider.duration * (chapterSlider.width - handle.width)
        z: 2
        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag {
                target: handle
                axis: Drag.XAxis
                minimumX: 0
                maximumX: chapterSlider.width - handle.width
                threshold: 0
            }
            onReleased: setPlaybackPosition(handle.x + handle.width / 2)
        }
    }
}

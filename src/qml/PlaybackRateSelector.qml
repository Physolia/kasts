/**
 * SPDX-FileCopyrightText: 2021 Swapnil Tripathi <swapnil06.st@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-only
 */

import QtQuick 2.14
import QtQuick.Controls 2.14 as Controls
import QtQuick.Layouts 1.14

import org.kde.kirigami 2.14 as Kirigami
import org.kde.kasts 1.0

Loader {
    sourceComponent: component

    function open() {
        item.open();
    }

    function round(x) {
        return (Math.ceil(x * 20 - 0.5) / 20).toFixed(2)
    }

    Component {
        id: component
        Kirigami.OverlaySheet {
            id: listViewSheet
            header: Kirigami.Heading {
                text: i18n("Select Playback Rates")
                level: 2
            }
            footer: RowLayout {
                Item { Layout.fillWidth: true }
                Controls.Button {
                    icon.name: "edit-reset"
                    text: i18n("Reset to Default")
                    onClicked: PlaybackRateModel.resetToDefault()
                }
            }
            contentItem: ColumnLayout {
                Layout.preferredWidth:  Kirigami.Units.gridUnit * 15
                Row {
                    Controls.Slider {
                        id: slider
                        from: 25
                        value: 100
                        to: 400
                        snapMode: Controls.Slider.SnapAlways
                        stepSize: 5
                    }
                    Kirigami.ActionTextField {
                        id: textField
                        text: round(slider.value) / 100
                        width: Kirigami.Units.gridUnit * 4
                        validator: DoubleValidator {
                            bottom: 0.25
                            top: 4.0
                            decimals: 2
                        }
                        rightActions: [
                            Kirigami.Action {
                                icon.name: "list-add"
                                visible: textField.acceptableInput
                                onTriggered: {
                                    PlaybackRateModel.insertPlaybackRate(slider.value);
                                }
                            }
                        ]
                        onEditingFinished: slider.value = 100 * round(textField.text)
                    }
                }
                Flow {
                    spacing: Kirigami.Units.smallSpacing
                    Layout.fillWidth: true

                    Repeater {
                        id: repeater
                        model: PlaybackRateModel

                        Controls.Button {
                            text: rate.playbackRate
                        }
                    }
                }
            }
        }
    }
}

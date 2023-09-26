/**
 * SPDX-FileCopyrightText: 2021 Bart De Vries <bart@mogwai.be>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.delegates as Delegates

import org.kde.kasts

Kirigami.Dialog {
    id: overlay
    parent: applicationWindow().overlay
    closePolicy: Kirigami.Dialog.CloseOnEscape | Kirigami.Dialog.CloseOnPressOutside

    property string headingText: i18n("Podcast updates are currently not allowed on metered connections")
    property bool condition: NetworkConnectionManager.feedUpdatesAllowed

    // Function to be overloaded where this is instantiated with another purpose
    // than refreshing all feeds
    function action() {
        Fetcher.fetchAll();
    }

    // This function will be executed when "Don't allow" is chosen; can be overloaded
    function abortAction() { }

    // This function will be executed when the "Allow once" action is chosen; can be overloaded
    function allowOnceAction() {
        action()
    }

    // This function will be executed when the "Always allow" action is chosed; can be overloaded
    function alwaysAllowAction() {
        SettingsManager.allowMeteredFeedUpdates = true;
        SettingsManager.save();
        action()
    }

    // this is the function that should be called if the action should be
    // triggered conditionally (on the basis that the condition is passed)
    function run() {
        if (condition) {
            action();
        } else {
            overlay.open();
        }
    }

    title: i18n("Select Option")

    ColumnLayout {
        spacing: 0

        Controls.Label {
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.bottomMargin: Kirigami.Units.largeSpacing
            Layout.leftMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
            Layout.rightMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
            Layout.fillWidth: true
            text: headingText
            wrapMode: Text.Wrap
            color: Kirigami.Theme.disabledTextColor
        }

        Kirigami.Separator {
            Layout.fillWidth: true
            opacity: 0.5
        }

        Delegates.RoundedItemDelegate {
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 2
            leftPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
            rightPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing

            text: i18n("Don't Allow")
            onClicked: {
                abortAction();
                close();
            }
        }

        Delegates.RoundedItemDelegate {
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 2
            leftPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
            rightPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing

            text: i18n("Allow Once")
            onClicked: {
                allowOnceAction();
                close();
            }
        }

        Delegates.RoundedItemDelegate {
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 2
            leftPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
            rightPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing

            text: i18n("Always Allow")
            onClicked: {
                alwaysAllowAction();
                close();
            }
        }
    }
}

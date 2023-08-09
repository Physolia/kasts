/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <tobias.fella@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.18 as Kirigami
import org.kde.kirigamiaddons.settings 1.0 as KirigamiSettings

KirigamiSettings.CategorizedSettings {
    actions: [
        KirigamiSettings.SettingAction {
            text: i18n("General")
            actionName: "General"
            icon.name: ":/logo.svg"
            page: "qrc:/GeneralSettingsPage.qml"
        },
        KirigamiSettings.SettingAction {
            text: i18n("Storage")
            actionName: "Storage"
            icon.name: "drive-harddisk-symbolic"
            page: "qrc:/StorageSettingsPage.qml"
        },
        KirigamiSettings.SettingAction {
            text: i18n("Network")
            actionName: "Network"
            icon.name: "network-connect"
            page: "qrc:/NetworkSettingsPage.qml"
        },
        KirigamiSettings.SettingAction {
            text: i18n("Synchronization")
            actionName: "Synchronization"
            icon.name: "state-sync"
            page: "qrc:/SynchronizationSettingsPage.qml"
        },
        KirigamiSettings.SettingAction {
            text: i18n("Error Log")
            actionName: "Error Log"
            icon.name: "error"
            page: "qrc:/ErrorListPage.qml"
        },
        KirigamiSettings.SettingAction {
            text: i18n("About")
            actionName: "About"
            icon.name: "documentinfo"
            page: "qrc:/AboutPage.qml"
        }
    ]
}

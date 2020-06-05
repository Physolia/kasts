/**
 * Copyright 2020 Tobias Fella <fella@posteo.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.14
import QtQuick.Controls 2.14 as Controls
import QtQuick.Layouts 1.14

import org.kde.kirigami 2.12 as Kirigami

import org.kde.alligator 1.0

Kirigami.SwipeListItem {
    ColumnLayout {
        spacing: 0
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
        Controls.Label {
            text: model.entry.title
            Layout.fillWidth: true
            elide: Text.ElideRight
            opacity: 1
            color: model.entry.read ? Kirigami.Theme.disabledTextColor : Kirigami.Theme.textColor
        }
        Controls.Label {
            id: subtitleItem
            text: model.entry.updated.toLocaleString(Qt.locale(), Locale.ShortFormat) + (model.entry.authors.length === 0 ? "" : " " + i18nc("by <author(s)>", "by") + " " + model.entry.authors[0].name)
            Layout.fillWidth: true
            elide: Text.ElideRight
            font: Kirigami.Theme.smallFont
            opacity: 0.6
            visible: text.length > 0
            color: model.entry.read ? Kirigami.Theme.disabledTextColor : Kirigami.Theme.textColor
        }
    }

    onClicked: {
        model.entry.read = true
        pageStack.push("qrc:/EntryPage.qml", {"entry": model.entry})
    }
}
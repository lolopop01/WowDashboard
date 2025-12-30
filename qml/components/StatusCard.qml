import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    property string title
    property string description
    property var status

    Layout.fillWidth: true
    implicitHeight: content.implicitHeight   // 🔑 THIS IS THE FIX

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: "#020617"
        border.color: "#1e293b"
        border.width: 1

        ColumnLayout {
            id: content
            anchors.fill: parent
            anchors.margins: 16
            spacing: 8

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: title
                    font.pixelSize: 18
                    font.bold: true
                    color: "#e5e7eb"
                }

                Item { Layout.fillWidth: true }

                StatusBadge {
                    active: (status && status.active === true) ? true : false
                }
            }

            Text {
                text: description
                color: "#94a3b8"
                font.pixelSize: 12
            }

            Text {
                visible: (status && status.active === true && status.since) ? true : false
                text: "Up since: " + (status ? status.since : "")
                font.family: "monospace"
                font.pixelSize: 11
                color: "#64748b"
            }

            Text {
                visible: (!status || status.active !== true) ? true : false
                text: "Service is currently unavailable"
                font.pixelSize: 11
                color: "#64748b"
            }
        }
    }
}

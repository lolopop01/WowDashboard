import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    property string title
    property string description
    property var status
    property bool hasSince: false

    Layout.fillWidth: true

    // 🔑 FIX: force consistent card height
    Layout.preferredHeight: 150

    readonly property bool online:
            status && status.active === true ? true : false

    Rectangle {
        anchors.fill: parent
        radius: 22
        color: "#020617"
        border.width: 1
        border.color: online ? "#2563eb" : "#334155"
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 12

            /* ======================
               Header
               ====================== */
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: title
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    color: "#f8fafc"
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Rectangle {
                    radius: 999
                    implicitHeight: 26
                    implicitWidth: badgeText.implicitWidth + 20
                    color: online ? "#052e16" : "#450a0a"
                    border.color: online ? "#22c55e" : "#ef4444"
                    border.width: 1

                    Text {
                        id: badgeText
                        anchors.centerIn: parent
                        text: online ? "ONLINE" : "OFFLINE"
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 1.1
                        color: online ? "#4ade80" : "#f87171"
                    }
                }
            }

            /* ======================
               Description
               ====================== */
            Text {
                text: description
                font.pixelSize: 13
                color: "#94a3b8"
                elide: Text.ElideRight
            }

            Item { Layout.fillHeight: true } // 🔑 spacer keeps footer aligned

            /* ======================
               Footer (RESERVED SPACE)
               ====================== */
            Text {
                text: hasSince && online ? ("UP SINCE  " + status.since) : ""
                visible: hasSince && online
                opacity: hasSince && online ? 1.0 : 0.0
                font.family: "monospace"
                font.pixelSize: 11
                color: "#64748b"
            }

            Text {
                text: !online ? "Service currently unavailable" : ""
                visible: !online
                opacity: !online ? 1.0 : 0.0
                font.pixelSize: 11
                color: "#64748b"
            }
        }
    }
}

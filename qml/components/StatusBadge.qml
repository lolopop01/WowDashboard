import QtQuick
import QtQuick.Controls

Item {
    id: root
    property bool active: false

    implicitHeight: 24
    implicitWidth: badge.implicitWidth

    Rectangle {
        id: badge
        radius: 999
        color: active ? "#14532d" : "#7f1d1d"
        opacity: 0.2
        border.color: active ? "#22c55e" : "#ef4444"

        Text {
            anchors.centerIn: parent
            anchors.margins: 8
            text: active ? "Online" : "Offline"
            font.pixelSize: 11
            font.bold: true
            color: active ? "#4ade80" : "#f87171"
        }
    }
}

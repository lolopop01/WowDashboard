import QtQuick
import QtQuick.Controls

Item {
    property string playerName: "Unknown"

    anchors.fill: parent

    Text {
        anchors.centerIn: parent
        text: "Player: " + playerName
        color: "white"
        font.pixelSize: 24
    }
}

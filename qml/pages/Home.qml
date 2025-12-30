import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24

        Rectangle {
            Layout.fillWidth: true
            radius: 16
            color: "#020617"
            border.color: "#1e293b"
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                Text {
                    text: "Welcome to Azeroth"
                    font.pixelSize: 24
                    font.bold: true
                    color: "#facc15"
                }

                Text {
                    text: "Azeroth is a community-run Wrath of the Lich King server built on AzerothCore."
                    wrapMode: Text.WordWrap
                    color: "#cbd5e1"
                }

                Row {
                    spacing: 12

                    Button {
                        text: "Download Client"
                        onClicked: stackView.replace("./Download.qml")
                    }

                    Button {
                        text: "View Players"
                        onClicked: stackView.replace("./Players.qml")
                    }
                }
            }
        }
    }
}

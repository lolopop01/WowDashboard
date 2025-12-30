import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 32
        spacing: 32

        /* ======================
           Welcome Card
           ====================== */
        Rectangle {
            Layout.fillWidth: true
            radius: 20
            color: "#020617"
            border.color: "#1e293b"
            border.width: 1

            ColumnLayout {
                Layout.fillWidth: true
                Layout.margins: 32
                spacing: 18

                Text {
                    text: "Welcome to Azeroth"
                    font.pixelSize: 34
                    font.weight: Font.DemiBold
                    color: "#facc15"
                    Layout.fillWidth: true
                }

                Text {
                    text: "Wrath of the Lich King · 3.3.5a"
                    font.pixelSize: 14
                    color: "#94a3b8"
                    Layout.fillWidth: true
                }

                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                    lineHeight: 1.3
                    color: "#cbd5e1"
                    text:
                        "Azeroth is a community-run Wrath of the Lich King server built on AzerothCore.\n\n" +
                        "Our goal is to provide a stable, transparent, and truly blizzlike experience — " +
                        "no shortcuts, no pay-to-win, just World of Warcraft as it was meant to be played."
                }

                /* ======================
                   Actions
                   ====================== */
                RowLayout {
                    spacing: 16
                    Layout.topMargin: 12

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

        Item { Layout.fillHeight: true }

        /* ======================
           Footer
           ====================== */
        Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
            color: "#64748b"
            text:
                "Server powered by AzerothCore · Not affiliated with Blizzard Entertainment"
        }
    }
}

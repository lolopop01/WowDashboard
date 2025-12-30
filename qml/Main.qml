import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 1000
    height: 700
    visible: true
    title: "Azeroth"

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        // Header
        Column {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            Text {
                text: "Azeroth"
                font.pixelSize: 36
                font.bold: true
                color: "#facc15"   // yellow-400
            }

            Text {
                text: "Wrath of the Lich King (3.3.5a)"
                color: "#94a3b8"  // slate-400
            }
        }

        // Navigation
        Nav {
            id: nav
            onNavigate: (page) => {
                stackView.replace(page)
            }
        }

        // Router
        StackView {
            id: stackView
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: "pages/Home.qml"
        }
    }

    background: Rectangle {
        color: "#020617" // slate-950
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    signal navigate(string page)
    spacing: 28
    Layout.alignment: Qt.AlignHCenter

    Button {
        text: "Home"
        onClicked: navigate("pages/Home.qml")
    }

    Button {
        text: "Download"
        onClicked: navigate("pages/Download.qml")
    }

    Button {
        text: "Players"
        onClicked: navigate("pages/Players.qml")
    }

    Button {
        text: "Services Status"
        onClicked: navigate("pages/Status.qml")
    }
}

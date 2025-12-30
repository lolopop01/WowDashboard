import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Item {
    id: root
    anchors.fill: parent

    property bool loading: false
    signal close()
    signal confirm(string password, bool auth, bool world)

    onVisibleChanged: {
        if (!visible) {
            countdownTimer.stop()
            reset()
        }
    }


    property bool auth: true
    property bool world: false
    property string password: ""
    property int countdown: -1
    property bool fired: false

    function reset() {
        password = ""
        auth = true
        world = false
        countdown = -1
        fired = false
    }


    Rectangle {
        anchors.fill: parent
        color: "#020617"
        opacity: 0.75
    }

    Timer {
        id: countdownTimer
        interval: 1000
        repeat: true
        running: countdown >= 0

        onTriggered: {
            if (countdown === 0) {
                if (!fired) {
                    fired = true
                    confirm(password, auth, world)
                    close()
                }
                stop()
                return
            }
            countdown--
        }
    }

    function startCountdown() {
        if (!password || (!auth && !world)) return
        fired = false
        countdown = 5
        countdownTimer.start()
    }

    function cancelCountdown() {
        countdown = -1
        fired = false
        countdownTimer.stop()
    }

    Rectangle {
        width: 420
        implicitHeight: content.implicitHeight
        anchors.centerIn: parent
        radius: 20
        color: "#020617"
        border.color: "#334155"
        border.width: 1

        ColumnLayout {
            id: content
            anchors.fill: parent
            anchors.margins: 28
            spacing: 18

            Text {
                text: "Restart Services"
                font.pixelSize: 22
                font.weight: Font.DemiBold
                color: "#f87171"
            }

            ColumnLayout {
                spacing: 10

                CheckBox {
                    text: "Auth server"
                    checked: auth
                    enabled: !loading && countdown < 0
                    onCheckedChanged: auth = checked
                }

                CheckBox {
                    text: "World server"
                    checked: world
                    enabled: !loading && countdown < 0
                    onCheckedChanged: world = checked
                }
            }

            TextField {
                placeholderText: "Admin password"
                echoMode: TextInput.Password
                text: password
                enabled: !loading && countdown < 0
                onTextChanged: password = text
            }

            Rectangle {
                height: 1
                Layout.fillWidth: true
                color: "#1e293b"
            }

            RowLayout {
                Layout.fillWidth: true

                Item {
                    visible: countdown >= 0
                    Layout.fillWidth: true

                    Text {
                        text: "Restarting in " + countdown + " seconds"
                        color: "#94a3b8"
                    }
                }

                Button {
                    visible: countdown >= 0
                    text: "Cancel"
                    onClicked: cancelCountdown()
                }

                Item { Layout.fillWidth: true }

                Button {
                    visible: countdown < 0
                    text: "Close"
                    onClicked: close()
                }

                Button {
                    visible: countdown < 0
                    text: "Restart"
                    enabled: !loading && password.length > 0 && (auth || world)
                    onClicked: startCountdown()
                }
            }
        }
    }
}

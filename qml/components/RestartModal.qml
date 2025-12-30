import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent

    // API
    property bool loading: false
    signal close()
    signal confirm(string password, bool auth, bool world)

    // state
    property bool auth: true
    property bool world: false
    property string password: ""
    property int countdown: -1
    property bool fired: false

    /* ======================
       Dark overlay (NO children)
       ====================== */
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.6
    }

    /* ======================
       Countdown engine
       ====================== */
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
        if (!password || (!auth && !world))
            return

        fired = false
        countdown = 5
        countdownTimer.start()
    }

    function cancelCountdown() {
        countdown = -1
        fired = false
        countdownTimer.stop()
    }

    /* ======================
       Dialog
       ====================== */
    Rectangle {
        id: dialog
        width: 400
        implicitHeight: content.implicitHeight   // 🔑 REQUIRED
        anchors.centerIn: parent
        radius: 16
        color: "#0f172a"
        border.color: "#1e293b"
        border.width: 1

        ColumnLayout {
            id: content
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            Text {
                text: "Restart Services"
                font.pixelSize: 20
                font.bold: true
                color: "#f87171"
            }

            ColumnLayout {
                spacing: 8

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

            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.fillWidth: true

                /* Countdown active */
                Item {
                    visible: countdown >= 0
                    Layout.fillWidth: true

                    RowLayout {
                        anchors.fill: parent

                        Text {
                            text: "Restarting in " + countdown + " seconds"
                            color: "#94a3b8"
                        }

                        Item { Layout.fillWidth: true }

                        Button {
                            text: "Cancel"
                            enabled: !loading
                            onClicked: cancelCountdown()
                        }
                    }
                }

                /* Normal actions */
                Item {
                    visible: countdown < 0
                    Layout.fillWidth: true

                    RowLayout {
                        anchors.fill: parent

                        Button {
                            text: "Close"
                            enabled: !loading
                            onClicked: close()
                        }

                        Item { Layout.fillWidth: true }

                        Button {
                            text: "Restart"
                            enabled: !loading
                                && password.length > 0
                                && (auth || world)
                            onClicked: startCountdown()
                        }
                    }
                }
            }
        }
    }
}

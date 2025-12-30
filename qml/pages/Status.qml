import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../components"

Item {
    id: page

    property bool modalOpen: false
    property string restartError: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 32
        spacing: 28

        RowLayout {
            Layout.fillWidth: true

            ColumnLayout {
                spacing: 6

                Text {
                    text: "Server Status"
                    font.pixelSize: 32
                    font.weight: Font.DemiBold
                    color: "#facc15"
                }

                Text {
                    text: "Live status of all backend services"
                    font.pixelSize: 14
                    color: "#94a3b8"
                }
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "Restart services"
                enabled: !statusService.restarting
                onClicked: {
                    restartError = ""
                    modalOpen = true
                }
            }
        }

        Rectangle {
            visible: restartError.length > 0
            Layout.fillWidth: true
            radius: 12
            color: "#450a0a"
            border.color: "#ef4444"
            opacity: 0.9

            Text {
                anchors.fill: parent
                anchors.margins: 14
                text: restartError
                color: "#fca5a5"
                wrapMode: Text.WordWrap
            }
        }

        Text {
            visible: statusService.loading
            text: "Checking services…"
            color: "#94a3b8"
        }

        GridLayout {
            visible: !statusService.loading
            Layout.fillWidth: true
            columns: width > 720 ? 2 : 1
            columnSpacing: 24
            rowSpacing: 24

            StatusCard {
                title: "API"
                description: "Backend API"
                status: statusService.api
                hasSince: false
            }

            StatusCard {
                title: "Auth Server"
                description: "Authentication service"
                status: statusService.authserver
                hasSince: statusService.authHasSince
            }

            StatusCard {
                title: "World Server"
                description: "Game world service"
                status: statusService.worldserver
                hasSince: statusService.worldHasSince
            }

            StatusCard {
                title: "Database"
                description: "Game database"
                status: statusService.database
                hasSince: false
            }
        }

        Item { Layout.fillHeight: true }

        Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: "Status is fetched live from the server."
            color: "#64748b"
            font.pixelSize: 12
        }
    }

    RestartModal {
        id: restartModal
        anchors.fill: parent
        visible: modalOpen
        loading: statusService.restarting

        onClose: modalOpen = false

        onConfirm: (password, auth, world) => {
            statusService.restart(password, auth, world)
        }
    }


    Connections {
        target: statusService

        function onRestartResult(ok, error) {
            if (ok) {
                restartError = ""
                return
            }

            restartError =
                    error === "unauthorized"
                ? "Invalid admin password."
                : error === "rate_limited"
                    ? "Restart already requested recently. Please wait."
                    : "Restart failed due to a server error."
        }
    }
}

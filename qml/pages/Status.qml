import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../components"

Item {
    id: page

    property bool modalOpen: false
    property string restartError: ""

    /* ======================
       Main page layout
       ====================== */
    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24

        /* ======================
           Header
           ====================== */
        RowLayout {
            Layout.fillWidth: true

            ColumnLayout {
                spacing: 4

                Text {
                    text: "Server Status"
                    font.pixelSize: 28
                    font.bold: true
                    color: "#facc15"
                }

                Text {
                    text: "Live status of all backend services"
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

        /* ======================
           Restart error banner
           ====================== */
        Rectangle {
            visible: restartError.length > 0
            Layout.fillWidth: true
            radius: 8
            color: "#7f1d1d"
            opacity: 0.2
            border.color: "#ef4444"

            Text {
                anchors.fill: parent
                anchors.margins: 12
                text: restartError
                color: "#f87171"
                wrapMode: Text.WordWrap
            }
        }

        /* ======================
           Loading
           ====================== */
        Text {
            visible: statusService.loading
            text: "Checking services…"
            color: "#94a3b8"
        }

        /* ======================
           Status grid
           ====================== */
        GridLayout {
            visible: !statusService.loading
            Layout.fillWidth: true
            columns: width > 600 ? 2 : 1
            columnSpacing: 16
            rowSpacing: 16

            StatusCard {
                title: "API"
                description: "Backend API"
                status: statusService.api
            }

            StatusCard {
                title: "Auth Server"
                description: "Authentication service"
                status: statusService.authserver
            }

            StatusCard {
                title: "World Server"
                description: "Game world service"
                status: statusService.worldserver
            }

            StatusCard {
                title: "Database"
                description: "Game database"
                status: statusService.database
            }
        }

        Item { Layout.fillHeight: true }

        /* ======================
           Footer
           ====================== */
        Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: "Status is fetched live from the server."
            color: "#64748b"
            font.pixelSize: 12
        }
    }

    /* ======================
       Restart modal (OUTSIDE layout)
       ====================== */
    RestartModal {
        anchors.fill: parent
        visible: modalOpen
        loading: statusService.restarting

        onClose: modalOpen = false

        onConfirm: (password, auth, world) => {
            const result = statusService.restart(password, auth, world)
            modalOpen = false

            if (!result || !result.ok) {
                restartError =
                        result.error === "unauthorized"
                    ? "Invalid admin password."
                    : result.error === "rate_limited"
                        ? "Restart already requested recently. Please wait before trying again."
                        : "Restart failed due to a server error."
            }
        }
    }
}

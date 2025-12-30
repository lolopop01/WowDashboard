cmake_minimum_required(VERSION 3.16)

project(WowDashboard VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_add_executable(appWowDashboard
        main.cpp
        backend/ApiClient.cpp
        backend/ApiClient.h
        backend/PlayersService.cpp
        backend/PlayersService.h
        backend/PlayerDetailsService.cpp
        backend/PlayerDetailsService.h
        backend/StatusService.cpp
        backend/StatusService.h
)

qt_add_qml_module(appWowDashboard
        URI WowDashboard
        VERSION 1.0
        QML_FILES
        qml/Main.qml
        qml/Nav.qml

        qml/pages/Home.qml
        qml/pages/Download.qml
        qml/pages/Players.qml
        qml/pages/Status.qml
        qml/pages/PlayerDetails.qml

        qml/components/RestartModal.qml
        qml/components/StatusCard.qml
        qml/components/StatusBadge.qml
)

target_link_libraries(appWowDashboard
        PRIVATE Qt6::Quick
)

set_target_properties(appWowDashboard PROPERTIES
        WIN32_EXECUTABLE TRUE
        MACOSX_BUNDLE TRUE
)

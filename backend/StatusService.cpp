#include "StatusService.h"
#include "ApiClient.h"

#include <QNetworkReply>
#include <QJsonDocument>
#include <QTimer>

StatusService::StatusService(ApiClient *api, QObject *parent)
    : QObject(parent), m_api(api)
{
    refresh();
}

void StatusService::refresh()
{
    m_loading = true;
    emit changed();

    auto reply = m_api->get("/api/status");

    connect(reply, &QNetworkReply::finished, this, [this, reply] {
        m_loading = false;

        if (reply->error()) {
            m_apiStatus = {{"active", false}};
            m_auth = {{"active", false}};
            m_world = {{"active", false}};
            m_db = {{"active", false}};
            emit changed();
            reply->deleteLater();
            return;
        }

        const auto json =
            QJsonDocument::fromJson(reply->readAll()).object();

        m_apiStatus = {{"active", true}};

        m_auth = {
            {"active", json["ac-authserver"].toObject()["active"].toBool()},
            {"since", json["ac-authserver"].toObject()["since"].toString()}
        };

        m_world = {
            {"active", json["ac-worldserver"].toObject()["active"].toBool()},
            {"since", json["ac-worldserver"].toObject()["since"].toString()}
        };

        m_db = {
            {"active", json["database"].toObject()["active"].toBool()}
        };

        emit changed();
        reply->deleteLater();
    });
}

QVariant StatusService::restart(
    const QString &password,
    bool auth,
    bool world
) {
    m_restarting = true;
    emit changed();

    QJsonObject payload{
        {"password", password},
        {"auth", auth},
        {"world", world}
    };

    auto reply = m_api->post("/api/restart", payload);

    connect(reply, &QNetworkReply::finished, this, [this, reply] {
        m_restarting = false;

        const int status =
            reply->attribute(
                QNetworkRequest::HttpStatusCodeAttribute
            ).toInt();

        if (status == 200) {
            QTimer::singleShot(5000, this, &StatusService::refresh);
        }

        emit changed();
        reply->deleteLater();
    });

    // Immediate optimistic response (like React)
    return QVariantMap{{"ok", true}};
}

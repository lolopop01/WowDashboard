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

bool StatusService::authHasSince() const {
    return m_auth.contains("since")
        && m_auth.value("since").isString()
        && !m_auth.value("since").toString().isEmpty();
}

bool StatusService::worldHasSince() const {
    return m_world.contains("since")
        && m_world.value("since").isString()
        && !m_world.value("since").toString().isEmpty();
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

        const auto authObj = json["ac-authserver"].toObject();
        m_auth = {
            {"active", authObj["active"].toBool()},
            {"since", authObj["since"].toString()}
        };

        const auto worldObj = json["ac-worldserver"].toObject();
        m_world = {
            {"active", worldObj["active"].toBool()},
            {"since", worldObj["since"].toString()}
        };

        const auto dbObj = json["database"].toObject();
        m_db = {
            {"active", dbObj["active"].toBool()}
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

    // optimistic response (React-style)
    return QVariantMap{{"ok", true}};
}

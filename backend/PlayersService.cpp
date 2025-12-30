#include "PlayersService.h"
#include "ApiClient.h"
#include <QNetworkReply>
#include <QJsonDocument>

PlayersService::PlayersService(ApiClient *api, QObject *parent)
    : QObject(parent), m_api(api)
{
    refresh();
}

void PlayersService::refresh() {
    m_loading = true;
    emit loadingChanged();

    auto reply = m_api->get("/api/players");

    connect(reply, &QNetworkReply::finished, this, [=] {
        m_loading = false;
        emit loadingChanged();

        if (reply->error()) {
            m_error = reply->errorString();
            emit errorChanged();
            reply->deleteLater();
            return;
        }

        auto doc = QJsonDocument::fromJson(reply->readAll());
        m_players = doc.array();
        emit playersChanged();

        reply->deleteLater();
    });
}

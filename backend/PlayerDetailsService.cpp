#include "PlayerDetailsService.h"
#include "ApiClient.h"
#include <QNetworkReply>
#include <QJsonDocument>

PlayerDetailsService::PlayerDetailsService(ApiClient *api, QObject *parent)
    : QObject(parent), m_api(api) {}

void PlayerDetailsService::setName(const QString &name) {
    if (m_name == name) return;
    m_name = name;
    emit nameChanged();
    fetch();
}

void PlayerDetailsService::fetch() {
    if (m_name.isEmpty()) return;

    m_loading = true;
    emit loadingChanged();

    auto reply = m_api->get("/api/players/" + QUrl::toPercentEncoding(m_name));

    connect(reply, &QNetworkReply::finished, this, [=] {
        m_loading = false;
        emit loadingChanged();

        if (reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt() == 404) {
            m_player = {};
            emit playerChanged();
            reply->deleteLater();
            return;
        }

        if (reply->error()) {
            m_error = reply->errorString();
            emit errorChanged();
            reply->deleteLater();
            return;
        }

        m_player = QJsonDocument::fromJson(reply->readAll()).object();
        emit playerChanged();
        reply->deleteLater();
    });
}

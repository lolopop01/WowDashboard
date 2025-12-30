#include "ApiClient.h"
#include <QNetworkRequest>
#include <QJsonDocument>

ApiClient::ApiClient(QObject *parent)
    : QObject(parent)
{
}

QNetworkReply* ApiClient::get(const QString &path)
{
    QNetworkRequest req(QUrl("https://azeroth-web.gros-sans-dessein.com" + path));
    req.setRawHeader("Accept", "application/json");
    return m_net.get(req);
}

QNetworkReply* ApiClient::post(const QString &path, const QJsonObject &body)
{
    QNetworkRequest req(QUrl("https://azeroth-web.gros-sans-dessein.com" + path));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    return m_net.post(req, QJsonDocument(body).toJson());
}

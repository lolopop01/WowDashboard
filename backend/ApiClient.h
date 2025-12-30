#pragma once
#include <QObject>
#include <QNetworkAccessManager>

class ApiClient : public QObject {
    Q_OBJECT
public:
    explicit ApiClient(QObject *parent = nullptr);

    QNetworkReply* get(const QString &path);
    QNetworkReply* post(const QString &path, const QJsonObject &body);

private:
    QNetworkAccessManager m_net;
};

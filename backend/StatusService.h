#pragma once

#include <QObject>
#include <QJsonObject>
#include <QVariant>

class ApiClient;

class StatusService : public QObject {
    Q_OBJECT

    Q_PROPERTY(QJsonObject api READ api NOTIFY changed)
    Q_PROPERTY(QJsonObject authserver READ authserver NOTIFY changed)
    Q_PROPERTY(QJsonObject worldserver READ worldserver NOTIFY changed)
    Q_PROPERTY(QJsonObject database READ database NOTIFY changed)
    Q_PROPERTY(bool loading READ loading NOTIFY changed)
    Q_PROPERTY(bool restarting READ restarting NOTIFY changed)

public:
    explicit StatusService(ApiClient *api, QObject *parent = nullptr);

    QJsonObject api() const { return m_apiStatus; }
    QJsonObject authserver() const { return m_auth; }
    QJsonObject worldserver() const { return m_world; }
    QJsonObject database() const { return m_db; }

    bool loading() const { return m_loading; }
    bool restarting() const { return m_restarting; }

    Q_INVOKABLE void refresh();
    Q_INVOKABLE QVariant restart(
        const QString &password,
        bool auth,
        bool world
    );

    signals:
        void changed();

private:
    ApiClient *m_api;

    QJsonObject m_apiStatus;
    QJsonObject m_auth;
    QJsonObject m_world;
    QJsonObject m_db;

    bool m_loading = false;
    bool m_restarting = false;
};

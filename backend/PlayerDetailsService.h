#pragma once
#include <QObject>
#include <QJsonObject>

class ApiClient;

class PlayerDetailsService : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QJsonObject player READ player NOTIFY playerChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
    Q_PROPERTY(QString error READ error NOTIFY errorChanged)

public:
    explicit PlayerDetailsService(ApiClient *api, QObject *parent = nullptr);

    QString name() const { return m_name; }
    void setName(const QString &name);

    QJsonObject player() const { return m_player; }
    bool loading() const { return m_loading; }
    QString error() const { return m_error; }

    signals:
        void nameChanged();
    void playerChanged();
    void loadingChanged();
    void errorChanged();

private:
    void fetch();

    ApiClient *m_api;
    QString m_name;
    QJsonObject m_player;
    bool m_loading = false;
    QString m_error;
};

#pragma once
#include <QObject>
#include <QJsonArray>

class ApiClient;

class PlayersService : public QObject {
    Q_OBJECT

    Q_PROPERTY(QJsonArray players READ players NOTIFY playersChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
    Q_PROPERTY(QString error READ error NOTIFY errorChanged)

public:
    explicit PlayersService(ApiClient *api, QObject *parent = nullptr);

    QJsonArray players() const { return m_players; }
    bool loading() const { return m_loading; }
    QString error() const { return m_error; }

    Q_INVOKABLE void refresh();

    signals:
        void playersChanged();
    void loadingChanged();
    void errorChanged();

private:
    ApiClient *m_api;
    QJsonArray m_players;
    bool m_loading = false;
    QString m_error;
};

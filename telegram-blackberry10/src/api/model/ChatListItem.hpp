#ifndef CHATLISTITEM_HPP_
#define CHATLISTITEM_HPP_

#include <QObject>

class ChatListItem: QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title)
    Q_PROPERTY(QString content READ content)
    Q_PROPERTY(QString timestamp READ timestamp)
    Q_PROPERTY(QString author READ author)
    Q_PROPERTY(QString peerId READ peerId)
    Q_PROPERTY(QString chatAvatar READ chatAvatar)
    Q_PROPERTY(int unreadCount READ unreadCount)
public:

    enum Type {
        NORMAL,
        SECRET,
        GROUP
    };

    explicit ChatListItem(
            QObject* parent = 0,
            const QString& title = 0,
            const QString& content = 0,
            const QString& timestamp = 0,
            const QString& author = 0,
            const QString& peerId = 0,
            const QString& chatAvatar = 0,
            const QString& outgoingStatus = 0,
            const Type& type = NORMAL,
            const int unreadCount = 0
    );

    QString title() const;
    QString content() const;
    QString timestamp() const;
    QString author() const;
    QString peerId() const;
    QString chatAvatar() const;
    QString outgoingStatus() const;
    Type type() const;
    int unreadCount() const;

private:
    QString m_title;
    QString m_content;
    QString m_timestamp;
    QString m_author;
    QString m_peerId;
    QString m_chat_avatar;
    QString m_outgoing_status;
    Type m_type;
    int m_unread_count;
};

#endif

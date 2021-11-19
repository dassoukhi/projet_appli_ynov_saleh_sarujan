import 'package:meta/meta.dart';
import 'package:projet_appli_ynov/utils/database.dart';


class MessageField {
  static final String message = 'message';
  static final String createdAt = 'createdAt';
}

class Message {
  final String uid;
  final String urlAvatar;
  final String name;
  final String message;
  final int createdAt;
/*
  final Message replyMessage;
*/

  const Message({
    required this.uid,
    required this.urlAvatar,
    required this.name,
    required this.message,
    required this.createdAt,
/*
    required this.replyMessage,
*/
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
    uid: json['uid'],
    urlAvatar: json['urlAvatar'],
    name: json['name'],
    message: json['message'],
    createdAt: json['createdAt'],
    /*replyMessage: json['replyMessage'] ??
        Message.fromJson(json['replyMessage']),*/
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'urlAvatar': urlAvatar,
    'name': name,
    'message': message,
    'createdAt': createdAt,
/*
    'replyMessage': replyMessage == null ? null : replyMessage.toJson(),
*/
  };
}

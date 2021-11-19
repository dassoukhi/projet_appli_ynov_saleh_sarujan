import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_appli_ynov/model/message.dart';
import 'package:projet_appli_ynov/utils/authentication.dart';
import 'package:projet_appli_ynov/utils/database.dart';
import 'package:swipe_to/swipe_to.dart';

import 'message_widget.dart';

class MessagesWidget extends StatelessWidget {
  final String idUser;
  final ValueChanged<Message> onSwipedMessage;

  MessagesWidget({
    required this.idUser,
    required this.onSwipedMessage,
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot>(
    stream: Database.getMessages(idUser),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator());
        default:
          if (snapshot.hasError) {
            return buildText('Something Went Wrong Try later');
          } else {
            List documents = snapshot.data!.docs;
            final messages = [];
            documents.forEach((element) {
              Message userData = Message.fromJson(element.data());
              messages.add(userData);
            });
            return messages.length == 0
                ? buildText('On dit bonjour !')
                : ListView.builder(
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                print(message.uid);
                return FutureBuilder(
                    future: Authentication.getUser(),
                    builder: (context, snapshot){
                    if (snapshot.hasData) {
                      return SwipeTo(
                        onRightSwipe: () => onSwipedMessage(message),
                        child: MessageWidget(
                          message: message,
                          isMe: message.uid == snapshot.data,
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                });
                  /*SwipeTo(
                  onRightSwipe: () => onSwipedMessage(message),
                  child: MessageWidget(
                    message: message,
                    isMe: message.uid == user!.uid,
                  ),
                );*/
              },
            );
          }
      }
    },
  );

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 24, color: Colors.grey),
    ),
  );
}

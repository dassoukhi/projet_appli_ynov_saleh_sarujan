import 'package:projet_appli_ynov/res/custom_colors.dart';
import 'package:projet_appli_ynov/widget/messages_widget.dart';
import 'package:projet_appli_ynov/widget/new_message_widget.dart';
import 'package:projet_appli_ynov/widget/profile_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:projet_appli_ynov/model/message.dart';
import 'package:projet_appli_ynov/model/Utilisateur.dart';

class ChatScreen extends StatefulWidget {
  final Utilisateur user;

  const ChatScreen({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final focusNode = FocusNode();
  late Message? replyMessage;

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBodyBehindAppBar: true,
    backgroundColor: CustomColors.firebaseNavy,
    body: SafeArea(
      child: Column(
        children: [
          ProfileHeaderWidget(name: widget.user.name),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: MessagesWidget(
                idUser: widget.user.uid,
                onSwipedMessage: (message) {
/*
                  replyToMessage(message);
*/
                  focusNode.requestFocus();
                },
              ),
            ),
          ),
          NewMessageWidget(
            focusNode: focusNode,
            idUser: widget.user.uid,
/*            onCancelReply: cancelReply,
            replyMessage: replyMessage!,*/
          )
        ],
      ),
    ),
  );

  void replyToMessage(Message message) {
    setState(() {
      replyMessage = message;
    });
  }

  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }
}

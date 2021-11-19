import 'dart:ui';

import 'package:projet_appli_ynov/res/custom_colors.dart';
import 'package:projet_appli_ynov/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:projet_appli_ynov/model/Utilisateur.dart';

class ChatBodyWidget extends StatelessWidget {
  final List<Utilisateur> users;

  const ChatBodyWidget({
    required this.users,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: buildChats(),
    ),
  );

  Widget buildChats() => ListView.builder(
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, index) {
      final user = users[index];

      return Container(
        height: 75,
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatScreen(user: user),
            ));
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.urlAvatar),
          ),
          title: Text(user.name, style: TextStyle(color: Colors.black),),
        ),
      );
    },
    itemCount: users.length,
  );
}

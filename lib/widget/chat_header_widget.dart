import 'package:projet_appli_ynov/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:projet_appli_ynov/model/Utilisateur.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List<Utilisateur> users;

  const ChatHeaderWidget({
    required this.users,
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
    width: double.infinity,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(
    width: MediaQuery.of(context).size.width * 0.75,
    child: Text(
    'ChatsApp',
    style: TextStyle(
    color: Colors.white,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    SizedBox(height: 12),
    Container(
    height: 60,
    child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: users.length,
    itemBuilder: (context, index) {
    final user = users[index];
    if (index == 0) {
      return Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 24,
              child: Icon(Icons.search),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatScreen(user: users[index]),
                ));
              },
              child: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(user.urlAvatar),
              ),
            ),
          )
        ],
      );
        Container(
        margin: EdgeInsets.only(right: 12),
        child: CircleAvatar(
        radius: 24,
        child: Icon(Icons.search),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(right: 12),
        child: GestureDetector(
        onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChatScreen(user: users[index]),
        ));
        },
        child: CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(user.urlAvatar),
        ),
        ),
      );
    }
    },
    ),
    )
    ],
    ),
    );
  }
}

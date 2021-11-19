import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projet_appli_ynov/res/custom_colors.dart';
import 'package:projet_appli_ynov/utils/authentication.dart';
import 'package:projet_appli_ynov/utils/database.dart';
import 'package:projet_appli_ynov/widget/chat_body_widget.dart';
import 'package:projet_appli_ynov/widget/chat_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:projet_appli_ynov/model/Utilisateur.dart';

class ChatsScreen extends StatelessWidget {
  Database database = Database();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: CustomColors.firebaseNavy,
    body: SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: database.retrieveUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print(snapshot.error);
                return buildText('Something Went Wrong Try later');
              } else {
                List documents = snapshot.data!.docs;
                final List<Utilisateur> users = [];
                documents.forEach((element) {
                  Utilisateur userData = Utilisateur.fromJson(element.data());
                  users.add(userData);
                });

                if (users.length < 1) {
                  return buildText('No Users Found');
                } else {

                  return FutureBuilder(
                      future: Authentication.getUser(),
                      builder: (context, snapshot){
                        if (snapshot.hasData) {
                          List<Utilisateur> finalUsers = users.where((element) => element.uid != snapshot.data).toList();
                          return Center(
                            child: Column(
                              children:[
                                ChatHeaderWidget(users: finalUsers),
                                ChatBodyWidget(users: finalUsers)
                              ],
                            ),
                          );
                        }
                        return CircularProgressIndicator();
                      });

                }
              }
          }
        },
      ),
    ),
  );

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 24, color: Colors.white),
    ),
  );
}

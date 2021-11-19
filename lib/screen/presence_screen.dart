import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projet_appli_ynov/model/Utilisateur.dart';
import 'package:projet_appli_ynov/res/custom_colors.dart';
import 'package:projet_appli_ynov/utils/authentication.dart';
import 'package:projet_appli_ynov/utils/database.dart';
import 'package:flutter/material.dart';

class PresenceScreen extends StatefulWidget {
  final User _user;

  const PresenceScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  @override
  _PresenceScreenState createState() => _PresenceScreenState();
}

class _PresenceScreenState extends State<PresenceScreen> {
  Database database = Database();
  late Timer timer;

  @override
  void initState() {
    /*database.updateUserPresence();*/
    timer = Timer.periodic(Duration(minutes: 1), (_) => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: Text(
          widget._user.displayName!,
          style: TextStyle(
            color: CustomColors.firebaseYellow,
            fontSize: 26,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size(100, 40.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'USERS',
                style: TextStyle(
                  color: CustomColors.firebaseAmber,
                  fontSize: 16,
                  letterSpacing: 3,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: StreamBuilder <QuerySnapshot>(
            stream: database.retrieveUsers(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                List documents = snapshot.data!.docs;
                return ListView.separated(
                  itemCount: documents.length,
                  itemBuilder: (_, index) {
                    Utilisateur userData = Utilisateur.fromJson(documents[index].data());
                    DateTime lastSeen =
                    DateTime.fromMillisecondsSinceEpoch(userData.lastSeenInEpoch);
                    DateTime currentDateTime = DateTime.now();

                    Duration differenceDuration = currentDateTime.difference(lastSeen);
                    String durationString = differenceDuration.inSeconds > 59
                        ? differenceDuration.inMinutes > 59
                        ? differenceDuration.inHours > 23
                        ? '${differenceDuration.inDays} ${differenceDuration.inDays == 1 ? 'day' : 'days'}'
                        : '${differenceDuration.inHours} ${differenceDuration.inHours == 1 ? 'hour' : 'hours'}'
                        : '${differenceDuration.inMinutes} ${differenceDuration.inMinutes == 1 ? 'minute' : 'minutes'}'
                        : 'few moments';

                    String presenceString = userData.presence ? 'Online' : '$durationString ago';

                    return userData.uid == widget._user.uid
                        ? Container()
                        : ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.circle,
                        size: 12.0,
                        color: userData.presence
                            ? Colors.greenAccent[400]
                            : CustomColors.firebaseGrey.withOpacity(0.4),
                      ),
                      title: Text(
                        userData.name,
                        style: TextStyle(
                          color: CustomColors.firebaseGrey,
                          fontSize: 26.0,
                        ),
                      ),
                      trailing: Text(
                        presenceString,
                        style: TextStyle(
                          color: userData.presence
                              ? Colors.greenAccent[400]
                              : CustomColors.firebaseGrey.withOpacity(0.4),
                          fontSize: 14.0,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    CustomColors.firebaseOrange,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

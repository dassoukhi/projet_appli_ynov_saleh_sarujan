import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:projet_appli_ynov/model/Utilisateur.dart';
import 'package:projet_appli_ynov/res/custom_colors.dart';
import 'package:projet_appli_ynov/screen/chats_screen.dart';
import 'package:projet_appli_ynov/screen/presence_screen.dart';
import 'package:projet_appli_ynov/screen/sign_in_screen.dart';
import 'package:projet_appli_ynov/utils/authentication.dart';
import 'package:projet_appli_ynov/widgets/app_bar_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final Utilisateur _user;
  final String currentId;
  late bool liked = false;
  Profile({Key? key, required Utilisateur user, required String currentId})
      : _user = user,
        currentId = currentId,
        super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isSigningOut = false;
  late int counter;

  @override
  void initState() {
    super.initState();
      widget.liked = widget._user.likes.contains(widget.currentId);
      counter = widget._user.likes.length;
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async{
    setState(() {
      widget.liked = false;
    });

    final bool find = widget._user.likes.contains(widget.currentId);
    final refUsers = FirebaseFirestore.instance.collection('users');
    if (!find){
      widget._user.likes = await List<dynamic>.from([widget.currentId]) + widget._user.likes;
      print("*******before : ");
      print(widget._user.likes);
      Map<String, dynamic> updateLikes = {
        'likes': widget._user.likes,
      };
      await refUsers
          .doc(widget._user.uid)
          .update(updateLikes);
      isLiked = false;
    }
    else{
        final List<dynamic> afterFilter =  widget._user.likes.where((element) => element != widget.currentId as dynamic).toList();
        print("*******after  $afterFilter");
        Map<String, dynamic> updateLikes = {
          'likes': afterFilter,
        };
      widget._user.likes = afterFilter;
      counter = afterFilter.length;
      await refUsers
            .doc(widget._user.uid)
            .update(updateLikes);
      isLiked = true;
    }
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: CustomColors.firebaseNavy,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: AppBarTitle(),
        ),
        body: SingleChildScrollView(child:
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(),
                widget._user.urlAvatar != null
                    ? ClipOval(
                  child: Material(
                    color: CustomColors.firebaseGrey.withOpacity(0.3),
                    child: Image.network(
                      widget._user.urlAvatar,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                )
                    : ClipOval(
                  child: Material(
                    color: CustomColors.firebaseGrey.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: CustomColors.firebaseGrey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  widget._user.name,
                  style: TextStyle(
                    color: CustomColors.firebaseYellow,
                    fontSize: 26,
                  ),
                ),
                LikeButton(
                  size: 40,
                  circleColor:
                  CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xff33b5e5),
                    dotSecondaryColor: Color(0xff0099cc),
                  ),
                  likeBuilder: (bool isLiked) {
                    print(isLiked);
                    return Icon(
                      Icons.favorite,
                      color: isLiked || widget.liked ? Colors.red : Colors.grey,
                      size: 40,
                    );
                  },
                  onTap: onLikeButtonTapped,
                  likeCount: counter,
                  countBuilder: (int? count, bool isLiked, String text) {
                    counter = count!;
                    print(count);
                    var color = isLiked ? Colors.red : Colors.grey;
                    Widget result;

                    result = Text(
                      text,
                      style: TextStyle(color: color),
                    );
                    return result;
                  },
                ),
              ],
            ),
          ),
        ),)

    );
  }
}

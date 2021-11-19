import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:projet_appli_ynov/model/Utilisateur.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:projet_appli_ynov/model/message.dart';
import 'package:projet_appli_ynov/utils/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  /// The main Firestore user collection
  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('users');
  final DatabaseReference databaseReference = FirebaseDatabase.instance
      .reference();

  storeUserData(
      {required String userName, required String uid, required String urlAvatar}) async {

    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid')!;*/
    DocumentReference documentReferencer = userCollection.doc(uid);
    final GeoPoint? loc = await getLoc();

    Utilisateur utilisateur = Utilisateur(
      uid: uid,
      name: userName,
      urlAvatar: urlAvatar,
      presence: true,
      lastSeenInEpoch: DateTime
          .now()
          .millisecondsSinceEpoch,
      location: loc ?? GeoPoint(0, 0),
      likes: []
    );

    var data = utilisateur.toJson();

    await documentReferencer.set(data).whenComplete(() {
      print("User data added");
    }).catchError((e) => print(e));

    /*prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);*/

    /*updateUserPresence();*/
  }

  Stream<QuerySnapshot> retrieveUsers() {
    Stream<QuerySnapshot> queryUsers = userCollection
        .orderBy('last_seen', descending: true)
        .snapshots();

    return queryUsers;
  }

  updateUserPresence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid')!;

    Map<String, dynamic> presenceStatusTrue = {
      'presence': true,
      'last_seen': DateTime
          .now()
          .millisecondsSinceEpoch,
    };
    print("in update : $uid");

    await databaseReference
        .child(uid)
        .update(presenceStatusTrue)
        .whenComplete(() => print('Updated your presence.'))
        .catchError((e) => print(e));

    Map<String, dynamic> presenceStatusFalse = {
      'presence': false,
      'last_seen': DateTime
          .now()
          .millisecondsSinceEpoch,
    };

    databaseReference.child(uid).onDisconnect().update(presenceStatusFalse);
  }

  static DateTime? toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static Stream<QuerySnapshot> getMessages(String idUser) {
    Stream<QuerySnapshot> msg = FirebaseFirestore.instance
        .collection('chats/$idUser/messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
    return msg;
  }

  static Future uploadMessage(
      String idUser, String message
/*
      , Message replyMessage
*/
      ) async {
    /*final Me = Authentication.getUser();
    print('*****MyId****' + Me.uid);*/

    final refMessages = FirebaseFirestore.instance.collection('chats/$idUser/messages');
    final User? user = await FirebaseAuth.instance.currentUser;
    final newMessage = Message(
      uid: user!.uid,
      urlAvatar: user.photoURL.toString(),
      name: user.displayName.toString(),
      message: message,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      /*replyMessage: replyMessage,*/
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('users');
    Map<String, dynamic> lastMessageTime = {
      'lastMessageTime': DateTime.now().millisecondsSinceEpoch,
    };
    await refUsers
        .doc(idUser)
        .update(lastMessageTime);
  }


  Future<GeoPoint?> getLoc() async {

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    var _lat = _locationData.latitude;
    var _long = _locationData.longitude;
    print('lat: $_lat');
    print('long: $_long');

    return GeoPoint(_lat!, _long!);
  }

}

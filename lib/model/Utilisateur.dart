// TODO Implement this library.

import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur{
  String uid;
  String name;
  String urlAvatar;
  bool presence;
  int lastSeenInEpoch;
  GeoPoint location;
  List<dynamic> likes;

  Utilisateur({
    required this.uid,
    required this.name,
    required this.presence,
    required this.lastSeenInEpoch,
    required this.urlAvatar,
    required this.location,
    required this.likes,

  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
        uid: json['uid'],
        name: json['name'],
        urlAvatar: json['urlAvatar'],
        presence: json['presence'],
        lastSeenInEpoch: json['last_seen'],
        location: json['location'],
        likes: json['likes']

    );
  }

  static Utilisateur fromJsonForChats(Map<String, dynamic> json) => Utilisateur(
    uid: json['idUser'],
    name: json['name'],
    urlAvatar: json['urlAvatar'],
    lastSeenInEpoch: json['last_seen'],
    presence: json['presence'],
    location: json['location'],
    likes: json['likes'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['uid'] = this.uid;
    data['name'] = this.name;
    data['urlAvatar'] = this.urlAvatar;
    data['presence'] = this.presence;
    data['last_seen'] = this.lastSeenInEpoch;
    data['location'] = this.location;
    data['likes'] = this.likes;

    return data;
  }

}
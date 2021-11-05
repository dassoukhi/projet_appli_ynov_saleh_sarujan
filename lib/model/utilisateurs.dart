import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Utilisateur{
  late String name;
  late String identifiant;


  Utilisateur(DocumentSnapshot snapshot){
    identifiant = snapshot.id;
    Map <String, dynamic> map = snapshot.data() as Map <String, dynamic>;
    name = map['name'];
  }

  Utilisateur.vide();

}
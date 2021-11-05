import 'package:flutter/material.dart';
import 'package:projet_appli_ynov/model/utilisateurs.dart';

import 'package:projet_appli_ynov/functions/firestoreHelper.dart';

class homepage extends StatefulWidget{
  late String mail;

  homepage({required String this.mail});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homepageState();
  }

}

class homepageState extends State<homepage>{
  String nom='';

  String identifiant='';

  //Utilisateur user = Utilisateur.vide();
  Utilisateur user = Utilisateur.vide();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    firestoreHelper().getIdentifiant().then((value) {
      identifiant = value;
      print('TESTESSSSSS');
      /*firestoreHelper().getUtilisateur(identifiant).then((value) {
        setState(() {
          user = value;
          print('User: ');
          print(user);
        });
        print(user.nom);
      });*/
    });
    print('Id:');
    print(identifiant);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information personnels'),
        //title: Text(user.prenom)
      ),
      body: bodyPage(),
    );
  }

  Widget bodyPage(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(

          children: [
            //nom
            TextField(
              onChanged: (String value){
                setState(() {
                  nom = value;


                });
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),

                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Nom"
              ),

            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
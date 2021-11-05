/*
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projet_appli_ynov/functions/firestoreHelper.dart';
import 'package:projet_appli_ynov/test.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projet Appli Ynov',
      theme: ThemeData(
        // This is the theme of your application.

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Chat With Ynov'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var mail = '';
  var password = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:
      SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('\n LOGIN \n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, fontFamily: 'Ubuntu-Bold',),),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero
                  ),
                  hintText: 'Enter your email address',
                  contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),

                ),
                onChanged: (value){
                  if (value.length!=0){
                    setState(() {
                      mail = value;
                      bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(mail);
                      print(emailValid);
                      print(mail);
                    });}
                },
                style: const TextStyle(
                    fontSize: 20.0,
                    height: 1,
                    color: Colors.black
                ),
              ),
              const Text('\n'),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero
                  ),
                  hintText: 'Enter your password',
                  contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                ),
                onChanged: (value){
                  if (value.length!=0){
                    setState(() {
                      password = value;
                      print(password);
                    });}
                },
                style: const TextStyle(
                    fontSize: 20.0,
                    height: 1,
                    color: Colors.black
                ),
              ),
              const Text(
                  '\n Forgot your password ? \n',
                  style:
                  TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                      fontFamily: 'Ubuntu-regular'
                  )
              ),


              ElevatedButton(
                onPressed: () async {
                  */
/*firestoreHelper().inscription(mail, password);
                Map<String,dynamic>toto = {
                'mail' : mail,
                'password' : password,
                };
                firestoreHelper().addUser(toto, firestoreHelper().getIdentifiant());*//*

                  firestoreHelper().inscription(mail, password, context).then((value){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context){
                          return homepage(mail: mail);
                        }
                    ));


                  });
                }, child: const Text('Inscription'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 15),
                    textStyle:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                ),
              ),

              Text('\n'),
              ElevatedButton(
                onPressed: () async {
                  firestoreHelper().connexion(mail, password, context).then((value){
                    print("Je suis connecté");
                    Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return homepage(mail: mail);
                      }));
                  }).catchError((error){
                    */
/*return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Wrong email or password', style: TextStyle(color: Colors.red),),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );*//*


                    ScaffoldMessenger.of(context).showSnackBar(MonSnackBar());
                  });



                }, child: const Text('LOGIN'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                    textStyle:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                ),
              ),

            ],
          ),
        ),
      )

     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  MonSnackBar(){
    return const SnackBar(
        duration: Duration(seconds: 10),
        backgroundColor: Colors.red,
        content: Text("Erreur de connexion !!!"));
  }
}
*/



import 'package:flutter/material.dart';

import 'package:projet_appli_ynov/screen/sign_in_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat With Ynov',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: SignInScreen(),
    );
  }
}

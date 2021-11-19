import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet_appli_ynov/model/Utilisateur.dart';
import 'package:projet_appli_ynov/res/custom_colors.dart';
import 'package:projet_appli_ynov/screen/chats_screen.dart';
import 'package:projet_appli_ynov/screen/presence_screen.dart';
import 'package:projet_appli_ynov/screen/profile.dart';
import 'package:projet_appli_ynov/screen/sign_in_screen.dart';
import 'package:projet_appli_ynov/utils/authentication.dart';
import 'package:projet_appli_ynov/widgets/app_bar_title.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User _user;
  bool _isSigningOut = false;

  CameraPosition monument = const CameraPosition(
    target: LatLng(48.8884, 2.2945), zoom: 15,);

  Completer <GoogleMapController> controllerMap = Completer();


  @override
  void initState() {
    getMarkerData();
    _user = widget._user;
    super.initState();
    getPref();
    getLoc();
  }

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _routeToPresenceScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PresenceScreen(user: _user),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _routeToChatsScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ChatsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  getLoc() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    var _lat = _locationData.latitude;
    var _long = _locationData.longitude;
    print('lat: $_lat');
    print('long: $_long');
  }

  void getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('uid'));
  }


  late GoogleMapController _controller;
  var location = Location();
  Location _location = new Location();
  Future<void> _onMapCreated(GoogleMapController _cntlr) async {
    var userLocation = await location.getLocation();
    final LatLng _initialCameraPosition = LatLng(
        userLocation.latitude, userLocation.longitude);
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _initialCameraPosition, zoom: 14),
      );
    });
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  void initMarker(specify, specifyId) async{
    var iconurl = specify['urlAvatar'];
    var dataBytes;
    var request = await http.get(Uri.parse(iconurl));
    var bytes = await request.bodyBytes;

    setState(() {
      dataBytes = bytes;
    });


    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Utilisateur userMarker = Utilisateur(uid: specify['uid'], name: specify['name'], presence: specify['presence'], lastSeenInEpoch: specify['last_seen'], urlAvatar: specify['urlAvatar'], location: specify['location'], likes: specify['likes']);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify['location'].latitude,specify['location'].longitude),
      infoWindow: InfoWindow(title: specify['name']),
      icon: dataBytes !=null ? BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List()) : BitmapDescriptor.defaultMarker,
      onTap: () async{
        print("in ontap : " + specify['name']);
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile(user: userMarker, currentId: _user.uid,),
          ),
        );
    }

    );
    setState(() {
      markers[markerId] = marker;
    });
  }


  getMarkerData() async{
    FirebaseFirestore.instance.collection('users').where("presence", isEqualTo: true).get().then((myMocData){
      if(myMocData.docs.isNotEmpty){
        for (int i=0; i<myMocData.docs.length; i++){
          initMarker(myMocData.docs[i].data(), myMocData.docs[i].id);
          print(myMocData.docs[i].data()['name']);
        }
      }
    });
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
              _user.photoURL != null
                  ? ClipOval(
                child: Material(
                  color: CustomColors.firebaseGrey.withOpacity(0.3),
                  child: Image.network(
                    _user.photoURL!,
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
                'Hello',
                style: TextStyle(
                  color: CustomColors.firebaseGrey,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _user.displayName!,
                style: TextStyle(
                  color: CustomColors.firebaseYellow,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '( ${_user.email!} )',
                style: TextStyle(
                  color: CustomColors.firebaseOrange,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24.0),
              Text('\n'),
              Container(
                margin: const EdgeInsets.all(10.0),
                color: Colors.amber[600],
                width: double.infinity,
                height: 600.0,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child:
                      GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: monument,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        markers: Set<Marker>.of(markers.values),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Text('\n'),

              _isSigningOut
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary:  Colors.redAccent,
                    padding: const EdgeInsets.fromLTRB(79.0, 10.0, 79.0, 10.0),
                    textStyle:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                ),
                onPressed: () async {
                  setState(() {
                    _isSigningOut = true;
                  });
                  await Authentication.signOut(context: context);
                  setState(() {
                    _isSigningOut = false;
                  });
                  Navigator.of(context)
                      .pushReplacement(_routeToSignInScreen());
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary:  Colors.blue,
                  padding: const EdgeInsets.fromLTRB(56.0, 10.0, 56.0, 10.0),
                  textStyle:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
              ),
                onPressed: () async {

                  Navigator.of(context)
                      .push(_routeToPresenceScreen());
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    'Users Online',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary:  Colors.green,
                    padding: const EdgeInsets.fromLTRB(95.0, 10.0, 95.0, 10.0),
                    textStyle:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                ),
                onPressed: () async {

                  Navigator.of(context)
                      .push(_routeToChatsScreen());
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    'Chats',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),)

    );
  }
}

import 'dart:async';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'dart:convert';
import 'package:coco_shop/models/user.dart';
import 'services/firestore_service.dart';
import 'services/current_user_service.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore store = new FirestoreService().store;
  final CurrentUserService currentUserService = new CurrentUserService();
  FirebaseUser _firebaseUser;
  User _user;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   _user = null;
    // });
    // _auth.signOut();
    _getCurrentUser();
  }

  Future<Null> _login() async {
    facebookSignIn.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions([
          'email',
          'user_birthday',
          'user_friends',
          'user_gender',
          'user_location'
        ]);
    print(result.status);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final FirebaseUser user = await _auth.signInWithFacebook(accessToken: accessToken.token);
        this._setCurrentUser(user);
        this._setUserInfo(accessToken, user);
        // _goToHomePage();
        // _showMessage('''
        //  Logged in!
         
        //  Token: ${accessToken.token}
        //  User id: ${accessToken.userId}
        //  Expires: ${accessToken.expires}
        //  Permissions: ${accessToken.permissions}
        //  Declined permissions: ${accessToken.declinedPermissions}
        //  ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  void _setCurrentUser(FirebaseUser user) {
    setState(() {
      _firebaseUser = user;
    });
  }

  void _setUser(User user) {
    setState(() {
      _user = user;
    });
    currentUserService.setCurrentUser(user);
  }

  Future<void> _setUserInfo(FacebookAccessToken accessToken, FirebaseUser user) async {
    http.get('https://graph.facebook.com/${accessToken.userId}?fields=name,birthday,first_name,last_name&access_token=${accessToken.token}')
      .then((response) async {
        print(response.body);
        Map responseData = jsonDecode(response.body);
        Map<String, dynamic> userData = new Map();
        userData["first_name"] = responseData["first_name"];
        userData["last_name"] = responseData["last_name"];
        userData["birthday"] = responseData["birthday"];
        userData["fb_access_token"] = accessToken.token;
        userData["firebase_uid"] = user.uid;
        userData["email"] = user.providerData[0].email;
        userData["fb_uid"] = accessToken.userId;
        userData["token_expiration"] = accessToken.expires;
        userData["photo_url"] = user.photoUrl;
        final DocumentReference document = await this.store.collection('users').add(userData);
        final DocumentSnapshot newDoc = await document.get();
        User newUser = new User.fromMap(newDoc.data);
        this._setUser(newUser);
      });
  }

  Future<void> _getCurrentUser() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    if (currentUser != null) {
      QuerySnapshot queryResult = await store.collection('users').where("firebase_uid = ${currentUser.uid}").getDocuments();
      if (queryResult.documents.isNotEmpty) {
        print(queryResult.documents[0].data);
        User user = new User.fromMap(queryResult.documents[0].data);
        this._setUser(user);
      }
      _setCurrentUser(currentUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this._firebaseUser != null && this._user != null) {
      return HomePage();
    }
    return new Scaffold(
      backgroundColor: Colors.yellow[200],
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Coco Shop',
              style: Theme.of(context).textTheme.display2,
            ),
            new Text(
              'Make shopping fun again',
              style: Theme.of(context).textTheme.display1,
            ),
            new RaisedButton(
              onPressed: _login,
              child: new Text('Log in with Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}
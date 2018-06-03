import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/user.dart';
import 'fb_api.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({this.firebaseUser, this.currentUser});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final FirebaseUser firebaseUser;
  final User currentUser;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Firestore store = Firestore.instance;
  FBApi fbApi;

  User _currentUser;

  @override
  void initState() {
    super.initState();
    this.initializeFBApi(widget.currentUser);
    // this._getFriends();
  }

  void _noOp() {
    print('this is a no op for now');
    // print(widget.accessToken.token);
    // print(widget.accessToken.userId);
  }

  void _setCurrentUser(User user) {
    setState(() {
      _currentUser = user;
    });
  }

  void initializeFBApi(User user) {
    this.fbApi = new FBApi(user.fbAccessToken, user.fbUID);
  }

  Future<Null> _getFriends() async {
    if (this.fbApi != null) {
      this.fbApi.getFriends();
    }
  }

  List<Widget> buildChildren() {
    List<Widget> children = [];
    // if (widget.firebaseUser != null) {
    //   children.add(new Image.network(widget.firebaseUser.photoUrl));
    // }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    // _getFriends();
    // print(widget.currentUser.photoUrl);
    if (this._currentUser != null) {
      this._getFriends();
    }
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(icon: new Icon(Icons.list), onPressed: _noOp),
        title: new Text('CocoShop'),
        actions: <Widget>[
          new FloatingActionButton(
                backgroundColor: Colors.yellowAccent,
                onPressed: () => {},
                mini: true,
                child: new Text('1'),
              ),
          new IconButton(icon: new Icon(Icons.shopping_cart), onPressed: _noOp),
        ],
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: this.buildChildren(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

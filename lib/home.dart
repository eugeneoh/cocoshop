import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coco_shop/models/user.dart';
import 'package:coco_shop/models/post.dart';
import 'fb_api.dart';
import 'dart:convert';
import 'constants/routes.dart';
import 'services/current_user_service.dart';
import 'package:coco_shop/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CurrentUserService currentUserService = new CurrentUserService();
  final Firestore store = new FirestoreService().store;
  FBApi fbApi;
  User currentUser;

  @override
  void initState() {
    super.initState();
    User user = currentUserService.getCurrentUser();
    this.initializeFBApi(user);
    this.currentUser = user;
  }

  Future<List> fetchPosts() async {
    QuerySnapshot res = await this.store.collection('posts').orderBy('created_at', descending: true).getDocuments();
    List<Post> posts = [];
    if (res.documents.isNotEmpty) {
      res.documents.forEach((d) {
        Post post = new Post.fromMap(d.data);
        posts.add(post);
      });
    }
    return posts;
  }

  void _noOp() {
    print('this is a no op for now');
    // print(widget.accessToken.token);
    // print(widget.accessToken.userId);
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

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Post> posts = snapshot.data;
    return new ListView.builder(
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        Post currPost = posts[index];
        return new Row (
          children: [
            new Expanded(child: new Image.network(currPost.picURL1),),
            new Expanded(child: new Text(currPost.description),)
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // this._getFriends();
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
      body: new FutureBuilder(
        future: fetchPosts(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Text('loading...');

            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return createListView(context, snapshot);
          }
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home, color: Colors.grey,)
          ),
          BottomNavigationBarItem(
            title: Text('Search'),
            icon: Icon(Icons.search, color: Colors.grey,)
          ),
          BottomNavigationBarItem(
            title: Text('Favorites'),
            icon: Icon(Icons.favorite, color: Colors.grey,)
          ),
          BottomNavigationBarItem(
            title: Text('Profile'),
            icon: Icon(Icons.portrait, color: Colors.grey,)
          ),
        ],
        onTap: (routeIndex) => Navigator.of(context).pushReplacementNamed(routes[routeIndex])
      ),
    );
  }
}

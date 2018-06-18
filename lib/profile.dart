import 'dart:async';

import 'package:flutter/material.dart';
import 'package:coco_shop/models/user.dart';
import 'package:coco_shop/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants/routes.dart';
import 'services/current_user_service.dart';
import 'services/firestore_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final CurrentUserService currentUserService = new CurrentUserService();
  final Firestore store = new FirestoreService().store;
  User currentUser;

  @override
  void initState() {
    super.initState();
    User user = currentUserService.getCurrentUser();
    this.currentUser = user;
    print(this.currentUser.username);
  }

  _onFollowPressed() {
    print('following');
  }

  _onPostTapped(Post post) {
    print(post.description);
  }

  Future<List> _getUserPosts() async {
    QuerySnapshot res = await this.store.collection('posts')
      .where("author_firebase_uid = ${this.currentUser.firebaseUID}")
      .orderBy('created_at', descending: true)
      .getDocuments();
    List<Post> posts = [];
    if (res.documents.isNotEmpty) {
      res.documents.forEach((d) {
        Post post = new Post.fromMap(d.data);
        posts.add(post);
      });
    }
    return posts;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Post> posts = snapshot.data;
    List<Widget> images = [];
    for (int i = 0; i < posts.length; i++) {
      images.add(
        new GestureDetector(
          onTap: () => this._onPostTapped(posts[i]),
          child: Container(
            child: Image.network(
              posts[i].picURL1, 
              fit: BoxFit.fitWidth
            ),
            decoration: new BoxDecoration(
              border: new Border.all(
                width: 1.0,
                color: Colors.white
              ),
            ),
          )
        )
      );
    }
    return new Expanded(
      child: new GridView.count(
        crossAxisCount: 3,
        children: images,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget topRow = new Container(
      child: new Row(
        children: <Widget>[
          new Container(
            height: 48.0,
            width: 48.0,
            decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
            fit: BoxFit.fill,
            image: new NetworkImage(
              this.currentUser.photoUrl)
            )
          )),
          new Container(
            margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
            child: new Text(this.currentUser.firstName + " " + this.currentUser.lastName)
          ),
        ]
      ),
      padding: new EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0)
    );
    Widget secondRow = new Container(
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(this.currentUser.aboutMe)
          ),
          new Expanded(
            child: new Container(
              width: 40.0,
              child: new FlatButton(
                child: new Text("Follow"),
                onPressed: this._onFollowPressed,
              ),
              decoration: new BoxDecoration(
                border: new Border.all(
                  width: 2.0,
                  color: Theme.of(context).dividerColor
                ),
                borderRadius: BorderRadius.all(new Radius.circular(2.0)),
              ),
            ),
          )
        ]
      ),
      padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 16.0),
      decoration: new BoxDecoration(
        border: new Border(bottom: new BorderSide(color: Theme.of(context).dividerColor)),
      )
    );
    Widget postsList = new FutureBuilder(
      future: _getUserPosts(),
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
    );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this.currentUser.username),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            topRow,
            secondRow,
            postsList,
          ]
        ,)
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
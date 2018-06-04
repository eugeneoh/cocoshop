import 'package:flutter/material.dart';
import 'constants/routes.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => new _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Favorites Page'),
      ),
      body: new Text('This is the favorites page'),
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
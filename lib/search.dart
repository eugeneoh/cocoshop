import 'package:flutter/material.dart';
import 'constants/routes.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Search Page'),
      ),
      body: new Text('This is the search page'),
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
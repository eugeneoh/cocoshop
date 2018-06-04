import 'package:flutter/material.dart';
import 'home.dart';
import 'splash.dart';
import 'search.dart';
import 'profile.dart';
import 'favorites.dart';

void main() => runApp(new MyApp());

  final pagesRouteFactories = {
    "/home": () => MaterialPageRoute(
          builder: (context) =>  new HomePage()
        ),
    "search": () => MaterialPageRoute(
          builder: (context) => new SearchPage()
        ),
    "favorites": () => MaterialPageRoute(
          builder: (context) => new FavoritesPage()
        ),
    "profile": () => MaterialPageRoute(
          builder: (context) => new ProfilePage()
        ),
  };
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Coco Shop',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.yellow,
        accentColor: Colors.grey,
      ),
      home: new SplashPage(),
      onGenerateRoute: (route) => pagesRouteFactories[route.name](),
      // routes: <String, WidgetBuilder> {
      //   '/search': (BuildContext context) => MaterialPageRoute(builder: (context) => new SplashPage()),
        // '/favorites': (BuildContext context) => new FavoritesPage(),
        // '/profile': (BuildContext context) => new ProfilePage(),
      // },
    );
  }
}


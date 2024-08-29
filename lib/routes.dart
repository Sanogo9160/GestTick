import 'package:flutter/material.dart';
import 'package:gesttick/screens/home_screen.dart';
import 'package:gesttick/screens/login_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text('Erreur 404'),
            ),
            body: Center(
              child: Text('Page non trouvée'),
            ),
          ),
        );
    }
  }
}

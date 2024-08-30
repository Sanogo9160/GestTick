import 'package:flutter/material.dart';
import 'package:gesttick/screens/home_screen.dart';
import 'package:gesttick/screens/login_screen.dart';
import 'package:gesttick/screens/register_screen.dart';
import 'package:gesttick/screens/welcome_screen.dart';



//import 'screens/login_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case '/signup': // Ajoutez cette ligne pour l'écran d'inscription
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case '/welcome':
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
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


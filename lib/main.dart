import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/screens/login_screen.dart';
import 'package:gesttick/screens/home_screen.dart'; // Importez votre écran d'accueil
import 'package:gesttick/screens/ErrorScreen.dart';
import 'firebase_options.dart'; // Importez le fichier généré

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Tickets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Route initiale
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(), // Ajoutez l'écran d'accueil
      },
      onGenerateRoute: (settings) {
        // Gérer les routes non définies ici
        return null;
      },
      onUnknownRoute: (settings) {
        // Route inconnue, retournez une page d'erreur ou autre
        return MaterialPageRoute(
          builder: (context) =>
              ErrorScreen(), // Créez une page d'erreur si nécessaire
        );
      },
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/routes.dart';
import 'package:gesttick/screens/home_screen.dart';
import 'package:gesttick/screens/login_screen.dart';
import 'package:gesttick/screens/register_screen.dart';

 // Assurez-vous que ce fichier existe
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
      initialRoute: '/welcome',
      onGenerateRoute: RouteGenerator.generateRoute,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Erreur 404'),
            ),
            body: Center(
              child: Text('Page non trouvée'),
            ),
          ),
        );
      },
    );
  }
}

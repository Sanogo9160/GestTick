import 'package:flutter/material.dart';
import 'package:gesttick/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:gesttick/providers/user_provider.dart';
import 'package:gesttick/routes.dart';
import 'package:gesttick/screens/home_screen.dart';
import 'package:gesttick/screens/login_screen.dart';
import 'package:gesttick/screens/register_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gesttick/services/firebase_messaging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  
  );

   // Créer une instance de AuthService
  final AuthService _authService = AuthService();
  // Crée le compte admin par défaut
  await _authService.createDefaultAdmin();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'Gestion de Tickets',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/welcome',
         debugShowCheckedModeBanner: false, // Supprimer le ruban de débogage
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
      ),
    );
  }
}

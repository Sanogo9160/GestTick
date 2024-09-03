import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _obscureText = true;

  void _login() async {
    bool success = await _authService.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Gérer les erreurs de connexion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la connexion')),
      );
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Ajout de SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50), // Espace supplémentaire en haut
              // Logo centré sans ombre
              Image.asset(
                'assets/images/logo2.png',
                width: 120,
                height: 120,
              ),
              SizedBox(height: 40.0),
              // Label pour l'email
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
              ),
              SizedBox(height: 8.0),
              // Champ de saisie pour l'email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Entrez votre email',
                  suffixIcon: Icon(Icons.alternate_email,
                      color: Colors.deepPurple), // Icone '@' à la fin
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24.0),
              // Label pour le mot de passe
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mot de passe',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
              ),
              SizedBox(height: 8.0),
              // Champ de saisie pour le mot de passe
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Entrez votre mot de passe',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.deepPurple,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ), // Icone œil pour basculer la visibilité du mot de passe
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                obscureText: _obscureText,
              ),
              SizedBox(height: 24.0),
              // Bouton de connexion stylisé
              ElevatedButton(
                onPressed: _login,
                child: Text('Se connecter'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple, // Couleur du texte du bouton
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5, // Ombre pour le bouton
                ),
              ),
              SizedBox(height: 16.0),
              // Texte pour la création de compte avec style
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Vous ne disposez pas de compte ? ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: 'Créer un compte',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Ajouter la navigation vers la page de création de compte
                          Navigator.pushNamed(context, '/signup');
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // Espace supplémentaire en bas
            ],
          ),
        ),
      ),
    );
  }
}

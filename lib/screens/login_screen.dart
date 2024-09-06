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
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // AppBar avec logo centré
          Container(
            height: 200, // Hauteur fixe pour l'AppBar
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30.0),
              ),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 50, // Taille du logo circulaire
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/logo2.png',
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
            ),
          ),
          // Espace pour centrer le contenu de connexion
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 50), // Ajout d'un espace avant le formulaire
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    hintText: 'Entrez votre email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.0),
                  _buildPasswordField(
                    controller: _passwordController,
                    label: 'Mot de passe',
                    hintText: 'Entrez votre mot de passe',
                    obscureText: _obscureText,
                    toggleVisibility: _togglePasswordVisibility,
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Se connecter'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Vous n\'avez pas de compte ? ',
                          style: TextStyle(color: Colors.black54, fontSize: 16),
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
                              Navigator.pushNamed(context, '/signup');
                            },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(12.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.deepPurple),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(12.0),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.deepPurple,
              ),
              onPressed: toggleVisibility,
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/services/auth_service.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'apprenant'; // Rôle par défaut
  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _passwordObscureText = !_passwordObscureText;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _confirmPasswordObscureText = !_confirmPasswordObscureText;
    });
  }

  Future<void> _register() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      bool success = await _authService.registerWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _selectedRole,
      );
      if (success) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'inscription')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Email',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Entrez votre email',
                suffixIcon: Icon(Icons.alternate_email, color: Colors.deepPurple),
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
            Text(
              'Mot de passe',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Entrez votre mot de passe',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordObscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.deepPurple,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              obscureText: _passwordObscureText,
            ),
            SizedBox(height: 24.0),
            Text(
              'Confirmez le mot de passe',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                hintText: 'Confirmez votre mot de passe',
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordObscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.deepPurple,
                  ),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              obscureText: _confirmPasswordObscureText,
            ),
            SizedBox(height: 24.0),
            DropdownButton<String>(
              value: _selectedRole,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue!;
                });
              },
              items: <String>['apprenant', 'formateur', 'administrateur']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _register,
              child: Text('S\'inscrire'),
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
                    text: 'Vous avez déjà un compte ? ',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  TextSpan(
                    text: 'Se connecter',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/login');
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedRole = 'apprenant';
  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;
  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
    _confirmPasswordController.addListener(_validateFields);
    _fullNameController.addListener(_validateFields);
    _phoneController.addListener(_validateFields);
  }

  void _validateFields() {
    setState(() {
      _isButtonActive = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _fullNameController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty;
    });
  }

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
        _fullNameController.text,
        _phoneController.text,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compte créé avec succès')),
        );
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

  String? _validatePhoneNumber(String? value) {
    final phonePattern = r'^\+?[0-9]{10,15}$';
    final regExp = RegExp(phonePattern);
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un numéro de téléphone';
    } else if (!regExp.hasMatch(value)) {
      return 'Veuillez entrer un numéro valide';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0),
          ),
        ),
        toolbarHeight: 150, // Augmente la hauteur pour le logo
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    'assets/images/logo2.png',
                    width: 90, // Ajustez la largeur du logo
                    height: 90,
                  ),
                ),
              ),
              SizedBox(height: 10), // Espace entre le logo et le texte
              Text(
                'Créer votre compte',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10), // l'espace en haut
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Nom complet',
                  hintText: 'Entrez votre nom complet',
                  icon: Icons.person,
                ),
                SizedBox(height: 4.0), // l'espace entre les champs
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Entrez votre email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 4.0), // l'espace entre les champs
                _buildPasswordField(
                  controller: _passwordController,
                  label: 'Mot de passe',
                  hintText: 'Entrez votre mot de passe',
                  obscureText: _passwordObscureText,
                  toggleVisibility: _togglePasswordVisibility,
                ),
                SizedBox(height: 4.0), // l'espace entre les champs
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirmez le mot de passe',
                  hintText: 'Confirmez votre mot de passe',
                  obscureText: _confirmPasswordObscureText,
                  toggleVisibility: _toggleConfirmPasswordVisibility,
                ),
                SizedBox(height: 4.0), // Réduit l'espace entre les champs
                _buildTextField(
                  controller: _phoneController,
                  label: 'Numéro de téléphone',
                  hintText: 'Entrez votre numéro de téléphone',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 4.0), // l'espace entre les champs
                _buildRoleDropdown(),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, 
                  child: _buildRegisterButton(),
                ),
                SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Vous avez déjà un compte ? ',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      TextSpan(
                        text: 'Connectez-vous',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
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

  Widget _buildRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(12.0),
        child: DropdownButtonFormField<String>(
          value: _selectedRole,
          onChanged: (String? newValue) {
            setState(() {
              _selectedRole = newValue!;
            });
          },
          items: <String>['apprenant', 'formateur']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.deepPurple)),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: 'Rôle',
            prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _isButtonActive ? _register : null,
      child: Text('S\'inscrire', style: TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(vertical: 14.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}

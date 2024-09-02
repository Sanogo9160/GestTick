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
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedRole = 'apprenant';
  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;
  bool _isButtonActive = false;  // Variable pour contrôler l'état du bouton

  @override
  void initState() {
    super.initState();
    // Ajouter des écouteurs pour surveiller les changements dans les champs de texte
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
    _confirmPasswordController.addListener(_validateFields);
    _fullNameController.addListener(_validateFields);
    _phoneController.addListener(_validateFields);
  }

  // Fonction pour valider les champs et mettre à jour l'état du bouton
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

  // Fonction pour valider le numéro de téléphone
  String? _validatePhoneNumber(String? value) {
    final phonePattern = r'^\+?[0-9]{10,15}$'; // Exemple de pattern pour un numéro international
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
        title: Text('Inscription'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildTextField(
              controller: _fullNameController,
              label: 'Nom complet',
              hintText: 'Entrez votre nom complet',
              icon: Icons.person,
            ),
            SizedBox(height: 16.0),
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
              obscureText: _passwordObscureText,
              toggleVisibility: _togglePasswordVisibility,
            ),
            SizedBox(height: 16.0),
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirmez le mot de passe',
              hintText: 'Confirmez votre mot de passe',
              obscureText: _confirmPasswordObscureText,
              toggleVisibility: _toggleConfirmPasswordVisibility,
            ),
            SizedBox(height: 16.0),
            // Utiliser TextFormField pour validation
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Numéro de téléphone',
                hintText: 'Entrez votre numéro de téléphone',
                prefixIcon: Icon(Icons.phone, color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: _validatePhoneNumber,
            ),
            SizedBox(height: 16.0),
            Text(
              'Rôle',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
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
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildRegisterButton(),
          ],
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
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return GestureDetector(
      onTap: _isButtonActive ? _register : null,  // Désactiver l'action si le bouton est désactivé
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
          gradient: _isButtonActive
              ? LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],  // Couleur active
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : LinearGradient(
                  colors: [Colors.grey, Colors.grey.shade400],  // Couleur désactivée
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Text(
            'S\'inscrire',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

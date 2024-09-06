import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  bool _newPasswordObscureText = true;
  bool _confirmNewPasswordObscureText = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _newPasswordObscureText = !_newPasswordObscureText;
    });
  }

  void _toggleConfirmNewPasswordVisibility() {
    setState(() {
      _confirmNewPasswordObscureText = !_confirmNewPasswordObscureText;
    });
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>?; 
          if (data != null) {
            setState(() {
              _fullNameController.text = data['fullName'] ?? '';
              _emailController.text = data['email'] ?? '';
              _phoneController.text = data['phone'] ?? '';
            });
          } else {
            print('Les données du document sont nulles.');
          }
        } else {
          print('Le document n\'existe pas.');
        }
      } catch (e) {
        print('Erreur lors de la récupération des données utilisateur : $e');
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'fullName': _fullNameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
          });

          if (_newPasswordController.text.isNotEmpty &&
              _newPasswordController.text == _confirmNewPasswordController.text) {
            try {
              final credential = EmailAuthProvider.credential(
                email: user.email!,
                password: _currentPasswordController.text,
              );

              await user.reauthenticateWithCredential(credential);
              await user.updatePassword(_newPasswordController.text);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mot de passe mis à jour')));
            } catch (e) {
              print('Erreur lors de la ré-authentification ou de la mise à jour : $e');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la mise à jour du mot de passe')));
            }
          } else if (_newPasswordController.text.isNotEmpty || _confirmNewPasswordController.text.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Les mots de passe ne correspondent pas')));
          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profil mis à jour')));
        } catch (e) {
          print('Erreur lors de la mise à jour du profil : $e');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la mise à jour')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
      ),
      body: SingleChildScrollView( // Ajout du scroll
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Informations personnelles',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.deepPurple),
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _fullNameController,
                label: 'Nom et Prenom',
                enabled: _isEditing,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
                enabled: _isEditing,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _phoneController,
                label: 'Numéro de téléphone',
                keyboardType: TextInputType.phone,
                enabled: _isEditing,
              ),
              SizedBox(height: 16.0),
              if (_isEditing) 
                _buildPasswordField(
                  controller: _currentPasswordController,
                  label: 'Mot de passe actuel',
                  obscureText: true,
                  toggleVisibility: () {  },
                ),
              SizedBox(height: 16.0),
              if (_isEditing) 
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: 'Nouveau mot de passe',
                  obscureText: _newPasswordObscureText,
                  toggleVisibility: _toggleNewPasswordVisibility,
                ),
              SizedBox(height: 16.0),
              if (_isEditing) 
                _buildPasswordField(
                  controller: _confirmNewPasswordController,
                  label: 'Confirmer le nouveau mot de passe',
                  obscureText: _confirmNewPasswordObscureText,
                  toggleVisibility: _toggleConfirmNewPasswordVisibility,
                ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (!_isEditing) 
                    TextButton.icon(
                      icon: Icon(Icons.edit, color: Colors.deepPurple),
                      label: Text("Modifier"),
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                    ),
                  if (_isEditing)
                    TextButton.icon(
                      icon: Icon(Icons.cancel, color: Colors.redAccent),
                      label: Text("Annuler"),
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                          _loadUserData(); 
                        });
                      },
                    ),
                  if (_isEditing)
                    TextButton.icon(
                      icon: Icon(Icons.save, color: Colors.green),
                      label: Text("Enregistrer"),
                      onPressed: _saveProfile,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      enabled: enabled,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
      obscureText: obscureText,
    );
  }
}

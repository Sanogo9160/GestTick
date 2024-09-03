import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:gesttick/providers/user_provider.dart'; 


class CreateTicketScreen extends StatefulWidget {
  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _category = 'Technique'; // Catégorie par défaut
  String _status = 'Attente'; // Statut initial par défaut

  void _submit() async {
    // Vérification que tous les champs sont remplis
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs obligatoires.')),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final studentId = userProvider.user?.uid ?? '';

    if (studentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur utilisateur : ID apprenant non trouvé.')),
      );
      return;
    }

    final ticket = Ticket(
      id: '', // Généré automatiquement par Firestore
      title: _titleController.text,
      description: _descriptionController.text,
      status: _status,
      category: _category,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      studentId: studentId,
      trainerId: '', // Vide initialement
    );

    try {
      await _firestoreService.addTicket(ticket);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création du ticket : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTextField(_titleController, 'Titre'),
            SizedBox(height: 8.0),
            _buildTextField(_descriptionController, 'Description', maxLines: 5),
            SizedBox(height: 8.0),
            _buildCategoryDropdown(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Soumettre'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _category,
      items: <String>['Technique', 'Pédagogique', 'Autre']
          .map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _category = newValue!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Catégorie',
        border: OutlineInputBorder(),
      ),
    );
  }
}

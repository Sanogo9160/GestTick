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
  final _categoryController = TextEditingController();
  String _status = 'Attente'; // Default status, managed dynamically

  void _submit() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final studentId = userProvider.user?.uid ?? 'currentUserId'; // Replace with actual student ID

    final ticket = Ticket(
      id: '', // Auto-generated by Firestore
      title: _titleController.text,
      description: _descriptionController.text,
      status: _status,
      category: _categoryController.text,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      studentId: studentId,
      trainerId: '', // Initially empty
    );

    await _firestoreService.addTicket(ticket);
    Navigator.pop(context);
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
            _buildTextField(_categoryController, 'Catégorie'),
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
}

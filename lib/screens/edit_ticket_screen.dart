import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/services/firestore_service.dart';

class EditTicketScreen extends StatelessWidget {
  final Ticket ticket;
  final FirestoreService _firestoreService = FirestoreService();

  EditTicketScreen({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController(text: ticket.title);
    final _descriptionController = TextEditingController(text: ticket.description);
    final _categoryController = TextEditingController(text: ticket.category);
    String _status = ticket.status;

  void _submit() async {
  final updatedTicket = ticket.copyWith(
    title: _titleController.text,
    description: _descriptionController.text,
    category: _categoryController.text,
    status: _status,
    updatedAt: Timestamp.now(),
  );

  await _firestoreService.updateTicket(updatedTicket);
  Navigator.pop(context);
}


    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Ticket'),
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
              child: Text('Enregistrer'),
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

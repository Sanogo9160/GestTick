import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/services/firestore_service.dart';

class EditTicketScreen extends StatelessWidget {
  final Ticket? ticket; // Ticket optionnel
  final FirestoreService _firestoreService = FirestoreService();

  EditTicketScreen({this.ticket});

  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController(text: ticket?.title ?? '');
    final _descriptionController = TextEditingController(text: ticket?.description ?? '');
    final _categoryController = TextEditingController(text: ticket?.category ?? '');
    String _status = ticket?.status ?? 'Non Résolu'; // Valeur par défaut si aucun ticket

    void _submit() async {
      final updatedTicket = Ticket(
        id: ticket?.id ?? '', // Utiliser un ID vide si aucun ticket n'est fourni
        title: _titleController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        status: _status,
        createdAt: ticket?.createdAt ?? Timestamp.now(),
        updatedAt: Timestamp.now(),
        studentId: ticket?.studentId ?? '',
        trainerId: ticket?.trainerId ?? '',
      );

      if (ticket != null) {
        // Mise à jour si un ticket existant est fourni
        await _firestoreService.updateTicket(updatedTicket);
      } else {
        // Création d'un nouveau ticket
        await _firestoreService.addTicket(updatedTicket);
      }
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(ticket == null ? 'Ajouter Ticket' : 'Modifier Ticket'),
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
              child: Text(ticket == null ? 'Ajouter' : 'Enregistrer'),
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

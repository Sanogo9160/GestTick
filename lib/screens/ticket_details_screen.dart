import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gesttick/services/firestore_service.dart';

class TicketDetailScreen extends StatefulWidget {
  final Ticket ticket;

  TicketDetailScreen({required this.ticket});

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Ticket'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildDetailRow(
                        icon: Icons.title,
                        title: 'Titre',
                        content: widget.ticket.title ?? 'Inconnu',
                      ),
                      _buildDetailRow(
                        icon: Icons.description,
                        title: 'Description',
                        content: widget.ticket.description ?? 'Aucune description',
                      ),
                      _buildDetailRow(
                        icon: Icons.category,
                        title: 'Catégorie',
                        content: widget.ticket.category ?? 'Aucune catégorie',
                      ),
                      _buildDetailRow(
                        icon: Icons.assignment_turned_in,
                        title: 'Statut',
                        content: widget.ticket.status ?? 'Inconnu',
                      ),
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        title: 'Date de Création',
                        content: _formatDate(widget.ticket.createdAt),
                      ),
                      _buildDetailRow(
                        icon: Icons.update,
                        title: 'Date de Mise à Jour',
                        content: _formatDate(widget.ticket.updatedAt),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // section pour afficher les réponses du formateur
              Text('Réponses du Formateur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 8.0),
              // Utilisation de StreamBuilder pour écouter les mises à jour en temps réel
              StreamBuilder<List<String>>(
                stream: _firestoreService.getResponsesForTicket(widget.ticket.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final responses = snapshot.data ?? [];

                  return responses.isEmpty
                      ? Text('Aucune réponse pour l\'instant.')
                      : ListView.builder(
                          shrinkWrap: true, // Cela permet d'ajuster la hauteur en fonction du contenu
                          physics: NeverScrollableScrollPhysics(), // Pour que le ListView ne scrolle pas indépendamment
                          itemCount: responses.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: Icon(Icons.message, color: Colors.deepPurple),
                                title: Text(responses[index]),
                              ),
                            );
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.deepPurple),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(content),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Inconnu';
    DateTime date = timestamp.toDate();
    return '${date.toLocal().toString().split(' ')[0]} à ${date.toLocal().toString().split(' ')[1].substring(0, 5)}';
  }
}

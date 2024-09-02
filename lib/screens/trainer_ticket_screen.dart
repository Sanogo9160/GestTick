import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/providers/user_provider.dart';
import 'package:gesttick/screens/edit_ticket_screen.dart';
import 'package:gesttick/screens/ticket_details_screen.dart';
import 'package:gesttick/services/firestore_service.dart';
import 'package:gesttick/widgets/ticket_card.dart';
import 'package:provider/provider.dart';

class TrainerTicketScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final trainerId = userProvider.user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Répondre aux Tickets'),
      ),
      body: StreamBuilder<List<Ticket>>(
        stream: _firestoreService.getTicketsForTrainer(trainerId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des tickets'));
          }

          final tickets = snapshot.data?.where((ticket) => ticket.status != 'resolved').toList() ?? [];

          if (tickets.isEmpty) {
            return Center(child: Text('Aucun ticket à afficher.'));
          }

          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return TicketCard(
                ticket: tickets[index],
                onTap: () {},
                onView: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketDetailScreen(ticket: tickets[index]),
                    ),
                  );
                },
                onEdit: () {
                  // Optionnel, selon vos besoins
                },
                onDelete: () async {
                  // Optionnel, selon vos besoins
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showResponseDialog(BuildContext context, Ticket ticket) {
    final TextEditingController responseController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une réponse'),
          content: TextField(
            controller: responseController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Écrire une réponse...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Envoyer'),
              onPressed: () async {
                if (responseController.text.isNotEmpty) {
                  await _firestoreService.addResponseToTicket(ticket.id, responseController.text, ticket.trainerId!);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

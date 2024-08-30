import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/services/firestore_service.dart';
import 'package:gesttick/widgets/ticket_card.dart';

class HomeScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion de Tickets'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Ajoutez ici votre logique de déconnexion
              print("Déconnexion de l'utilisateur");
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Ticket>>(
        stream: _firestoreService.getTickets(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final tickets = snapshot.data!;
          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return TicketCard(
                ticket: tickets[index],
                onTap: () {
                  // Actions à effectuer lors de la sélection d'un ticket
                  print('Ticket sélectionné : ${tickets[index].title}');
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logique pour ajouter un nouveau ticket
          print('Ajouter un nouveau ticket');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/services/firestore_service.dart';
import 'package:gesttick/widgets/ticket_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedIndex = 0; // Index for bottom navigation bar

  // List of ticket statuses
  List<Ticket> _tickets = [];

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Tickets'),
              onTap: () {
                // Handle profile navigation
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Notification'),
              onTap: () {
                // Handle help navigation
                Navigator.pop(context);
              },
            ),

            ListTile(
              title: Text('Rapport'),
              onTap: () {
                // Handle help navigation
                Navigator.pop(context);
              },
            ),

            ListTile(
              title: Text('Chat'),
              onTap: () {
                // Handle help navigation
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Profil'),
              onTap: () {
                // Handle settings navigation
                Navigator.pop(context);
              },
            ),

            ListTile(
              title: Text('Se deconnecter'),
              onTap: () {
                // Handle settings navigation
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
      body: StreamBuilder<List<Ticket>>(
        stream: _firestoreService.getTickets(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          _tickets = snapshot.data!;

          switch (_selectedIndex) {
            case 0:
              return ListView.builder(
                itemCount: _tickets.length,
                itemBuilder: (context, index) {
                  return TicketCard(
                    ticket: _tickets[index],
                    onTap: () {
                      // Actions à effectuer lors de la sélection d'un ticket
                      print('Ticket sélectionné : ${_tickets[index].title}');
                    },
                  );
                },
              );
            case 1:
              // Filter and display tickets based on status
              final inProgressTickets = _tickets.where((ticket) => ticket.status == 'En cours').toList();
              return ListView.builder(
                itemCount: inProgressTickets.length,
                itemBuilder: (context, index) {
                  return TicketCard(
                    ticket: inProgressTickets[index],
                    onTap: () {
                      // Actions à effectuer lors de la sélection d'un ticket
                      print('Ticket sélectionné : ${inProgressTickets[index].title}');
                    },
                  );
                },
              );
            case 2:
              // Sort and display recent tickets
              final recentTickets = _tickets.where((ticket) => ticket.isRecent()).toList();
              return ListView.builder(
                itemCount: recentTickets.length,
                itemBuilder: (context, index) {
                  return TicketCard(
                    ticket: recentTickets[index],
                    onTap: () {
                      // Actions à effectuer lors de la sélection d'un ticket
                      print('Ticket sélectionné : ${recentTickets[index].title}');
                    },
                  );
                },
              );
            default:
              return Center(child: Text('Sélectionnez une option'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Voir mes tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem),
            label: 'Tickets en cours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'Tickets récents',
          ),
        ],
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

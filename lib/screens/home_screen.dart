import 'package:flutter/material.dart';
import 'package:gesttick/screens/ticket_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/services/firestore_service.dart';
import 'package:gesttick/screens/create_ticket_screen.dart';
import 'package:gesttick/screens/edit_ticket_screen.dart';
import 'package:gesttick/providers/user_provider.dart';
import 'package:gesttick/screens/trainer_ticket_screen.dart'; // Import the trainer ticket screen
import 'package:gesttick/widgets/ticket_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedIndex = 0; // Index for bottom navigation bar
  List<Ticket> _tickets = []; // List of tickets

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion de Tickets'),
      ),
      drawer: _buildDrawer(userProvider),
      body: _buildBody(userProvider.role ?? 'apprenant'), // Provide default value if role is null
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTicketScreen()),
          ).then((_) => _refreshTickets()); // Refresh tickets after creating a new one
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Method to build the drawer
  Widget _buildDrawer(UserProvider userProvider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo2.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 10),
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Tickets'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          if (userProvider.role == 'administrateur') ...[
            ListTile(
              leading: Icon(Icons.assessment),
              title: Text('Rapport'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Gestion des utilisateurs'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
          if (userProvider.role == 'formateur') ...[
            ListTile(
              leading: Icon(Icons.reply_all),
              title: Text('Répondre aux tickets'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainerTicketScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chat'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profil'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Se déconnecter'),
            onTap: () async {
              await userProvider.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }

  // Method to build the bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }

  // Build body content based on user role
  Widget _buildBody(String role) {
    return StreamBuilder<List<Ticket>>(
      stream: _firestoreService.getTicketsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        _tickets = snapshot.data!;

        switch (role) {
          case 'administrateur':
            return _buildAdminDashboard();
          case 'formateur':
            return _buildTrainerDashboard();
          case 'apprenant':
            return _buildStudentDashboard();
          default:
            return Center(child: Text('Rôle non reconnu'));
        }
      },
    );
  }

  // Admin Dashboard
  Widget _buildAdminDashboard() {
    return _buildTicketList(_tickets);
  }

  // Trainer Dashboard
  Widget _buildTrainerDashboard() {
    // Optionally filter tickets for trainers
    return _buildTicketList(_tickets);
  }

  // Student Dashboard
  Widget _buildStudentDashboard() {
    final recentTickets = _tickets.where((ticket) => ticket.isRecent()).toList();
    return _buildTicketList(recentTickets);
  }

  // Method to build a list of tickets with TicketCard widget
  Widget _buildTicketList(List<Ticket> tickets) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return TicketCard(
                ticket: tickets[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketDetailScreen(ticket: tickets[index]),
                    ),
                  );
                },
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTicketScreen(ticket: tickets[index]),
                    ),
                  ).then((_) => _refreshTickets()); // Refresh tickets after editing
                },
                onDelete: () async {
                  try {
                    await _firestoreService.deleteTicket(tickets[index].id);
                    _refreshTickets(); // Refresh tickets after deletion
                  } catch (e) {
                    print('Error deleting ticket: $e');
                  }
                },
                onView: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketDetailScreen(ticket: tickets[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Refresh the list of tickets
  void _refreshTickets() {
    setState(() {});
  }
}

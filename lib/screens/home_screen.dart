import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/screens/User_management_screen.dart';
import 'package:gesttick/screens/ViewTicketsScreen.dart';
import 'package:gesttick/screens/chat_screen.dart';
import 'package:gesttick/screens/notifications_screen.dart';
import 'package:gesttick/screens/report_screen.dart';
import 'package:gesttick/screens/ticket_answers_Screen.dart';
import 'package:gesttick/screens/ticket_details_screen.dart';
import 'package:gesttick/screens/create_ticket_screen.dart';
import 'package:gesttick/screens/edit_ticket_screen.dart'; 
import 'package:gesttick/screens/profile_screen.dart'; 
import 'package:gesttick/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:gesttick/providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  List<Ticket> _recentTickets = [];
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _fetchRecentTickets();
  }

  Future<void> _fetchRecentTickets() async {
    try {
      final tickets = await _firestoreService.searchTickets(_searchQuery); // Adjust the query as needed
      setState(() {
        _recentTickets = tickets;
      });
    } catch (e) {
      print('Error fetching recent tickets: $e');
    }
  }

  Future<void> _deleteTicket(String ticketId) async {
    try {
      await _firestoreService.deleteTicket(ticketId);
      _refreshTickets();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du ticket : $e')),
      );
    }
  }

  void _updateTicketStatus(String ticketId, String status) async {
    try {
      await FirestoreService().updateTicketStatus(ticketId, status);
      // Vous pouvez ajouter une notification ou une mise à jour de l'UI ici
    } catch (e) {
      print('Erreur lors de la mise à jour du statut : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  width: 250,
                  child: TextField(
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                        _fetchRecentTickets(); // Fetch tickets based on the search query
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(horizontal: 70.0),
                      isDense: true,
                    ),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                if (userProvider.role != 'formateur') // Hide if user is a formateur
                  Tooltip(
                    message: 'Soumettre un ticket',
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateTicketScreen()),
                        ).then((_) => _refreshTickets());
                      },
                      child: Icon(Icons.add, color: Colors.white),
                      backgroundColor: Colors.deepPurple,
                      elevation: 8.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(userProvider),
      body: _recentTickets.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _recentTickets.length,
              itemBuilder: (context, index) {
                final ticket = _recentTickets[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      ticket.title ?? 'No Title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ticket.description ?? 'No Description'),
                        SizedBox(height: 8.0),
                        Text(
                          'Statut: ${ticket.status ?? 'Unknown'}',
                          style: TextStyle(color: Colors.blueGrey[800]),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Date de création: ${ticket.createdAt?.toDate().toLocal().toString().split(' ')[0] ?? 'Unknown'}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (ticket.status == 'Résolu') // Show chat icon if ticket is resolved
                          IconButton(
                            icon: Icon(Icons.chat),
                            color: Colors.deepPurple,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          ticket: ticket,
                                          receiverId: '',
                                          receiverName: '',
                                          ticketId: '',
                                        )), // Navigate to ChatScreen
                              );
                            },
                          ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            _handleAction(value, ticket);
                          },
                          itemBuilder: (BuildContext context) {
                            final role = userProvider.role ?? 'guest'; // Default to 'guest' or any other default role
                            return _buildActionsForUser(role).map((action) {
                              return PopupMenuItem<String>(
                                value: action['value'],
                                child: Row(
                                  children: [
                                    Icon(action['icon'], color: Colors.deepPurple),
                                    SizedBox(width: 8.0),
                                    Text(action['label']),
                                  ],
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  List<Map<String, dynamic>> _buildActionsForUser(String role) {
    final actions = [
      if (role != 'formateur') ...[
        {'icon': Icons.edit, 'label': 'Modifier', 'value': 'edit'},
        {'icon': Icons.delete, 'label': 'Supprimer', 'value': 'delete'},
      ],
      {
        'icon': Icons.visibility,
        'label': 'Voir détails',
        'value': 'view_details'
      },
      if (role == 'formateur') ...[
        {
          'icon': Icons.assignment_turned_in,
          'label': 'Reprendre en charge',
          'value': 'take_charge'
        },
        {'icon': Icons.reply, 'label': 'Traiter', 'value': 'reply'},
      ],
    ];
    return actions;
  }

  void _handleAction(String action, Ticket ticket) {
    switch (action) {
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditTicketScreen(ticket: ticket)),
        ).then((_) => _fetchRecentTickets()); // Refresh the tickets after editing
        break;
      case 'delete':
        _deleteTicket(ticket.id); // Delete ticket
        break;
      case 'view_details':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TicketDetailScreen(ticket: ticket)), // Navigate to TicketDetailScreen
        );
        break;
      case 'take_charge':
        _updateTicketStatus(ticket.id, 'En cours'); // Mise à jour du statut à "En cours"
        break;
      case 'reply':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TicketAnswersScreen(ticket: ticket)),
        );
        break;
      default:
        break;
    }
  }

  Widget _buildDrawer(UserProvider userProvider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/logo2.png',
                width: 120,
                height: 100,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Voir tickets'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewTicketsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.report),
            title: Text('Rapports'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportScreen()),
              );
            },
          ),
          if (userProvider.role == 'formateur') // Show this menu item only for formateurs
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Gestion des utilisateurs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagementScreen()),
                );
              },
            ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Déconnexion'),
            onTap: () {
              // Implement logout functionality here
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _refreshTickets() {
    setState(() {
      _fetchRecentTickets();
    });
  }
}

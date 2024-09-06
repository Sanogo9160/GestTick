import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:gesttick/providers/user_provider.dart';

class ViewTicketsScreen extends StatefulWidget {
  @override
  _ViewTicketsScreenState createState() => _ViewTicketsScreenState();
}

class _ViewTicketsScreenState extends State<ViewTicketsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final ScrollController _scrollController = ScrollController();
  List<Ticket> _tickets = [];
  bool _hasMore = true;
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchTickets() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Récupération de l'utilisateur connecté
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final studentId = userProvider.user?.uid ?? 'currentUserId'; // Remplacer par l'ID réel

      // Appel au service Firestore pour récupérer les tickets
      final result = await _firestoreService.getTicketsForStudent(studentId, _lastDocument);
      
      List<Ticket> tickets = result['tickets'] as List<Ticket>;
      DocumentSnapshot? lastDocument = result['lastDocument'] as DocumentSnapshot?;

      setState(() {
        if (tickets.isEmpty) {
          _hasMore = false;
        } else {
          _lastDocument = lastDocument;
          _tickets.addAll(tickets);
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching tickets: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMore) {
      _fetchTickets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Tickets'),
      ),
      body: _isLoading && _tickets.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _tickets.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _tickets.length) {
                  return Center(child: CircularProgressIndicator());
                }

                final ticket = _tickets[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre
                        Text(
                          ticket.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        
                        // Description
                        Text(
                          ticket.description,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),

                        Divider(),

                        // Statut et catégorie
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Statut: ${ticket.status}',
                              style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              'Catégorie: ${ticket.category}',
                              style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),

                        // Date de création
                        Text(
                          'Créé le: ${_formatDate(ticket.createdAt)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Méthode pour formater la date
  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    try {
      QuerySnapshot snapshot = await _db.collection('users').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Ajouter l'ID du document manuellement
        return data;
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des utilisateurs : $e');
      return [];
    }
  }

  Future<void> _approveUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).update({'status': 'approuvé'});
      setState(() {}); // Rafraîchir l'UI
    } catch (e) {
      print('Erreur lors de l\'approbation de l\'utilisateur : $e');
    }
  }

  Future<void> _disapproveUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).update({'status': 'désapprouvé'});
      setState(() {}); // Rafraîchir l'UI
    } catch (e) {
      print('Erreur lors de la désapprobation de l\'utilisateur : $e');
    }
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
      setState(() {}); // Rafraîchir l'UI
    } catch (e) {
      print('Erreur lors de la suppression de l\'utilisateur : $e');
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context, String userId, String action) async {
    String message;
    String title;

    switch (action) {
      case 'approve':
        title = 'Approuver l\'utilisateur';
        message = 'Voulez-vous vraiment approuver cet utilisateur ?';
        break;
      case 'disapprove':
        title = 'Désapprouver l\'utilisateur';
        message = 'Voulez-vous vraiment désapprouver cet utilisateur ?';
        break;
      case 'delete':
        title = 'Supprimer l\'utilisateur';
        message = 'Voulez-vous vraiment supprimer cet utilisateur ?';
        break;
      default:
        return;
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmer'),
              onPressed: () {
                Navigator.of(context).pop();
                if (action == 'approve') {
                  _approveUser(userId);
                } else if (action == 'disapprove') {
                  _disapproveUser(userId);
                } else if (action == 'delete') {
                  _deleteUser(userId);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Utilisateurs'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors de la récupération des utilisateurs'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun utilisateur trouvé'));
          }

          List<Map<String, dynamic>> users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> user = users[index];

              String userId = user['id'] ?? 'ID inconnu';
              String userName = user['fullName'] ?? 'Nom inconnu';
              String userStatus = user['status'] ?? 'Statut inconnu';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                    backgroundColor: Colors.deepPurple,
                  ),
                  title: Text(userName),
                  subtitle: Text('Statut : $userStatus'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (userStatus == 'approuvé')
                        IconButton(
                          icon: Icon(Icons.block, color: Colors.orange),
                          onPressed: () => _showConfirmationDialog(context, userId, 'disapprove'),
                          tooltip: 'Désapprouver',
                        ),
                      if (userStatus != 'approuvé')
                        IconButton(
                          icon: Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () => _showConfirmationDialog(context, userId, 'approve'),
                          tooltip: 'Approuver',
                        ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showConfirmationDialog(context, userId, 'delete'),
                        tooltip: 'Supprimer',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

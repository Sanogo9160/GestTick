import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';
import 'package:gesttick/services/firestore_service.dart';

class TicketAnswersScreen extends StatefulWidget {
  final Ticket ticket;

  TicketAnswersScreen({required this.ticket});

  @override
  _TicketAnswersScreenState createState() => _TicketAnswersScreenState();
}

class _TicketAnswersScreenState extends State<TicketAnswersScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _responseController = TextEditingController();
  late Ticket _ticket;
  int? _editingResponseIndex;

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
  }

  void _submitResponse() async {
    try {
      final response = _responseController.text;
      if (response.isNotEmpty) {
        if (_editingResponseIndex != null) {
          // Update existing response
          await _firestoreService.updateResponse(_ticket.id, _editingResponseIndex!, response);
        } else {
          // Add new response
          await _firestoreService.addReplyToTicket(_ticket.id, response);
        }
        _responseController.clear();
        setState(() {
          _editingResponseIndex = null;
        });
        Navigator.pop(context); // Close screen after submission
      }
    } catch (e) {
      print('Error submitting response: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting response')),
      );
    }
  }

  void _deleteResponse(int index) async {
    try {
      await _firestoreService.deleteResponseFromTicket(_ticket.id, index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Response deleted')),
      );
    } catch (e) {
      print('Error deleting response: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting response')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail du Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Titre: ${_ticket.title ?? 'No Title'}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text('Description: ${_ticket.description ?? 'No Description'}'),
            SizedBox(height: 16.0),
            Text('Réponses:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: StreamBuilder<List<String>>(
                stream: _firestoreService.getResponsesForTicket(_ticket.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final responses = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: responses.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(responses[index]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _responseController.text = responses[index];
                                setState(() {
                                  _editingResponseIndex = index;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteResponse(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: _responseController,
              decoration: InputDecoration(
                labelText: 'Votre réponse',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitResponse,
              child: Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }
}

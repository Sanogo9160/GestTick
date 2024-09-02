import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onTap;
  final VoidCallback onEdit; // Callback for editing ticket
  final VoidCallback onDelete; // Callback for deleting ticket
  final VoidCallback onView; // Callback for viewing ticket

  TicketCard({
    required this.ticket,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ticket title and actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      ticket.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: onEdit, // Appeler le callback de modification
                        tooltip: 'Modifier',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete, // Appeler le callback de suppression
                        tooltip: 'Supprimer',
                      ),
                      IconButton(
                        icon: Icon(Icons.visibility, color: Colors.green),
                        onPressed: onView, // Appeler le callback de visualisation
                        tooltip: 'Voir',
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              
              // Ticket description
              Text(
                ticket.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              
              // Ticket category and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category
                  Chip(
                    label: Text(ticket.category),
                    backgroundColor: Colors.blue[100],
                  ),
                  
                  // Status
                  Text(
                    ticket.status,
                    style: TextStyle(
                      color: ticket.status == 'Résolu' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              // Creation date
              Text(
                'Créé le: ${formatTimestamp(ticket.createdAt)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to format Firestore Timestamp
  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}

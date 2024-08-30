import 'package:flutter/material.dart';
import 'package:gesttick/models/ticket.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onTap;

  const TicketCard({
    required this.ticket,
    required this.onTap,
  }) : assert(ticket != null),
       assert(onTap != null);

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
              // Titre du ticket
              Text(
                ticket.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

              // Description du ticket
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

              // Catégorie et Statut du ticket
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Catégorie
                  Chip(
                    label: Text(ticket.category),
                    backgroundColor: Colors.blue[100],
                  ),

                  // Statut
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

              // Date de création
              Text(
                'Créé le: ${ticket.createdAt.toLocal()}',
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
}

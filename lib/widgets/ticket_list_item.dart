// lib/widgets/ticket_list_item.dart
import 'package:flutter/material.dart';

class TicketListItem extends StatelessWidget {
  final String title;
  final String status;
  final VoidCallback onTap;

  TicketListItem({
    required this.title,
    required this.status,
    required this.onTap, required ticket,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('Statut: $status'),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}

import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Erreur'),
      ),
      body: Center(
        child: Text('Page non trouvée'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gesttick/models/report_generator.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Générer un Rapport'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final startDate = DateTime(2024, 1, 1); // Modifier selon la période souhaitée
            final endDate = DateTime(2024, 12, 31);  // Modifier selon la période souhaitée

            final reportGenerator = ReportGenerator();
            await reportGenerator.generateReport(startDate, endDate);
            
          },
          child: Text('Générer le Rapport'),
        ),
      ),
    );
  }
}

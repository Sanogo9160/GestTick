import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class ReportGenerator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> generateReport(DateTime startDate, DateTime endDate) async {
    final pdf = pw.Document();
    final ticketsCollection = _firestore.collection('tickets');

    // Récupération des tickets résolus dans la période donnée
    final querySnapshot = await ticketsCollection
        .where('status', isEqualTo: 'Résolu')
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .where('createdAt', isLessThanOrEqualTo: endDate)
        .get();

    final tickets = querySnapshot.docs.map((doc) => doc.data()).toList();

    // Ajout des tickets au PDF
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Rapport des Tickets Résolus', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              data: [
                ['ID', 'Titre', 'Description', 'Catégorie', 'Date de Création'],
                ...tickets.map((ticket) => [
                  ticket['id'] ?? 'N/A',
                  ticket['title'] ?? 'N/A',
                  ticket['description'] ?? 'N/A',
                  ticket['category'] ?? 'N/A',
                  _formatDate(ticket['createdAt']) ?? 'N/A',
                ]),
              ],
            ),
          ],
        );
      },
    ));

    // Enregistrement du PDF
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/ticket_report.pdf');
    await file.writeAsBytes(await pdf.save());

    print('Rapport généré avec succès : ${file.path}');
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }
  
  getTemporaryDirectory() {}
}

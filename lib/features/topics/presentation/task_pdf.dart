import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

typedef PdfTask = ({String caption, String question});

Future<Uint8List> buildTasksPdf({
  required Uint8List fontBytes,
  required String title,
  required List<PdfTask> tasks,
}) async {
  final font = pw.Font.ttf(ByteData.sublistView(fontBytes));
  final document = pw.Document();
  document.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(base: font, bold: font),
      build: (context) => [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 16),
        for (final task in tasks) ...[
          pw.Text(
            task.caption,
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 4),
          pw.Text(task.question, style: const pw.TextStyle(fontSize: 14)),
          pw.SizedBox(height: 16),
        ],
      ],
    ),
  );
  return document.save();
}

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:airplane_management/models/airplane_model.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show rootBundle;

class FlightQRPageInterface extends StatelessWidget {
  final Datum flight;

  const FlightQRPageInterface({
    super.key,
    required this.flight,
  });

  void _showETicket(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  // E-Ticket Header
                  Text(
                    'E-Ticket',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Flight Details
                  _buildDetailRow('Flight', flight.flight?.iata ?? 'N/A'),
                  _buildDetailRow('Airline', flight.airline?.name ?? 'N/A'),
                  _buildDetailRow('From', flight.departure?.airport ?? 'N/A'),
                  _buildDetailRow('To', flight.arrival?.airport ?? 'N/A'),
                  _buildDetailRow(
                      'Date',
                      flight.departure?.scheduled?.toString().split(' ')[0] ??
                          'N/A'),
                  _buildDetailRow(
                      'Status', flight.flightStatus?.toUpperCase() ?? 'N/A'),
                  _buildDetailRow(
                      'Terminal', flight.departure?.terminal ?? 'N/A'),
                  _buildDetailRow('Gate', flight.departure?.gate ?? 'N/A'),
                  const SizedBox(height: 20),
                  // Download Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _generateAndDownloadPDF(context);
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[800],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Download E-Ticket'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndDownloadPDF(BuildContext context) async {
    final pdf = pw.Document();

    // Load custom font to support Unicode
    // final font = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    // final ttf = pw.Font.ttf(font);

    pdf.addPage(
      pw.Page(
        // theme: pw.ThemeData.withFont(
        //   base: ttf,
        //   bold: ttf,
        // ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'E-Ticket',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              _buildPDFRow('Flight', flight.flight?.iata ?? 'N/A'),
              _buildPDFRow('Airline', flight.airline?.name ?? 'N/A'),
              _buildPDFRow('From', flight.departure?.airport ?? 'N/A'),
              _buildPDFRow('To', flight.arrival?.airport ?? 'N/A'),
              _buildPDFRow(
                  'Date',
                  flight.departure?.scheduled?.toString().split(' ')[0] ??
                      'N/A'),
              _buildPDFRow(
                  'Status', flight.flightStatus?.toUpperCase() ?? 'N/A'),
              _buildPDFRow('Terminal', flight.departure?.terminal ?? 'N/A'),
              _buildPDFRow('Gate', flight.departure?.gate ?? 'N/A'),
            ],
          );
        },
      ),
    );

    if (Platform.isAndroid) {
      // Request all necessary permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.manageExternalStorage,
        Permission.mediaLibrary,
      ].request();

      bool permissionGranted =
          statuses.values.every((status) => status.isGranted);

      if (permissionGranted) {
        try {
          final directory = await getExternalStorageDirectory();
          final downloadPath = Directory('${directory?.path}/Download');

          if (!await downloadPath.exists()) {
            await downloadPath.create(recursive: true);
          }

          final String filePath =
              '${downloadPath.path}/e_ticket_${flight.flight?.iata ?? 'ticket'}.pdf';
          final file = File(filePath);
          await file.writeAsBytes(await pdf.save());

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('E-Ticket saved successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Permission Required'),
              content: const Text(
                  'Please grant storage permission to save the E-ticket'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => openAppSettings(),
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          );
        }
      }
    } else if (Platform.isIOS) {
      // For iOS, use share sheet
      final bytes = await pdf.save();
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
          '${tempDir.path}/e_ticket_${flight.flight?.iata ?? 'ticket'}.pdf');
      await tempFile.writeAsBytes(bytes);

      if (context.mounted) {
        await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: 'Your E-Ticket',
        );
      }
    }
  }

  // Helper method for PDF rows
  pw.Widget _buildPDFRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 14,
              color: PdfColors.grey,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String flightDetails = '''
Flight: ${flight.flight?.iata ?? 'N/A'}
Airline: ${flight.airline?.name ?? 'N/A'}
From: ${flight.departure?.airport ?? 'N/A'}
To: ${flight.arrival?.airport ?? 'N/A'}
Date: ${flight.departure?.scheduled?.toString() ?? 'N/A'}
Status: ${flight.flightStatus?.toUpperCase() ?? 'N/A'}
''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking QR Code'),
        backgroundColor: Colors.purple[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    QrImageView(
                      data: flightDetails,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Flight ${flight.flight?.iata ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${flight.departure?.airport ?? 'N/A'} → ${flight.arrival?.airport ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _showETicket(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[800],
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

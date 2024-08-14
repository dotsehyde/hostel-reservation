import 'dart:io';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SavedReportsPage extends StatefulWidget {
  @override
  _SavedReportsPageState createState() => _SavedReportsPageState();
}

class _SavedReportsPageState extends State<SavedReportsPage> {
  List<File> _pdfFiles = [];

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    _loadSavedReports();
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _loadSavedReports() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();
    List<File> pdfFiles = files
        .where((file) => file.path.endsWith(".pdf"))
        .map((file) => File(file.path))
        .toList();

    setState(() {
      _pdfFiles = pdfFiles;
    });
  }

  void _deletePdf(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        _loadSavedReports(); // Reload the list after deletion
      }
    } catch (e) {
      print("Error deleting file: $e");
    }
  }

  void _confirmDelete(BuildContext context, File file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Report"),
          content: Text("Are you sure you want to delete this report?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deletePdf(file);
                Navigator.of(context).pop();
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
        title: Text('Saved Reports'),
      ),
      body: _pdfFiles.isEmpty
          ? Center(child: Text('No reports saved yet.'))
          : ListView.builder(
              itemCount: _pdfFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_pdfFiles[index].path.split('/').last),
                  onTap: () {
                    _openPdf(_pdfFiles[index]);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmDelete(context, _pdfFiles[index]);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _openPdf(File file) async {
    PDFDocument doc = await PDFDocument.fromFile(file);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PView(doc)));
  }
}

class PView extends StatelessWidget {
  final PDFDocument doc;
  const PView(this.doc, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report View'),
      ),
      body: Center(child: PDFViewer(document: doc)),
    );
  }
}

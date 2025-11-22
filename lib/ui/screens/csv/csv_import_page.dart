import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:provider/provider.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:invtrack/features/products/models/product.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class CsvImportPage extends StatefulWidget {
  const CsvImportPage({super.key});

  @override
  State<CsvImportPage> createState() => _CsvImportPageState();
}

class _CsvImportPageState extends State<CsvImportPage> {
  List<String> _csvHeaders = [];
  List<List<dynamic>> _csvData = [];
  String _fileName = 'No file selected';
  bool _isLoading = false;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm'); // Date formatter for display

  void _showSnackBar(BuildContext context, String message, {Color color = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _pickCsvFile() async {
    setState(() {
      _isLoading = true;
      _csvHeaders = [];
      _csvData = [];
      _fileName = 'No file selected';
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.bytes != null) {
        Uint8List bytes = result.files.single.bytes!;
        final String csvString = utf8.decode(bytes);
        final List<List<dynamic>> rawCsvList =
            const CsvToListConverter().convert(csvString);

        if (rawCsvList.isNotEmpty) {
          setState(() {
            _csvHeaders = rawCsvList[0].map((e) => e.toString()).toList();
            _csvData = rawCsvList.sublist(1);
            _fileName = result.files.single.name;
          });
          developer.log('[InvTrack] CSV file picked: $_fileName');
          _showSnackBar(context, 'CSV file loaded successfully!');
        } else {
          _showSnackBar(context, 'CSV file is empty.', color: Colors.red);
        }
      } else {
        developer.log('[InvTrack] CSV file picking cancelled or no file selected.');
        _showSnackBar(context, 'File picking cancelled or no file selected.', color: Colors.orange);
      }
    } catch (e, s) {
      developer.log('[InvTrack] Error picking or parsing CSV file', error: e, stackTrace: s);
      _showSnackBar(context, 'Error picking or parsing CSV file: $e', color: Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _importData() async {
    if (_csvData.isEmpty) {
      _showSnackBar(context, 'No CSV data to import.', color: Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });
    developer.log('[InvTrack] CSV import started.');

    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    int importedCount = 0;
    int errorCount = 0;

    for (int i = 0; i < _csvData.length; i++) {
      final row = _csvData[i];
      Map<String, dynamic> productData = {};

      for (int j = 0; j < _csvHeaders.length && j < row.length; j++) {
        // Trim string values to remove leading/trailing whitespace
        productData[_csvHeaders[j]] = row[j]?.toString().trim();
      }

      try {
        final String name = productData['name']?.toString() ?? 'Unnamed Product';
        final String serialNumber = productData['serialNumber']?.toString() ?? '';
        final String category = productData['category']?.toString() ?? 'Others';
        // Safely parse cost, defaulting to 0.0
        final double cost = double.tryParse(productData['cost']?.toString() ?? '') ?? 0.0;
        final String assignedTo = productData['assignedTo']?.toString() ?? 'Unassigned';
        final String notes = productData['notes']?.toString() ?? '';
        String? imageUrl = productData['imageUrl']?.toString();
        if (imageUrl != null && imageUrl.isEmpty) {
          imageUrl = null; // Treat empty string as null
        }

        DateTime? createdAt;
        String? createdAtString = productData['createdAt']?.toString();
        if (createdAtString != null && createdAtString.isNotEmpty) {
          try {
            createdAt = DateTime.parse(createdAtString);
          } catch (e) {
            developer.log('[InvTrack] Could not parse createdAt for row ${i + 1}: $createdAtString', error: e);
          }
        }

        DateTime? updatedAt;
        String? updatedAtString = productData['updatedAt']?.toString();
        if (updatedAtString != null && updatedAtString.isNotEmpty) {
          try {
            updatedAt = DateTime.parse(updatedAtString);
          } catch (e) {
            developer.log('[InvTrack] Could not parse updatedAt for row ${i + 1}: $updatedAtString', error: e);
          }
        }

        final newProduct = Product(
          id: '', // Firestore will generate this
          name: name,
          serialNumber: serialNumber,
          category: category,
          cost: cost,
          assignedTo: assignedTo,
          notes: notes,
          imageUrl: imageUrl!, // Can be null
          createdAt: createdAt, // Can be null
          updatedAt: updatedAt, // Can be null
        );
        await firestoreService.addProduct(newProduct);
        importedCount++;
      } catch (e, s) {
        errorCount++;
        developer.log('[InvTrack] Error importing row ${i + 1}: $e', error: e, stackTrace: s);
      }
    }

    setState(() {
      _isLoading = false;
    });

    if (errorCount == 0) {
      _showSnackBar(context, 'Successfully imported $importedCount products!');
      developer.log('[InvTrack] CSV import finished. $importedCount products imported.');
    } else {
      _showSnackBar(context, 'Import finished with $importedCount successes and $errorCount errors.', color: Colors.orange);
      developer.log('[InvTrack] CSV import finished with $importedCount successes and $errorCount errors.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV Import'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _pickCsvFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('Pick CSV File'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: _isLoading,
              child: const LinearProgressIndicator(),
            ),
            if (!_isLoading) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _fileName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 8),
              if (_csvData.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 20,
                        horizontalMargin: 10,
                        columns: _csvHeaders
                            .map((header) => DataColumn(
                                  label: Text(
                                    header,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ))
                            .toList(),
                        rows: _csvData.take(10).map((row) { // Show first 10 rows as preview
                          // Create a map for easier access to data by header name
                          Map<String, dynamic> rowData = {};
                          for(int k=0; k<_csvHeaders.length && k<row.length; k++) {
                            rowData[_csvHeaders[k]] = row[k];
                          }

                          return DataRow(
                            cells: _csvHeaders.map((header) {
                                String cellValue = rowData[header]?.toString() ?? '';
                                // Special handling for date fields in preview
                                if (header == 'createdAt' || header == 'updatedAt') {
                                  try {
                                    if (cellValue.isNotEmpty) {
                                      DateTime parsedDate = DateTime.parse(cellValue);
                                      cellValue = _dateFormat.format(parsedDate);
                                    } else {
                                      cellValue = 'N/A';
                                    }
                                  } catch (e) {
                                    cellValue = 'Invalid Date'; // Indicate parsing error in preview
                                  }
                                }
                                return DataCell(
                                      Text(
                                        cellValue,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: Text(
                      'No CSV data to display. Pick a file to preview.',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _csvData.isEmpty || _isLoading ? null : _importData,
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Import Data'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
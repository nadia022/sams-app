import 'package:flutter/material.dart';

class FileExtensionHelper {
  static (IconData, Color) getFileTypeDetails(String? fileName) {
    if (fileName == null) return (Icons.insert_drive_file, Colors.grey);
    
    String extension = fileName.split('.').last.toLowerCase();

    return switch (extension) {
      'pdf' => (Icons.picture_as_pdf, Colors.red),
      'doc' || 'docx' => (Icons.description, Colors.blue),
      'xls' || 'xlsx' => (Icons.table_chart, Colors.green),
      'png' || 'jpg' || 'jpeg' => (Icons.image, Colors.purple),
      'zip' || 'rar' => (Icons.archive, Colors.orange),
      _ => (Icons.insert_drive_file, Colors.blueGrey),
    };
  }
}
import 'dart:io';

class FileValidator {
  static const int maxFileSizeBytes = 2 * 1024 * 1024;

  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  ];

  static String? validateFileSize(File file) {
    if (file.lengthSync() > maxFileSizeBytes) {
      return 'The file size must be less than 2 MB!';
    }
    return null;
  }

  static String? validateImageExtension(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    if (!allowedImageExtensions.contains(extension)) {
      return 'The file format is invalid.';
    }
    return null;
  }

  static String sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[^a-zA-Z0-9\-_\.]'), '_')
        .toLowerCase();
  }
}
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String path) async {
    final ref = _storage.ref().child(path);
    final task = await ref.putFile(file);
    final url = await task.ref.getDownloadURL();
    return url;
  }

  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (_) {}
  }
}

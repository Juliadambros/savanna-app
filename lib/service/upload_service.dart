import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> escolherEEnviarImagem(String pasta, {BuildContext? context}) async {
    try {
      final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);
      if (imagem == null) return null;

      return await uploadImagem(File(imagem.path), pasta);
    } catch (e) {
      print('Erro no upload: $e');
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar imagem: $e')),
        );
      }
      return null;
    }
  }

  Future<String?> uploadImagem(File arquivo, String pasta) async {
    try {
      final String nomeArquivo = '${DateTime.now().millisecondsSinceEpoch}_${arquivo.path.split('/').last}';
      final ref = _storage.ref().child('$pasta/$nomeArquivo');
      await ref.putFile(arquivo);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Erro no upload direto: $e');
      return null;
    }
  }
}

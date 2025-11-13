import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integrador/models/diretor_model.dart';

class DiretoriaService {
  final _colecao = FirebaseFirestore.instance.collection('diretoria');

  Future<void> salvarDiretor(DiretorModel diretor) async {
    if (diretor.id != null) {
      await _colecao.doc(diretor.id).update(diretor.toMap());
    } else {
      await _colecao.add(diretor.toMap());
    }
  }

  Future<List<DiretorModel>> listarDiretores() async {
    final snapshot = await _colecao.get();
    return snapshot.docs
        .map((doc) => DiretorModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> deletarDiretor(String id) async {
    await _colecao.doc(id).delete();
  }
}



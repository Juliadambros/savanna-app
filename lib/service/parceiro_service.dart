import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integrador/models/parceiro_model.dart';

class ParceiroService {
  final _colecao = FirebaseFirestore.instance.collection('parceiros');

  Future<void> salvar(ParceiroModel parceiro) async {
    if (parceiro.id != null) {
      await _colecao.doc(parceiro.id).update(parceiro.toMap());
    } else {
      await _colecao.add(parceiro.toMap());
    }
  }

  Future<List<ParceiroModel>> listar() async {
    final snapshot = await _colecao.get();
    return snapshot.docs
        .map((doc) => ParceiroModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> deletar(String id) async {
    await _colecao.doc(id).delete();
  }
}






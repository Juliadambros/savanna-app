import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sobre_nos_model.dart';

class SobreNosService {
  final CollectionReference _colecao =
      FirebaseFirestore.instance.collection('sobre_nos');

  Future<void> salvar(SobreNosModel sobre) async {
    if (sobre.id != null) {
      await _colecao.doc(sobre.id).set(sobre.toMap());
    } else {
      await _colecao.add(sobre.toMap());
    }
  }

  Future<List<SobreNosModel>> listar() async {
    final snapshot = await _colecao.get();
    return snapshot.docs
        .map((doc) => SobreNosModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> deletar(String id) async {
    await _colecao.doc(id).delete();
  }
}

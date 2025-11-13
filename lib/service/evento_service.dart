import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integrador/models/evento_model.dart';

class EventoService {
  final _colecao = FirebaseFirestore.instance.collection('eventos');

  Future<void> salvar(EventoModel evento) async {
    if (evento.id != null) {
      await _colecao.doc(evento.id).update(evento.toMap());
    } else {
      await _colecao.add(evento.toMap());
    }
  }

  Future<List<EventoModel>> listar() async {
    final snapshot = await _colecao.get();
    return snapshot.docs
        .map((doc) => EventoModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> deletar(String id) async {
    await _colecao.doc(id).delete();
  }
}




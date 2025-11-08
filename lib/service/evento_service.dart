import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/evento_model.dart';

class EventoService {
  final CollectionReference eventos =
      FirebaseFirestore.instance.collection('eventos');

  Future<void> salvarEvento(EventoModel evento) async {
    await eventos.doc(evento.id).set(evento.toMap());
  }

  Future<List<EventoModel>> listarEventos() async {
    final snapshot = await eventos.get();
    return snapshot.docs
        .map((d) => EventoModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }
}


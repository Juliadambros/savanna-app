import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pagina_model.dart';

class PaginaService {
  final CollectionReference _paginas =
      FirebaseFirestore.instance.collection('paginas');

  Future<PaginaModel?> buscar(String id) async {
    try {
      print('🔎 Buscando página: $id');
      final doc = await _paginas.doc(id).get();
      if (!doc.exists) {
        print('⚠️ Página "$id" ainda não existe no Firestore.');
        return null;
      }

      final dados = doc.data() as Map<String, dynamic>;
      return PaginaModel.fromMap({
        ...dados,
        'id': id,
      });
    } catch (e) {
      print('❌ Erro ao buscar página: $e');
      return null;
    }
  }

  Future<void> salvar(PaginaModel pagina) async {
    try {
      print('💾 Salvando página "${pagina.id}"...');
      print('📦 Dados enviados: ${pagina.toMap()}');

      await _paginas.doc(pagina.id).set(pagina.toMap(), SetOptions(merge: true));

      print('✅ Página "${pagina.id}" salva com sucesso!');
    } catch (e) {
      print('❌ Erro ao salvar página: $e');
    }
  }

  Future<List<PaginaModel>> listar() async {
    try {
      final snapshot = await _paginas.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PaginaModel.fromMap({
          ...data,
          'id': doc.id,
        });
      }).toList();
    } catch (e) {
      print('❌ Erro ao listar páginas: $e');
      return [];
    }
  }
}

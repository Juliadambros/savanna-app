import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integrador/models/associacao_model.dart';
import 'package:integrador/service/whatsapp_service.dart';

class AssociacaoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _colecao = 'associacoes';

  Future<List<AssociacaoModel>> listarAssociacoes() async {
    final snap = await _db.collection(_colecao).get();
    return snap.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return AssociacaoModel.fromMap(data);
    }).toList();
  }

  Future<void> salvarAssociacao(AssociacaoModel associacao) async {
    final docRef = _db.collection(_colecao).doc(associacao.id);

    await docRef.set(associacao.toMap(), SetOptions(merge: true));
  }

  Future<void> excluirAssociacao(String id) async {
    await _db.collection(_colecao).doc(id).delete();
  }

  Future<void> atualizarStatus(String id, String novoStatus) async {
    await _db.collection(_colecao).doc(id).update({'status': novoStatus});
  }

  Future<void> enviarParaWhatsApp(AssociacaoModel associacao) async {
    if (associacao.telefone == null || associacao.telefone!.isEmpty) return;

    final mensagem =
        '''
Olá ${associacao.nomeCompleto} 
Recebemos sua solicitação de associação!

 Curso: ${associacao.curso}
 Pagamento: ${associacao.meioPagamento}
 Tipo: ${associacao.tipo}

Status atual: ${associacao.status.toUpperCase()}

Em breve entraremos em contato com mais informações.
Obrigado por fazer parte da associação!
''';

    await WhatsAppService.enviarMensagem(associacao.telefone!, mensagem);
  }
}

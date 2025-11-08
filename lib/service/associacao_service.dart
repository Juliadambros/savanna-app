import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/associacao_model.dart';
import 'whatsapp_service.dart';

class AssociacaoService {
  final CollectionReference associacoes =
      FirebaseFirestore.instance.collection("associacoes");

  Future<void> salvarAssociacao(AssociacaoModel associacao) async {
    await associacoes.doc(associacao.id).set(associacao.toMap());
  }

  Future<List<AssociacaoModel>> listarAssociacoes() async {
    final snapshot = await associacoes.get();
    return snapshot.docs
        .map((d) => AssociacaoModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<AssociacaoModel>> listarPorEmail(String email) async {
    final snapshot =
        await associacoes.where('email', isEqualTo: email).get();
    return snapshot.docs
        .map((d) => AssociacaoModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> enviarParaWhatsApp(AssociacaoModel associacao) async {
    const numeroDiretor = '55XXXXXXXXXXX'; 

    final mensagem = '''
📩 Nova ${associacao.tipo.toUpperCase()} recebida!

👤 Nome: ${associacao.nomeCompleto}
📧 Email: ${associacao.email}
🪪 CPF: ${associacao.cpf}
🎓 RA: ${associacao.ra}
📚 Curso: ${associacao.curso}
💳 Pagamento: ${associacao.meioPagamento}
''';

    await WhatsAppService.enviarMensagem(numeroDiretor, mensagem);
  }
}

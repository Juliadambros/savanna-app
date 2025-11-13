import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integrador/models/associacao_model.dart';
import 'package:integrador/service/whatsapp_service.dart';

class AdmAssociacoesPage extends StatefulWidget {
  const AdmAssociacoesPage({super.key});

  @override
  State<AdmAssociacoesPage> createState() => _AdmAssociacoesPageState();
}

class _AdmAssociacoesPageState extends State<AdmAssociacoesPage> {
  final _db = FirebaseFirestore.instance;

  Future<void> _atualizarStatus(
    AssociacaoModel associacao,
    String novoStatus,
  ) async {
    try {
      await _db.collection('associacoes').doc(associacao.id).update({
        'status': novoStatus,
      });

      final msg = novoStatus == 'aprovado'
          ? '''
🎉 *Associação Aprovada!*
Olá ${associacao.nomeCompleto}, sua solicitação de associação foi aprovada com sucesso!
Bem-vindo(a) à nossa comunidade. 🤝
'''
          : '''
⚠️ *Associação Recusada*
Olá ${associacao.nomeCompleto}, infelizmente sua solicitação de associação foi recusada.
Entre em contato com o suporte para mais informações.
''';

      await WhatsAppService.enviarMensagem(associacao.telefone ?? '', msg);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status atualizado para "$novoStatus"')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar status: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administração de Associações'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('associacoes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma solicitação encontrada.'));
          }

          final associacoes = snapshot.data!.docs
              .map(
                (d) =>
                    AssociacaoModel.fromMap(d.data() as Map<String, dynamic>),
              )
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: associacoes.length,
            itemBuilder: (context, index) {
              final a = associacoes[index];
              final corStatus = switch (a.status) {
                'aprovado' => Colors.green,
                'recusado' => Colors.red,
                _ => Colors.grey,
              };

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.nomeCompleto,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Curso: ${a.curso}'),
                      Text('E-mail: ${a.email}'),
                      Text('CPF: ${a.cpf}'),
                      Text('Tipo: ${a.tipo}'),
                      Text('Pagamento: ${a.meioPagamento}'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text(a.status.toUpperCase()),
                            backgroundColor: corStatus.withOpacity(0.2),
                            labelStyle: TextStyle(color: corStatus),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                tooltip: 'Aprovar',
                                onPressed: a.status == 'aprovado'
                                    ? null
                                    : () => _atualizarStatus(a, 'aprovado'),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                tooltip: 'Recusar',
                                onPressed: a.status == 'recusado'
                                    ? null
                                    : () => _atualizarStatus(a, 'recusado'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

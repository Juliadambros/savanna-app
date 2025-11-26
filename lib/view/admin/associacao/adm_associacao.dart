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
 *Associação Aprovada!*
Olá ${associacao.nomeCompleto}, sua solicitação foi aprovada!
'''
          : '''
 *Associação Recusada*
Olá ${associacao.nomeCompleto}, sua solicitação foi recusada.
''';

      await WhatsAppService.enviarMensagem(associacao.telefone ?? '', msg);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Status atualizado!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'aprovado':
        return const Color(0xFF4CAF50);
      case 'recusado':
        return const Color(0xFFE53935);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                "assets/imgs/mascote.png",
                width: 220,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 28,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Center(
                  child: Image.asset(
                    "assets/imgs/logo.png",
                    height: 70,
                  ),
                ),

                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Administração de Associações",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _db.collection('associacoes').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'Nenhuma solicitação encontrada.',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      final associacoes = snapshot.data!.docs
                          .map((d) => AssociacaoModel.fromMap(
                              d.data() as Map<String, dynamic>))
                          .toList();

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: associacoes.length,
                        itemBuilder: (context, index) {
                          final a = associacoes[index];
                          final corStatus = _corStatus(a.status);

                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.nomeCompleto,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  _info("Curso", a.curso),
                                  _info("E-mail", a.email),
                                  _info("CPF", a.cpf),
                                  _info("Tipo", a.tipo),
                                  _info("Pagamento", a.meioPagamento),

                                  const SizedBox(height: 12),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Chip(
                                        label: Text(
                                          a.status.toUpperCase(),
                                          style: TextStyle(
                                            color: corStatus,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        backgroundColor:
                                            corStatus.withOpacity(0.2),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            tooltip: 'Aprovar',
                                            icon: const Icon(
                                                Icons.check_circle),
                                            color: Colors.green,
                                            onPressed: a.status ==
                                                    'aprovado'
                                                ? null
                                                : () => _atualizarStatus(
                                                    a, 'aprovado'),
                                          ),
                                          IconButton(
                                            tooltip: 'Recusar',
                                            icon:
                                                const Icon(Icons.cancel),
                                            color: Colors.red,
                                            onPressed: a.status ==
                                                    'recusado'
                                                ? null
                                                : () => _atualizarStatus(
                                                    a, 'recusado'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(String titulo, String? valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        "$titulo: ${valor ?? '-'}",
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}

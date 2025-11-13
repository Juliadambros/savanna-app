import 'package:flutter/material.dart';
import 'package:integrador/models/associacao_model.dart';
import 'package:integrador/service/associacao_service.dart';
import 'package:integrador/view/admin/associacao/form_associacao.dart';

class AssociacoesPage extends StatefulWidget {
  const AssociacoesPage({super.key});

  @override
  State<AssociacoesPage> createState() => _AssociacoesPageState();
}

class _AssociacoesPageState extends State<AssociacoesPage> {
  final service = AssociacaoService();
  List<AssociacaoModel> associacoes = [];

  @override
  void initState() {
    super.initState();
    carregarAssociacoes();
  }

  Future<void> carregarAssociacoes() async {
    final lista = await service.listarAssociacoes();
    setState(() => associacoes = lista);
  }

  Future<void> _abrirFormulario({AssociacaoModel? associacao}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormAssociacao(associacao: associacao),
      ),
    );
    await carregarAssociacoes(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Associações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nova Associação',
            onPressed: () => _abrirFormulario(),
          ),
        ],
      ),
      body: associacoes.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma associação cadastrada.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : RefreshIndicator(
              onRefresh: carregarAssociacoes,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: associacoes.length,
                itemBuilder: (context, index) {
                  final a = associacoes[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(a.nomeCompleto),
                      subtitle: Text('${a.curso} — ${a.tipo}'),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _abrirFormulario(associacao: a),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

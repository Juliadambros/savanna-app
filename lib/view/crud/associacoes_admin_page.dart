import 'package:flutter/material.dart';
import 'package:integrador/models/associacao_model.dart';
import 'package:integrador/service/associacao_service.dart';
import 'associacao_form_page.dart';

class AssociacoesAdminPage extends StatefulWidget {
  const AssociacoesAdminPage({super.key});

  @override
  State<AssociacoesAdminPage> createState() => _AssociacoesAdminPageState();
}

class _AssociacoesAdminPageState extends State<AssociacoesAdminPage> {
  final AssociacaoService _service = AssociacaoService();
  List<AssociacaoModel> lista = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    setState(() => carregando = true);
    lista = await _service.listarAssociacoes();
    setState(() => carregando = false);
  }

  Future<void> deletar(String id) async {
    await _service.associacoes.doc(id).delete();
    carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gerenciar Associações")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AssociacaoFormPage()),
          );
          carregar();
        },
        child: const Icon(Icons.add),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : lista.isEmpty
              ? const Center(child: Text("Nenhuma associação encontrada"))
              : ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (_, i) {
                    final a = lista[i];
                    return Card(
                      child: ListTile(
                        title: Text(a.nomeCompleto),
                        subtitle: Text("${a.email} • ${a.curso}"),
                        trailing: PopupMenuButton(
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                                value: "editar", child: Text("Editar")),
                            PopupMenuItem(
                                value: "deletar", child: Text("Excluir")),
                          ],
                          onSelected: (v) async {
                            if (v == "editar") {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AssociacaoFormPage(associacao: a),
                                ),
                              );
                              carregar();
                            } else {
                              deletar(a.id);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}


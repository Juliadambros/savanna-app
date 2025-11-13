import 'package:flutter/material.dart';
import 'package:integrador/models/sobre_nos_model.dart';
import 'package:integrador/service/sobre_nos_service.dart';

import 'form_sobre_nos.dart';

class AdmSobreNosPage extends StatefulWidget {
  const AdmSobreNosPage({super.key});

  @override
  State<AdmSobreNosPage> createState() => _AdmSobreNosPageState();
}

class _AdmSobreNosPageState extends State<AdmSobreNosPage> {
  final SobreNosService _service = SobreNosService();
  List<SobreNosModel> _paginas = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista = await _service.listar();
    setState(() => _paginas = lista);
  }

  void _abrirForm({SobreNosModel? pagina}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormSobreNos(pagina: pagina)),
    );
    _carregar();
  }

  Future<void> _remover(String id) async {
    await _service.deletar(id);
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Sobre Nós')),
      body: _paginas.isEmpty
          ? const Center(child: Text('Nenhuma informação cadastrada.'))
          : ListView.builder(
              itemCount: _paginas.length,
              itemBuilder: (context, i) {
                final p = _paginas[i];
                return ListTile(
                  title: Text(p.titulo),
                  subtitle: Text(p.conteudo),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _remover(p.id!),
                  ),
                  onTap: () => _abrirForm(pagina: p),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

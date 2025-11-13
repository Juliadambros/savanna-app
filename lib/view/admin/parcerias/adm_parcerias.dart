import 'package:flutter/material.dart';
import 'package:integrador/models/parceiro_model.dart';
import 'package:integrador/service/parceiro_service.dart';
import 'form_parceria.dart';

class AdmParceriasPage extends StatefulWidget {
  const AdmParceriasPage({super.key});

  @override
  State<AdmParceriasPage> createState() => _AdmParceriasPageState();
}

class _AdmParceriasPageState extends State<AdmParceriasPage> {
  final ParceiroService _service = ParceiroService();
  List<ParceiroModel> _parceiros = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista = await _service.listar();
    setState(() => _parceiros = lista);
  }

  void _abrirForm({ParceiroModel? parceiro}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormParceria(parceiro: parceiro)),
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
      appBar: AppBar(title: const Text('Gerenciar Parcerias')),
      body: _parceiros.isEmpty
          ? const Center(child: Text('Nenhuma parceria cadastrada.'))
          : ListView.builder(
              itemCount: _parceiros.length,
              itemBuilder: (context, i) {
                final p = _parceiros[i];
                return ListTile(
                  title: Text(p.nome),
                  subtitle: Text('${p.descricao}\nContato: ${p.contato}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _remover(p.id!),
                  ),
                  onTap: () => _abrirForm(parceiro: p),
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



import 'package:flutter/material.dart';
import 'package:integrador/models/evento_model.dart';
import 'package:integrador/service/evento_service.dart';
import 'package:integrador/view/admin/evento/form_evento.dart';

class AdmEventosPage extends StatefulWidget {
  const AdmEventosPage({super.key});

  @override
  State<AdmEventosPage> createState() => _AdmEventosPageState();
}

class _AdmEventosPageState extends State<AdmEventosPage> {
  final EventoService _service = EventoService();
  List<EventoModel> _eventos = [];

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    final eventos = await _service.listar();
    setState(() => _eventos = eventos);
  }

  Future<void> _remover(String id) async {
    await _service.deletar(id);
    _carregarEventos();
  }

  void _abrirFormulario({EventoModel? evento}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormEvento(evento: evento)),
    );
    _carregarEventos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Eventos')),
      body: _eventos.isEmpty
          ? const Center(child: Text('Nenhum evento cadastrado.'))
          : ListView.builder(
              itemCount: _eventos.length,
              itemBuilder: (context, i) {
                final e = _eventos[i];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(e.nome),
                    subtitle: Text(
                      '${e.tipo} • ${e.local}\n${e.data.toLocal().toString().split(' ')[0]}',
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _remover(e.id!),
                    ),
                    onTap: () => _abrirFormulario(evento: e),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

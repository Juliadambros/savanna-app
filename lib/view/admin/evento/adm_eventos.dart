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
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text(
          'Gerenciar Eventos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/imgs/mascote.png',
              width: 220,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/imgs/logo.png',
                height: 90,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: _eventos.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum evento cadastrado.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: _eventos.length,
                    itemBuilder: (context, i) {
                      final e = _eventos[i];

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            e.nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
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
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0E2877),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _abrirFormulario(),
   
      ),
    );
  }
}

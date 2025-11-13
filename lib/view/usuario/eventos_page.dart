import 'package:flutter/material.dart';
import 'package:integrador/models/evento_model.dart';
import 'package:integrador/service/evento_service.dart';

class EventosPage extends StatefulWidget {
  const EventosPage({super.key});

  @override
  State<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  final service = EventoService();
  List<EventoModel> eventos = [];

  @override
  void initState() {
    super.initState();
    carregarEventos();
  }

  Future<void> carregarEventos() async {
    final lista = await service.listar();
    setState(() => eventos = lista);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eventos')),
      body: eventos.isEmpty
          ? const Center(child: Text('Nenhum evento disponível.'))
          : ListView.builder(
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final e = eventos[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(e.nome),
                    subtitle: Text(
                      '${e.tipo} • ${e.local}\n${e.data.toLocal().toString().split(' ')[0]}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}


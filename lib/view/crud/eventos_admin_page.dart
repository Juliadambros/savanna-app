import 'package:flutter/material.dart';
import 'package:integrador/service/evento_service.dart';
import 'package:integrador/view/crud/evento_form_page.dart';
import '../../models/evento_model.dart';


class EventosAdminPage extends StatefulWidget {
  const EventosAdminPage({super.key});

  @override
  State<EventosAdminPage> createState() => _EventosAdminPageState();
}

class _EventosAdminPageState extends State<EventosAdminPage> {
  final EventoService _service = EventoService();
  List<EventoModel> _eventos = [];
  List<EventoModel> _filtrados = [];
  bool _carregando = true;
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    try {
      final lista = await _service.listarEventos();
      setState(() {
        _eventos = lista;
        _aplicarFiltro();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar eventos: $e')));
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _aplicarFiltro() {
    if (_filtro.trim().isEmpty) {
      _filtrados = List.from(_eventos);
    } else {
      final termo = _filtro.toLowerCase();
      _filtrados = _eventos.where((e) =>
        e.titulo.toLowerCase().contains(termo) ||
        e.tipo.toLowerCase().contains(termo) ||
        e.local.toLowerCase().contains(termo)
      ).toList();
    }
  }

  Future<void> _deletar(EventoModel evento) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja excluir o evento "${evento.titulo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _service.eventos.doc(evento.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Evento excluído')));
      await _carregar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao excluir: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Eventos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const EventoFormPage()));
          await _carregar();
        },
        child: const Icon(Icons.add),
        tooltip: 'Novo evento',
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar eventos (título, tipo, local)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                setState(() => _filtro = v);
                _aplicarFiltro();
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _carregar,
                      child: _filtrados.isEmpty
                          ? const Center(child: Text('Nenhum evento encontrado'))
                          : ListView.builder(
                              itemCount: _filtrados.length,
                              itemBuilder: (context, index) {
                                final e = _filtrados[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    title: Text(e.titulo),
                                    subtitle: Text('${e.tipo} • ${e.data} • ${e.local}'),
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (value) async {
                                        if (value == 'editar') {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => EventoFormPage(evento: e)),
                                          );
                                          await _carregar();
                                        } else if (value == 'deletar') {
                                          await _deletar(e);
                                        }
                                      },
                                      itemBuilder: (_) => const [
                                        PopupMenuItem(value: 'editar', child: Text('Editar')),
                                        PopupMenuItem(value: 'deletar', child: Text('Excluir')),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

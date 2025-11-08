import 'package:flutter/material.dart';
import 'package:integrador/service/usuario_service.dart';
import 'package:integrador/view/crud/usuario_form_page.dart';
import '../../models/usuario_model.dart';


class UsuariosAdminPage extends StatefulWidget {
  const UsuariosAdminPage({super.key});

  @override
  State<UsuariosAdminPage> createState() => _UsuariosAdminPageState();
}

class _UsuariosAdminPageState extends State<UsuariosAdminPage> {
  final UsuarioService _service = UsuarioService();
  List<UsuarioModel> _usuarios = [];
  List<UsuarioModel> _filtrados = [];
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
      final lista = await _service.listarUsuarios();
      setState(() {
        _usuarios = lista;
        _aplicarFiltro();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar usuários: $e')));
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _aplicarFiltro() {
    if (_filtro.trim().isEmpty) {
      _filtrados = List.from(_usuarios);
    } else {
      final termo = _filtro.toLowerCase();
      _filtrados = _usuarios.where((u) =>
        u.nome.toLowerCase().contains(termo) ||
        u.email.toLowerCase().contains(termo) ||
        u.curso.toLowerCase().contains(termo)
      ).toList();
    }
  }

  Future<void> _deletar(UsuarioModel u) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja excluir o usuário "${u.nome}"? Esta ação não remove o Auth do Firebase.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await _service.usuarios.doc(u.uid).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário removido')));
      await _carregar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao excluir usuário: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Usuários'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const UsuarioFormPage()));
          await _carregar();
        },
        child: const Icon(Icons.person_add),
        tooltip: 'Novo usuário (criar manualmente)',
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar usuários (nome, email, curso)',
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
                          ? const Center(child: Text('Nenhum usuário encontrado'))
                          : ListView.builder(
                              itemCount: _filtrados.length,
                              itemBuilder: (context, index) {
                                final u = _filtrados[index];
                                return Card(
                                  child: ListTile(
                                    leading: const CircleAvatar(child: Icon(Icons.person)),
                                    title: Text(u.nome),
                                    subtitle: Text('${u.email} • ${u.curso}'),
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (value) async {
                                        if (value == 'editar') {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => UsuarioFormPage(usuario: u)),
                                          );
                                          await _carregar();
                                        } else if (value == 'deletar') {
                                          await _deletar(u);
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

import 'package:flutter/material.dart';
import 'package:integrador/models/usuario_model.dart';
import 'package:integrador/service/usuario_service.dart';
import 'package:integrador/view/admin/usuario/form_usuario.dart';
import 'package:integrador/components/campo_texto.dart'; // Importe o componente

class UsuariosAdminPage extends StatefulWidget {
  const UsuariosAdminPage({super.key});

  @override
  State<UsuariosAdminPage> createState() => _UsuariosAdminPageState();
}

class _UsuariosAdminPageState extends State<UsuariosAdminPage> {
  final UsuarioService _service = UsuarioService();
  final TextEditingController _buscaController = TextEditingController();
  List<UsuarioModel> _usuarios = [];
  List<UsuarioModel> _filtrados = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final lista = await _service.listarUsuarios();
      setState(() {
        _usuarios = lista;
        _aplicarFiltro();
      });
    } catch (e) {
      setState(() => _erro = 'Erro ao carregar usuários.');
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _aplicarFiltro() {
    final filtro = _buscaController.text.trim();
    if (filtro.isEmpty) {
      _filtrados = List.from(_usuarios);
    } else {
      final termo = filtro.toLowerCase();
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
        content: Text(
            'Deseja excluir o usuário "${u.nome}"?\n(Isto não remove do Firebase Auth)'
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await _service.usuarios.doc(u.uid).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário removido com sucesso!')),
      );
      await _carregar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir usuário.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF0E2877),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Usuários",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E2877),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Opacity(
              opacity: 0.13,
              child: Image.asset(
                'assets/imgs/mascote.png',
                width: 220,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Image.asset(
                    "assets/imgs/logo.png",
                    height: 70,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Gerenciar Usuários",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CampoTexto(
                    controller: _buscaController,
                    label: 'Buscar usuários',
                    hint: 'Digite nome, email ou curso...',
                    emojiFinal: const Icon(Icons.search, color: Color(0xFF0E2877)),
                    corBorda: const Color(0xFF0E2877),
                    corLabel: const Color(0xFF0E2877),
                    onChanged: (value) {
                      setState(() => _aplicarFiltro());
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _carregando
                      ? const Center(child: CircularProgressIndicator())
                      : _erro != null
                          ? Center(child: Text(_erro!))
                          : _filtrados.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Nenhum usuário encontrado.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: _carregar,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _filtrados.length,
                                    itemBuilder: (context, i) {
                                      final u = _filtrados[i];
                                      return Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        margin: const EdgeInsets.only(bottom: 16),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(16),
                                          leading: const CircleAvatar(
                                            child: Icon(Icons.person),
                                          ),
                                          title: Text(
                                            u.nome,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${u.email} • ${u.curso}",
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                          trailing: PopupMenuButton<String>(
                                            onSelected: (value) async {
                                              if (value == 'editar') {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => UsuarioFormPage(usuario: u),
                                                  ),
                                                );
                                                await _carregar();
                                              } else if (value == 'deletar') {
                                                await _deletar(u);
                                              }
                                            },
                                            itemBuilder: (_) => const [
                                              PopupMenuItem(
                                                value: 'editar',
                                                child: Text('Editar'),
                                              ),
                                              PopupMenuItem(
                                                value: 'deletar',
                                                child: Text('Excluir'),
                                              ),
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0E2877),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UsuarioFormPage()),
          );
          await _carregar();
        },
      ),
    );
  }
}
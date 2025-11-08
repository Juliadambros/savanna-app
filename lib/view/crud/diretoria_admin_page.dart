import 'dart:io';
import 'package:flutter/material.dart';
import '../../service/pagina_service.dart';
import '../../service/upload_service.dart';
import '../../models/pagina_model.dart';

class DiretoriaAdminPage extends StatefulWidget {
  const DiretoriaAdminPage({super.key});

  @override
  State<DiretoriaAdminPage> createState() => _DiretoriaAdminPageState();
}

class _DiretoriaAdminPageState extends State<DiretoriaAdminPage> {
  final PaginaService _service = PaginaService();
  final UploadService _uploadService = UploadService();
  List<Map<String, dynamic>> membros = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final pagina = await _service.buscar('diretoria');
    setState(() {
      membros = List<Map<String, dynamic>>.from(pagina?.conteudo['membros'] ?? []);
      carregando = false;
    });
  }

  Future<void> _salvar() async {
    final pagina = PaginaModel(id: 'diretoria', conteudo: {'membros': membros});
    await _service.salvar(pagina);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Diretoria atualizada com sucesso!')),
    );
  }

  Future<void> _adicionarMembro() async {
    final nomeCtrl = TextEditingController();
    final cargoCtrl = TextEditingController();
    final cursoCtrl = TextEditingController();
    File? imagem;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Novo Membro"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final picked = await _uploadService.escolherEEnviarImagem('diretoria');
                  if (picked != null) setState(() => imagem = File(picked));
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: imagem != null ? FileImage(imagem!) : null,
                  child: imagem == null ? const Icon(Icons.add_a_photo) : null,
                ),
              ),
              TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: "Nome")),
              TextField(controller: cargoCtrl, decoration: const InputDecoration(labelText: "Cargo")),
              TextField(controller: cursoCtrl, decoration: const InputDecoration(labelText: "Curso")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              String? fotoUrl;
              if (imagem != null) fotoUrl = await _uploadService.uploadImagem(imagem!, 'diretoria');
              setState(() {
                membros.add({
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'nome': nomeCtrl.text,
                  'cargo': cargoCtrl.text,
                  'curso': cursoCtrl.text,
                  'fotoUrl': fotoUrl,
                });
              });
              if (mounted) Navigator.pop(context);
              await _salvar();
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  Future<void> _editarMembro(int index) async {
    final membro = membros[index];
    final nomeCtrl = TextEditingController(text: membro['nome']);
    final cargoCtrl = TextEditingController(text: membro['cargo']);
    final cursoCtrl = TextEditingController(text: membro['curso']);
    File? imagem;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Membro"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final picked = await _uploadService.escolherEEnviarImagem('diretoria');
                  if (picked != null) imagem = File(picked);
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: imagem != null
                      ? FileImage(imagem!)
                      : (membro['fotoUrl'] != null ? NetworkImage(membro['fotoUrl']) as ImageProvider : null),
                  child: imagem == null && membro['fotoUrl'] == null ? const Icon(Icons.person) : null,
                ),
              ),
              TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: "Nome")),
              TextField(controller: cargoCtrl, decoration: const InputDecoration(labelText: "Cargo")),
              TextField(controller: cursoCtrl, decoration: const InputDecoration(labelText: "Curso")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              String? fotoUrl = membro['fotoUrl'];
              if (imagem != null) fotoUrl = await _uploadService.uploadImagem(imagem!, 'diretoria');
              setState(() {
                membros[index] = {
                  'id': membro['id'],
                  'nome': nomeCtrl.text,
                  'cargo': cargoCtrl.text,
                  'curso': cursoCtrl.text,
                  'fotoUrl': fotoUrl,
                };
              });
              if (mounted) Navigator.pop(context);
              await _salvar();
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  void _removerMembro(String id) {
    setState(() => membros.removeWhere((m) => m['id'] == id));
    _salvar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin - Diretoria")),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: membros.length + 1, // +1 para o card de adicionar
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                if (i == membros.length) {
                  return GestureDetector(
                    onTap: _adicionarMembro,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: const Center(
                        child: Icon(Icons.add, size: 40, color: Colors.black54),
                      ),
                    ),
                  );
                }

                final m = membros[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: m['fotoUrl'] != null ? NetworkImage(m['fotoUrl']) : null,
                    child: m['fotoUrl'] == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(m['nome'] ?? ''),
                  subtitle: Text('${m['cargo']} • ${m['curso']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _editarMembro(i)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _removerMembro(m['id'])),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

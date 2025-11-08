import 'dart:io';
import 'package:flutter/material.dart';
import '../../service/pagina_service.dart';
import '../../service/upload_service.dart';
import '../../models/pagina_model.dart';

class ParceriasAdminPage extends StatefulWidget {
  const ParceriasAdminPage({super.key});

  @override
  State<ParceriasAdminPage> createState() => _ParceriasAdminPageState();
}

class _ParceriasAdminPageState extends State<ParceriasAdminPage> {
  final PaginaService _service = PaginaService();
  final UploadService _uploadService = UploadService();
  List<Map<String, dynamic>> parceiros = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final pagina = await _service.buscar('parcerias');
    setState(() {
      parceiros = List<Map<String, dynamic>>.from(pagina?.conteudo['parceiros'] ?? []);
      carregando = false;
    });
  }

  Future<void> _salvar() async {
    final pagina = PaginaModel(id: 'parcerias', conteudo: {'parceiros': parceiros});
    await _service.salvar(pagina);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Parcerias atualizadas com sucesso!')),
    );
  }

  Future<void> _adicionarParceiro() async {
    final nomeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final benefCtrl = TextEditingController();
    File? logo;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nova Parceria"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final picked = await _uploadService.escolherEEnviarImagem('parceiros');
                  if (picked != null) logo = File(picked);
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: logo != null ? FileImage(logo!) : null,
                  child: logo == null ? const Icon(Icons.add_photo_alternate) : null,
                ),
              ),
              TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: "Nome")),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Descrição")),
              TextField(controller: benefCtrl, decoration: const InputDecoration(labelText: "Benefícios")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              String? logoUrl;
              if (logo != null) logoUrl = await _uploadService.uploadImagem(logo!, 'parceiros');
              setState(() {
                parceiros.add({
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'nome': nomeCtrl.text,
                  'descricao': descCtrl.text,
                  'beneficios': benefCtrl.text,
                  'logoUrl': logoUrl,
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

  Future<void> _editarParceiro(int index) async {
    final parceiro = parceiros[index];
    final nomeCtrl = TextEditingController(text: parceiro['nome']);
    final descCtrl = TextEditingController(text: parceiro['descricao']);
    final benefCtrl = TextEditingController(text: parceiro['beneficios']);
    File? logo;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Parceria"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final picked = await _uploadService.escolherEEnviarImagem('parceiros');
                  if (picked != null) logo = File(picked);
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: logo != null
                      ? FileImage(logo!)
                      : (parceiro['logoUrl'] != null ? NetworkImage(parceiro['logoUrl']) as ImageProvider : null),
                  child: logo == null && parceiro['logoUrl'] == null ? const Icon(Icons.store) : null,
                ),
              ),
              TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: "Nome")),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Descrição")),
              TextField(controller: benefCtrl, decoration: const InputDecoration(labelText: "Benefícios")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              String? logoUrl = parceiro['logoUrl'];
              if (logo != null) logoUrl = await _uploadService.uploadImagem(logo!, 'parceiros');
              setState(() {
                parceiros[index] = {
                  'id': parceiro['id'],
                  'nome': nomeCtrl.text,
                  'descricao': descCtrl.text,
                  'beneficios': benefCtrl.text,
                  'logoUrl': logoUrl,
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

  void _removerParceiro(String id) {
    setState(() => parceiros.removeWhere((p) => p['id'] == id));
    _salvar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin - Parcerias")),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: parceiros.length + 1, // +1 para o card de adicionar
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                if (i == parceiros.length) {
                  return GestureDetector(
                    onTap: _adicionarParceiro,
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

                final p = parceiros[i];
                return ListTile(
                  leading: p['logoUrl'] != null
                      ? Image.network(p['logoUrl'], width: 48, height: 48, fit: BoxFit.cover)
                      : const Icon(Icons.store, size: 40),
                  title: Text(p['nome'] ?? ''),
                  subtitle: Text(p['descricao'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _editarParceiro(i)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _removerParceiro(p['id'])),
                    ],
                  ),
                );
              },
            ),
    );
  }
}



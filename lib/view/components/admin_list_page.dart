import 'dart:io';
import 'package:flutter/material.dart';
import '../../service/pagina_service.dart';
import '../../service/upload_service.dart';
import '../../models/pagina_model.dart';

class AdminListPage extends StatefulWidget {
  final String titulo;
  final String colecao; 
  final List<String> campos; 
  final bool temImagem; 

  const AdminListPage({
    super.key,
    required this.titulo,
    required this.colecao,
    required this.campos,
    this.temImagem = false,
  });

  @override
  State<AdminListPage> createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  final PaginaService _service = PaginaService();
  final UploadService _uploadService = UploadService();
  List<Map<String, dynamic>> itens = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final pagina = await _service.buscar(widget.colecao);
    setState(() {
      itens = List<Map<String, dynamic>>.from(
          pagina?.conteudo[widget.colecao] ?? []);
      carregando = false;
    });
  }

  Future<void> _salvar() async {
    final pagina = PaginaModel(id: widget.colecao, conteudo: {widget.colecao: itens});
    await _service.salvar(pagina);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.titulo} atualizados com sucesso!')),
    );
  }

  Future<void> _adicionarItem() async {
    List<TextEditingController> controllers =
        widget.campos.map((_) => TextEditingController()).toList();
    File? imagem;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Novo ${widget.titulo.substring(0, widget.titulo.length - 1)}"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.temImagem)
                GestureDetector(
                  onTap: () async {
                    final picked = await _uploadService.escolherEEnviarImagem(widget.colecao);
                    if (picked != null) imagem = File(picked);
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: imagem != null ? FileImage(imagem!) : null,
                    child: imagem == null
                        ? const Icon(Icons.add_a_photo)
                        : null,
                  ),
                ),
              ...List.generate(
                widget.campos.length,
                (i) => TextField(
                  controller: controllers[i],
                  decoration: InputDecoration(labelText: widget.campos[i]),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              String? fotoUrl;
              if (imagem != null) {
                fotoUrl = await _uploadService.uploadImagem(imagem!, widget.colecao);
              }
              Map<String, dynamic> novoItem = {'id': DateTime.now().millisecondsSinceEpoch.toString()};
              for (int i = 0; i < widget.campos.length; i++) {
                novoItem[widget.campos[i]] = controllers[i].text;
              }
              if (widget.temImagem) novoItem['fotoUrl'] = fotoUrl;

              setState(() => itens.add(novoItem));
              if (mounted) Navigator.pop(context);
              await _salvar();
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  Future<void> _editarItem(int index) async {
    final item = itens[index];
    List<TextEditingController> controllers = widget.campos
        .map((c) => TextEditingController(text: item[c]?.toString() ?? ''))
        .toList();
    File? imagem;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar ${widget.titulo.substring(0, widget.titulo.length - 1)}"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.temImagem)
                GestureDetector(
                  onTap: () async {
                    final picked = await _uploadService.escolherEEnviarImagem(widget.colecao);
                    if (picked != null) imagem = File(picked);
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: imagem != null
                        ? FileImage(imagem!)
                        : (item['fotoUrl'] != null
                            ? NetworkImage(item['fotoUrl']) as ImageProvider
                            : null),
                    child: imagem == null && item['fotoUrl'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                ),
              ...List.generate(
                widget.campos.length,
                (i) => TextField(
                  controller: controllers[i],
                  decoration: InputDecoration(labelText: widget.campos[i]),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              String? fotoUrl = item['fotoUrl'];
              if (imagem != null) fotoUrl = await _uploadService.uploadImagem(imagem!, widget.colecao);

              Map<String, dynamic> atualizado = {'id': item['id']};
              for (int i = 0; i < widget.campos.length; i++) {
                atualizado[widget.campos[i]] = controllers[i].text;
              }
              if (widget.temImagem) atualizado['fotoUrl'] = fotoUrl;

              setState(() => itens[index] = atualizado);
              if (mounted) Navigator.pop(context);
              await _salvar();
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  void _removerItem(String id) {
    setState(() => itens.removeWhere((i) => i['id'] == id));
    _salvar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin - ${widget.titulo}")),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: itens.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final item = itens[i];
                return ListTile(
                  leading: widget.temImagem
                      ? (item['fotoUrl'] != null
                          ? CircleAvatar(backgroundImage: NetworkImage(item['fotoUrl']))
                          : const CircleAvatar(child: Icon(Icons.person)))
                      : null,
                  title: Text(item[widget.campos[0]] ?? ''),
                  subtitle: Text(widget.campos.length > 1
                      ? widget.campos.skip(1).map((c) => item[c] ?? '').join(' • ')
                      : ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _editarItem(i)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _removerItem(item['id'])),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}

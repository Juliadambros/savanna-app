import 'dart:io';
import 'package:flutter/material.dart';
import '../../service/pagina_service.dart';
import '../../service/upload_service.dart';
import '../../models/pagina_model.dart';
import 'package:image_picker/image_picker.dart';

class EditarPaginaPage extends StatefulWidget {
  final String id;
  const EditarPaginaPage({super.key, required this.id});

  @override
  State<EditarPaginaPage> createState() => _EditarPaginaPageState();
}

class _EditarPaginaPageState extends State<EditarPaginaPage> {
  final PaginaService _service = PaginaService();
  final UploadService _uploadService = UploadService();

  final textoCtrl = TextEditingController();
  String? imagemUrl;
  File? _imagemLocal;

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final pagina = await _service.buscar(widget.id);

    if (pagina == null) {
      final novaPagina = PaginaModel(
        id: widget.id,
        conteudo: {'texto': 'Edite aqui o conteúdo da página "${widget.id}".'},
      );
      await _service.salvar(novaPagina);
      textoCtrl.text = novaPagina.conteudo['texto']!;
      imagemUrl = null;
    } else {
      textoCtrl.text = pagina.conteudo['texto'] ?? '';
      imagemUrl = pagina.conteudo['imagemUrl'];
    }

    setState(() => carregando = false);
  }

  Future<void> _selecionarImagem() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imagemLocal = File(picked.path));
    }
  }

  Future<void> _salvar() async {
    String? url = imagemUrl;

    if (_imagemLocal != null) {
      url = await _uploadService.uploadImagem(_imagemLocal!, widget.id);
    }

    final pagina = PaginaModel(
      id: widget.id,
      conteudo: {
        'texto': textoCtrl.text,
        'imagemUrl': url,
      },
    );

    await _service.salvar(pagina);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Página salva com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar página: ${widget.id}")),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _selecionarImagem,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _imagemLocal != null
                          ? FileImage(_imagemLocal!)
                          : (imagemUrl != null
                              ? NetworkImage(imagemUrl!) as ImageProvider
                              : null),
                      child: (_imagemLocal == null && imagemUrl == null)
                          ? const Icon(Icons.add_a_photo, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: textoCtrl,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: "Conteúdo da página",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _salvar,
                    icon: const Icon(Icons.save),
                    label: const Text("Salvar"),
                  ),
                ],
              ),
            ),
    );
  }
}



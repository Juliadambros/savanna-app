import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SobreAdminPage extends StatefulWidget {
  const SobreAdminPage({super.key});

  @override
  State<SobreAdminPage> createState() => _SobreAdminPageState();
}

class _SobreAdminPageState extends State<SobreAdminPage> {
  final _textoCtrl = TextEditingController();
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _carregarTexto();
  }

  Future<void> _carregarTexto() async {
    final doc = await FirebaseFirestore.instance
        .collection('paginas')
        .doc('sobre')
        .get();

    if (doc.exists) {
      _textoCtrl.text = doc['conteudo'] ?? '';
    }
  }

  Future<void> _salvarTexto() async {
    final texto = _textoCtrl.text.trim();
    if (texto.isEmpty) return;

    setState(() => _salvando = true);

    await FirebaseFirestore.instance
        .collection('paginas')
        .doc('sobre')
        .set({'conteudo': texto});

    setState(() => _salvando = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Texto salvo com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Sobre Nós')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _textoCtrl,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: 'Conteúdo da página Sobre Nós',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: _salvando
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_salvando ? 'Salvando...' : 'Salvar'),
              onPressed: _salvando ? null : _salvarTexto,
            )
          ],
        ),
      ),
    );
  }
}

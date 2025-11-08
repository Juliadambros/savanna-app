import 'package:flutter/material.dart';
import 'package:integrador/service/whatsapp_service.dart';

import '../models/produto_model.dart';
import 'components/campo_texto.dart';
import 'components/campo_dropdown.dart';

class FormularioJerseyPage extends StatefulWidget {
  final ProdutoModel? produto;
  const FormularioJerseyPage({super.key, this.produto});

  @override
  State<FormularioJerseyPage> createState() => _FormularioJerseyPageState();
}

class _FormularioJerseyPageState extends State<FormularioJerseyPage> {
  final nomeController = TextEditingController();
  final numeroController = TextEditingController();
  String? tamanho;
  final tamanhos = ['PP', 'P', 'M', 'G', 'GG'];
  bool enviando = false;

  @override
  void dispose() {
    nomeController.dispose();
    numeroController.dispose();
    super.dispose();
  }

  Future<void> _enviarPedido() async {
    final numeroInt = int.tryParse(numeroController.text.trim());
    if (nomeController.text.isEmpty || numeroInt == null || numeroInt < 1 || numeroInt > 100 || tamanho == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome, número (1-100) e tamanho corretos')),
      );
      return;
    }

    setState(() => enviando = true);
    try {
      final mensagem = StringBuffer();
      mensagem.writeln('Pedido de Jersey');
      if (widget.produto != null) mensagem.writeln('Produto: ${widget.produto!.nome}');
      mensagem.writeln('Nome: ${nomeController.text.trim()}');
      mensagem.writeln('Número: ${numeroController.text.trim()}');
      mensagem.writeln('Tamanho: $tamanho');

      // Número do diretor de produtos (exemplo). Substituir pelo real.
      await WhatsAppService.enviarMensagem('55DD999999999', mensagem.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp aberto com mensagem pronta')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao abrir WhatsApp: $e')),
      );
    } finally {
      setState(() => enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final produtoNome = widget.produto?.nome ?? 'Jersey';

    return Scaffold(
      appBar: AppBar(title: Text('Pedido: $produtoNome')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            CampoTexto(label: 'Nome na Jersey', controller: nomeController),
            const SizedBox(height: 12),
            CampoTexto(label: 'Número (1-100)', controller: numeroController),
            const SizedBox(height: 12),
            CampoDropdown(
              label: 'Tamanho',
              valor: tamanho,
              itens: tamanhos,
              aoMudar: (v) => setState(() => tamanho = v),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: enviando ? null : _enviarPedido,
              child: enviando ? const CircularProgressIndicator(color: Colors.white) : const Text('Enviar pedido (WhatsApp)'),
            ),
          ],
        ),
      ),
    );
  }
}

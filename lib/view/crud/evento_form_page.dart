import 'package:flutter/material.dart';
import 'package:integrador/service/evento_service.dart';
import 'package:intl/intl.dart';
import '../../models/evento_model.dart';

import '../components/campo_texto.dart';
import '../components/campo_dropdown.dart';

class EventoFormPage extends StatefulWidget {
  final EventoModel? evento;
  const EventoFormPage({super.key, this.evento});

  @override
  State<EventoFormPage> createState() => _EventoFormPageState();
}

class _EventoFormPageState extends State<EventoFormPage> {
  final tituloCtrl = TextEditingController();
  final descricaoCtrl = TextEditingController();
  final localCtrl = TextEditingController();
  final precoCtrl = TextEditingController();
  DateTime? dataSelecionada;
  String? tipo;
  bool salvando = false;

  final tipos = ['Festa', 'Campeonato', 'Workshop', 'Outro'];

  final EventoService _service = EventoService();

  @override
  void initState() {
    super.initState();
    if (widget.evento != null) {
      final e = widget.evento!;
      tituloCtrl.text = e.titulo;
      descricaoCtrl.text = e.descricao;
      localCtrl.text = e.local;
      precoCtrl.text = e.preco.toString();
      tipo = e.tipo;
      try {
        dataSelecionada = DateFormat('yyyy-MM-dd').parse(e.data);
      } catch (_) {
        dataSelecionada = null;
      }
    }
  }

  @override
  void dispose() {
    tituloCtrl.dispose();
    descricaoCtrl.dispose();
    localCtrl.dispose();
    precoCtrl.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: dataSelecionada ?? hoje,
      firstDate: hoje.subtract(const Duration(days: 365)),
      lastDate: hoje.add(const Duration(days: 365 * 5)),
    );
    if (d != null) setState(() => dataSelecionada = d);
  }

  String _formatData(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  Future<void> _salvar() async {
    if (tituloCtrl.text.trim().isEmpty) {
      _erro('Preencha o título do evento');
      return;
    }
    if (tipo == null) {
      _erro('Selecione o tipo do evento');
      return;
    }
    if (dataSelecionada == null) {
      _erro('Selecione a data do evento');
      return;
    }
    if (localCtrl.text.trim().isEmpty) {
      _erro('Informe o local do evento');
      return;
    }

    double preco = 0.0;
    if (precoCtrl.text.trim().isNotEmpty) {
      preco = double.tryParse(precoCtrl.text.replaceAll(',', '.')) ?? -1;
      if (preco < 0) {
        _erro('Preço inválido');
        return;
      }
    }

    setState(() => salvando = true);
    try {
      final id = widget.evento?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      final evento = EventoModel(
        id: id,
        titulo: tituloCtrl.text.trim(),
        descricao: descricaoCtrl.text.trim(),
        data: _formatData(dataSelecionada!),
        local: localCtrl.text.trim(),
        preco: preco,
        tipo: tipo!,
      );

      await _service.salvarEvento(evento);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Evento salvo com sucesso')));
      Navigator.pop(context);
    } catch (e) {
      _erro('Erro ao salvar: $e');
    } finally {
      setState(() => salvando = false);
    }
  }

  void _erro(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final titulo = widget.evento == null ? 'Novo Evento' : 'Editar Evento';
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CampoTexto(label: 'Título', controller: tituloCtrl),
          const SizedBox(height: 8),
          CampoDropdown(label: 'Tipo', valor: tipo, itens: tipos, aoMudar: (v) => setState(() => tipo = v)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _selecionarData,
            child: AbsorbPointer(
              child: CampoTexto(
                label: 'Data (toque para selecionar)',
                controller: TextEditingController(text: dataSelecionada == null ? '' : _formatData(dataSelecionada!)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          CampoTexto(label: 'Local', controller: localCtrl),
          const SizedBox(height: 8),
          CampoTexto(label: 'Preço (opcional)', controller: precoCtrl),
          const SizedBox(height: 8),
          CampoTexto(label: 'Descrição', controller: descricaoCtrl),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: salvando ? null : _salvar,
            child: salvando ? const CircularProgressIndicator(color: Colors.white) : const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}

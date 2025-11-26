import 'package:flutter/material.dart';
import 'package:integrador/components/botao_padrao.dart';
import 'package:integrador/components/campo_texto.dart';
import 'package:integrador/models/evento_model.dart';
import 'package:integrador/service/evento_service.dart';

class FormEvento extends StatefulWidget {
  final EventoModel? evento;
  const FormEvento({super.key, this.evento});

  @override
  State<FormEvento> createState() => _FormEventoState();
}

class _FormEventoState extends State<FormEvento> {
  final _formKey = GlobalKey<FormState>();
  final EventoService _service = EventoService();

  late TextEditingController _nomeController;
  late TextEditingController _localController;
  late TextEditingController _tipoController;
  late TextEditingController _descricaoController;
  DateTime? _dataSelecionada;

  @override
  void initState() {
    super.initState();
    final e = widget.evento;
    _nomeController = TextEditingController(text: e?.nome ?? '');
    _localController = TextEditingController(text: e?.local ?? '');
    _tipoController = TextEditingController(text: e?.tipo ?? '');
    _descricaoController = TextEditingController(text: e?.descricao ?? '');
    _dataSelecionada = e?.data;
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? hoje,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      setState(() => _dataSelecionada = data);
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate() || _dataSelecionada == null) return;

    final evento = EventoModel(
      id: widget.evento?.id,
      nome: _nomeController.text,
      local: _localController.text,
      tipo: _tipoController.text,
      descricao: _descricaoController.text,
      data: _dataSelecionada!,
    );

    try {
      await _service.salvar(evento);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento salvo com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar evento.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.evento != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF0E2877),
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEdicao ? 'Editar Evento' : 'Novo Evento',
          style: const TextStyle(
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
                Text(
                  isEdicao ? 'Editar Evento' : 'Novo Evento',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          CampoTexto(
                            controller: _nomeController,
                            label: "Nome do Evento",
                            hint: "Digite o nome do evento",
                            emojiFinal: const Icon(Icons.event, color: Color(0xFF0E2877)),
                          ),
                          CampoTexto(
                            controller: _localController,
                            label: "Local",
                            hint: "Digite o local do evento",
                            emojiFinal: const Icon(Icons.place, color: Color(0xFF0E2877)),
                          ),
                          CampoTexto(
                            controller: _tipoController,
                            label: "Tipo",
                            hint: "Digite o tipo de evento",
                            emojiFinal: const Icon(Icons.category, color: Color(0xFF0E2877)),
                          ),
                          CampoTexto(
                            controller: _descricaoController,
                            label: "Descrição",
                            hint: "Digite a descrição do evento",
                            maxLines: 3,
                            emojiFinal: const Icon(Icons.description, color: Color(0xFF0E2877)),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: _selecionarData,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF0E2877),
                                  width: 3,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF0E2877),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _dataSelecionada == null
                                          ? "Selecione uma data"
                                          : "Data: ${_dataSelecionada!.toLocal().toString().split(' ')[0]}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          BotaoPadrao(
                            texto: "Salvar",
                            icone: Icons.save,
                            cor: const Color(0xFF0E2877),
                            raioBorda: 20,
                            tamanhoFonte: 18,
                            onPressed: _salvar,
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
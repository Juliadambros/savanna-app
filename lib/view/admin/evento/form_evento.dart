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
  final EventoService _service = EventoService();

  late TextEditingController _nomeController;
  late TextEditingController _localController;
  late TextEditingController _tipoController;
  late TextEditingController _descricaoController;
  DateTime? _dataSelecionada;
  bool _salvando = false;
  
  bool _formularioModificado = false;

  @override
  void initState() {
    super.initState();
    final e = widget.evento;
    _nomeController = TextEditingController(text: e?.nome ?? '');
    _localController = TextEditingController(text: e?.local ?? '');
    _tipoController = TextEditingController(text: e?.tipo ?? '');
    _descricaoController = TextEditingController(text: e?.descricao ?? '');
    _dataSelecionada = e?.data;
    
    _nomeController.addListener(_verificarModificacao);
    _localController.addListener(_verificarModificacao);
    _tipoController.addListener(_verificarModificacao);
    _descricaoController.addListener(_verificarModificacao);
  }

  void _verificarModificacao() {
    final e = widget.evento;
    if (!_formularioModificado) {
      final modificado = 
          _nomeController.text != (e?.nome ?? '') ||
          _localController.text != (e?.local ?? '') ||
          _tipoController.text != (e?.tipo ?? '') ||
          _descricaoController.text != (e?.descricao ?? '') ||
          _dataSelecionada != e?.data;
      
      if (modificado) {
        setState(() {
          _formularioModificado = true;
        });
      }
    }
  }

  String? _validarCampos() {
    if (_nomeController.text.trim().isEmpty) {
      return 'Preencha o nome do evento';
    }
    
    if (_localController.text.trim().isEmpty) {
      return 'Preencha o local do evento';
    }
    
    if (_tipoController.text.trim().isEmpty) {
      return 'Preencha o tipo de evento';
    }
    
    if (_descricaoController.text.trim().isEmpty) {
      return 'Preencha a descrição do evento';
    }
    
    if (_dataSelecionada == null) {
      return 'Selecione uma data para o evento';
    }
    
    return null;
  }

  Future<bool> _verificarSaida() async {
    if (!_formularioModificado) return true;
    
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Alterações não salvas'),
        content: const Text('Você tem alterações não salvas. Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _localController.dispose();
    _tipoController.dispose();
    _descricaoController.dispose();
    super.dispose();
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
      setState(() {
        _dataSelecionada = data;
        _formularioModificado = true;
      });
    }
  }

  Future<void> _salvar() async {
    // Fecha o teclado
    FocusScope.of(context).unfocus();

    // Valida todos os campos
    final erroValidacao = _validarCampos();
    if (erroValidacao != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erroValidacao)),
      );
      return;
    }

    setState(() => _salvando = true);

    try {
      final evento = EventoModel(
        id: widget.evento?.id,
        nome: _nomeController.text.trim(),
        local: _localController.text.trim(),
        tipo: _tipoController.text.trim(),
        descricao: _descricaoController.text.trim(),
        data: _dataSelecionada!,
      );

      await _service.salvar(evento);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento salvo com sucesso!')),
      );
      
      setState(() => _formularioModificado = false);
      Navigator.pop(context);
      
    } catch (e) {
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar evento.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.evento != null;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        
        final sair = await _verificarSaida();
        if (sair) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final sair = await _verificarSaida();
              if (sair && context.mounted) {
                Navigator.pop(context);
              }
            },
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
                      child: ListView(
                        children: [
                          CampoTexto(
                            controller: _nomeController,
                            label: "Nome do Evento *",
                            hint: "Digite o nome do evento",
                            emojiFinal: const Icon(Icons.event, color: Color(0xFF0E2877)),
                          ),
                          const SizedBox(height: 8),
                          
                          CampoTexto(
                            controller: _localController,
                            label: "Local *",
                            hint: "Digite o local do evento",
                            emojiFinal: const Icon(Icons.place, color: Color(0xFF0E2877)),
                          ),
                          const SizedBox(height: 8),
                          
                          CampoTexto(
                            controller: _tipoController,
                            label: "Tipo *",
                            hint: "Digite o tipo de evento",
                            emojiFinal: const Icon(Icons.category, color: Color(0xFF0E2877)),
                          ),
                          const SizedBox(height: 8),
                          
                          CampoTexto(
                            controller: _descricaoController,
                            label: "Descrição *",
                            hint: "Digite a descrição do evento",
                            maxLines: 3,
                            emojiFinal: const Icon(Icons.description, color: Color(0xFF0E2877)),
                          ),
                          const SizedBox(height: 20),
                          
                          // Campo de data
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
                                  color: _dataSelecionada == null 
                                      ? Colors.red 
                                      : const Color(0xFF0E2877),
                                  width: 3,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: _dataSelecionada == null 
                                        ? Colors.red 
                                        : const Color(0xFF0E2877),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _dataSelecionada == null
                                          ? "Selecione uma data *"
                                          : "Data: ${_dataSelecionada!.toLocal().toString().split(' ')[0]}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _dataSelecionada == null 
                                            ? Colors.red 
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_dataSelecionada == null) ...[
                            const SizedBox(height: 8),
                            const Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'Por favor, selecione uma data',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          
                          BotaoPadrao(
                            texto: "Salvar",
                            icone: Icons.save,
                            cor: const Color(0xFF0E2877),
                            raioBorda: 20,
                            tamanhoFonte: 18,
                            onPressed: _salvar,
                          ),
                          
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '* Campos obrigatórios',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
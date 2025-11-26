import 'package:flutter/material.dart';
import 'package:integrador/components/botao_padrao.dart';
import 'package:integrador/components/campo_texto.dart';
import 'package:integrador/components/mask_formatter.dart';
import 'package:integrador/models/parceiro_model.dart';
import 'package:integrador/service/parceiro_service.dart';

class FormParceria extends StatefulWidget {
  final ParceiroModel? parceiro;
  const FormParceria({super.key, this.parceiro});

  @override
  State<FormParceria> createState() => _FormParceriaState();
}

class _FormParceriaState extends State<FormParceria> {
  final ParceiroService _service = ParceiroService();

  late TextEditingController _nome;
  late TextEditingController _descricao;
  late TextEditingController _contato;
  bool _salvando = false;
  
  bool _formularioModificado = false;

  final phoneMask = PhoneMaskTextInputFormatter();

  @override
  void initState() {
    super.initState();
    final p = widget.parceiro;
    _nome = TextEditingController(text: p?.nome ?? '');
    _descricao = TextEditingController(text: p?.descricao ?? '');
    
    if (p?.contato != null && p!.contato.isNotEmpty && RegExp(r'^\d+$').hasMatch(p.contato)) {
      _contato = TextEditingController(
        text: phoneMask.formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: p.contato),
        ).text,
      );
    } else {
      _contato = TextEditingController(text: p?.contato ?? '');
    }
    
    _nome.addListener(_verificarModificacao);
    _descricao.addListener(_verificarModificacao);
    _contato.addListener(_verificarModificacao);
  }

  void _verificarModificacao() {
    final p = widget.parceiro;
    if (!_formularioModificado) {
      final contatoOriginal = p?.contato ?? '';
      final contatoFormatado = contatoOriginal.isNotEmpty && RegExp(r'^\d+$').hasMatch(contatoOriginal)
          ? phoneMask.formatEditUpdate(
              TextEditingValue.empty,
              TextEditingValue(text: contatoOriginal),
            ).text
          : contatoOriginal;
      
      final modificado = 
          _nome.text != (p?.nome ?? '') ||
          _descricao.text != (p?.descricao ?? '') ||
          _contato.text != contatoFormatado;
      
      if (modificado) {
        setState(() {
          _formularioModificado = true;
        });
      }
    }
  }

  String? _validarCampos() {
    if (_nome.text.trim().isEmpty) {
      return 'Preencha o nome da parceria';
    }
    
    if (_descricao.text.trim().isEmpty) {
      return 'Preencha a descrição da parceria';
    }
    
    if (_contato.text.trim().isEmpty) {
      return 'Preencha o contato da parceria';
    }
    
    if (!_validarTelefone(_contato.text)) {
      return 'Telefone inválido. Digite um número com DDD (10 ou 11 dígitos).';
    }
    
    return null;
  }

  bool _validarTelefone(String telefone) {
    final apenasNumeros = telefone.replaceAll(RegExp(r'[^\d]'), '');
    if (apenasNumeros.length != 10 && apenasNumeros.length != 11) {
      return false;
    }
    final ddd = int.tryParse(apenasNumeros.substring(0, 2));
    if (ddd == null || ddd < 11 || ddd > 99) {
      return false;
    }
    
    return true;
  }

  String _obterApenasNumerosTelefone(String telefoneComMascara) {
    return telefoneComMascara.replaceAll(RegExp(r'[^\d]'), '');
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
    _nome.dispose();
    _descricao.dispose();
    _contato.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    FocusScope.of(context).unfocus();
    final erroValidacao = _validarCampos();
    if (erroValidacao != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erroValidacao)),
      );
      return;
    }

    setState(() => _salvando = true);

    try {
      final contatoApenasNumeros = _obterApenasNumerosTelefone(_contato.text);

      final parceiro = ParceiroModel(
        id: widget.parceiro?.id,
        nome: _nome.text.trim(),
        descricao: _descricao.text.trim(),
        contato: contatoApenasNumeros,
      );

      await _service.salvar(parceiro);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parceria salva com sucesso!')),
      );
      
      setState(() => _formularioModificado = false);
      Navigator.pop(context);
      
    } catch (e) {
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar parceria.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.parceiro != null;

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
            isEdicao ? 'Editar Parceria' : 'Nova Parceria',
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
                    isEdicao ? 'Editar Parceria' : 'Nova Parceria',
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
                            controller: _nome,
                            label: "Nome *",
                            hint: "Digite o nome da parceria",
                            emojiFinal: const Icon(Icons.business, color: Color(0xFF0E2877)),
                          ),
                          const SizedBox(height: 8),
                          
                          CampoTexto(
                            controller: _descricao,
                            label: "Descrição *",
                            hint: "Digite a descrição da parceria",
                            emojiFinal: const Icon(Icons.description, color: Color(0xFF0E2877)),
                          ),
                          const SizedBox(height: 8),
                          
                          // Campo de contato/telefone com máscara automática
                          TextField(
                            controller: _contato,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [phoneMask],
                            decoration: InputDecoration(
                              labelText: 'Contato *',
                              labelStyle: TextStyle(color: Color(0xFF0E2877)),
                              hintText: '(11) 99999-9999',
                              suffixIcon: Icon(Icons.phone, color: Color(0xFF0E2877)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Color(0xFF0E2877), width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Color(0xFF0E2877), width: 3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
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
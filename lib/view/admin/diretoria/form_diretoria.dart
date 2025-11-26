import 'package:flutter/material.dart';
import 'package:integrador/components/botao_padrao.dart';
import 'package:integrador/components/campo_dropdown.dart';
import 'package:integrador/components/campo_texto.dart';
import 'package:integrador/models/diretor_model.dart';
import 'package:integrador/service/diretoria_service.dart';

class FormDiretor extends StatefulWidget {
  final DiretorModel? diretor;

  const FormDiretor({super.key, this.diretor});

  @override
  State<FormDiretor> createState() => _FormDiretorState();
}

class _FormDiretorState extends State<FormDiretor> {
  final DiretoriaService _service = DiretoriaService();

  late TextEditingController _nomeController;
  String? _cargoSelecionado;
  String? _cursoSelecionado;
  bool _salvando = false;
  
  bool _formularioModificado = false;

  final List<String> cargos = [
    'Presidente',
    'Vice-Presidente',
    'Tesoureiro',
    'Secretário',
    'Eventos',
  ];

  final cursos = [
    'Ciência da Computação',
    'Química',
    'Física',
    'Matemática Licenciatura',
    "Big Data",
    "Matematica Computacional"
  ];

  @override
  void initState() {
    super.initState();
    final d = widget.diretor;

    _nomeController = TextEditingController(text: d?.nome ?? '');
    _cargoSelecionado = d?.cargo ?? cargos.first;
    _cursoSelecionado = d?.curso ?? cursos.first;
    
    _nomeController.addListener(_verificarModificacao);
  }

  void _verificarModificacao() {
    final d = widget.diretor;
    if (!_formularioModificado) {
      final modificado = 
          _nomeController.text != (d?.nome ?? '') ||
          _cargoSelecionado != d?.cargo ||
          _cursoSelecionado != d?.curso;
      
      if (modificado) {
        setState(() {
          _formularioModificado = true;
        });
      }
    }
  }

  String? _validarCampos() {
    if (_nomeController.text.trim().isEmpty) {
      return 'Preencha o nome do membro';
    }
    
    if (_cargoSelecionado == null || _cargoSelecionado!.isEmpty) {
      return 'Selecione um cargo';
    }
    
    if (_cursoSelecionado == null || _cursoSelecionado!.isEmpty) {
      return 'Selecione um curso';
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
      final diretor = DiretorModel(
        id: widget.diretor?.id,
        nome: _nomeController.text.trim(),
        cargo: _cargoSelecionado!,
        curso: _cursoSelecionado!,
      );

      await _service.salvarDiretor(diretor);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membro salvo com sucesso!')),
      );
      
      setState(() => _formularioModificado = false);
      Navigator.pop(context);
      
    } catch (e) {
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar membro.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.diretor != null;

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
            isEdicao ? 'Editar Diretor' : 'Novo Diretor',
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
                    isEdicao ? 'Editar Diretor' : 'Novo Diretor',
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
                            label: "Nome *",
                            hint: "Digite o nome completo",
                            emojiFinal: const Icon(Icons.person, color: Color(0xFF0E2877)),
                          ),
                          const SizedBox(height: 8),
                          
                          CampoDropdown(
                            label: "Cargo *",
                            valor: _cargoSelecionado,
                            itens: cargos,
                            aoMudar: (v) => setState(() {
                              _cargoSelecionado = v;
                              _formularioModificado = true;
                            }),
                          ),
                          const SizedBox(height: 8),
                          
                          CampoDropdown(
                            label: "Curso *",
                            valor: _cursoSelecionado,
                            itens: cursos,
                            aoMudar: (v) => setState(() {
                              _cursoSelecionado = v;
                              _formularioModificado = true;
                            }),
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
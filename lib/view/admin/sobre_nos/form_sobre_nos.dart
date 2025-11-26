import 'package:flutter/material.dart';
import 'package:integrador/components/botao_padrao.dart';
import 'package:integrador/components/campo_texto.dart';
import 'package:integrador/models/sobre_nos_model.dart';
import 'package:integrador/service/sobre_nos_service.dart';

class FormSobreNos extends StatefulWidget {
  final SobreNosModel? pagina;
  const FormSobreNos({super.key, this.pagina});

  @override
  State<FormSobreNos> createState() => _FormSobreNosState();
}

class _FormSobreNosState extends State<FormSobreNos> {
  final SobreNosService _service = SobreNosService();

  late TextEditingController _titulo;
  late TextEditingController _conteudo;
  bool _salvando = false;
  
  bool _formularioModificado = false;

  @override
  void initState() {
    super.initState();
    final p = widget.pagina;
    _titulo = TextEditingController(text: p?.titulo ?? '');
    _conteudo = TextEditingController(text: p?.conteudo ?? '');
    
    _titulo.addListener(_verificarModificacao);
    _conteudo.addListener(_verificarModificacao);
  }

  void _verificarModificacao() {
    final p = widget.pagina;
    if (!_formularioModificado) {
      final modificado = 
          _titulo.text != (p?.titulo ?? '') ||
          _conteudo.text != (p?.conteudo ?? '');
      
      if (modificado) {
        setState(() {
          _formularioModificado = true;
        });
      }
    }
  }

  String? _validarCampos() {
    if (_titulo.text.trim().isEmpty) {
      return 'Preencha o título da página';
    }
    
    if (_conteudo.text.trim().isEmpty) {
      return 'Preencha o conteúdo da página';
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
    _titulo.dispose();
    _conteudo.dispose();
    super.dispose();
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
      final pagina = SobreNosModel(
        id: widget.pagina?.id,
        titulo: _titulo.text.trim(),
        conteudo: _conteudo.text.trim(),
      );

      await _service.salvar(pagina);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Página salva com sucesso!')),
      );
      
      setState(() => _formularioModificado = false);
      Navigator.pop(context);
      
    } catch (e) {
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar página.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.pagina != null;

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
            isEdicao ? 'Editar Página' : 'Nova Página',
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
                    isEdicao ? 'Editar Página' : 'Nova Página',
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
                            controller: _titulo,
                            label: "Título *",
                            hint: "Digite o título da página",
                            emojiFinal: const Icon(Icons.title, color: Color(0xFF0E2877)),
                          ),
                          const SizedBox(height: 8),
                          
                          CampoTexto(
                            controller: _conteudo,
                            label: "Conteúdo *",
                            hint: "Digite o conteúdo da página",
                            maxLines: 5,
                            emojiFinal: const Icon(Icons.description, color: Color(0xFF0E2877)),
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
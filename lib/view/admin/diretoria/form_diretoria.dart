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
  final _formKey = GlobalKey<FormState>();
  final DiretoriaService _service = DiretoriaService();

  late TextEditingController _nomeController;
  String? _cargoSelecionado;
  String? _cursoSelecionado;

  final List<String> cargos = [
    'Presidente',
    'Vice-Presidente',
    'Tesoureiro',
    'Secretário',
    'Membro',
  ];

  final List<String> cursos = [
    'Administração',
    'Engenharia',
    'Ciência da Computação',
    'Direito',
    'Arquitetura',
    'Outro',
  ];

  @override
  void initState() {
    super.initState();
    final d = widget.diretor;

    _nomeController = TextEditingController(text: d?.nome ?? '');
    _cargoSelecionado = d?.cargo ?? cargos.first;
    _cursoSelecionado = d?.curso ?? cursos.first;
  }

  Future<void> _salvar() async {
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Informe o nome")),
      );
      return;
    }

    final diretor = DiretorModel(
      id: widget.diretor?.id,
      nome: _nomeController.text.trim(),
      cargo: _cargoSelecionado!,
      curso: _cursoSelecionado!,
    );

    try {
      await _service.salvarDiretor(diretor);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membro salvo com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar membro.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.diretor != null;

    return Scaffold(
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
                          label: "Nome",
                          hint: "Digite o nome completo",
                          emojiFinal: const Icon(Icons.person, color: Color(0xFF0E2877)),
                        ),
                        CampoDropdown(
                          label: "Cargo",
                          valor: _cargoSelecionado,
                          itens: cargos,
                          aoMudar: (v) => setState(() => _cargoSelecionado = v),
                        ),
                        CampoDropdown(
                          label: "Curso",
                          valor: _cursoSelecionado,
                          itens: cursos,
                          aoMudar: (v) => setState(() => _cursoSelecionado = v),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
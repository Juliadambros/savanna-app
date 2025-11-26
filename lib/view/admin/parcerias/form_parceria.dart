import 'package:flutter/material.dart';
import 'package:integrador/components/botao_padrao.dart';
import 'package:integrador/components/campo_texto.dart';
import 'package:integrador/models/parceiro_model.dart';
import 'package:integrador/service/parceiro_service.dart';

class FormParceria extends StatefulWidget {
  final ParceiroModel? parceiro;
  const FormParceria({super.key, this.parceiro});

  @override
  State<FormParceria> createState() => _FormParceriaState();
}

class _FormParceriaState extends State<FormParceria> {
  final _formKey = GlobalKey<FormState>();
  final ParceiroService _service = ParceiroService();

  late TextEditingController _nome;
  late TextEditingController _descricao;
  late TextEditingController _contato;

  @override
  void initState() {
    super.initState();
    final p = widget.parceiro;
    _nome = TextEditingController(text: p?.nome ?? '');
    _descricao = TextEditingController(text: p?.descricao ?? '');
    _contato = TextEditingController(text: p?.contato ?? '');
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final parceiro = ParceiroModel(
      id: widget.parceiro?.id,
      nome: _nome.text,
      descricao: _descricao.text,
      contato: _contato.text,
    );

    try {
      await _service.salvar(parceiro);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parceria salva com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar parceria.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.parceiro != null;

    return Scaffold(
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
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          CampoTexto(
                            controller: _nome,
                            label: "Nome",
                            hint: "Digite o nome da parceria",
                            emojiFinal: const Icon(Icons.business, color: Color(0xFF0E2877)),
                          ),
                          CampoTexto(
                            controller: _descricao,
                            label: "Descrição",
                            hint: "Digite a descrição da parceria",
                            emojiFinal: const Icon(Icons.description, color: Color(0xFF0E2877)),
                          ),
                          CampoTexto(
                            controller: _contato,
                            label: "Contato",
                            hint: "Digite o contato da parceria",
                            emojiFinal: const Icon(Icons.phone, color: Color(0xFF0E2877)),
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
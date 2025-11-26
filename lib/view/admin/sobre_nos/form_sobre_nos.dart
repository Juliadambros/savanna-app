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
  final _formKey = GlobalKey<FormState>();
  final SobreNosService _service = SobreNosService();

  late TextEditingController _titulo;
  late TextEditingController _conteudo;

  @override
  void initState() {
    super.initState();
    final p = widget.pagina;
    _titulo = TextEditingController(text: p?.titulo ?? '');
    _conteudo = TextEditingController(text: p?.conteudo ?? '');
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final pagina = SobreNosModel(
      id: widget.pagina?.id,
      titulo: _titulo.text,
      conteudo: _conteudo.text,
    );

    try {
      await _service.salvar(pagina);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Página salva com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar página.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.pagina != null;

    return Scaffold(
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
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          CampoTexto(
                            controller: _titulo,
                            label: "Título",
                            hint: "Digite o título da página",
                            emojiFinal: const Icon(Icons.title, color: Color(0xFF0E2877)),
                          ),
                          CampoTexto(
                            controller: _conteudo,
                            label: "Conteúdo",
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
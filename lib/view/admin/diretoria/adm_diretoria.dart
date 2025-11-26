import 'package:flutter/material.dart';
import 'package:integrador/models/diretor_model.dart';
import 'package:integrador/service/diretoria_service.dart';
import 'form_diretoria.dart';

class AdmDiretoriaPage extends StatefulWidget {
  const AdmDiretoriaPage({super.key});

  @override
  State<AdmDiretoriaPage> createState() => _AdmDiretoriaPageState();
}

class _AdmDiretoriaPageState extends State<AdmDiretoriaPage> {
  final DiretoriaService _service = DiretoriaService();
  List<DiretorModel> _membros = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final lista = await _service.listarDiretores();
      setState(() => _membros = lista);
    } catch (e) {
      setState(() => _erro = 'Erro ao carregar membros.');
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _remover(DiretorModel diretor) async {
    try {
      await _service.deletarDiretor(diretor.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membro removido com sucesso!')),
      );
      _carregar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao remover membro.')),
      );
    }
  }

  void _abrirForm({DiretorModel? diretor}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormDiretor(diretor: diretor)),
    );
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                "assets/imgs/mascote.png",
                width: 220,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 28,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Center(
                  child: Image.asset(
                    "assets/imgs/logo.png",
                    height: 70,
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  "Gerenciar Diretoria",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),
                Expanded(
                  child: _carregando
                      ? const Center(child: CircularProgressIndicator())
                      : _erro != null
                          ? Center(child: Text(_erro!))
                          : _membros.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Nenhum membro cadastrado.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _membros.length,
                                  itemBuilder: (context, i) {
                                    final m = _membros[i];

                                    return Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(16),
                                        title: Text(
                                          m.nome,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${m.cargo} • ${m.curso}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _remover(m),
                                        ),
                                        onTap: () => _abrirForm(diretor: m),
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0E2877),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _abrirForm(),
      ),
    );
  }
}

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
      appBar: AppBar(title: const Text('Gerenciar Diretoria')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? Center(child: Text(_erro!))
              : _membros.isEmpty
                  ? const Center(child: Text('Nenhum membro cadastrado.'))
                  : ListView.builder(
                      itemCount: _membros.length,
                      itemBuilder: (context, i) {
                        final m = _membros[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            title: Text(m.nome),
                            subtitle: Text('${m.cargo} • ${m.curso}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _remover(m),
                            ),
                            onTap: () => _abrirForm(diretor: m),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}



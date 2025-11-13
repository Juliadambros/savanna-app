import 'package:flutter/material.dart';
import 'package:integrador/models/diretor_model.dart';
import 'package:integrador/service/diretoria_service.dart';

class DiretoriaPage extends StatefulWidget {
  const DiretoriaPage({super.key});

  @override
  State<DiretoriaPage> createState() => _DiretoriaPageState();
}

class _DiretoriaPageState extends State<DiretoriaPage> {
  final service = DiretoriaService();
  List<DiretorModel> membros = [];

  @override
  void initState() {
    super.initState();
    carregarDiretoria();
  }

  Future<void> carregarDiretoria() async {
    final lista = await service.listarDiretores();
    setState(() => membros = lista);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diretoria')),
      body: membros.isEmpty
          ? const Center(child: Text('Nenhum membro cadastrado.'))
          : ListView.builder(
              itemCount: membros.length,
              itemBuilder: (context, index) {
                final m = membros[index];
                return ListTile(
                  title: Text(m.nome),
                  subtitle: Text('${m.cargo} • ${m.curso}'),
                );
              },
            ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:integrador/models/parceiro_model.dart';
import 'package:integrador/service/parceiro_service.dart';

class ParceriasPage extends StatefulWidget {
  const ParceriasPage({super.key});

  @override
  State<ParceriasPage> createState() => _ParceriasPageState();
}

class _ParceriasPageState extends State<ParceriasPage> {
  final service = ParceiroService();
  List<ParceiroModel> parceiros = [];

  @override
  void initState() {
    super.initState();
    carregarParcerias();
  }

  Future<void> carregarParcerias() async {
    final lista = await service.listar();
    setState(() => parceiros = lista);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parcerias')),
      body: parceiros.isEmpty
          ? const Center(child: Text('Nenhuma parceria cadastrada.'))
          : ListView.builder(
              itemCount: parceiros.length,
              itemBuilder: (context, index) {
                final p = parceiros[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(p.nome),
                    subtitle: Text('${p.descricao}\nContato: ${p.contato}'),
                  ),
                );
              },
            ),
    );
  }
}


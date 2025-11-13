import 'package:flutter/material.dart';
import 'package:integrador/models/sobre_nos_model.dart';
import 'package:integrador/service/sobre_nos_service.dart';


class SobrePage extends StatefulWidget {
  const SobrePage({super.key});

  @override
  State<SobrePage> createState() => _SobrePageState();
}

class _SobrePageState extends State<SobrePage> {
  final SobreNosService _service = SobreNosService();
  List<SobreNosModel> _paginas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista = await _service.listar();
    setState(() {
      _paginas = lista;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre nós')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _paginas.isEmpty
              ? const Center(child: Text('Nenhuma informação disponível.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _paginas
                        .map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.titulo,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    p.conteudo,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
    );
  }
}

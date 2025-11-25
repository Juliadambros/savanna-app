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
      // APPBAR PADRÃO
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),

      body: Stack(
        children: [
          // ---------- MASCOTE NO FUNDO ----------
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/imgs/mascote.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          if (_carregando)
            const Center(child: CircularProgressIndicator())

          else if (_paginas.isEmpty)
            const Center(
              child: Text(
                'Nenhuma informação disponível.',
                style: TextStyle(fontSize: 16),
              ),
            )

          else
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // ---------- LOGO NO TOPO ----------
                  Center(
                    child: Image.asset(
                      'assets/imgs/logo.png',
                      height: 110,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ---------- CONTEÚDO CENTRALIZADO ----------
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _paginas.map((p) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              p.titulo,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              p.conteudo,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

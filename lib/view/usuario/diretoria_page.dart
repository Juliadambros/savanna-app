import 'package:flutter/material.dart';
import 'package:integrador/models/diretor_model.dart';
import 'package:integrador/service/diretoria_service.dart';
import 'package:integrador/components/card_item.dart';

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
      // APPBAR PADRÃO COM VOLTAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),

      body: Stack(
        children: [
          // ----------- MASCOTE NO FUNDO -----------
          Positioned.fill(
            child: Opacity(
              opacity: 0.30,
              child: Image.asset('assets/imgs/mascote.png', fit: BoxFit.cover),
            ),
          ),

          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 20),
                child: Text(
                  "Diretoria",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              Expanded(
                child: membros.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum membro cadastrado.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: membros.length,
                        itemBuilder: (context, index) {
                          final m = membros[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CardItem(
                              titulo: m.nome,
                              descricao: "${m.cargo}\nCurso: ${m.curso}",
                              imagem: "assets/imgs/img4.png",
                              opacidade: 0.70,
                              corFundo: index % 2 == 0
                                  ? const Color(0xFF0E2877)
                                  : const Color(0xFFE96120),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

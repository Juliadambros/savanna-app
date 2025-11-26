import 'package:flutter/material.dart';
import 'package:integrador/models/parceiro_model.dart';
import 'package:integrador/service/parceiro_service.dart';
import 'form_parceria.dart';

class AdmParceriasPage extends StatefulWidget {
  const AdmParceriasPage({super.key});

  @override
  State<AdmParceriasPage> createState() => _AdmParceriasPageState();
}

class _AdmParceriasPageState extends State<AdmParceriasPage> {
  final ParceiroService _service = ParceiroService();
  List<ParceiroModel> _parceiros = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista = await _service.listar();
    setState(() => _parceiros = lista);
  }

  Future<void> _remover(String id) async {
    await _service.deletar(id);
    _carregar();
  }

  void _abrirForm({ParceiroModel? parceiro}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormParceria(parceiro: parceiro)),
    );
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text(
          'Gerenciar Parcerias',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Stack(
        children: [
          // Fundo branco
          Positioned.fill(
            child: Container(color: Colors.white),
          ),

          // Mascote igual ao AdmEventosPage
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/imgs/mascote.png',
              width: 220,
              fit: BoxFit.contain,
            ),
          ),

          // Logo no topo
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/imgs/logo.png',
                height: 90,
              ),
            ),
          ),

          // Conteúdo
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: _parceiros.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma parceria cadastrada.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: _parceiros.length,
                    itemBuilder: (context, i) {
                      final p = _parceiros[i];

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            p.nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '${p.descricao}\nContato: ${p.contato}',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _remover(p.id!),
                          ),
                          onTap: () => _abrirForm(parceiro: p),
                        ),
                      );
                    },
                  ),
          ),
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

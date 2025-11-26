import 'package:flutter/material.dart';
import 'package:integrador/models/sobre_nos_model.dart';
import 'package:integrador/service/sobre_nos_service.dart';
import 'form_sobre_nos.dart';

class AdmSobreNosPage extends StatefulWidget {
  const AdmSobreNosPage({super.key});

  @override
  State<AdmSobreNosPage> createState() => _AdmSobreNosPageState();
}

class _AdmSobreNosPageState extends State<AdmSobreNosPage> {
  final SobreNosService _service = SobreNosService();
  List<SobreNosModel> _paginas = [];
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
      final lista = await _service.listar();
      setState(() => _paginas = lista);
    } catch (e) {
      setState(() => _erro = 'Erro ao carregar informações.');
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _abrirForm({SobreNosModel? pagina}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormSobreNos(pagina: pagina)),
    );
    _carregar();
  }

  Future<void> _remover(String id) async {
    try {
      await _service.deletar(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informação removida com sucesso!')),
      );
      _carregar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao remover informação.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF0E2877),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Sobre Nós",
          style: TextStyle(
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
                const Text(
                  "Gerenciar Sobre Nós",
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
                          : _paginas.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Nenhuma informação cadastrada.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _paginas.length,
                                  itemBuilder: (context, i) {
                                    final p = _paginas[i];
                                    return Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(16),
                                        title: Text(
                                          p.titulo,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          p.conteudo,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _remover(p.id!),
                                        ),
                                        onTap: () => _abrirForm(pagina: p),
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
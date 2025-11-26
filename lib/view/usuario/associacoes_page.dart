import 'package:flutter/material.dart';
import 'package:integrador/models/associacao_model.dart';
import 'package:integrador/service/associacao_service.dart';
import 'package:integrador/view/admin/associacao/form_associacao.dart';

class AssociacoesPage extends StatefulWidget {
  const AssociacoesPage({super.key});

  @override
  State<AssociacoesPage> createState() => _AssociacoesPageState();
}

class _AssociacoesPageState extends State<AssociacoesPage> {
  final AssociacaoService _service = AssociacaoService();
  List<AssociacaoModel> _associacoes = [];
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
      final lista = await _service.listarAssociacoes();
      setState(() => _associacoes = lista);
    } catch (e) {
      setState(() => _erro = 'Erro ao carregar associação.');
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _abrirFormulario({AssociacaoModel? associacao}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormAssociacao(associacao: associacao),
      ),
    );
    await _carregar();
  }

  Widget _buildCarteirinha(AssociacaoModel associacao) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0E2877),
              const Color(0xFF0E2877).withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'AAACETU SAVANNA ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
              ],
            ),
            
            const SizedBox(height: 8),
            const Divider(color: Colors.white54),
            const SizedBox(height: 8),
            
            // Texto descritivo
            const Text(
              'Aqui está sua Carteirinha de sócio, lembre-se de apresentar ela ao pedir descontos!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Dados do sócio
            _buildInfoCarteirinha('Nome Sócio', associacao.nomeCompleto),
            _buildInfoCarteirinha('RA', associacao.ra),
            _buildInfoCarteirinha('Tipo da associação', associacao.tipo),
            _buildInfoCarteirinha('Curso', associacao.curso),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCarteirinha(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
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
          "Minha Carteirinha",
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
                  "Associação de Sócio",
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
                          : _associacoes.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Nenhuma associação cadastrada.',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () => _abrirFormulario(),
                                      child: const Text('Criar Associação'),
                                    ),
                                  ],
                                )
                              : RefreshIndicator(
                                  onRefresh: _carregar,
                                  child: ListView(
                                    children: [
                                      // Mostra apenas a carteirinha do usuário
                                      _buildCarteirinha(_associacoes.first),
                                      
                                      // Botão de editar
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: ElevatedButton.icon(
                                          onPressed: () => _abrirFormulario(associacao: _associacoes.first),
                                          icon: const Icon(Icons.edit),
                                          label: const Text('Editar Carteirinha'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF0E2877),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: _associacoes.isEmpty
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF0E2877),
              child: const Icon(Icons.add),
              onPressed: () => _abrirFormulario(),
            )
          : null,
    );
  }
}
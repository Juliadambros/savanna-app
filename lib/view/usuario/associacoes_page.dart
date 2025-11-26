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
  AssociacaoModel? _minhaAssociacao;
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
      _minhaAssociacao = lista.isNotEmpty ? lista.first : null;

    } catch (e) {
      setState(() => _erro = 'Erro ao carregar: $e');
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _abrirFormulario({AssociacaoModel? associacao}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormAssociacao(
          associacao: associacao,
        ),
      ),
    );
    await _carregar();
  }

  Widget _buildCarteirinha(AssociacaoModel associacao) {
    final bool isAprovado = associacao.status == 'aprovado';
    
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                // Status da associação
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCorStatus(associacao.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    associacao.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(color: Colors.white54),
            const SizedBox(height: 8),

            Text(
              _getMensagemStatus(associacao.status),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 20),

            _buildInfoCarteirinha('Nome Sócio', 
                isAprovado ? associacao.nomeCompleto : 'Aguardando aprovação'),
            _buildInfoCarteirinha('RA', 
                isAprovado ? associacao.ra : 'Aguardando aprovação'),
            _buildInfoCarteirinha('Tipo da associação', 
                isAprovado ? associacao.tipo : 'Aguardando aprovação'),
            _buildInfoCarteirinha('Curso', 
                isAprovado ? associacao.curso : 'Aguardando aprovação'),

            const SizedBox(height: 16),
            if (associacao.status == 'pendente') 
              const Text(
                'Sua solicitação está em análise. Você receberá uma mensagem quando for aprovada.',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (associacao.status == 'recusado')
              const Text(
                'Sua solicitação foi recusada. Entre em contato para mais informações.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarteirinhaDefault() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                // Status da associação
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'EXEMPLO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(color: Colors.white54),
            const SizedBox(height: 8),

            // Texto descritivo
            const Text(
              'Esta é uma prévia da sua futura carteirinha de sócio!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 20),

            _buildInfoCarteirinha('Nome Sócio', 'Seu Nome Completo'),
            _buildInfoCarteirinha('RA', '57023740017'),
            _buildInfoCarteirinha('Tipo da associação', 'Calouro'),
            _buildInfoCarteirinha('Curso', 'Ciência da Computação'),

            const SizedBox(height: 16),
            const Text(
              'Torne-se um associado para obter sua carteirinha personalizada!',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelaComAssociacao() {
    return Column(
      children: [
        _buildCarteirinha(_minhaAssociacao!),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              if (_minhaAssociacao!.status == 'pendente')
                Column(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 50,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Solicitação em Análise',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sua solicitação está sendo analisada pela equipe.\nVocê receberá uma notificação quando for aprovada.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _abrirFormulario(associacao: _minhaAssociacao),
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar Solicitação'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E2877),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              
              if (_minhaAssociacao!.status == 'recusado')
                Column(
                  children: [
                    const Icon(
                      Icons.cancel,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Solicitação Recusada',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sua solicitação foi recusada. Entre em contato para mais informações.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _abrirFormulario(associacao: _minhaAssociacao),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reenviar Solicitação'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E2877),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              
              if (_minhaAssociacao!.status == 'aprovado')
                Column(
                  children: [
                    const Icon(
                      Icons.verified,
                      size: 50,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Associação Aprovada!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Parabéns! Você agora é um associado da AAACETU SAVANNA.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTelaSemAssociacao() {
    return Column(
      children: [
        _buildCarteirinhaDefault(),
        
        const SizedBox(height: 20),
        const Icon(
          Icons.card_membership,
          size: 60,
          color: Color(0xFF0E2877),
        ),
        const SizedBox(height: 20),
        const Text(
          'Torne-se um Associado!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E2877),
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Faça parte da nossa associação e aproveite todos os benefícios exclusivos para sócios!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () => _abrirFormulario(),
          icon: const Icon(Icons.person_add),
          label: const Text('Quero me Associar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0E2877),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ],
    );
  }

  Color _getCorStatus(String status) {
    switch (status) {
      case 'aprovado':
        return Colors.green;
      case 'recusado':
        return Colors.red;
      case 'pendente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getMensagemStatus(String status) {
    switch (status) {
      case 'aprovado':
        return 'Aqui está sua Carteirinha de sócio, lembre-se de apresentar ela ao pedir descontos!';
      case 'recusado':
        return 'Sua solicitação foi recusada. Entre em contato para mais informações.';
      case 'pendente':
        return 'Sua solicitação está em análise. Aguarde a aprovação.';
      default:
        return 'Complete sua solicitação para obter sua carteirinha.';
    }
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
            value.isNotEmpty ? value : 'Não informado',
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
          "Minha Associação",
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
                Center(child: Image.asset("assets/imgs/logo.png", height: 70)),
                const SizedBox(height: 10),
                const Text(
                  "AAACETU SAVANNA",
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
                      : RefreshIndicator(
                          onRefresh: _carregar,
                          child: ListView(
                            children: [
                              if (_minhaAssociacao != null)
                                _buildTelaComAssociacao()
                              else
                                _buildTelaSemAssociacao(),
                              
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _minhaAssociacao == null
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF0E2877),
              child: const Icon(Icons.person_add),
              onPressed: () => _abrirFormulario(),
            )
          : null,
    );
  }
}
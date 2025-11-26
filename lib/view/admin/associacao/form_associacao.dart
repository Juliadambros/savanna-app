import 'package:flutter/material.dart';
import 'package:integrador/components/mask_formatter.dart';
import 'package:integrador/models/associacao_model.dart';
import 'package:integrador/service/associacao_service.dart';
import 'package:integrador/service/whatsapp_service.dart';
import 'package:uuid/uuid.dart';

class FormAssociacao extends StatefulWidget {
  final AssociacaoModel? associacao;
  final String? emailUsuario;
  final String? nomeUsuario;

  const FormAssociacao({
    super.key, 
    this.associacao,
    this.emailUsuario,
    this.nomeUsuario,
  });

  @override
  State<FormAssociacao> createState() => _FormAssociacaoState();
}

class _FormAssociacaoState extends State<FormAssociacao> {
  final _formKey = GlobalKey<FormState>();
  final _service = AssociacaoService();
  final _uuid = const Uuid();

  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _cpfController;
  late TextEditingController _raController;
  late TextEditingController _telefoneController;

  String? _tipoSelecionado;
  String? _cursoSelecionado;
  String? _pagamentoSelecionado;

  final List<String> tipos = ['Calouro', 'Aluno', 'Ex-aluno'];
  final cursos = [
    'Ciência da Computação',
    'Química',
    'Física',
    'Matemática Licenciatura',
    "Big Data",
    "Matematica Computacional"
  ];
  final List<String> pagamentos = ['Pix', 'Cartão', 'Boleto', 'Outro'];

  bool _dadosAlterados = false;


@override
void initState() {
  super.initState();
  

  if (widget.associacao != null) {
    final a = widget.associacao!;
    _nomeController = TextEditingController(text: a.nomeCompleto);
    _emailController = TextEditingController(text: a.email);
    _cpfController = TextEditingController(text: a.cpf);
    _raController = TextEditingController(text: a.ra);
    _telefoneController = TextEditingController(text: a.telefone);
    _tipoSelecionado = a.tipo;
    _cursoSelecionado = a.curso;
    _pagamentoSelecionado = a.meioPagamento;
  } else {
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _cpfController = TextEditingController();
    _raController = TextEditingController();
    _telefoneController = TextEditingController();
    
    _tipoSelecionado = tipos.first;
    _cursoSelecionado = cursos.first;
    _pagamentoSelecionado = pagamentos.first;
  }

  _nomeController.addListener(_verificarAlteracoes);
  _emailController.addListener(_verificarAlteracoes);
  _cpfController.addListener(_verificarAlteracoes);
  _raController.addListener(_verificarAlteracoes);
  _telefoneController.addListener(_verificarAlteracoes);
}

  void _verificarAlteracoes() {
    if (widget.associacao != null) {
      final a = widget.associacao!;
      setState(() {
        _dadosAlterados = 
          _nomeController.text != a.nomeCompleto ||
          _emailController.text != a.email ||
          _cpfController.text != a.cpf ||
          _raController.text != a.ra ||
          _telefoneController.text != a.telefone ||
          _tipoSelecionado != a.tipo ||
          _cursoSelecionado != a.curso ||
          _pagamentoSelecionado != a.meioPagamento;
      });
    } else {
      setState(() {
        _dadosAlterados = 
          _nomeController.text.isNotEmpty ||
          _emailController.text != widget.emailUsuario ||
          _cpfController.text.isNotEmpty ||
          _raController.text.isNotEmpty ||
          _telefoneController.text.isNotEmpty;
      });
    }
  }

  Future<bool> _confirmarSaida() async {
    if (!_dadosAlterados) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterações não salvas'),
        content: const Text('Você tem alterações não salvas. Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final cpfSemMascara = obterApenasNumerosCPF(_cpfController.text);
    final telefoneSemMascara = obterApenasNumerosTelefone(_telefoneController.text);

    final novaAssociacao = AssociacaoModel(
      id: widget.associacao?.id ?? _uuid.v4(),
      nomeCompleto: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      cpf: cpfSemMascara,
      ra: _raController.text.trim(),
      curso: _cursoSelecionado ?? '',
      tipo: _tipoSelecionado ?? '',
      meioPagamento: _pagamentoSelecionado ?? '',
      telefone: telefoneSemMascara,
      status: 'pendente',
    );

    try {
      await _service.salvarAssociacao(novaAssociacao);

      const numeroAdm = '+55XXXXXXXXXX'; // substituir
      final mensagem = '''
 *Nova Solicitação de Associação*

 Nome: ${novaAssociacao.nomeCompleto}
 E-mail: ${novaAssociacao.email}
 CPF: ${_cpfController.text}
 RA: ${novaAssociacao.ra}
 Curso: ${novaAssociacao.curso}
 Pagamento: ${novaAssociacao.meioPagamento}
 Telefone: ${_telefoneController.text}

 Acesse o painel administrativo para aprovar ou recusar.
''';
      await WhatsAppService.enviarMensagem(numeroAdm, mensagem);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitação enviada com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.removeListener(_verificarAlteracoes);
    _emailController.removeListener(_verificarAlteracoes);
    _cpfController.removeListener(_verificarAlteracoes);
    _raController.removeListener(_verificarAlteracoes);
    _telefoneController.removeListener(_verificarAlteracoes);
    
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _raController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.associacao != null;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final sair = await _confirmarSaida();
        if (sair) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF0E2877),
          elevation: 0,
          centerTitle: true,
          title: Text(
            isEdicao ? 'Editar Associação' : 'Nova Associação',
            style: const TextStyle(
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
                  Text(
                    isEdicao ? 'Editar Associação' : 'Nova Associação',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            TextFormField(
                              controller: _nomeController,
                              decoration: const InputDecoration(
                                labelText: 'Nome Completo *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Informe o nome completo';
                                }
                                if (!validarNome(v)) {
                                  return 'Informe nome e sobrenome (mín. 2 palavras)';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'E-mail *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Informe o e-mail';
                                }
                                if (!validarEmail(v)) {
                                  return 'Informe um e-mail válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _cpfController,
                              decoration: const InputDecoration(
                                labelText: 'CPF *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              inputFormatters: [CpfMaskTextInputFormatter()],
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Informe o CPF';
                                }
                                if (!validarCPF(v)) {
                                  return 'Informe um CPF válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _raController,
                              decoration: const InputDecoration(
                                labelText: 'RA *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              inputFormatters: [RaMaskTextInputFormatter()],
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Informe o RA';
                                }
                                if (!validarRA(v)) {
                                  return 'RA deve ter 11 dígitos';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _telefoneController,
                              decoration: const InputDecoration(
                                labelText: 'Telefone (com DDD) *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              inputFormatters: [PhoneMaskTextInputFormatter()],
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Informe o telefone';
                                }
                                if (!validarTelefone(v)) {
                                  return 'Informe um telefone válido com DDD';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _tipoSelecionado,
                              decoration: const InputDecoration(
                                labelText: 'Tipo *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              items: tipos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                              onChanged: (v) {
                                setState(() => _tipoSelecionado = v);
                                _verificarAlteracoes();
                              },
                              validator: (v) => v == null ? 'Selecione o tipo' : null,
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _cursoSelecionado,
                              decoration: const InputDecoration(
                                labelText: 'Curso *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              items: cursos.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                              onChanged: (v) {
                                setState(() => _cursoSelecionado = v);
                                _verificarAlteracoes();
                              },
                              validator: (v) => v == null ? 'Selecione o curso' : null,
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _pagamentoSelecionado,
                              decoration: const InputDecoration(
                                labelText: 'Meio de Pagamento *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              items: pagamentos.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                              onChanged: (v) {
                                setState(() => _pagamentoSelecionado = v);
                                _verificarAlteracoes();
                              },
                              validator: (v) => v == null ? 'Selecione o pagamento' : null,
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: _salvar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0E2877),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: Text(
                                isEdicao ? 'Atualizar Solicitação' : 'Enviar Solicitação',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                '* Campos obrigatórios',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:integrador/components/botao_padrao.dart';
import 'package:integrador/components/campo_dropdown.dart';
import 'package:integrador/components/campo_texto.dart';
import 'package:integrador/components/mask_formatter.dart';
import 'package:integrador/models/usuario_model.dart';
import 'package:integrador/service/usuario_service.dart';

class UsuarioFormPage extends StatefulWidget {
  final UsuarioModel? usuario;
  final bool? isEdicaoPerfil;
  const UsuarioFormPage({super.key, this.usuario, this.isEdicaoPerfil = false});

  @override
  State<UsuarioFormPage> createState() => _UsuarioFormPageState();
}

class _UsuarioFormPageState extends State<UsuarioFormPage> {
  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final dataCtrl = TextEditingController();
  final telefoneCtrl = TextEditingController();
  final apelidoCtrl = TextEditingController();
  String? curso;
  String? tipoUsuario;
  bool salvando = false;
  bool _dadosAlterados = false;

  final phoneMask = PhoneMaskTextInputFormatter();
  final cursos = [
    'Ciência da Computação',
    'Química',
    'Física',
    'Matemática Licenciatura',
    "Big Data",
    "Matematica Computacional"
  ];
  
  final tipos = ['usuario', 'administrador'];

  final UsuarioService _service = UsuarioService();

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      final u = widget.usuario!;
      nomeCtrl.text = u.nome;
      emailCtrl.text = u.email;
      dataCtrl.text = u.dataNascimento;
      
      if (u.telefone.isNotEmpty && RegExp(r'^\d+$').hasMatch(u.telefone)) {
        telefoneCtrl.text = phoneMask.formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: u.telefone),
        ).text;
      } else {
        telefoneCtrl.text = u.telefone;
      }
      
      apelidoCtrl.text = u.apelidoCalouro;
      curso = u.curso;
      tipoUsuario = u.tipoUsuario;
    } else {
      tipoUsuario = 'usuario';
    }

    _adicionarListeners();
  }

  void _adicionarListeners() {
    nomeCtrl.addListener(_verificarAlteracoes);
    emailCtrl.addListener(_verificarAlteracoes);
    dataCtrl.addListener(_verificarAlteracoes);
    telefoneCtrl.addListener(_verificarAlteracoes);
    apelidoCtrl.addListener(_verificarAlteracoes);
  }

  void _verificarAlteracoes() {
    if (widget.usuario != null) {
      final u = widget.usuario!;
      final telefoneFormatado = phoneMask.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: u.telefone),
      ).text;
      
      bool alterado = 
          nomeCtrl.text != u.nome ||
          emailCtrl.text != u.email ||
          dataCtrl.text != u.dataNascimento ||
          telefoneCtrl.text != (u.telefone.contains('(') ? u.telefone : telefoneFormatado) ||
          apelidoCtrl.text != u.apelidoCalouro ||
          curso != u.curso ||
          (widget.isEdicaoPerfil != true && tipoUsuario != u.tipoUsuario);
      
      if (alterado != _dadosAlterados) {
        setState(() {
          _dadosAlterados = alterado;
        });
      }
    } else {
      bool alterado = 
          nomeCtrl.text.isNotEmpty ||
          emailCtrl.text.isNotEmpty ||
          dataCtrl.text.isNotEmpty ||
          telefoneCtrl.text.isNotEmpty ||
          apelidoCtrl.text.isNotEmpty ||
          curso != null ||
          tipoUsuario != null;
      
      if (alterado != _dadosAlterados) {
        setState(() {
          _dadosAlterados = alterado;
        });
      }
    }
  }

  Future<void> _selecionarData() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0E2877),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0E2877),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF0E2877),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (dataSelecionada != null) {
      final formatada = '${dataSelecionada.day.toString().padLeft(2, '0')}/${dataSelecionada.month.toString().padLeft(2, '0')}/${dataSelecionada.year}';
      dataCtrl.text = formatada;
    }
  }

  String? _validarCampos() {
    if (nomeCtrl.text.isEmpty) return 'Preencha o nome';
    if (emailCtrl.text.isEmpty) return 'Preencha o email';
    if (dataCtrl.text.isEmpty) return 'Selecione a data de nascimento';
    if (telefoneCtrl.text.isEmpty) return 'Preencha o telefone';
    if (apelidoCtrl.text.isEmpty) return 'Preencha o apelido de calouro';
    if (curso == null || curso!.isEmpty) return 'Selecione o curso';
    
    if (widget.isEdicaoPerfil != true && (tipoUsuario == null || tipoUsuario!.isEmpty)) {
      return 'Selecione o tipo de usuário';
    }
    
    if (!emailCtrl.text.contains('@') || !emailCtrl.text.contains('.')) {
      return 'Email inválido';
    }
    
    if (!validarTelefone(telefoneCtrl.text)) {
      return 'Telefone inválido. Digite um número com DDD (10 ou 11 dígitos).';
    }
    
    return null;
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    emailCtrl.dispose();
    dataCtrl.dispose();
    telefoneCtrl.dispose();
    apelidoCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final erroValidacao = _validarCampos();
    if (erroValidacao != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erroValidacao)),
      );
      return;
    }

    setState(() => salvando = true);
    try {
      final id = widget.usuario?.uid ?? DateTime.now().millisecondsSinceEpoch.toString();

      final telefoneApenasNumeros = obterApenasNumerosTelefone(telefoneCtrl.text);
      final tipoUsuarioFinal = widget.isEdicaoPerfil == true 
          ? (widget.usuario?.tipoUsuario ?? 'usuario')
          : tipoUsuario!;

      final usuario = UsuarioModel(
        uid: id,
        nome: nomeCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        dataNascimento: dataCtrl.text.trim(),
        telefone: telefoneApenasNumeros,
        apelidoCalouro: apelidoCtrl.text.trim(),
        curso: curso!,
        tipoUsuario: tipoUsuarioFinal,
      );

      await _service.salvarUsuario(usuario);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário salvo com sucesso!')),
      );
      _dadosAlterados = false; 
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar usuário.')),
      );
    } finally {
      setState(() => salvando = false);
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
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.usuario != null;
    final isEdicaoPerfil = widget.isEdicaoPerfil == true;

    return PopScope(
      canPop: false, // Impede o pop padrão
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        
        final sair = await _confirmarSaida();
        if (sair) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF0E2877),
          elevation: 0,
          centerTitle: true,
          title: Text(
            isEdicaoPerfil ? 'Editar Perfil' : (isEdicao ? 'Editar Usuário' : 'Novo Usuário'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E2877),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final sair = await _confirmarSaida();
              if (sair && context.mounted) {
                Navigator.pop(context);
              }
            },
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
                    isEdicaoPerfil ? 'Editar Perfil' : (isEdicao ? 'Editar Usuário' : 'Novo Usuário'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        children: [
                          CampoTexto(
                            controller: nomeCtrl,
                            label: "Nome *",
                            hint: "Digite o nome completo",
                            emojiFinal: const Icon(Icons.person, color: Color(0xFF0E2877)),
                          ),
                          CampoTexto(
                            controller: emailCtrl,
                            label: "Email *",
                            hint: "Digite o email",
                            tipo: TextInputType.emailAddress,
                            emojiFinal: const Icon(Icons.email, color: Color(0xFF0E2877)),
                          ),
                          // Campo de data com DatePicker
                          GestureDetector(
                            onTap: _selecionarData,
                            child: AbsorbPointer(
                              child: CampoTexto(
                                controller: dataCtrl,
                                label: "Data de Nascimento *",
                                hint: "Selecione a data",
                                emojiFinal: const Icon(Icons.calendar_today, color: Color(0xFF0E2877)),
                              ),
                            ),
                          ),
                          TextField(
                            controller: telefoneCtrl,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [phoneMask],
                            decoration: InputDecoration(
                              labelText: 'Telefone *',
                              labelStyle: TextStyle(color: Color(0xFF0E2877)),
                              hintText: '(11) 99999-9999',
                              suffixIcon: Icon(Icons.phone, color: Color(0xFF0E2877)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Color(0xFF0E2877), width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Color(0xFF0E2877), width: 3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          CampoTexto(
                            controller: apelidoCtrl,
                            label: "Apelido de Calouro *",
                            hint: "Digite o apelido",
                            emojiFinal: const Icon(Icons.emoji_emotions, color: Color(0xFF0E2877)),
                          ),
                          CampoDropdown(
                            label: "Curso *",
                            valor: curso,
                            itens: cursos,
                            aoMudar: (v) {
                              setState(() => curso = v);
                              _verificarAlteracoes();
                            },
                          ),
                      
                          if (!isEdicaoPerfil) ...[
                            CampoDropdown(
                              label: "Tipo de Usuário *",
                              valor: tipoUsuario,
                              itens: tipos,
                              aoMudar: (v) {
                                setState(() => tipoUsuario = v);
                                _verificarAlteracoes();
                              },
                            ),
                          ],
                          
                          const SizedBox(height: 20),
                          BotaoPadrao(
                          texto: "Salvar",
                          icone: Icons.save,
                          cor: const Color(0xFF0E2877),
                          raioBorda: 20,
                          tamanhoFonte: 18,
                          onPressed: ()=>salvando ? null : _salvar,
               
                        ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '* Campos obrigatórios',
                              style: TextStyle(
                                color: Colors.grey[600],
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
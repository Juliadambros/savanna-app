import 'package:flutter/material.dart';
import 'package:integrador/components/mask_formatter.dart';
import 'package:integrador/service/auth_service.dart';
import 'package:integrador/service/usuario_service.dart';
import 'package:integrador/components/campo_dropdown.dart';
import '../../models/usuario_model.dart';
import 'home_page.dart';
import '../../components/campo_texto.dart';
import 'escolha_tipo_usuario_page.dart';
import '../../components/botao_padrao.dart';


class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nome = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  final data = TextEditingController();
  final telefone = TextEditingController();
  final apelido = TextEditingController();
  String? curso;
  bool carregando = false;

  final phoneMask = PhoneMaskTextInputFormatter();

  final cursos = [
    'Ciência da Computação',
    'Química',
    'Física',
    'Matemática Licenciatura',
    "Big Data",
    "Matematica Computacional"
  ];

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
      data.text = formatada;
    }
  }

  String? _validarCampos() {
    if (nome.text.isEmpty) return 'Preencha o nome';
    if (email.text.isEmpty) return 'Preencha o email';
    if (senha.text.isEmpty) return 'Preencha a senha';
    if (data.text.isEmpty) return 'Selecione a data de nascimento';
    if (telefone.text.isEmpty) return 'Preencha o telefone';
    if (apelido.text.isEmpty) return 'Preencha o apelido de calouro';
    if (curso == null || curso!.isEmpty) return 'Selecione o curso';
    
    if (!email.text.contains('@') || !email.text.contains('.')) {
      return 'Email inválido';
    }
    
    if (senha.text.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    
    if (!validarTelefone(telefone.text)) {
      return 'Telefone inválido. Digite um número com DDD (10 ou 11 dígitos).';
    }
    
    return null;
  }

  Future<void> _cadastrar() async {
    final erroValidacao = _validarCampos();
    if (erroValidacao != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erroValidacao)),
      );
      return;
    }

    setState(() => carregando = true);

    final auth = AuthService();
    final (user, erro) = await auth.cadastrar(
      email.text.trim(),
      senha.text.trim(),
    );

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
      setState(() => carregando = false);
      return;
    }

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro inesperado ao criar usuário.")),
      );
      setState(() => carregando = false);
      return;
    }

    final telefoneApenasNumeros = obterApenasNumerosTelefone(telefone.text);

    final usuario = UsuarioModel(
      uid: user.uid,
      nome: nome.text.trim(),
      email: email.text.trim(),
      dataNascimento: data.text.trim(),
      telefone: telefoneApenasNumeros,
      apelidoCalouro: apelido.text.trim(),
      curso: curso!,
      tipoUsuario: 'usuario',
    );

    await UsuarioService().salvarUsuario(usuario);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );

    setState(() => carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f7),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f7),
        title: const Text('Cadastro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const EscolhaTipoUsuarioPage()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset("assets/imgs/mascote.png", fit: BoxFit.contain),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: Image.asset("assets/imgs/logo.png", height: 120),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Cadastre-se já e obtenha todos os benefícios!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Color(0xFF0E2877), Color(0xFFE96120)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(
                          Rect.fromLTWH(0, 0, 400, 70),
                        ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 50),

                  CampoTexto(
                    label: 'Nome *', 
                    controller: nome,
                    hint: 'Digite seu nome completo',
                  ),
                  const SizedBox(height: 12),

                  CampoTexto(
                    label: 'Email *', 
                    controller: email,
                    hint: 'Digite seu email',
                    tipo: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),

                  CampoTexto(
                    label: 'Senha *', 
                    controller: senha, 
                    senha: true,
                    hint: 'Mínimo 6 caracteres',
                  ),
                  const SizedBox(height: 12),

                  // Campo de data com DatePicker
                  GestureDetector(
                    onTap: _selecionarData,
                    child: AbsorbPointer(
                      child: CampoTexto(
                        label: 'Data de nascimento *',
                        controller: data,
                        hint: 'Selecione a data',
                        emojiFinal: const Icon(Icons.calendar_today, color: Color(0xFF0E2877)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: telefone,
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
                  const SizedBox(height: 12),

                  CampoTexto(
                    label: 'Apelido de calouro *', 
                    controller: apelido,
                    hint: 'Digite seu apelido de calouro',
                  ),
                  const SizedBox(height: 12),

                  CampoDropdown(
                    label: 'Curso *',
                    valor: curso,
                    itens: cursos,
                    aoMudar: (v) => setState(() => curso = v),
                  ),

                  const SizedBox(height: 20),

                  BotaoPadrao(
                    texto: carregando ? "Cadastrando..." : "Cadastrar",
                    onPressed: carregando ? () {} : _cadastrar,
                    cor: const Color(0xffE96120),
                    transparencia: 0.8,
                    tamanhoFonte: 14,
                    altura: 45,
                    largura: 200,
                    raioBorda: 20,
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
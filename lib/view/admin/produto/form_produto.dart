import 'package:flutter/material.dart';
import 'package:integrador/components/botao_padrao.dart';
import 'package:integrador/components/campo_texto.dart';
import 'package:integrador/models/produto_model.dart';
import 'package:integrador/service/produto_service.dart';

class FormProduto extends StatefulWidget {
  final ProdutoModel? produto;
  const FormProduto({super.key, this.produto});

  @override
  State<FormProduto> createState() => _FormProdutoState();
}

class _FormProdutoState extends State<FormProduto> {
  final _formKey = GlobalKey<FormState>();
  final ProdutoService _service = ProdutoService();

  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _precoController;
  bool _disponivel = true;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    final p = widget.produto;
    _nomeController = TextEditingController(text: p?.nome ?? '');
    _descricaoController = TextEditingController(text: p?.descricao ?? '');
    _precoController = TextEditingController(
        text: p != null ? p.preco.toStringAsFixed(2) : '');
    _disponivel = p?.disponivel ?? true;
  }


  String? _validarCampos() {
    if (_nomeController.text.trim().isEmpty) {
      return 'Preencha o nome do produto';
    }
    
    if (_descricaoController.text.trim().isEmpty) {
      return 'Preencha a descrição do produto';
    }
    
    if (_precoController.text.trim().isEmpty) {
      return 'Preencha o preço do produto';
    }
    
    final preco = double.tryParse(_precoController.text.replaceAll(',', '.'));
    if (preco == null) {
      return 'Preço inválido. Use apenas números (ex: 25.90)';
    }
    
    if (preco <= 0) {
      return 'O preço deve ser maior que zero';
    }
    
    return null;
  }

  Future<void> _salvar({bool novo = false}) async {
    FocusScope.of(context).unfocus();

    final erroValidacao = _validarCampos();
    if (erroValidacao != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erroValidacao)),
      );
      return;
    }

    setState(() => _salvando = true);

    try {
      final precoTexto = _precoController.text.replaceAll(',', '.');
      final preco = double.tryParse(precoTexto) ?? 0.0;

      final produto = ProdutoModel(
        id: widget.produto?.id,
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim(),
        preco: preco,
        disponivel: _disponivel,
      );

      await _service.salvar(produto);

      if (novo) {
        _nomeController.clear();
        _descricaoController.clear();
        _precoController.clear();
        setState(() {
          _disponivel = true;
          _salvando = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto salvo. Adicione outro!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto salvo com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar produto.')),
      );
    }
  }

  String? _validarPreco(String? value) {
    if (value == null || value.isEmpty) {
      return 'Preencha o preço';
    }
  
    final regex = RegExp(r'^[0-9]+([,.]?[0-9]{0,2})?$');
    if (!regex.hasMatch(value)) {
      return 'Use apenas números (ex: 25.90 ou 25,90)';
    }
    
    final preco = double.tryParse(value.replaceAll(',', '.'));
    if (preco == null) {
      return 'Preço inválido';
    }
    
    if (preco <= 0) {
      return 'O preço deve ser maior que zero';
    }
    
    return null;
  }

  void _formatarPreco(String value) {
    if (value.isEmpty) return;
    
    final cleaned = value.replaceAll(RegExp(r'[^\d,.]'), '');
    
    final parts = cleaned.split(RegExp('[,.]'));
    if (parts.length > 2) {
      final firstPart = parts[0];
      final decimalPart = parts.sublist(1).join();
      _precoController.text = '$firstPart.${decimalPart.substring(0, 2)}';
      _precoController.selection = TextSelection.collapsed(offset: _precoController.text.length);
      return;
    }
    
    if (parts.length == 2 && parts[1].length > 2) {
      _precoController.text = '${parts[0]}.${parts[1].substring(0, 2)}';
      _precoController.selection = TextSelection.collapsed(offset: _precoController.text.length);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.produto != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF0E2877),
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEdicao ? 'Editar Produto' : 'Novo Produto',
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
                  isEdicao ? 'Editar Produto' : 'Novo Produto',
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
                          controller: _nomeController,
                          label: "Nome *",
                          hint: "Digite o nome do produto",
                          emojiFinal: const Icon(Icons.shopping_bag, color: Color(0xFF0E2877)),
                        ),
                        const SizedBox(height: 8),
                        
                        CampoTexto(
                          controller: _descricaoController,
                          label: "Descrição *",
                          hint: "Digite a descrição do produto",
                          maxLines: 3,
                          emojiFinal: const Icon(Icons.description, color: Color(0xFF0E2877)),
                        ),
                        const SizedBox(height: 8),
                        
                        // Campo de preço com validação específica
                        TextFormField(
                          controller: _precoController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: "Preço *",
                            labelStyle: TextStyle(color: Color(0xFF0E2877)),
                            hintText: "Ex: 25.90 ou 25,90",
                            suffixIcon: Icon(Icons.attach_money, color: Color(0xFF0E2877)),
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
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          validator: _validarPreco,
                          onChanged: _formatarPreco,
                        ),
                        const SizedBox(height: 8),
                        
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            title: const Text(
                              'Disponível',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: _disponivel,
                            onChanged: (v) => setState(() => _disponivel = v),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        BotaoPadrao(
                          texto: "Salvar",
                          icone: Icons.save,
                          cor: const Color(0xFF0E2877),
                          raioBorda: 20,
                          tamanhoFonte: 18,
                          onPressed: () => _salvar(),
                        ),
                        const SizedBox(height: 10),
                        
                        BotaoPadrao(
                          texto: "Salvar e Adicionar Outro",
                          icone: Icons.add,
                          cor: const Color(0xFF0E2877),
                          raioBorda: 20,
                          tamanhoFonte: 16,
                          onPressed: () => _salvar(novo: true)
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
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produto_model.dart';

class ProdutoService {
  final CollectionReference produtos =
      FirebaseFirestore.instance.collection('produtos');

  Future<void> salvarProduto(ProdutoModel produto) async {
    await produtos.doc(produto.id).set(produto.toMap());
  }

  Future<List<ProdutoModel>> listarProdutos() async {
    final snapshot = await produtos.get();
    return snapshot.docs
        .map((d) => ProdutoModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<ProdutoModel?> buscarProduto(String id) async {
    final doc = await produtos.doc(id).get();
    if (!doc.exists) return null;
    return ProdutoModel.fromMap(doc.data() as Map<String, dynamic>);
  }
}


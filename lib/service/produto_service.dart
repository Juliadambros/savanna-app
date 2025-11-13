import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integrador/models/produto_model.dart';


class ProdutoService {
  final _colecao = FirebaseFirestore.instance.collection('produtos');

  Future<void> salvar(ProdutoModel produto) async {
    if (produto.id != null) {
      await _colecao.doc(produto.id).update(produto.toMap());
    } else {
      await _colecao.add(produto.toMap());
    }
  }

  Future<List<ProdutoModel>> listar() async {
    final snapshot = await _colecao.get();
    return snapshot.docs
        .map((doc) => ProdutoModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> deletar(String id) async {
    await _colecao.doc(id).delete();
  }
}





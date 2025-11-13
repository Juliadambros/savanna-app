import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:integrador/view/escolha_tipo_usuario_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atlética',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const EscolhaTipoUsuarioPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

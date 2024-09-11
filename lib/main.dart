import 'package:flutter/material.dart';
import 'package:app_002/view/cadastro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CadastroPage(),
    );
  }
}

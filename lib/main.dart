// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:malhamais/telas/portao_autenticacao.dart';
import 'package:malhamais/util/tema/app_tema.dart';
import 'package:malhamais/util/tema/controle_tema.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ControleTema.instancia.carregar();
  runApp(const MalhaApp());
}

/// Widget raiz do Malha+ (temas e rota inicial).
class MalhaApp extends StatelessWidget {
  const MalhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controleTema = ControleTema.instancia;

    return ListenableBuilder(
      listenable: controleTema,
      builder: (context, _) => MaterialApp(
        title: 'Malha+',
        debugShowCheckedModeBanner: false,
        theme: AppTema.claro(),
        darkTheme: AppTema.escuro(),
        themeMode: controleTema.modo,
        home: const PortaoAutenticacao(),
      ),
    );
  }
}

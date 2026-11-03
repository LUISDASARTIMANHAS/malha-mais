// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:malhamais/telas/portao_autenticacao.dart';
import 'package:malhamais/util/tema/cores_malha.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MalhaApp());
}

/// Widget raiz do Malha+ (tema e rota inicial).
class MalhaApp extends StatelessWidget {
  const MalhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final esquemaCores = ColorScheme.fromSeed(
      seedColor: Colors.green,
      brightness: Brightness.dark,
    ).copyWith(
      primary: CoresMalha.verdeNeon,
      onPrimary: CoresMalha.fundo,
      secondary: CoresMalha.roxoNeon,
      surface: CoresMalha.cartao,
    );

    return MaterialApp(
      title: 'Malha+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: esquemaCores,
        scaffoldBackgroundColor: CoresMalha.fundo,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: CoresMalha.cartao,
          surfaceTintColor: Colors.transparent,
          indicatorColor: CoresMalha.verdeNeon.withValues(alpha: 0.12),
          iconTheme: WidgetStateProperty.resolveWith(
            (estados) => IconThemeData(
              color: estados.contains(WidgetState.selected)
                  ? CoresMalha.verdeNeon
                  : CoresMalha.textoSecundario,
            ),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (estados) => TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: estados.contains(WidgetState.selected)
                  ? CoresMalha.verdeNeon
                  : CoresMalha.textoSecundario,
            ),
          ),
        ),
      ),
      home: const PortaoAutenticacao(),
    );
  }
}

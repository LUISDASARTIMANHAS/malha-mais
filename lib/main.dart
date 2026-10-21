import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:malhamais/telas/portao_autenticacao.dart';

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
    );

    return MaterialApp(
      title: 'Malha+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: esquemaCores,
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
      ),
      home: const PortaoAutenticacao(),
    );
  }
}

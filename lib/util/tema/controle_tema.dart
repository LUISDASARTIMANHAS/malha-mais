// lib/util/tema/controle_tema.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Modo de tema do app (automático/escuro/claro), persistido no aparelho.
class ControleTema extends ChangeNotifier {
  ControleTema._();

  static final ControleTema instancia = ControleTema._();
  static const String _chave = 'modo_tema';

  ThemeMode _modo = ThemeMode.dark;

  ThemeMode get modo => _modo;

  /// Lê a preferência salva. Chame antes de `runApp`.
  Future<void> carregar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _modo = _decodificar(prefs.getString(_chave));
    } catch (_) {
      // Sem acesso ao armazenamento: mantém o padrão.
    }
  }

  /// Aplica e salva o novo modo.
  ///
  /// @param novo modo desejado.
  Future<void> definir(ThemeMode novo) async {
    if (novo == _modo) return;
    _modo = novo;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_chave, novo.name);
    } catch (_) {
      // Melhor esforço: o modo vale nesta sessão.
    }
  }

  /// Aceita só valores conhecidos (lista branca) para o dado salvo.
  static ThemeMode _decodificar(String? valor) => ThemeMode.values.firstWhere(
    (m) => m.name == valor,
    orElse: () => ThemeMode.dark,
  );
}

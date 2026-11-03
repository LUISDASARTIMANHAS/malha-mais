// lib/util/tema/cores_malha.dart

import 'package:flutter/material.dart';

/// Paleta oficial do Malha+ (identidade dark neon).
class CoresMalha {
  CoresMalha._();

  static const Color fundo = Color(0xFF080A14);
  static const Color cartao = Color(0xFF111523);
  static const Color verdeNeon = Color(0xFFC5F52B);
  static const Color roxoNeon = Color(0xFF843CFF);
  static const Color verdeEsmeralda = Color(0xFF22D98B);
  static const Color vermelhoCoracao = Color(0xFFFF4D5E);
  static const Color textoSecundario = Color(0xFF8C93A8);

  /// Raio padrão dos cards.
  static const double raioCartao = 18;

  /// Borda discreta com leve transparência.
  static final Color borda = Colors.white.withValues(alpha: 0.07);
}

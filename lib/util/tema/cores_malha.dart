// lib/util/tema/cores_malha.dart

import 'package:flutter/material.dart';

/// Paleta do Malha+ (extensão de tema; existe uma versão escura e uma clara).
@immutable
class CoresMalha extends ThemeExtension<CoresMalha> {
  const CoresMalha({
    required this.fundo,
    required this.cartao,
    required this.neon,
    required this.sobreNeon,
    required this.roxo,
    required this.esmeralda,
    required this.borda,
    required this.intensidadeBrilho,
  });

  final Color fundo;
  final Color cartao;

  /// Cor de destaque (verde neon no escuro; verde mais fechado no claro,
  /// para manter contraste).
  final Color neon;

  /// Cor de texto/ícone sobre áreas preenchidas com [neon].
  final Color sobreNeon;
  final Color roxo;
  final Color esmeralda;
  final Color borda;

  /// Opacidade base dos efeitos de glow.
  final double intensidadeBrilho;

  /// Raio padrão dos cards.
  static const double raioCartao = 18;

  static const escuro = CoresMalha(
    fundo: Color(0xFF080A14),
    cartao: Color(0xFF111523),
    neon: Color(0xFFC5F52B),
    sobreNeon: Color(0xFF080A14),
    roxo: Color(0xFF843CFF),
    esmeralda: Color(0xFF10B981),
    borda: Color(0x14FFFFFF),
    intensidadeBrilho: 0.18,
  );

  static const claro = CoresMalha(
    fundo: Color(0xFFF3F5FA),
    cartao: Color(0xFFFFFFFF),
    neon: Color(0xFF4F7A00),
    sobreNeon: Color(0xFFFFFFFF),
    roxo: Color(0xFF6D28D9),
    esmeralda: Color(0xFF047857),
    borda: Color(0x14000000),
    intensidadeBrilho: 0.08,
  );

  @override
  CoresMalha copyWith({
    Color? fundo,
    Color? cartao,
    Color? neon,
    Color? sobreNeon,
    Color? roxo,
    Color? esmeralda,
    Color? borda,
    double? intensidadeBrilho,
  }) {
    return CoresMalha(
      fundo: fundo ?? this.fundo,
      cartao: cartao ?? this.cartao,
      neon: neon ?? this.neon,
      sobreNeon: sobreNeon ?? this.sobreNeon,
      roxo: roxo ?? this.roxo,
      esmeralda: esmeralda ?? this.esmeralda,
      borda: borda ?? this.borda,
      intensidadeBrilho: intensidadeBrilho ?? this.intensidadeBrilho,
    );
  }

  @override
  CoresMalha lerp(ThemeExtension<CoresMalha>? other, double t) {
    if (other is! CoresMalha) return this;
    return CoresMalha(
      fundo: Color.lerp(fundo, other.fundo, t)!,
      cartao: Color.lerp(cartao, other.cartao, t)!,
      neon: Color.lerp(neon, other.neon, t)!,
      sobreNeon: Color.lerp(sobreNeon, other.sobreNeon, t)!,
      roxo: Color.lerp(roxo, other.roxo, t)!,
      esmeralda: Color.lerp(esmeralda, other.esmeralda, t)!,
      borda: Color.lerp(borda, other.borda, t)!,
      intensidadeBrilho:
          intensidadeBrilho + (other.intensidadeBrilho - intensidadeBrilho) * t,
    );
  }
}

/// Atalho: `context.cores.neon`.
extension CoresMalhaContexto on BuildContext {
  CoresMalha get cores =>
      Theme.of(this).extension<CoresMalha>() ?? CoresMalha.escuro;
}

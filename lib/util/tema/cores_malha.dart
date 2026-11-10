// lib/util/tema/cores_malha.dart

import 'package:flutter/material.dart';

/// Paleta do Malha+.
///
/// Dois usos convivem nesta classe:
/// - Constantes estáticas (`CoresMalha.verdeNeon`, `CoresMalha.fundo`...):
///   paleta escura fixa, usada pelo Dashboard e widgets antigos.
/// - Extensão de tema (`context.cores.neon`, `context.cores.fundoApp`...):
///   muda conforme o tema claro/escuro. Usada pelo Perfil e pelo [AppTema].
@immutable
class CoresMalha extends ThemeExtension<CoresMalha> {
  const CoresMalha({
    required this.fundoApp,
    required this.cartaoApp,
    required this.neon,
    required this.sobreNeon,
    required this.roxo,
    required this.esmeralda,
    required this.bordaApp,
    required this.intensidadeBrilho,
  });

  // ---------------------------------------------------------------------------
  // Paleta estática (legada, sempre escura)
  // ---------------------------------------------------------------------------
  static const Color fundo = Color(0xFF080A14);
  static const Color cartao = Color(0xFF111523);
  static const Color borda = Color(0x14FFFFFF);
  static const Color verdeNeon = Color(0xFFC5F52B);
  static const Color roxoNeon = Color(0xFF843CFF);
  static const Color verdeEsmeralda = Color(0xFF22D98B);
  // Ajuste estes dois se tiver os valores originais (ver git).
  static const Color textoSecundario = Color(0xFF8C93AB);
  static const Color vermelhoCoracao = Color(0xFFFF4D6A);

  /// Raio padrão dos cards do Dashboard.
  static const double raioCartao = 18;

  // ---------------------------------------------------------------------------
  // Extensão de tema (muda com claro/escuro)
  // ---------------------------------------------------------------------------
  final Color fundoApp;
  final Color cartaoApp;

  /// Cor de destaque (verde neon no escuro; verde mais fechado no claro,
  /// para manter contraste).
  final Color neon;

  /// Cor de texto/ícone sobre áreas preenchidas com [neon].
  final Color sobreNeon;
  final Color roxo;
  final Color esmeralda;
  final Color bordaApp;

  /// Opacidade base dos efeitos de glow.
  final double intensidadeBrilho;

  static const escuro = CoresMalha(
    fundoApp: Color(0xFF080A14),
    cartaoApp: Color(0xFF111523),
    neon: Color(0xFFC5F52B),
    sobreNeon: Color(0xFF080A14),
    roxo: Color(0xFF843CFF),
    esmeralda: Color(0xFF10B981),
    bordaApp: Color(0x14FFFFFF),
    intensidadeBrilho: 0.18,
  );

  static const claro = CoresMalha(
    fundoApp: Color(0xFFF3F5FA),
    cartaoApp: Color(0xFFFFFFFF),
    neon: Color(0xFF4F7A00),
    sobreNeon: Color(0xFFFFFFFF),
    roxo: Color(0xFF6D28D9),
    esmeralda: Color(0xFF047857),
    bordaApp: Color(0x14000000),
    intensidadeBrilho: 0.08,
  );

  @override
  CoresMalha copyWith({
    Color? fundoApp,
    Color? cartaoApp,
    Color? neon,
    Color? sobreNeon,
    Color? roxo,
    Color? esmeralda,
    Color? bordaApp,
    double? intensidadeBrilho,
  }) {
    return CoresMalha(
      fundoApp: fundoApp ?? this.fundoApp,
      cartaoApp: cartaoApp ?? this.cartaoApp,
      neon: neon ?? this.neon,
      sobreNeon: sobreNeon ?? this.sobreNeon,
      roxo: roxo ?? this.roxo,
      esmeralda: esmeralda ?? this.esmeralda,
      bordaApp: bordaApp ?? this.bordaApp,
      intensidadeBrilho: intensidadeBrilho ?? this.intensidadeBrilho,
    );
  }

  @override
  CoresMalha lerp(ThemeExtension<CoresMalha>? other, double t) {
    if (other is! CoresMalha) return this;
    return CoresMalha(
      fundoApp: Color.lerp(fundoApp, other.fundoApp, t)!,
      cartaoApp: Color.lerp(cartaoApp, other.cartaoApp, t)!,
      neon: Color.lerp(neon, other.neon, t)!,
      sobreNeon: Color.lerp(sobreNeon, other.sobreNeon, t)!,
      roxo: Color.lerp(roxo, other.roxo, t)!,
      esmeralda: Color.lerp(esmeralda, other.esmeralda, t)!,
      bordaApp: Color.lerp(bordaApp, other.bordaApp, t)!,
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

// lib/util/unidades.dart

import 'package:malhamais/dominio/perfil_usuario.dart';

/// Conversões entre o sistema métrico (padrão de armazenamento) e imperial.
///
/// O banco guarda sempre kg e cm; a conversão acontece só na exibição/edição.
class Unidades {
  Unidades._();

  static const double _kgPorLibra = 0.45359237;
  static const double _cmPorPolegada = 2.54;

  static double pesoParaExibir(double kg, SistemaUnidades s) =>
      s == SistemaUnidades.metrico ? kg : kg / _kgPorLibra;

  static double pesoParaKg(double valor, SistemaUnidades s) =>
      s == SistemaUnidades.metrico ? valor : valor * _kgPorLibra;

  static double alturaParaExibir(double cm, SistemaUnidades s) =>
      s == SistemaUnidades.metrico ? cm : cm / _cmPorPolegada;

  static double alturaParaCm(double valor, SistemaUnidades s) =>
      s == SistemaUnidades.metrico ? valor : valor * _cmPorPolegada;

  static String rotuloPeso(SistemaUnidades s) =>
      s == SistemaUnidades.metrico ? 'kg' : 'lb';

  static String rotuloAltura(SistemaUnidades s) =>
      s == SistemaUnidades.metrico ? 'cm' : 'in';

  /// Arredonda para 1 casa decimal (o que é guardado).
  static double arredondar(double valor) =>
      double.parse(valor.toStringAsFixed(1));

  /// Formata com vírgula e sem ",0" final (ex.: 62 → "62"; 62.5 → "62,5").
  ///
  /// @param valor número a formatar.
  /// @return texto no padrão pt-BR.
  static String formatar(double valor) {
    final texto = valor.toStringAsFixed(1);
    final semZero = texto.endsWith('.0')
        ? texto.substring(0, texto.length - 2)
        : texto;
    return semZero.replaceAll('.', ',');
  }
}

/// Separador de milhar pt-BR (10000 → "10.000").
///
/// @param valor inteiro a formatar.
String formatarMilhar(int valor) => valor.toString().replaceAllMapped(
  RegExp(r'\B(?=(\d{3})+(?!\d))'),
  (_) => '.',
);

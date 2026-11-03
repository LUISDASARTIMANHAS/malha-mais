// lib/dominio/resumo_diario.dart

/// Uma leitura de frequência cardíaca ao longo do dia.
class AmostraBatimento {
  const AmostraBatimento({required this.hora, required this.bpm});

  /// Hora do dia em formato decimal (0 a 24). Ex.: 13.5 = 13:30.
  final double hora;
  final int bpm;
}

/// Resumo das métricas do dia exibidas no Dashboard.
class ResumoDiario {
  const ResumoDiario({
    required this.calorias,
    required this.caloriasMeta,
    required this.passos,
    required this.passosMeta,
    required this.minutosAtivos,
    required this.minutosAtivosMeta,
    required this.distanciaKm,
    required this.caloriasAtivas,
    required this.sonoMinutos,
    required this.batimentoAtual,
    required this.amostrasBatimento,
    required this.indiceDestaqueBatimento,
  });

  final int calorias;
  final int caloriasMeta;
  final int passos;
  final int passosMeta;
  final int minutosAtivos;
  final int minutosAtivosMeta;
  final double distanciaKm;
  final int caloriasAtivas;
  final int sonoMinutos;
  final int batimentoAtual;
  final List<AmostraBatimento> amostrasBatimento;

  /// Índice da amostra destacada no gráfico (leitura atual).
  final int indiceDestaqueBatimento;

  double get progressoCalorias => _fracao(calorias, caloriasMeta);
  double get progressoPassos => _fracao(passos, passosMeta);
  double get progressoTempoAtivo => _fracao(minutosAtivos, minutosAtivosMeta);

  static double _fracao(int valor, int meta) =>
      meta <= 0 ? 0 : (valor / meta).clamp(0.0, 1.0).toDouble();
}

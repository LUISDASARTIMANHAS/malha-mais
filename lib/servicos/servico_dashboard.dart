// lib/servicos/servico_dashboard.dart

import 'package:malhamais/dominio/resumo_diario.dart';

/// Fornece o resumo diário exibido no Dashboard.
///
/// Por enquanto devolve dados de exemplo. Quando houver sensores/backend,
/// basta trocar o corpo de [obterResumoDiario] (a tela não muda).
class ServicoDashboard {
  // BPM de hora em hora (0h a 24h). O índice 14 é a leitura atual (78).
  static const List<int> _bpmPorHora = [
    58, 56, 54, 53, 52, 55, 62, 74, 86, 80, 72, 70, 74,
    79, 78, 92, 104, 88, 76, 70, 66, 62, 60, 58, 57,
  ];
  static const int _indiceAtual = 14;

  /// Busca o resumo do dia.
  ///
  /// @return [ResumoDiario] com as métricas atuais.
  Future<ResumoDiario> obterResumoDiario() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return ResumoDiario(
      calorias: 1850,
      caloriasMeta: 2200,
      passos: 8420,
      passosMeta: 10000,
      minutosAtivos: 45,
      minutosAtivosMeta: 60,
      distanciaKm: 2.4,
      caloriasAtivas: 310,
      sonoMinutos: 7 * 60 + 32,
      batimentoAtual: _bpmPorHora[_indiceAtual],
      indiceDestaqueBatimento: _indiceAtual,
      amostrasBatimento: [
        for (var h = 0; h < _bpmPorHora.length; h++)
          AmostraBatimento(hora: h.toDouble(), bpm: _bpmPorHora[h]),
      ],
    );
  }
}

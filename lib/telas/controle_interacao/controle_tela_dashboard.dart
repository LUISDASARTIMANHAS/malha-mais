// lib/telas/controle_interacao/controle_tela_dashboard.dart

import 'package:flutter/material.dart';
import 'package:malhamais/dominio/resumo_diario.dart';
import 'package:malhamais/servicos/servico_dashboard.dart';
import 'package:malhamais/util/formatadores.dart';

/// Controla estado e regras de interação da [TelaDashboard].
class ControleTelaDashboard extends ChangeNotifier {
  ControleTelaDashboard({
    required this.nomeCompleto,
    ServicoDashboard? servico,
    DateTime Function()? agora,
  })  : _servico = servico ?? ServicoDashboard(),
        _agora = agora ?? DateTime.now;

  final String nomeCompleto;
  final ServicoDashboard _servico;
  final DateTime Function() _agora;

  ResumoDiario? _resumo;
  bool _carregando = false;
  bool _descartado = false;
  String? _mensagemErro;

  ResumoDiario? get resumo => _resumo;
  bool get carregando => _carregando;
  String? get mensagemErro => _mensagemErro;
  DateTime get data => _agora();

  /// Ex.: `Good morning, Madina! 👋`.
  String get saudacao {
    final primeiro = Formatadores.primeiroNome(nomeCompleto);
    final base = Formatadores.saudacao(_agora());
    return primeiro.isEmpty ? '$base! 👋' : '$base, $primeiro! 👋';
  }

  /// Carrega (ou recarrega) o resumo do dia.
  Future<void> carregar() async {
    if (_carregando) return;
    _carregando = true;
    _mensagemErro = null;
    _notificar();

    try {
      _resumo = await _servico.obterResumoDiario();
    } catch (_) {
      _mensagemErro = 'Não foi possível carregar seus dados.';
    }

    _carregando = false;
    _notificar();
  }

  void _notificar() {
    if (!_descartado) notifyListeners();
  }

  @override
  void dispose() {
    _descartado = true;
    super.dispose();
  }
}

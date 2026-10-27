// lib/telas/controle_interacao/controle_tela_login.dart

import 'package:flutter/material.dart';
import 'package:malhamais/servicos/servico_autenticacao.dart';

/// Controla estado e regras de interação da [TelaLogin].
class ControleTelaLogin extends ChangeNotifier {
  ControleTelaLogin({ServicoAutenticacao? servico})
      : _servico = servico ?? ServicoAutenticacao();

  static const int _maxFalhas = 5;
  static const Duration _duracaoBloqueio = Duration(seconds: 30);

  final ServicoAutenticacao _servico;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final focoSenha = FocusNode();

  bool _carregando = false;
  bool _senhaVisivel = false;
  bool _descartado = false;
  String? _mensagemErro;
  int _falhas = 0;
  DateTime? _bloqueadoAte;

  bool get carregando => _carregando;
  bool get senhaVisivel => _senhaVisivel;
  String? get mensagemErro => _mensagemErro;

  bool get _bloqueado =>
      _bloqueadoAte != null && DateTime.now().isBefore(_bloqueadoAte!);

  /// Mostra/oculta a senha digitada.
  void alternarVisibilidadeSenha() {
    _senhaVisivel = !_senhaVisivel;
    _notificar();
  }

  /// Valida o formulário e tenta autenticar.
  ///
  /// Aplica um bloqueio local temporário após várias falhas seguidas
  /// (camada extra sobre a proteção do próprio Firebase).
  ///
  /// @return `true` se autenticou com sucesso.
  Future<bool> entrar() async {
    if (_carregando) return false;
    if (_bloqueado) {
      _mensagemErro = 'Muitas tentativas. Aguarde alguns segundos.';
      _notificar();
      return false;
    }
    if (!(formKey.currentState?.validate() ?? false)) return false;

    _carregando = true;
    _mensagemErro = null;
    _notificar();

    final resultado = await _servico.entrar(
      email: emailController.text.trim(),
      senha: senhaController.text,
    );

    _carregando = false;
    if (resultado.sucesso) {
      _falhas = 0;
      senhaController.clear();
    } else {
      _registrarFalha();
      _mensagemErro = resultado.mensagemErro;
    }
    _notificar();
    return resultado.sucesso;
  }

  void _registrarFalha() {
    _falhas++;
    if (_falhas >= _maxFalhas) {
      _bloqueadoAte = DateTime.now().add(_duracaoBloqueio);
      _falhas = 0;
    }
  }

  void _notificar() {
    if (!_descartado) notifyListeners();
  }

  @override
  void dispose() {
    _descartado = true;
    emailController.dispose();
    senhaController.dispose();
    focoSenha.dispose();
    super.dispose();
  }
}

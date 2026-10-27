// lib/telas/controle_interacao/controle_tela_redefinir_senha.dart

import 'package:flutter/material.dart';
import 'package:malhamais/servicos/servico_autenticacao.dart';

/// Controla estado e regras de interação da [TelaRedefinirSenha].
class ControleTelaRedefinirSenha extends ChangeNotifier {
  ControleTelaRedefinirSenha({
    String emailInicial = '',
    ServicoAutenticacao? servico,
  })  : emailController = TextEditingController(text: emailInicial),
        _servico = servico ?? ServicoAutenticacao();

  static const Duration _intervaloReenvio = Duration(seconds: 60);

  final ServicoAutenticacao _servico;

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController;

  bool _carregando = false;
  bool _enviado = false;
  bool _descartado = false;
  String? _mensagemErro;
  DateTime? _bloqueadoAte;

  bool get carregando => _carregando;
  bool get enviado => _enviado;
  String? get mensagemErro => _mensagemErro;

  bool get _emIntervalo =>
      _bloqueadoAte != null && DateTime.now().isBefore(_bloqueadoAte!);

  /// Valida o e-mail e solicita o envio do link de redefinição.
  ///
  /// Respeita um intervalo mínimo entre envios para evitar spam.
  /// A resposta é a mesma exista ou não conta para o e-mail informado.
  Future<void> enviar() async {
    if (_carregando) return;
    if (_emIntervalo) {
      _mensagemErro = 'Aguarde um minuto para reenviar o e-mail.';
      _notificar();
      return;
    }
    if (!(formKey.currentState?.validate() ?? true)) return;

    _carregando = true;
    _mensagemErro = null;
    _notificar();

    final resultado =
        await _servico.recuperarSenha(emailController.text.trim());

    _carregando = false;
    if (resultado.sucesso) {
      _enviado = true;
      _bloqueadoAte = DateTime.now().add(_intervaloReenvio);
    } else {
      _mensagemErro = resultado.mensagemErro;
    }
    _notificar();
  }

  /// Volta ao formulário para corrigir o e-mail.
  void editarEmail() {
    _enviado = false;
    _mensagemErro = null;
    _notificar();
  }

  void _notificar() {
    if (!_descartado) notifyListeners();
  }

  @override
  void dispose() {
    _descartado = true;
    emailController.dispose();
    super.dispose();
  }
}

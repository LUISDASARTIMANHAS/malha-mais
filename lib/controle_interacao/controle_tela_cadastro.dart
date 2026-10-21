import 'package:flutter/material.dart';
import 'package:malhamais/servicos/servico_autenticacao.dart';
import 'package:malhamais/util/validadores.dart';

/// Controla estado e regras de interação da [TelaCadastro].
class ControleTelaCadastro extends ChangeNotifier {
  ControleTelaCadastro({ServicoAutenticacao? servico})
      : _servico = servico ?? ServicoAutenticacao() {
    // Atualiza o checklist de requisitos a cada tecla.
    senhaController.addListener(_notificar);
  }

  final ServicoAutenticacao _servico;

  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmacaoController = TextEditingController();
  final focoEmail = FocusNode();
  final focoSenha = FocusNode();
  final focoConfirmacao = FocusNode();

  bool _carregando = false;
  bool _senhaVisivel = false;
  bool _aceitouTermos = false;
  bool _termosPendentes = false;
  bool _descartado = false;
  String? _mensagemErro;

  bool get carregando => _carregando;
  bool get senhaVisivel => _senhaVisivel;
  bool get aceitouTermos => _aceitouTermos;
  bool get termosPendentes => _termosPendentes;
  String? get mensagemErro => _mensagemErro;
  RequisitosSenha get requisitos => RequisitosSenha(senhaController.text);

  /// Mostra/oculta as senhas digitadas.
  void alternarVisibilidadeSenha() {
    _senhaVisivel = !_senhaVisivel;
    _notificar();
  }

  /// Marca/desmarca o aceite dos termos.
  ///
  /// @param valor novo estado do checkbox.
  void definirAceiteTermos(bool valor) {
    _aceitouTermos = valor;
    if (valor) _termosPendentes = false;
    _notificar();
  }

  /// Valida o formulário e cria a conta.
  ///
  /// @return `true` se a conta foi criada (e o usuário já está autenticado).
  Future<bool> cadastrar() async {
    if (_carregando) return false;

    final formularioOk = formKey.currentState?.validate() ?? false;
    _termosPendentes = !_aceitouTermos;
    if (!formularioOk || _termosPendentes) {
      _notificar();
      return false;
    }

    _carregando = true;
    _mensagemErro = null;
    _notificar();

    final resultado = await _servico.cadastrar(
      nome: nomeController.text.trim(),
      email: emailController.text.trim(),
      senha: senhaController.text,
    );

    _carregando = false;
    if (resultado.sucesso) {
      senhaController.clear();
      confirmacaoController.clear();
    } else {
      _mensagemErro = resultado.mensagemErro;
    }
    _notificar();
    return resultado.sucesso;
  }

  void _notificar() {
    if (!_descartado) notifyListeners();
  }

  @override
  void dispose() {
    _descartado = true;
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmacaoController.dispose();
    focoEmail.dispose();
    focoSenha.dispose();
    focoConfirmacao.dispose();
    super.dispose();
  }
}

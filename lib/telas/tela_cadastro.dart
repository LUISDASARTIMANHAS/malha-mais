// lib/telas/tela_cadastro.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malhamais/util/validadores.dart';

import 'controle_interacao/controle_tela_cadastro.dart';

/// Tela de criação de conta do Malha+.
class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _controle = ControleTelaCadastro();

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  Future<void> _aoCadastrar() async {
    final sucesso = await _controle.cadastrar();
    if (!sucesso || !mounted) return;
    TextInput.finishAutofillContext();
    // O PortaoAutenticacao já trocou a tela raiz; fecha as rotas empilhadas.
    Navigator.of(context).popUntil((rota) => rota.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ListenableBuilder(
                listenable: _controle,
                builder: (context, _) => Form(
                  key: _controle.formKey,
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _campoNome(),
                        const SizedBox(height: 16),
                        _campoEmail(),
                        const SizedBox(height: 16),
                        _campoSenha(),
                        const SizedBox(height: 12),
                        _PainelRequisitos(requisitos: _controle.requisitos),
                        const SizedBox(height: 16),
                        _campoConfirmacao(),
                        const SizedBox(height: 8),
                        _aceiteTermos(tema),
                        if (_controle.mensagemErro != null) ...[
                          const SizedBox(height: 8),
                          Semantics(
                            liveRegion: true,
                            child: Text(
                              _controle.mensagemErro!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: tema.colorScheme.error),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed:
                              _controle.carregando ? null : _aoCadastrar,
                          child: _controle.carregando
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5),
                                )
                              : const Text('Criar conta',
                                  style: TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _controle.carregando
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text('Já tenho conta'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoNome() {
    return TextFormField(
      controller: _controle.nomeController,
      validator: Validadores.nome,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.name],
      maxLength: Validadores.tamanhoMaximoNome,
      onFieldSubmitted: (_) => _controle.focoEmail.requestFocus(),
      decoration: const InputDecoration(
        labelText: 'Nome',
        prefixIcon: Icon(Icons.person_outline),
        counterText: '',
      ),
    );
  }

  Widget _campoEmail() {
    return TextFormField(
      controller: _controle.emailController,
      focusNode: _controle.focoEmail,
      validator: Validadores.email,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      autocorrect: false,
      enableSuggestions: false,
      maxLength: Validadores.tamanhoMaximoEmail,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      onFieldSubmitted: (_) => _controle.focoSenha.requestFocus(),
      decoration: const InputDecoration(
        labelText: 'E-mail',
        prefixIcon: Icon(Icons.email_outlined),
        counterText: '',
      ),
    );
  }

  Widget _campoSenha() {
    return TextFormField(
      controller: _controle.senhaController,
      focusNode: _controle.focoSenha,
      validator: Validadores.senhaNova,
      obscureText: !_controle.senhaVisivel,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.newPassword],
      autocorrect: false,
      enableSuggestions: false,
      maxLength: Validadores.tamanhoMaximoSenha,
      onFieldSubmitted: (_) => _controle.focoConfirmacao.requestFocus(),
      decoration: InputDecoration(
        labelText: 'Senha',
        prefixIcon: const Icon(Icons.lock_outline),
        counterText: '',
        suffixIcon: IconButton(
          tooltip: _controle.senhaVisivel ? 'Ocultar senha' : 'Mostrar senha',
          icon: Icon(_controle.senhaVisivel
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
          onPressed: _controle.alternarVisibilidadeSenha,
        ),
      ),
    );
  }

  Widget _campoConfirmacao() {
    return TextFormField(
      controller: _controle.confirmacaoController,
      focusNode: _controle.focoConfirmacao,
      validator:
          Validadores.confirmacao(() => _controle.senhaController.text),
      obscureText: !_controle.senhaVisivel,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.newPassword],
      autocorrect: false,
      enableSuggestions: false,
      maxLength: Validadores.tamanhoMaximoSenha,
      onFieldSubmitted: (_) => _aoCadastrar(),
      decoration: const InputDecoration(
        labelText: 'Confirmar senha',
        prefixIcon: Icon(Icons.lock_reset_outlined),
        counterText: '',
      ),
    );
  }

  Widget _aceiteTermos(ThemeData tema) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          value: _controle.aceitouTermos,
          onChanged: _controle.carregando
              ? null
              : (valor) => _controle.definirAceiteTermos(valor ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Li e aceito os Termos de Uso e a Política de Privacidade',
          ),
        ),
        if (_controle.termosPendentes)
          Semantics(
            liveRegion: true,
            child: Text(
              'É necessário aceitar para criar a conta',
              style: tema.textTheme.bodySmall
                  ?.copyWith(color: tema.colorScheme.error),
            ),
          ),
      ],
    );
  }
}

/// Barra de força e checklist dos requisitos da senha.
class _PainelRequisitos extends StatelessWidget {
  const _PainelRequisitos({required this.requisitos});

  final RequisitosSenha requisitos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            minHeight: 6,
            value: requisitos.atendidos / 4,
          ),
        ),
        const SizedBox(height: 8),
        _ItemRequisito(
          texto: 'Mínimo de ${Validadores.tamanhoMinimoSenha} caracteres',
          atendido: requisitos.tamanho,
        ),
        _ItemRequisito(
            texto: 'Uma letra minúscula', atendido: requisitos.minuscula),
        _ItemRequisito(
            texto: 'Uma letra maiúscula', atendido: requisitos.maiuscula),
        _ItemRequisito(texto: 'Um número', atendido: requisitos.numero),
      ],
    );
  }
}

class _ItemRequisito extends StatelessWidget {
  const _ItemRequisito({required this.texto, required this.atendido});

  final String texto;
  final bool atendido;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(
            atendido ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18,
            color: atendido ? cores.primary : cores.outline,
          ),
          const SizedBox(width: 8),
          Text(texto, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

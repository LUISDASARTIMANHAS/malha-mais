// lib/telas/tela_login.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malhamais/util/validadores.dart';

import 'controle_interacao/controle_tela_login.dart';
import 'tela_cadastro.dart';
import 'tela_redefinir_senha.dart';

/// Tela de login do Malha+.
class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _controle = ControleTelaLogin();

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  Future<void> _aoEntrar() async {
    final sucesso = await _controle.entrar();
    // Ao autenticar, o PortaoAutenticacao troca a tela sozinho.
    if (sucesso) TextInput.finishAutofillContext();
  }

  void _abrir(Widget tela) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => tela));
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
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
                        Icon(Icons.fitness_center,
                            size: 64, color: tema.colorScheme.primary),
                        const SizedBox(height: 12),
                        Text('Malha+',
                            textAlign: TextAlign.center,
                            style: tema.textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Treine, evolua, compita.',
                            textAlign: TextAlign.center,
                            style: tema.textTheme.bodyMedium),
                        const SizedBox(height: 32),
                        _campoEmail(),
                        const SizedBox(height: 16),
                        _campoSenha(),
                        if (_controle.mensagemErro != null) ...[
                          const SizedBox(height: 12),
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
                          onPressed: _controle.carregando ? null : _aoEntrar,
                          child: _controle.carregando
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5),
                                )
                              : const Text('Entrar',
                                  style: TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _controle.carregando
                              ? null
                              : () => _abrir(TelaRedefinirSenha(
                                    emailInicial:
                                        _controle.emailController.text.trim(),
                                  )),
                          child: const Text('Esqueci minha senha'),
                        ),
                        OutlinedButton(
                          onPressed: _controle.carregando
                              ? null
                              : () => _abrir(const TelaCadastro()),
                          child: const Text('Criar conta'),
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

  Widget _campoEmail() {
    return TextFormField(
      controller: _controle.emailController,
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
      validator: Validadores.senhaLogin,
      obscureText: !_controle.senhaVisivel,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      autocorrect: false,
      enableSuggestions: false,
      maxLength: Validadores.tamanhoMaximoSenha,
      onFieldSubmitted: (_) => _aoEntrar(),
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
}

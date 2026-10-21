import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malhamais/controle_interacao/controle_tela_redefinir_senha.dart';
import 'package:malhamais/util/validadores.dart';

/// Tela para solicitar o link de redefinição de senha.
class TelaRedefinirSenha extends StatefulWidget {
  const TelaRedefinirSenha({super.key, this.emailInicial = ''});

  /// E-mail já digitado no login, para poupar a digitação.
  final String emailInicial;

  @override
  State<TelaRedefinirSenha> createState() => _TelaRedefinirSenhaState();
}

class _TelaRedefinirSenhaState extends State<TelaRedefinirSenha> {
  late final ControleTelaRedefinirSenha _controle;

  @override
  void initState() {
    super.initState();
    _controle = ControleTelaRedefinirSenha(emailInicial: widget.emailInicial);
  }

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Redefinir senha')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ListenableBuilder(
                listenable: _controle,
                builder: (context, _) =>
                    _controle.enviado ? _confirmacao() : _formulario(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formulario() {
    final tema = Theme.of(context);

    return Form(
      key: _controle.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.lock_reset, size: 64, color: tema.colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            'Esqueceu a senha?',
            textAlign: TextAlign.center,
            style: tema.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Informe o e-mail da sua conta e enviaremos um link '
            'para criar uma nova senha.',
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _controle.emailController,
            validator: Validadores.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
            enableSuggestions: false,
            maxLength: Validadores.tamanhoMaximoEmail,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            onFieldSubmitted: (_) => _controle.enviar(),
            decoration: const InputDecoration(
              labelText: 'E-mail',
              prefixIcon: Icon(Icons.email_outlined),
              counterText: '',
            ),
          ),
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
            onPressed: _controle.carregando ? null : _controle.enviar,
            child: _controle.carregando
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : const Text('Enviar link', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _confirmacao() {
    final tema = Theme.of(context);
    final email = _controle.emailController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.mark_email_read_outlined,
          size: 64,
          color: tema.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        Text(
          'Verifique seu e-mail',
          textAlign: TextAlign.center,
          style: tema.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          liveRegion: true,
          child: Text(
            'Se $email estiver cadastrado, você receberá as instruções '
            'em instantes. Confira também a caixa de spam.',
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyMedium,
          ),
        ),
        if (_controle.mensagemErro != null) ...[
          const SizedBox(height: 12),
          Text(
            _controle.mensagemErro!,
            textAlign: TextAlign.center,
            style: TextStyle(color: tema.colorScheme.error),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Voltar ao login', style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: _controle.carregando ? null : _controle.enviar,
          child: const Text('Reenviar e-mail'),
        ),
        TextButton(
          onPressed: _controle.editarEmail,
          child: const Text('Usar outro e-mail'),
        ),
      ],
    );
  }
}
